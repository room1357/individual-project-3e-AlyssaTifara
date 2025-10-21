import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/logic/user_manager.dart';

// 🎨 Warna tema global
const Color charcoal = Color(0xFF434D59);
const Color bone = Color(0xFFE1D9CC);
const Color maroon = Color(0xFF4B1C1A);
const Color maroonLight = Color(0xFF6E2E2A);

class RegisterScreen extends StatefulWidget {
  final UserManager userManager;

  const RegisterScreen({super.key, required this.userManager});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _registerUser() {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // 🔒 Validasi: semua kolom wajib diisi
    if (fullName.isEmpty ||
        email.isEmpty ||
        username.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Harap isi semua kolom sebelum mendaftar!'),
          backgroundColor: maroonLight,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 🟢 Jika lolos validasi
    widget.userManager.registerUser(fullName, email, username, password);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Akun berhasil dibuat!'),
        backgroundColor: maroonLight,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bone,
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(color: bone, fontWeight: FontWeight.bold),
        ),
        backgroundColor: maroon,
        centerTitle: true,
        iconTheme: const IconThemeData(color: bone),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Buat Akun Baru",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: charcoal,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person, color: maroonLight),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: maroonLight),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.account_circle, color: maroonLight),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: maroonLight),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _registerUser,
                icon: const Icon(Icons.app_registration, color: bone),
                label: const Text(
                  "REGISTER",
                  style: TextStyle(
                      color: bone,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: maroonLight,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
