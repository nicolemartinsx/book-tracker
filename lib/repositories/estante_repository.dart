import 'package:book_tracker/models/estante.dart';

class EstanteRepository {
  static final List<Estante> _estante = [];

  static List<Estante> get estante => _estante;

  static void adicionarLivro(Estante estante) {
    Estante? estanteLivro = getLivro(estante.livro.id);

    if (estanteLivro == null) {
      _estante.add(estante);
    } else {
      removerLivro(estanteLivro);
      _estante.add(estante);
    }
  }

  static void removerLivro(Estante estante) {
    _estante.remove(estante);
  }

  static Estante? getLivro(String idLivro) {
    try {
      Estante livroEstante = _estante.firstWhere(
        (estante) => estante.livro.id == idLivro,
      );
      return livroEstante;
    } catch (e) {
      return null;
    }
  }
}
