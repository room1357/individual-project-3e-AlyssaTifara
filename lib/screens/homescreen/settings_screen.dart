import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), backgroundColor: Colors.blue),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Account"),
            subtitle: const Text("Manage your account"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Privacy"),
            subtitle: const Text("Privacy settings"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            subtitle: const Text("Notification preferences"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
