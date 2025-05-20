// utils/app_bar_custom.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

PreferredSizeWidget buildCustomAppBar(String title) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.grey[50],
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [Text('Book Tracker')],
    ),
    titleTextStyle: TextStyle(
      fontFamily: GoogleFonts.crimsonPro().fontFamily,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );
}
