import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About"), backgroundColor: Colors.blue),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.info_outline, size: 80, color: Colors.blue),
              SizedBox(height: 24),
              Text("Aplikasi Checkout Barang",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text("Aplikasi ini dibuat dengan Flutter.\n"
                  "Fitur: Login, Register, Sidebar Menu, Checkout Produk."),
            ],
          ),
        ),
      ),
    );
  }
}
