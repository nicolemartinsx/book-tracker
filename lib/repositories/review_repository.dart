import 'package:book_tracker/models/ReviewComLivro.dart';
import 'package:book_tracker/models/estante.dart';
import 'package:book_tracker/models/livro.dart';
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

   static Future<List<Livro>> getLivrosReviewed(String userId) async {

      try {
    final snapshot = await FirebaseFirestore.instance
        .collection('estante')
        .where('userId', isEqualTo: userId)
        .get();

    final estantes = snapshot.docs
        .map((doc) => Estante.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

  
    return estantes.map((e) => e.livro).toList();
  } catch (e) {
    print('Erro ao buscar livros do usuário: $e');
    return [];
  }

  }

  static Future<List<ReviewComLivro>> buscarReviewsComLivros(String userId) async {
  final reviews = await ReviewRepository.getReviewsByAutor(userId);
  final livros = await ReviewRepository.getLivrosReviewed(userId); // função que retorna List<Livro>

  // Mesclar review com livro correspondente
  List<ReviewComLivro> combinados = [];

  for (var review in reviews) {
  final livro = livros.firstWhere(
    (l) => l.id == review.idLivro, 
    orElse: () => Livro(
      id: review.idLivro,
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
  final snapshot = await FirebaseFirestore.instance
      .collection('reviews')
      .where('autor', isEqualTo: autor)
      .get();

  return snapshot.docs
      .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
      .toList();
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

  static void removerReviewPorEstante(Estante estante) async{
     final query = await FirebaseFirestore.instance
      .collection('reviews')
      .where('idLivro', isEqualTo: estante.livro.id)
      .where('autor', isEqualTo: estante.userId)
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
