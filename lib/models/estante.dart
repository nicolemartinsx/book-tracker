import 'package:book_tracker/models/livro.dart';

enum StatusLivro { lendo, lido, queroLer }

class Estante {
  Livro livro;
  StatusLivro statusLivro;

  Estante({required this.livro, required this.statusLivro});



  factory Estante.fromMap(Map<String, dynamic> map) {
    return Estante(
      livro: Livro.fromMap(map['livro']),
      statusLivro: StatusLivro.values.firstWhere(
        (e) => e.toString() == 'StatusLivro.${map['statusLivro']}',
      ),
    );
  }

   Map<String, dynamic> toMap() {
    return {
      'livro': livro.toMap(),
      'statusLivro': statusLivro.name,
    };
  }
}


