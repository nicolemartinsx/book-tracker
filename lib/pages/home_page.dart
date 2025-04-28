import 'package:book_tracker/app_bar.dart';
import 'package:book_tracker/pages/estante_page.dart';
import 'package:book_tracker/pages/feed_page.dart';
import 'package:book_tracker/pages/login_page.dart';
import 'package:book_tracker/pages/pesquisa_page.dart';
import 'package:book_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  logout() async {
    await context.read<AuthService>().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar('Book Tracker', logout),
      body: Container(
        color: Colors.grey[100],
        child: PageView(
          controller: pc,
          onPageChanged: setPaginaAtual,
          children: [FeedPage(), SearchPage(), BookshelfPage()],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.blueGrey[500],
        currentIndex: paginaAtual,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pesquisa'),
          BottomNavigationBarItem(icon: Icon(Icons.shelves), label: 'Estante'),
        ],
        onTap: (pagina) {
          pc.animateToPage(
            pagina,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
}
