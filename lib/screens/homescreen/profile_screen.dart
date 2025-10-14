import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final User? user;

  const ProfileScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.blue),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 20),
            Text(user?.fullName ?? "Nama Pengguna", style: const TextStyle(fontSize: 24)),
            Text(user?.email ?? "user@email.com", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
