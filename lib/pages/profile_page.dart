import 'package:book_tracker/pages/settings_page.dart';

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 35,
                    backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/847/847969.png',
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'nomedousuario',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 55),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                    icon: Icon(Icons.settings, size: 30, color: Colors.teal),
                  ),
                ],
              ),
            ),

            TabBar(
              indicatorColor: Colors.teal,
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.black54,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              tabs: [Tab(text: 'Favoritos'), Tab(text: 'Resenhas')],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: Text(
                      'Seus livros favoritos aparecerão aqui',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  Center(
                    child: Text(
                      'Suas resenhas aparecerão aqui',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
