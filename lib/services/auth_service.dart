import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      print('[AUTH] Tentando login...');

      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      print('[AUTH] Login bem-sucedido!');
      getUser();
    } on FirebaseAuthException catch (e) {
        print('[AUTH] Erro no login: ${e.code}');
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Email ou Senha incorreto');
      } else if (e.code == 'channel-error') {
        throw AuthException('Preencha todos os campos');
      } else if (e.code == 'invalid-email') {
        throw AuthException('Email inválido');
      } else {
      throw AuthException('Erro desconhecido: ${e.message}');
    }
    }
  }

  logout() async {
    await _auth.signOut();
    getUser();
  }

  registrar(String email, String senha, String nome) async {
    try {
      

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: senha);

    
      await userCredential.user!.updateDisplayName(nome);

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
        'nome': nome,
        'email': email,
      });

      
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

   Future<void> alterarNomeUsuario(String novoNome) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(novoNome);
      await user.reload();
    } else {
      throw Exception('Usuário não está logado.');
    }
  }

   // Reautenticação
  Future<void> reautenticarUsuario(String email, String senhaAtual) async {
    final user = _auth.currentUser;
    final cred = EmailAuthProvider.credential(email: email, password: senhaAtual);

    if (user != null) {
      await user.reauthenticateWithCredential(cred);
    } else {
      throw Exception('Usuário não está logado.');
    }
  }

  // Alterar senha com reautenticação
  Future<void> atualizarSenhaComReautenticacao(
      String email, String senhaAtual, String novaSenha) async {
    await reautenticarUsuario(email, senhaAtual);
    await alterarSenha(novaSenha);
  }

  Future<void> alterarSenha(String novaSenha) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(novaSenha);
    } else {
      throw Exception('Usuário não está logado.');
    }
  }

}
