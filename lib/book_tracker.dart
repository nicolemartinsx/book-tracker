import 'package:book_tracker/pages/home_page.dart';
import 'package:flutter/material.dart';

class BookTracker extends StatelessWidget {
  const BookTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: HomePage(),
    );
  }
}
