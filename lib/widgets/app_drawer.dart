import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              "Menu Utama",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pushNamed(context, "/home");
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text("Daftar Barang"),
            onTap: () {
              Navigator.pushNamed(context, "/expenses");
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text("Checkout"),
            onTap: () {
              Navigator.pushNamed(context, "/messages");
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About"),
            onTap: () {
              Navigator.pushNamed(context, "/about");
            },
          ),
        ],
      ),
    );
  }
}
