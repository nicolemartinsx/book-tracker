import 'package:book_tracker/models/livro.dart';

enum StatusLivro { lendo, lido, queroLer }

class Estante {
  Livro livro;
  StatusLivro statusLivro;
  String userId;

  Estante({
    required this.livro,
    required this.statusLivro,
    required this.userId,
  });

  factory Estante.fromMap(Map<String, dynamic> map) {
    return Estante(
      livro: Livro.fromMap(map['livro']),
      statusLivro: StatusLivro.values.firstWhere(
        (e) => e.toString() == 'StatusLivro.${map['statusLivro']}',
      ),
      userId: map['userId'] ?? '', // Certifique-se que esse campo exista no Firestore
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'livro': livro.toMap(),
      'statusLivro': statusLivro.name,
      'userId': userId,
    };
  }
}