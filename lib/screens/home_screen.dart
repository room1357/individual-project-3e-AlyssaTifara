import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import 'expense_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 🎨 Warna tema
  static const Color charcoal = Color(0xFF434D59); // abu elegan
  static const Color bone = Color(0xFFE1D9CC); // krem lembut
  static const Color lightCard = Color(0xFFF5F1E9); // abu terang kontras lembut

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Card(
      color: lightCard, // ✅ warna card kontras lembut
      elevation: 6,
      shadowColor: Colors.black26,
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
                  color: Color(0xFF2E2E2E), // teks abu tua lembut
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
    return Container(
      color: bone, // background utama lembut
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header elegan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            alignment: Alignment.center, // ✅ teks rata tengah
            decoration: const BoxDecoration(
              color: charcoal,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 3),
                  blurRadius: 5,
                ),
              ],
            ),
            child: const Text(
              "Kategori Pengeluaran",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFE1D9CC), // warna bone
                fontSize: 17,
                fontWeight: FontWeight.w600,
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
