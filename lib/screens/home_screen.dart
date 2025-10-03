import 'package:flutter/material.dart';
import 'expense_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildCategoryCard(
      BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigasi ke ExpenseScreen sesuai kategori
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpenseScreen(category: title),
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildCategoryCard(
                context, "Kebutuhan Pokok", Icons.fastfood, Colors.green),
            _buildCategoryCard(
                context, "Produk Segar", Icons.local_grocery_store, Colors.orange),
            _buildCategoryCard(
                context, "Produk Kebersihan", Icons.cleaning_services, Colors.purple),
            _buildCategoryCard(
                context, "Produk Bernilai Tinggi", Icons.security, Colors.red),
          ],
        ),
      ),
    );
  }
}
