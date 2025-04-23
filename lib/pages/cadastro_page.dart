import 'package:book_tracker/app_bar.dart';
import 'package:book_tracker/pages/login_page.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController senhaController = TextEditingController();
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: buildCustomAppBar('Book Tracker'),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black87),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),
              SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.black87),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),
              SizedBox(height: 24),
              TextField(
                controller: senhaController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: Colors.black87),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _toggleVisibility,
                  ),
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[900],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'CRIAR CONTA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  "Já tem uma conta? Faça login",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.teal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
