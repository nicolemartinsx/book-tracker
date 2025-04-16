import 'package:book_tracker/models/livro.dart';

class LivroRepository {
  static List<Livro> livros = [
    Livro(
      id: '1',
      titulo: 'A Guerra dos Tronos',
      autor: 'George R. R. Martin',
      icone: 'images/1.png',
    ),
    Livro(
      id: '2',
      titulo: 'Corte de Espinhos e Rosas',
      autor: 'Sarah J. Maas',
      icone: 'images/2.png',
    ),
    Livro(
      id: '3',
      titulo: 'Trono de Vidro',
      autor: 'Sarah J. Maas',
      icone: 'images/3.png',
    ),
    Livro(
      id: '4',
      titulo: 'Biblioteca da Meia-Noite',
      autor: 'Matt Haig',
      icone: 'images/4.png',
    ),
    Livro(
      id: '5',
      titulo: 'The Witcher',
      autor: 'Andrez Sapkowski',
      icone: 'images/5.png',
    ),
  ];
}
