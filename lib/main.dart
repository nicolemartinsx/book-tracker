import 'package:book_tracker/book_tracker.dart';
import 'package:book_tracker/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Supabase.initialize(
    url: 'https://dxldchvhbdjegalfthkj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR4bGRjaHZoYmRqZWdhbGZ0aGtqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA3MDU1NDAsImV4cCI6MjA2NjI4MTU0MH0.AypSHc4C4Ipw0q5NqI41--Uqz6BB7Ta4rPTUGbhfG7U',
  );
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthService())],
      child: BookTracker(),
    ),
  );
}
