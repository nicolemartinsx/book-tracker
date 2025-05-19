import 'package:book_tracker/models/review.dart';

class ReviewRepository {
  static final List<Review> _reviews = [];

  static List<Review> get reviews => _reviews;

  static void addReview(Review review) {
    if (!hasReviewed(review.idLivro, review.autor)) {
      _reviews.add(review);
    } else {
      Review? estanteLivro = getReview(review.idLivro, review.autor);
      removerReview(estanteLivro);
      _reviews.add(review);
    }
    /* await FirebaseFirestore.instance.collection('reviews').add({
      'idLivro': review.idLivro,
      'titulo': review.titulo,
      'estrelas': review.estrelas,
      'autor': review.autor,
      'conteudo': review.conteudo,
      'data': Timestamp.now(),
    }); */
  }

  static void removerReview(Review review) {
    _reviews.remove(review);
  }

  /* static Future<List<Review>> getReviews(String? idLivro) async {
    Query query = FirebaseFirestore.instance.collection('reviews');

    if (idLivro != null) {
      query = query.where('idLivro', isEqualTo: idLivro);
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
 */
  static bool hasReviewed(String livroId, String usuario) {
    return _reviews.any(
      (review) => review.idLivro == livroId && review.autor == usuario,
    );
  }

  static Review getReview(String livroId, String usuario) {
    return _reviews.firstWhere(
      (review) => review.idLivro == livroId && review.autor == usuario,
    );
  }
}
