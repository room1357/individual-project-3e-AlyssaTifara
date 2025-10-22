import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/models/user_model.dart';
import 'package:pemrograman_mobile/logic/user_manager.dart';
import 'package:pemrograman_mobile/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;
  final UserManager? userManager;
  final Function(User)? onUserUpdated;

  const ProfileScreen({super.key, this.user, this.userManager, this.onUserUpdated});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  // 🎨 Warna tema konsisten
  static const Color charcoal = Color(0xFF434D59); // abu elegan
  static const Color bone = Color(0xFFE1D9CC); // krem lembut
  static const Color maroon = Color(0xFF800000); // maroon elegan

  void _editProfile() async {
    if (_currentUser != null && widget.userManager != null) {
      final updatedUser = await Navigator.push<User>(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(
            user: _currentUser!,
            userManager: widget.userManager!,
          ),
        ),
      );

      if (updatedUser != null) {
        setState(() {
          _currentUser = updatedUser;
        });
        widget.onUserUpdated?.call(updatedUser);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bone,
      appBar: AppBar(
        backgroundColor: charcoal,
        centerTitle: true,
        title: const Text(
          "Profil Pengguna",
          style: TextStyle(
            color: bone,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔸 Ikon profil warna bone
              const CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xFF800000), // maroon sebagai background
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: bone, // ikon berwarna bone
                ),
              ),
              const SizedBox(height: 25),
              Text(
                _currentUser?.fullName ?? "Nama Pengguna",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _currentUser?.email ?? "user@email.com",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // 🔸 Tombol Edit: maroon background, bone text & icon
              ElevatedButton.icon(
                onPressed: _editProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: maroon,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: maroon, width: 1.5),
                  ),
                ),
                icon: const Icon(Icons.edit, color: bone),
                label: const Text(
                  "Edit Profil",
                  style: TextStyle(
                    color: bone,
                    fontWeight: FontWeight.w600,
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
