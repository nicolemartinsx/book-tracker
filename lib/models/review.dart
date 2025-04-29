class Review {
  String idLivro;
  String estrelas;
  String titulo;
  String autor;
  String conteudo;

  Review({
    required this.idLivro,
    required this.titulo,
    required this.estrelas,
    required this.autor,
    required this.conteudo,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      idLivro: map['idLivro'] ?? '',
      titulo: map['titulo'] ?? '',
      estrelas: map['estrelas'] ?? '',
      autor: map['autor'] ?? '',
      conteudo: map['conteudo'] ?? '',
    );
  }
}
