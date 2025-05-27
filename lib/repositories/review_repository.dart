import 'package:book_tracker/models/ReviewComLivro.dart';
import 'package:book_tracker/models/estante.dart';
import 'package:book_tracker/models/livro.dart';
import 'package:book_tracker/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewRepository {
  static Future<void> addReview(Review review) async {
    bool reviewExiste = await hasReviewed(review.livro.id, review.autor);
    if (!reviewExiste) {
    } else {
      Review? estanteLivro = await getReview(review.livro.id, review.autor);
      await removerReview(estanteLivro!);
    }
    await FirebaseFirestore.instance.collection('reviews').add({
      'livro': review.livro.toMap(),
      'titulo': review.titulo,
      'estrelas': review.estrelas,
      'autor': review.autor,
      'conteudo': review.conteudo,
      'data': Timestamp.now(),
    });
  }

  static Future<List<Livro>> getLivrosReviewed(String userId) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('estante')
              .where('userId', isEqualTo: userId)
              .get();

      final estantes =
          snapshot.docs.map((doc) => Estante.fromMap(doc.data())).toList();

      return estantes.map((e) => e.livro).toList();
    } catch (e) {
      print('Erro ao buscar livros do usuário: $e');
      return [];
    }
  }

  static Future<List<ReviewComLivro>> buscarReviewsComLivros(
    String userId,
  ) async {
    final reviews = await ReviewRepository.getReviewsByAutor(userId);
    final livros = await ReviewRepository.getLivrosReviewed(
      userId,
    ); // função que retorna List<Livro>

    // Mesclar review com livro correspondente
    List<ReviewComLivro> combinados = [];

    for (var review in reviews) {
      final livro = livros.firstWhere(
        (l) => l.id == review.livro.id,
        orElse:
            () => Livro(
              id: review.livro.id,
              titulo: review.titulo,
              autor: 'Desconhecido',
              capa: '',
              ano: "0",
              isbn: '',
              editora: '',
              paginas: '',
              sinopse: '',
            ),
      );

      combinados.add(ReviewComLivro(review: review, livro: livro));
    }

    return combinados;
  }

  static Future<List<Review>> getReviewsByAutor(String autor) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('reviews')
            .where('autor', isEqualTo: autor)
            .get();

    return snapshot.docs.map((doc) => Review.fromMap(doc.data())).toList();
  }

  static Future<void> removerReview(Review review) async {
    final query =
        await FirebaseFirestore.instance
            .collection('reviews')
            .where('livro.id', isEqualTo: review.livro.id)
            .where('autor', isEqualTo: review.autor)
            .get();

    for (var doc in query.docs) {
      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(doc.id)
          .delete();
    }
  }

  static void removerReviewPorEstante(Estante estante) async {
    final query =
        await FirebaseFirestore.instance
            .collection('reviews')
            .where('livro.id', isEqualTo: estante.livro.id)
            .where('autor', isEqualTo: estante.userId)
            .get();

    for (var doc in query.docs) {
      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(doc.id)
          .delete();
    }
  }

  static Future<List<Review>> getReviews(String? idLivro) async {
    Query query = FirebaseFirestore.instance.collection('reviews');

    if (idLivro != null) {
      query = query.where('livro.id', isEqualTo: idLivro);
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<bool> hasReviewed(String livroId, String usuario) async {
    final query =
        await FirebaseFirestore.instance
            .collection('reviews')
            .where('livro.id', isEqualTo: livroId)
            .where('autor', isEqualTo: usuario)
            .limit(1)
            .get();

    return query.docs.isNotEmpty;
  }

  static Future<Review?> getReview(String livroId, String usuario) async {
    final query =
        await FirebaseFirestore.instance
            .collection('reviews')
            .where('livro.id', isEqualTo: livroId)
            .where('autor', isEqualTo: usuario)
            .limit(1)
            .get();

    if (query.docs.isNotEmpty) {
      return Review.fromMap(query.docs.first.data());
    } else {
      return null;
    }
  }
}
