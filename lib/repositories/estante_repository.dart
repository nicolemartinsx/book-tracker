import 'package:book_tracker/models/estante.dart';
import 'package:book_tracker/repositories/review_repository.dart';
import 'package:book_tracker/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class EstanteRepository {
  static final List<Estante> _estante = [];


  static final _firestore = FirebaseFirestore.instance;
   static final _colecao = _firestore.collection('estante');

   
  static List<Estante> get estante => _estante;

  static void adicionarLivro(Estante estante, String userId) async{

try{


    if (userId == null) {
      throw Exception("User  ID não pode ser nulo");
    }

   Estante? estanteLivro = await getLivro(estante.livro.id,userId);
  final docId = '${userId}_${estante.livro.id}';



    if (estanteLivro == null)  {
      _estante.add(estante);
        await FirebaseFirestore.instance
          .collection('estante')
          .doc(docId)
          .set({
          'userId': userId,
          'livro': estante.livro.toMap(),
          'statusLivro': estante.statusLivro.name,
        });

    } else {
          removerLivro(estanteLivro);
          _estante.add(estante);

      
    }
    }catch(e) {
     print('Erro ao adicionar livro: $e');
    }
  }

  /*
  static Future<Estante?> buscarLivroPorId(String idLivro) async {
  final query = await FirebaseFirestore.instance
      .collection('estante')
      .where('livro.id', isEqualTo: idLivro)
      .limit(1)
      .get();

  if (query.docs.isNotEmpty) {
    return Estante.fromMap(query.docs.first.data());
  } else {
    return null;
  }

  }
  */

  static void removerLivro(Estante estante) async {
    _estante.remove(estante);

    final query = await FirebaseFirestore.instance
      .collection('estante')
      .where('livro.id', isEqualTo: estante.livro.id)
      .where('userId',isEqualTo: estante.userId)
      .get();

    ReviewRepository.removerReviewPorEstante(estante);

    for (var doc in query.docs) {
    await FirebaseFirestore.instance.collection('estante').doc(doc.id).delete();
    }

  }

        static Future<List<Estante>> getTodosLivrosPorUsuario(String userId) async {
        List<Estante> livros = [];
        try {
          final snapshot = await FirebaseFirestore.instance
              .collection('estante')
              .where('userId', isEqualTo: userId)
              .get();

          for (var doc in snapshot.docs) {
            // Supondo que você tenha um método para converter o documento em um objeto Estante
            livros.add(Estante.fromMap(doc.data()));
          }
        } catch (e) {
          print('Erro ao buscar livros do usuário: $e');
        }
        return livros; // Retorna a lista de livros
      }


  static Future<Estante?> getLivro(String idLivro,String userId) async {
      try {
        
        final query = await FirebaseFirestore.instance
        .collection('estante')
        .where('livro.id', isEqualTo: idLivro)
        .where('userId', isEqualTo: userId) // Adiciona a verificação do userId
        .limit(1)
        .get();

          print('================================================== aqui: ${query}');

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
