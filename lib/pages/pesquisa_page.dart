import 'package:book_tracker/models/livro.dart';
import 'package:book_tracker/pages/livro_page.dart';
import 'package:book_tracker/repositories/livro_repository.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  List<Livro> allBooks = LivroRepository.livros;
  List<Livro> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchResults = allBooks.take(5).toList(); // Mostra 5 livros logo de cara
  }

  void _searchBooks() {
    String query = searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        searchResults = allBooks.take(5).toList();
      } else {
        searchResults =
            allBooks.where((livro) {
              return livro.titulo.toLowerCase().contains(query) ||
                  livro.autor.toLowerCase().contains(query) ||
                  livro.id.contains(query);
            }).toList();
      }
    });
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
                      hintText: "Autor, Título ou ISBN",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black87, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) => _searchBooks(),
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  ),
                ),
                SizedBox(width: 16),
              ],
            ),

            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final livro = searchResults[index];
                  return ListTile(
                    title: Text(livro.titulo),
                    subtitle: Text(livro.autor),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LivroDetalhePage(livro: livro),
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
