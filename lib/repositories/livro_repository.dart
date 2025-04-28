import 'package:book_tracker/models/livro.dart';

class LivroRepository {
  static List<Livro> livros = [
    Livro(
      id: '1',
      titulo: 'A Guerra dos Tronos',
      autor: 'George R. R. Martin',
      icone: 'images/1.jpg',
      sinopse:
          ' Em um mundo medieval fictício, sete famílias disputam o controle do Trono de Ferro, o símbolo supremo de poder. Entre intrigas políticas, traições e batalhas épicas, a história segue personagens complexos e a luta por sobrevivência enquanto uma ameaça ancestral ameaça todo o continente.',
    ),
    Livro(
      id: '2',
      titulo: 'Corte de Espinhos e Rosas',
      autor: 'Sarah J. Maas',
      icone: 'images/2.jpg',
      sinopse:
          'Feyre, uma jovem caçadora, é levada para um reino encantado após matar um lobo, que na verdade era um fae disfarçado. Ela é forçada a viver com o fae Tamlin, mas descobre segredos antigos e perigos que ameaçam não apenas seu novo lar, mas o equilíbrio de todo o mundo dos fae.',
    ),
    Livro(
      id: '3',
      titulo: 'Trono de Vidro',
      autor: 'Sarah J. Maas',
      icone: 'images/3.jpg',
      sinopse:
          'Celaena Sardothien, a assassina mais temida do reino, é libertada da prisão para competir em uma competição para se tornar a campeã do rei tirano. Mas enquanto ela luta pela liberdade, ela descobre que há mais em jogo do que simples vingança, com mistérios e forças sobrenaturais em sua jornada.',
    ),
    Livro(
      id: '4',
      titulo: 'Biblioteca da Meia-Noite',
      autor: 'Matt Haig',
      icone: 'images/4.jpg',
      sinopse:
          'Nora Seed, em um momento de crise, se encontra em uma biblioteca que contém livros de vidas alternativas. Cada livro revela uma versão diferente de como sua vida poderia ter sido. À medida que ela explora essas vidas, Nora aprende sobre escolhas, arrependimentos e as infinitas possibilidades que existem para ela.',
    ),
    Livro(
      id: '5',
      titulo: 'The Witcher',
      autor: 'Andrez Sapkowski',
      icone: 'images/5.jpg',
      sinopse:
          'Geralt de Rívia, um caçador de monstros conhecido como "Witcher", luta contra criaturas e humanos em um mundo sombrio e moralmente ambíguo. Ao longo de suas aventuras, ele se vê preso em uma teia de política, magia e destino, enquanto tenta proteger aqueles que ama e enfrentar uma guerra iminente.',
    ),
  ];
}
