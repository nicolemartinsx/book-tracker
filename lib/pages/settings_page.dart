import 'package:book_tracker/pages/login_page.dart';
import 'package:book_tracker/services/auth_service.dart';
import 'package:book_tracker/services/foto_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final authService = AuthService();

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
  onTap: () {
    final nomeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Novo nome de usuário'),
        content: TextField(
          controller: nomeController,
          decoration: InputDecoration(hintText: 'Digite o novo nome'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await authService.alterarNomeUsuario(nomeController.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Nome de usuário atualizado com sucesso!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro: ${e.toString()}')),
                );
              }
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  },
          ),
          Divider(),
          ListTile(
             leading: Icon(Icons.lock_outline, color: Colors.teal),
  title: Text('Alterar senha'),
  onTap: () {
              final senhaAtualController = TextEditingController();
              final novaSenhaController = TextEditingController();

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Alterar senha'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: senhaAtualController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Senha atual'),
                      ),
                      TextField(
                        controller: novaSenhaController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Nova senha'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          final user = FirebaseAuth.instance.currentUser!;
                          final email = user.email!;
                          await authService.atualizarSenhaComReautenticacao(
                            email,
                            senhaAtualController.text.trim(),
                            novaSenhaController.text.trim(),
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Senha alterada com sucesso!')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro: ${e.toString()}')),
                          );
                        }
                      },
                      child: Text('Salvar'),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.photo_camera_outlined, color: Colors.teal),
            title: Text('Alterar foto de perfil'),
               onTap: () async{
              try{
                final authService = Provider.of<AuthService>(context, listen: false);
                 final _usuarioId = authService.usuario?.uid;
    
                await ImageUploadService.pickAndUploadImage(_usuarioId!);
                SnackBar(content: Text('imagem atualizada com sucesso!'));
              }catch(e){
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro: ${e.toString()}')),
                );
              }
    
            },
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
