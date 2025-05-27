import 'package:book_tracker/models/livro.dart';
import 'package:book_tracker/models/review.dart';

class ReviewComLivro {
  final Review review;
  final Livro livro;

  ReviewComLivro({required this.review, required this.livro});
}