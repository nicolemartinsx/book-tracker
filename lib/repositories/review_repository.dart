import 'package:book_tracker/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewRepository {
  static final List<Review> _reviews = [];

  static List<Review> get reviews => _reviews;

  static void addReview(Review review) async {
    bool reviewExiste = await hasReviewed(review.idLivro, review.autor);
    if (!reviewExiste) {
      
      _reviews.add(review);
    } else {
      Review? estanteLivro = await getReview(review.idLivro, review.autor);
      await removerReview(estanteLivro!);
      _reviews.add(review);
    }
     await FirebaseFirestore.instance.collection('reviews').add({
      'idLivro': review.idLivro,
      'titulo': review.titulo,
      'estrelas': review.estrelas,
      'autor': review.autor,
      'conteudo': review.conteudo,
      'data': Timestamp.now(),
    }); 
  }

  static Future<void> removerReview(Review review) async {
    _reviews.remove(review);

    final query = await FirebaseFirestore.instance
      .collection('reviews')
      .where('idLivro', isEqualTo: review.idLivro)
      .where('autor', isEqualTo: review.autor)
      .get();

    for (var doc in query.docs) {
    await FirebaseFirestore.instance.collection('reviews').doc(doc.id).delete();
      }
  }

   static Future<List<Review>> getReviews(String? idLivro) async {
    Query query = FirebaseFirestore.instance.collection('reviews');

    if (idLivro != null) {
      query = query.where('idLivro', isEqualTo: idLivro);
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
 
  static Future<bool> hasReviewed(String livroId, String usuario) async {

     final query = await FirebaseFirestore.instance
      .collection('reviews')
      .where('idLivro', isEqualTo: livroId)
      .where('autor', isEqualTo: usuario)
      .limit(1)
      .get();

      return query.docs.isNotEmpty;

  }

  static Future<Review?> getReview(String livroId, String usuario) async {
    final query = await FirebaseFirestore.instance
      .collection('reviews')
      .where('idLivro', isEqualTo: livroId)
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
