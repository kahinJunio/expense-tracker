import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('User Profile'),
            automaticallyImplyLeading: false,
          ),
          const ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.login),
            title: Text('Login'),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
