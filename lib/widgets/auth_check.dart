import 'package:book_tracker/pages/home_page.dart';
import 'package:book_tracker/pages/login_page.dart';
import 'package:book_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({ super.key });

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {

    AuthService auth = Provider.of<AuthService>(context);

    if(auth.isLoading) {
      return loading();
    } else if(auth.usuario == null )

      return LoginPage();

    else
      return HomePage();
    

  }

  loading(){
    return Scaffold(body: Center(child: CircularProgressIndicator(),));
  }
}