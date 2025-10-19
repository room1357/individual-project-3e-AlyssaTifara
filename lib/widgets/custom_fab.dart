import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomFAB({super.key, required this.onPressed});

  // 🎨 Warna tema utama
  static const Color maroon = Color(0xFF800000); // maroon elegan
  static const Color bone = Color(0xFFE1D9CC);   // krem lembut

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: maroon,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.add,
        color: bone,
        size: 28,
      ),
    );
  }
}
