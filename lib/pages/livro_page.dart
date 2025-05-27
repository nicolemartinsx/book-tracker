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
  String? _usuario;
  Estante? _estante;
  bool _temReview = false;
  bool _carregando = true;
  String _textoBotao = 'Adicionar';

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    _usuario = authService.usuario?.uid;

    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final estante = await EstanteRepository.getLivro(
      widget.livro.id,
      _usuario!,
    );
    final temReview = await ReviewRepository.hasReviewed(
      widget.livro.id,
      _usuario!,
    );

    setState(() {
      _estante = estante;
      _temReview = temReview;
      _textoBotao = getTextoStatus(estante?.statusLivro);
      print('Status do livro: ${_estante}');
      _carregando = false;
    });
  }

  void _verificarSeTemReview() async {
    if (_usuario != null) {
      final temReview = await ReviewRepository.hasReviewed(
        widget.livro.id,
        _usuario!,
      );
      print('Tem reivew ${_temReview}');
      setState(() {
        _temReview = temReview;
      });
    }
  }

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
    if (_carregando) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                    if (_usuario != null) {
                      final novaEstante = Estante(
                        livro: widget.livro,
                        statusLivro: StatusLivro.lendo,
                        userId: _usuario!,
                      );
                      EstanteRepository.adicionarLivro(novaEstante, _usuario!);
                      setState(() {
                        _estante = novaEstante;
                        _textoBotao = getTextoStatus(StatusLivro.lendo);
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.check_circle_sharp, color: Colors.teal),
                  title: Text('Lido'),
                  onTap: () {
                    if (_usuario != null) {
                      final novaEstante = Estante(
                        livro: widget.livro,
                        statusLivro: StatusLivro.lido,
                        userId: _usuario!,
                      );
                      EstanteRepository.adicionarLivro(novaEstante, _usuario!);
                      setState(() {
                        _estante = novaEstante;
                        _textoBotao = getTextoStatus(StatusLivro.lido);
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.bookmark_add, color: Colors.teal),
                  title: Text('Quero Ler'),
                  onTap: () {
                    if (_usuario != null) {
                      final novaEstante = Estante(
                        livro: widget.livro,
                        statusLivro: StatusLivro.queroLer,
                        userId: _usuario!,
                      );
                      EstanteRepository.adicionarLivro(novaEstante, _usuario!);
                      setState(() {
                        _estante = novaEstante;
                        _textoBotao = getTextoStatus(StatusLivro.queroLer);
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
                if (_estante != null)
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.red[300]),
                    title: Text('Remover'),
                    onTap: () {
                      if (_estante != null) {
                        EstanteRepository.removerLivro(_estante!);
                        setState(() {
                          _estante = null;
                          _temReview = false;
                          _textoBotao = getTextoStatus(null);
                        });
                        Navigator.pop(context);
                      }
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
                    _textoBotao,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    if (_estante?.statusLivro != StatusLivro.lido) {
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
                          builder: (context) => ReviewPage(livro: widget.livro),
                        ),
                      ).then((_) {
                        _verificarSeTemReview();
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
                    _temReview ? 'Editar Resenha' : 'Criar Resenha',
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
