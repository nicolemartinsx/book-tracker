import 'package:book_tracker/app_bar.dart';
import 'package:book_tracker/pages/estante_page.dart';
import 'package:book_tracker/pages/feed_page.dart';

import 'package:book_tracker/pages/pesquisa_page.dart';
import 'package:book_tracker/pages/profile_page.dart';

import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar('Book Tracker'),
      body: Container(
        color: Colors.grey[100],
        child: PageView(
          controller: pc,
          onPageChanged: setPaginaAtual,
          children: [FeedPage(), SearchPage(), BookshelfPage(), ProfilePage()],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.blueGrey[500],
        currentIndex: paginaAtual,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pesquisa'),
          BottomNavigationBarItem(icon: Icon(Icons.shelves), label: 'Estante'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
            backgroundColor: Colors.grey[50],
          ),
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
