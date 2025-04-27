import 'package:book_tracker/app_bar.dart';
import 'package:book_tracker/pages/cadastro_page.dart';
import 'package:book_tracker/pages/estante_page.dart';
import 'package:book_tracker/pages/home_page.dart';
import 'package:book_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formkey = GlobalKey<FormState>();

  final loginController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();



  bool _obscureText = true;

  login() async {
    try{
      await context.read<AuthService>().login(loginController.text, senhaController.text);

         Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      
    }on AuthException catch(e){
       ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.message) ));
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
          child: Column(
            children: [
              TextFormField(
                controller: loginController,
                decoration: InputDecoration(
                  labelText: 'Login',
                  labelStyle: TextStyle(color: Colors.black87),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
        

                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(value!.isEmpty)
                  return 'Informe o email corretamente';
                  return null;
                },
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

                  validator: (value){
                  if(value!.isEmpty)
                  return 'Informe a senha corretamente';
                  return null;
                },

                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),




              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                   login();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[900],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'ACESSAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24),
              TextButton(
                onPressed: () {
                 
                },
                child: Text(
                  "ESQUECI A SENHA",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.teal,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroPage()),
                  );
                },
                child: Text(
                  "Não possui uma conta? Cadastre-se",
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
