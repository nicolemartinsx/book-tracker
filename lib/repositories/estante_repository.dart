import 'package:book_tracker/models/estante.dart';
import 'package:book_tracker/repositories/review_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EstanteRepository {
  static final List<Estante> _estante = [];

  static final _firestore = FirebaseFirestore.instance;
  static final _colecao = _firestore.collection('estante');

  static List<Estante> get estante => _estante;

  static void adicionarLivro(Estante estante, String userId) async {
    try {
      if (userId.isEmpty) {
        throw Exception("User ID não pode ser nulo");
      }

      Estante? estanteLivro = await getLivro(estante.livro.id, userId);
      final docId = '${userId}_${estante.livro.id}';

      if (estanteLivro == null) {
        _estante.add(estante);
      } else {
        await removerLivro(estanteLivro);
        _estante.add(estante);
      }

      await _colecao.doc(docId).set({
        'userId': userId,
        'livro': estante.livro.toMap(),
        'statusLivro': estante.statusLivro.name,
      });
    } catch (e) {
      print('Erro ao adicionar livro: $e');
    }
  }

  static Future<void> removerLivro(Estante estante) async {
    _estante.remove(estante);

    final query =
        await _colecao
            .where('livro.id', isEqualTo: estante.livro.id)
            .where('userId', isEqualTo: estante.userId)
            .get();

    ReviewRepository.removerReviewPorEstante(estante);

    for (var doc in query.docs) {
      await _colecao.doc(doc.id).delete();
    }
  }

  static Future<List<Estante>> getTodosLivrosPorUsuario(String userId) async {
    List<Estante> livros = [];
    try {
      final snapshot = await _colecao.where('userId', isEqualTo: userId).get();

      for (var doc in snapshot.docs) {
        // Supondo que você tenha um método para converter o documento em um objeto Estante
        livros.add(Estante.fromMap(doc.data()));
      }
    } catch (e) {
      print('Erro ao buscar livros do usuário: $e');
    }
    return livros; // Retorna a lista de livros
  }

  static Future<Estante?> getLivro(String idLivro, String userId) async {
    try {
      final query =
          await _colecao
              .where('livro.id', isEqualTo: idLivro)
              .where(
                'userId',
                isEqualTo: userId,
              ) // Adiciona a verificação do userId
              .limit(1)
              .get();

      if (query.docs.isNotEmpty) {
        return Estante.fromMap(query.docs.first.data());
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
