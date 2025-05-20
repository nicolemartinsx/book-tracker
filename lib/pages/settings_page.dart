import 'package:book_tracker/pages/login_page.dart';
import 'package:book_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        title: Text(
          'Configurações',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.person_outline, color: Colors.teal),
            title: Text('Alterar nome de usuário'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.lock_outline, color: Colors.teal),
            title: Text('Alterar senha'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.photo_camera_outlined, color: Colors.teal),
            title: Text('Alterar foto de perfil'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red[800]),
            title: Text(
              'Sair da conta',
              style: TextStyle(color: Colors.red[800]),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(
                        'Deseja sair da conta?',
                        style: TextStyle(fontSize: 18),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await context.read<AuthService>().logout();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text(
                            'Sair',
                            style: TextStyle(
                              color: Colors.red[800],
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
