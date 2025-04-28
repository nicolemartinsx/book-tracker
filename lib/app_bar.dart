// utils/app_bar_custom.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

PreferredSizeWidget buildCustomAppBar(String title, [Function()? logout]) {
  return AppBar(
    centerTitle: true,
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.menu_book_sharp, color: Colors.black87, size: 30),
        Text(' Book Tracker'),
      ],
    ),
    titleTextStyle: TextStyle(
      fontFamily: GoogleFonts.crimsonPro().fontFamily,
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),

    actions: [
      if (logout != null)
        IconButton(onPressed: logout, icon: Icon(Icons.output_outlined)),
    ],
  );
}
