import 'package:book_tracker/models/livro.dart';

class Review {
  Livro livro;
  String estrelas;
  String titulo;
  String autor;
  String conteudo;

  Review({
    required this.livro,
    required this.titulo,
    required this.estrelas,
    required this.autor,
    required this.conteudo,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      livro: Livro.fromMap(map['livro']),
      titulo: map['titulo'] ?? '',
      estrelas: map['estrelas'] ?? '',
      autor: map['autor'] ?? '',
      conteudo: map['conteudo'] ?? '',
    );
  }
}
