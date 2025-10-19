import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color maroonDark = Color(0xFF4B1C1A);
  static const Color maroonLight = Color(0xFF6E2E2A);
  static const Color bone = Color(0xFFE1D9CC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: maroonDark,
        foregroundColor: bone,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: maroonDark),
            title: const Text("Account"),
            subtitle: const Text("Manage your account"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock, color: maroonDark),
            title: const Text("Privacy"),
            subtitle: const Text("Privacy settings"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications, color: maroonDark),
            title: const Text("Notifications"),
            subtitle: const Text("Notification preferences"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
