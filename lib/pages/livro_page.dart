import 'package:book_tracker/pages/review_page.dart';
import 'package:book_tracker/repositories/review_repository.dart';
import 'package:book_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:book_tracker/models/livro.dart';
import 'package:provider/provider.dart';

class LivroDetalhePage extends StatelessWidget {
  final Livro livro;

  const LivroDetalhePage({super.key, required this.livro});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuario = authService.usuario?.uid;

    return Scaffold(
      backgroundColor: Colors.grey[50], // igual a SearchPage
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Detalhes do Livro',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: 200,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(livro.icone),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  livro.titulo,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                Text(
                  livro.autor,
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                SizedBox(height: 22),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final authService = Provider.of<AuthService>(
                      context,
                      listen: false,
                    );
                    if (authService.usuario != null) {
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Você precisa estar logado para realizar esta ação.',
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[900],

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    if (ReviewRepository.hasReviewed(livro.id, usuario!)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Você já resenhou este livro.'),
                          backgroundColor: Colors.orangeAccent,
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ReviewPage(
                                idLivro: livro.id,
                                livroTitulo: livro.titulo,
                              ),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Criar Resenha',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey[900]),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
              child: Text(
                livro.sinopse,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
