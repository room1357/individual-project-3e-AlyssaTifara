import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/logic/user_manager.dart';
import 'package:pemrograman_mobile/models/user_model.dart';

// 🎨 Warna tema konsisten
const Color charcoal = Color(0xFF434D59); // abu elegan
const Color bone = Color(0xFFE1D9CC); // krem lembut
const Color maroon = Color(0xFF800000); // maroon elegan

class EditProfileScreen extends StatefulWidget {
  final User user;
  final UserManager userManager;

  const EditProfileScreen({
    super.key,
    required this.user,
    required this.userManager,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController(text: widget.user.password);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Harap isi semua kolom!'),
          backgroundColor: maroon,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Update user in UserManager
    widget.userManager.updateUser(
      widget.user.username,
      fullName,
      email,
      password,
    );

    // Create updated user object
    final updatedUser = widget.user.copyWith(
      fullName: fullName,
      email: email,
      password: password,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Profil berhasil diperbarui!'),
        backgroundColor: maroon,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Return updated user to previous screen
    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bone,
      appBar: AppBar(
        backgroundColor: charcoal,
        centerTitle: true,
        title: const Text(
          "Edit Profil",
          style: TextStyle(
            color: bone,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // 🔸 Ikon profil
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: maroon,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: bone,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // 🔸 Form fields
            const Text(
              'Nama Lengkap',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: charcoal,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama lengkap',
                prefixIcon: const Icon(Icons.person, color: maroon),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: charcoal,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Masukkan email',
                prefixIcon: const Icon(Icons.email, color: maroon),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: charcoal,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Masukkan password baru',
                prefixIcon: const Icon(Icons.lock, color: maroon),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            // 🔸 Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: maroon,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.save, color: bone),
                label: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(
                    color: bone,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
