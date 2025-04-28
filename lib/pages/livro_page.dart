import 'package:book_tracker/pages/review_page.dart';
import 'package:book_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:book_tracker/models/livro.dart';
import 'package:provider/provider.dart';

class LivroDetalhePage extends StatelessWidget {


  final Livro livro;
 
  const LivroDetalhePage({super.key, required this.livro});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // igual a SearchPage
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Detalhes do Livro',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              livro.titulo,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              livro.autor,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          SizedBox(height: 16),
            Container(
              height: 100, 
              color: Colors.grey[200], 
              child: Center(
                child: Text(
                  'Descrição do livro',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                  final authService = Provider.of<AuthService>(context, listen: false);

                if (authService.usuario != null) //usado para verificar se o usuario está logado
                {
                  //Ação de adicionar
                } 
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Você precisa estar logado para realizar esta ação.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  ); 
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[900],
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Adicionar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                 final authService = Provider.of<AuthService>(context, listen: false);

                if (authService.usuario != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewPage(livroTitulo: livro.titulo),
                    ),
                  );
                } else {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Você precisa estar logado para realizar esta ação.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  ); 
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Fazer Resenha',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}