import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  User? usuario;

  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Email ou Senha incorreto');
      } else if (e.code == 'channel-error') {
        throw AuthException('Preencha todos os campos');
      } else if (e.code == 'invalid-email') {
        throw AuthException('Email inválido');
      }
    }
  }

  logout() async {
    await _auth.signOut();
    getUser();
  }

  registrar(String email, String senha, String nome) async {
    try {
      //await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      //_getUser();

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: senha);

      // Atualiza o nome do usuário no perfil
      await userCredential.user!.updateDisplayName(nome);

      // Atualiza o usuário no app também
      await userCredential.user!.reload();
      getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('Senha muito fraca');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado');
      }
    }
  }

  getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }
}
