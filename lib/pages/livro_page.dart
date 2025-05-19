import 'package:book_tracker/models/estante.dart';
import 'package:book_tracker/pages/review_page.dart';
import 'package:book_tracker/repositories/estante_repository.dart';
import 'package:book_tracker/repositories/review_repository.dart';
import 'package:book_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:book_tracker/models/livro.dart';
import 'package:provider/provider.dart';

class LivroDetalhePage extends StatefulWidget {
  final Livro livro;

  const LivroDetalhePage({super.key, required this.livro});

  @override
  State<LivroDetalhePage> createState() => _LivroDetalhePageState();
}

class _LivroDetalhePageState extends State<LivroDetalhePage> {
  String getTextoStatus(StatusLivro? status) {
    switch (status) {
      case StatusLivro.lendo:
        return 'Lendo';
      case StatusLivro.lido:
        return 'Lido';
      case StatusLivro.queroLer:
        return 'Quero Ler';
      default:
        return 'Adicionar';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuario = authService.usuario?.uid;
    final estante = EstanteRepository.getLivro(widget.livro.id);
    var temReview = ReviewRepository.hasReviewed(widget.livro.id, usuario!);
    var textoBotao = getTextoStatus(estante?.statusLivro);

    void showBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Adicionar à Estante',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                ListTile(
                  leading: Icon(Icons.menu_book, color: Colors.teal),
                  title: Text('Lendo'),
                  onTap: () {
                    EstanteRepository.adicionarLivro(
                      Estante(
                        livro: widget.livro,
                        statusLivro: StatusLivro.lendo,
                      ),
                    );
                    setState(() {
                      textoBotao = getTextoStatus(StatusLivro.lendo);
                    });

                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.check_circle_sharp, color: Colors.teal),
                  title: Text('Lido'),
                  onTap: () {
                    EstanteRepository.adicionarLivro(
                      Estante(
                        livro: widget.livro,
                        statusLivro: StatusLivro.lido,
                      ),
                    );
                    setState(() {
                      textoBotao = getTextoStatus(StatusLivro.lido);
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.bookmark_add, color: Colors.teal),
                  title: Text('Quero Ler'),
                  onTap: () {
                    EstanteRepository.adicionarLivro(
                      Estante(
                        livro: widget.livro,
                        statusLivro: StatusLivro.queroLer,
                      ),
                    );
                    setState(() {
                      textoBotao = getTextoStatus(StatusLivro.queroLer);
                    });
                    Navigator.pop(context);
                  },
                ),
                if (estante != null)
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.red[300]),
                    title: Text('Remover'),
                    onTap: () {
                      EstanteRepository.removerLivro(estante);
                      setState(() {
                        textoBotao = getTextoStatus(null);
                      });
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          );
        },
      );
    }

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
                  image:
                      widget.livro.capa.isNotEmpty
                          ? DecorationImage(
                            image: NetworkImage(widget.livro.capa),
                            fit: BoxFit.cover,
                          )
                          : null,
                  color: widget.livro.capa.isEmpty ? Colors.grey[300] : null,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    widget.livro.titulo.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Text(
                  widget.livro.autor,
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
                    showBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    textoBotao,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    if (estante?.statusLivro != StatusLivro.lido) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Você precisa ler o livro para adicionar uma resenha',
                          ),
                          backgroundColor: Colors.amber[900],
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ReviewPage(
                                idLivro: widget.livro.id,
                                livroTitulo: widget.livro.titulo,
                              ),
                        ),
                      ).then((_) {
                        setState(() {
                          temReview = ReviewRepository.hasReviewed(
                            widget.livro.id,
                            usuario,
                          );
                        });
                      });
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    temReview ? 'Editar Resenha' : 'Criar Resenha',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey[900]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: 350,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),

              child: Row(
                spacing: 8,
                children: [
                  Icon(Icons.store_outlined, size: 24),
                  Expanded(
                    child: Text(
                      widget.livro.editora,
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.calendar_today_outlined, size: 22),
                  Text(widget.livro.ano, style: TextStyle(fontSize: 16)),

                  Icon(Icons.auto_stories_outlined, size: 22),
                  Text(widget.livro.paginas, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
              child: Text(
                widget.livro.sinopse,
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
