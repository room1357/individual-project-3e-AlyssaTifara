import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import 'expense_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 🎨 Warna tema elegan & profesional
  static const Color charcoal = Color(0xFF36454F); // warna utama baru
  static const Color bone = Color(0xFFE1D9CC); // lembut
  static const Color whiteCard = Colors.white; // netral

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Card(
      color: whiteCard,
      elevation: 5,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: charcoal.withOpacity(0.2),
        highlightColor: bone.withOpacity(0.3),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ExpenseListScreen(initialCategory: category.name),
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 50, color: category.color),
              const SizedBox(height: 12),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: charcoal, // teks abu tua elegan
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bone,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: bone),
            child: const Text(
              "Kategori Pengeluaran",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: charcoal,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // 🔹 Grid kategori
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                children: categories
                    .map((category) => _buildCategoryCard(context, category))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
