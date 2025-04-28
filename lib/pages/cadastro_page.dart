import 'package:book_tracker/app_bar.dart';
import 'package:book_tracker/pages/home_page.dart';
import 'package:book_tracker/pages/login_page.dart';
import 'package:book_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final loginController = TextEditingController();
  final nameController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool _obscureText = true;

  registrar() async {
    try {
      await context.read<AuthService>().registrar(
        loginController.text,
        senhaController.text,
        nameController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

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
          child:Form(
          key:_formKey,
          child: Column(
            children: [
              TextFormField(
                controller: loginController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black87),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),

                validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o seu email';
                }
                if (!value.contains('@')) {
                  return 'Email inválido';
                }
                return null; // se estiver tudo certo, retorna null
                },

              ),
              SizedBox(height: 24),
              TextFormField(
                controller: nameController,
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
              TextFormField(
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

                
                validator: (value) {
                      if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha.';
                      }

                     if (value.length < 6) {
                     return 'A senha deve ter pelo menos 6 caracteres.';
                     }

                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                    return 'A senha deve conter pelo menos um número.';
                    }

                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    return 'A senha deve conter pelo menos uma letra maiúscula.';
                    }

                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return 'A senha deve conter pelo menos um caractere especial.';
                    }
                    return null;

                },

              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                  registrar();
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, corrija os erros acima.')),
                    );
                  }
                },
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


                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
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
      ),
    );
  }
}
