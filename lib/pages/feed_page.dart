import 'package:flutter/material.dart';
import 'package:book_tracker/models/review.dart';
import 'package:book_tracker/repositories/review_repository.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../repositories/user_repository.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late Future<List<Review>> _futureReviews;
  final Map<String, String> _autoresMap = {};

  @override
  void initState() {
    super.initState();
    _futureReviews = _loadData();
  }

  Future<List<Review>> _loadData() async {
    final reviews = await ReviewRepository.getReviews(null);

    final autorFutures = <Future<void>>[];

    for (final review in reviews) {
      autorFutures.add(
        UserRepository.buscarNomeAutor(review.autor)
            .then((nome) {
              _autoresMap[review.autor] = nome;
            })
            .catchError((_) {
              _autoresMap[review.autor] = 'Autor desconhecido';
            }),
      );
    }

    await Future.wait([...autorFutures]);
    return reviews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FutureBuilder<List<Review>>(
        future: _futureReviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Erro ao carregar resenhas: ${snapshot.error}');
            return const Center(child: Text('Erro ao carregar resenhas.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Sem resenhas disponíveis',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final reviews = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              final autor = _autoresMap[review.autor] ?? 'Autor desconhecido';

              return Card(
                color: Colors.grey[200],
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (review.livro.capa.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            review.livro.capa,
                            height: 120,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          width: 80,
                          height: 120,
                          color: Colors.grey[200],
                          child: const Icon(Icons.book, size: 40),
                        ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.livro.titulo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              review.titulo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SmoothStarRating(
                              rating: double.tryParse(review.estrelas) ?? 0.0,
                              starCount: 5,
                              size: 20,
                              color: Colors.teal,
                              borderColor: Colors.teal,
                              allowHalfRating: true,
                              spacing: 2.0,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              review.conteudo,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '- Autor: $autor',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
