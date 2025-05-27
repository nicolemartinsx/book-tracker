import 'package:book_tracker/models/ReviewComLivro.dart';
import 'package:book_tracker/pages/settings_page.dart';
import 'package:book_tracker/repositories/review_repository.dart';
import 'package:book_tracker/services/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                        final lista = snapshot.data!;
                        return ListView.builder(
                          itemCount: lista.length,
                          itemBuilder: (context, index) {
                            final item = lista[index];
                            final review = item.review;
                            final livro = item.livro;

                            return ListTile(
                              leading:
                                  livro.capa.isNotEmpty
                                      ? Image.network(
                                        livro.capa,
                                        height: 60,
                                        //width: 80,
                                        fit: BoxFit.cover,
                                      )
                                      : Icon(Icons.book, size: 50),
                              title: Text(
                                livro.titulo,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(review.conteudo),
                                  SizedBox(height: 6),
                                  Row(
                                    children: List.generate(
                                      (double.tryParse(review.estrelas) ?? 0)
                                          .toInt(),
                                      (i) => Icon(
                                        Icons.star,
                                        color: Colors.teal,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
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
