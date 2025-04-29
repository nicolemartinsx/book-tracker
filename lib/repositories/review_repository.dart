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
  }

  static void removerReview(Review review) {
    _reviews.remove(review);
  }

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
