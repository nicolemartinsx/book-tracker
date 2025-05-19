class Livro {
  String id;
  String isbn;
  String titulo;
  String autor;
  String editora;
  String ano;
  String paginas;
  String capa;
  String sinopse;

  Livro({
    required this.id,
    required this.isbn,
    required this.titulo,
    required this.autor,
    required this.editora,
    required this.ano,
    required this.paginas,
    required this.capa,
    required this.sinopse,
  });

  static Livro fromGoogleBooks(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];

    final autores = volumeInfo['authors'];
    final autor =
        (autores != null && autores.isNotEmpty)
            ? autores.first
            : 'Autor Desconhecido';

    String isbn = '';
    if (volumeInfo['industryIdentifiers'] != null) {
      for (var id in volumeInfo['industryIdentifiers']) {
        if (id['type'] == 'ISBN_13') {
          isbn = id['identifier'];
          break;
        } else if (id['type'] == 'ISBN_10' && isbn.isEmpty) {
          isbn = id['identifier'];
        }
      }
    }

    return Livro(
      id: json['id'] ?? '',
      isbn: isbn,
      titulo: volumeInfo['title'] ?? 'Sem Título',
      autor: autor ?? 'Desconhecido',
      editora: volumeInfo['publisher'] ?? 'Editora Desconhecida',
      ano: (volumeInfo['publishedDate'] ?? 'Desconhecido').split('-').first,
      paginas: volumeInfo['pageCount']?.toString() ?? '0',
      capa: volumeInfo['imageLinks']?['thumbnail'] ?? '',
      sinopse: volumeInfo['description'] ?? 'Sem Descrição',
    );
  }
}
