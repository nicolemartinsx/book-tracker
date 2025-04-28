import 'package:book_tracker/models/review.dart';

class ReviewRepository {
  static final List<Review> _reviews = [];

  static List<Review> get reviews => _reviews;

  static void addReview(Review review) {
    _reviews.add(review);
  }

  static bool hasReviewed(String livroId, String usuario) {
    return _reviews.any(
      (review) => review.idLivro == livroId && review.autor == usuario,
    );
  }
}
