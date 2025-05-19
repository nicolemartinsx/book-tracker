import 'dart:convert';

import 'package:book_tracker/models/livro.dart';
import 'package:book_tracker/pages/livro_page.dart';
import 'package:book_tracker/repositories/livro_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  List<Livro> allBooks = LivroRepository.livros;
  List<Livro> searchResults = [];

  ConnectionState status = ConnectionState.none;

  @override
  void initState() {
    super.initState();
  }

  void buscarLivros() async {
    String query = Uri.encodeComponent(
      searchController.text.trim().toLowerCase(),
    );

    setState(() {
      status = ConnectionState.waiting;
    });

    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?maxResults=10&orderBy=relevance&printType=books&q=intitle:${(query)}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final livrosJson = json.decode(response.body);
        final lista = livrosJson['items'] as List;
        final livros =
            lista.map((json) => Livro.fromGoogleBooks(json)).toList();
        setState(() {
          searchResults = livros;
          status = ConnectionState.done;
        });
      } catch (e) {
        setState(() {
          searchResults = [];
          status = ConnectionState.done;
        });
      }
    } else {
      throw Exception('Erro ao buscar livros');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Margem ao redor do conteúdo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Busque Livros',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Pesquisa pelo Titúlo",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black87, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    buscarLivros();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.blueGrey[900],
                    padding: EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: Icon(Icons.search, color: Colors.white, size: 30),
                ),
              ],
            ),

            SizedBox(height: 20),

            if (searchResults.isEmpty && status == ConnectionState.done)
              Center(
                child: Text(
                  "Nenhum livro encontrado.",
                  style: TextStyle(fontSize: 18),
                ),
              )
            else if (status == ConnectionState.waiting)
              Center(child: CircularProgressIndicator(color: Colors.teal))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final livro = searchResults[index];
                    return ListTile(
                      title: Text(livro.titulo.toUpperCase()),
                      subtitle: Text(livro.autor),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => LivroDetalhePage(livro: livro),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
