import 'package:book_tracker/models/estante.dart';
import 'package:book_tracker/pages/livro_page.dart';
import 'package:book_tracker/repositories/estante_repository.dart';
import 'package:flutter/material.dart';

class BookshelfPage extends StatefulWidget {
  const BookshelfPage({super.key});

  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {
  List<Estante> estante = [];

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  void _carregarLivros() {
    setState(() {
      estante = EstanteRepository.estante;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: estante.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => LivroDetalhePage(
                                  livro: estante[index].livro,
                                ),
                          ),
                        ).then((_) {
                          _carregarLivros();
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 18),
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 2 / 3,
                            child: Image.asset(
                              estante[index].livro.icone,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
