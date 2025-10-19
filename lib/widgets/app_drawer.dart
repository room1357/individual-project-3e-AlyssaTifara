import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const Color charcoal = Color(0xFF434D59);
  static const Color bone = Color(0xFFE1D9CC);
  static const Color accent = Color(0xFF8C2F39);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bone,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [charcoal, accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.shopping_bag, color: Colors.white, size: 40),
                SizedBox(height: 8),
                Text(
                  "Checkout App",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Menu Utama",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildListTile(context, Icons.home, "Home", "/home"),
          _buildListTile(context, Icons.category, "Daftar Barang", "/expenses"),
          _buildListTile(context, Icons.shopping_cart, "Checkout", "/messages"),
          _buildListTile(context, Icons.info, "About", "/about"),
        ],
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: charcoal),
      title: Text(
        title,
        style: const TextStyle(
          color: charcoal,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
      hoverColor: accent.withOpacity(0.1),
      splashColor: accent.withOpacity(0.2),
    );
  }
}
