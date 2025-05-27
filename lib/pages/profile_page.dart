import 'package:book_tracker/models/ReviewComLivro.dart';
import 'package:book_tracker/pages/settings_page.dart';
import 'package:book_tracker/repositories/review_repository.dart';
import 'package:book_tracker/services/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _usuarioId;
  String? _nomeUsuario;
  //late Future<List<Review>> _futureResenhas;
  late Future<List<ReviewComLivro>> _futureReviewsComLivro;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    _usuarioId = authService.usuario?.uid;
    _nomeUsuario = authService.usuario?.displayName ?? 'Usuário';

    if (_usuarioId != null) {
      _futureReviewsComLivro = ReviewRepository.buscarReviewsComLivros(
        _usuarioId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 35,
                    backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/847/847969.png',
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    _nomeUsuario ?? 'inválido',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 55),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                    icon: Icon(Icons.settings, size: 30, color: Colors.teal),
                  ),
                ],
              ),
            ),

            TabBar(
              indicatorColor: Colors.teal,
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.black54,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              tabs: [Tab(text: 'Favoritos'), Tab(text: 'Resenhas')],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: Text(
                      'Seus livros favoritos aparecerão aqui',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  // Resenhas
                  FutureBuilder<List<ReviewComLivro>>(
                    future: _futureReviewsComLivro,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erro ao carregar resenhas'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('Você ainda não escreveu resenhas.'),
                        );
                      } else {
                        final reviews = snapshot.data!;
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];

                            return Card(
                              color: Colors.grey[50],
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (review.livro.capa.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          review.livro.capa,
                                          height: 100,
                                          width: 70,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            review.livro.titulo,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(height: 8),
                                          SmoothStarRating(
                                            rating:
                                                double.tryParse(
                                                  review.review.estrelas,
                                                ) ??
                                                0.0,
                                            starCount: 5,
                                            size: 18,
                                            color: Colors.teal,
                                            borderColor: Colors.teal,
                                            allowHalfRating: true,
                                            spacing: 2.0,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            review.review.conteudo,
                                            style: const TextStyle(
                                              fontSize: 14,
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
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
