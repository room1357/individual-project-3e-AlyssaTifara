import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color maroonDark = Color(0xFF4B1C1A);
  static const Color maroonLight = Color(0xFF6E2E2A);
  static const Color bone = Color(0xFFE1D9CC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: maroonDark,
        foregroundColor: bone,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.info_outline, size: 80, color: maroonDark),
              SizedBox(height: 24),
              Text(
                "Aplikasi Checkout Barang",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: maroonDark,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Aplikasi ini dibuat dengan Flutter.\n"
                "Fitur: Login, Register, Sidebar Menu, Checkout Produk.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
