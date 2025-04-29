import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  static Future<String> buscarNomeAutor(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
    if (doc.exists) {
      return doc['nome'] ?? 'Autor desconhecido';
    } else {
      return 'Autor desconhecido';
    }
  }
}
