import 'package:book_tracker/models/review.dart';
import 'package:book_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:book_tracker/repositories/review_repository.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewPage extends StatefulWidget {
  final String idLivro;
  final String livroTitulo;

  const ReviewPage({
    super.key,
    required this.idLivro,
    required this.livroTitulo,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _conteudoController = TextEditingController();
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final usuario = authService.usuario?.uid;
      if (ReviewRepository.hasReviewed(widget.idLivro, usuario!)) {
        final review = ReviewRepository.getReview(widget.idLivro, usuario);
        _tituloController.text = review.titulo;
        _conteudoController.text = review.conteudo;
        setState(() {
          rating = double.parse(review.estrelas);
        });
      }
    });
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  Future<void> _salvarResenha() async {
    if (_tituloController.text.isEmpty || _conteudoController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Preencha todos os campos!')));
      return;
    }

    ReviewRepository.addReview(
      Review(
        idLivro: widget.idLivro,
        titulo: _tituloController.text,
        estrelas: rating.toString(),
        autor: context.read<AuthService>().usuario!.uid,
        conteudo: _conteudoController.text,
      ),
    );

    try {
      //a configuração do firestore deve ficar aqui.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resenha enviada com sucesso!'),
          backgroundColor: Colors.teal,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar resenha. Tente novamente.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Fazer Resenha'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                widget.livroTitulo,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmoothStarRating(
                    rating: rating,
                    size: 40,
                    starCount: 5,
                    allowHalfRating: true,
                    onRatingChanged: (value) {
                      setState(() {
                        rating = value;
                      });
                    },
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half,
                    defaultIconData: Icons.star_border,
                    color: Colors.teal,
                    borderColor: Colors.teal,
                    spacing: 8.0,
                  ),
                ],
              ),

              SizedBox(height: 16),
              TextField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: Colors.black87),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _conteudoController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Conteúdo da Resenha',
                  labelStyle: TextStyle(color: Colors.black87),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                onPressed: _salvarResenha,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Salvar Resenha',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey[900]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
