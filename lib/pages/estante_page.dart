import 'package:book_tracker/models/estante.dart';
import 'package:book_tracker/pages/livro_page.dart';
import 'package:book_tracker/repositories/estante_repository.dart';
import 'package:book_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookshelfPage extends StatefulWidget {
  const BookshelfPage({super.key});

  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {
  List<Estante> estante = [];
  StatusLivro? filtroSelecionado;

  String? _usuario;

  @override
  void initState() {
    final authService = Provider.of<AuthService>(context, listen: false);
    _usuario = authService.usuario?.uid;

    super.initState();
    _carregarLivros();
  }

  void _carregarLivros() async {
    if (_usuario != null) {
      try {
        final livros = await EstanteRepository.getTodosLivrosPorUsuario(
          _usuario!,
        );
        setState(() {
          estante = livros;
        });
      } catch (e) {
        print('Erro ao carregar livros: $e');
        // Você pode mostrar um Snackbar ou um diálogo de erro aqui
      }
    } else {
      print('Usuário não autenticado');
      // Trate o caso de usuário não autenticado, se necessário
    }
  }

  List<Estante> get livrosFiltrados {
    if (filtroSelecionado == null) {
      return estante;
    }
    return estante
        .where((item) => item.statusLivro == filtroSelecionado)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Divider(thickness: 1),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFiltroChip('Todos', null),
                  _buildFiltroChip('Lendo', StatusLivro.lendo),
                  _buildFiltroChip('Lido', StatusLivro.lido),
                  _buildFiltroChip('Quero Ler', StatusLivro.queroLer),
                ],
              ),
            ),

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
                  itemCount: livrosFiltrados.length,
                  itemBuilder: (context, index) {
                    final livro = livrosFiltrados[index].livro;
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => LivroDetalhePage(livro: livro),
                          ),
                        ).then((_) {
                          _carregarLivros();
                        });
                      },

                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 18),
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 2 / 3,
                            child: Image.network(livro.capa, fit: BoxFit.cover),
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

  Widget _buildFiltroChip(String label, StatusLivro? status) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: filtroSelecionado == status,
        onSelected: (_) {
          setState(() {
            filtroSelecionado = status;
          });
        },
        selectedColor: Colors.teal,
        backgroundColor: Colors.grey[50],

        showCheckmark: false,
        labelStyle: TextStyle(
          color: filtroSelecionado == status ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
