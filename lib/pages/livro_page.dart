import 'package:flutter/material.dart';
import 'package:book_tracker/models/livro.dart';

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
                // ação de adicionar
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
                // ação de fazer resenha
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