import 'package:book_tracker/models/livro.dart';

enum StatusLivro { lendo, lido, queroLer }

class Estante {
  Livro livro;
  StatusLivro statusLivro;

  Estante({required this.livro, required this.statusLivro});
}
