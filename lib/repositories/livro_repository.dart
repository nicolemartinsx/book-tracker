import 'package:book_tracker/models/livro.dart';

class LivroRepository {
  static List<Livro> livros = [];

  static Future<Livro> getLivroById(String idLivro) async {
    final livro = livros.firstWhere(
      (livro) => livro.id == idLivro,
      orElse: () => throw Exception('Livro com id $idLivro não encontrado'),
    );
    return Future.value(livro);
  }
}
