import 'package:flutter/material.dart';
import '../logic/checkout_manager.dart';
import '../models/expense_model.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  /// Format angka ke Rupiah
  String formatCurrency(int amount) {
    return "Rp ${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => "${match[1]}.",
    )}";
  }

  @override
  Widget build(BuildContext context) {
    final List<Expense> checkoutItems = CheckoutManager.checkoutItems;

    // Hitung total belanja
    final double totalHarga =
        checkoutItems.fold(0.0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Keranjang Checkout"),
        backgroundColor: Colors.blue,
        actions: [
          if (checkoutItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  CheckoutManager.clearCheckout();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Keranjang dikosongkan")),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Bagian total harga di atas
          if (checkoutItems.isNotEmpty)
            Card(
              color: Colors.blue.shade50,
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.blue, width: 1),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Harga:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      formatCurrency(totalHarga.toInt()),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Daftar barang di bawah total harga
          Expanded(
            child: checkoutItems.isEmpty
                ? const Center(
                    child: Text("Belum ada barang di checkout"),
                  )
                : ListView.builder(
                    itemCount: checkoutItems.length,
                    itemBuilder: (context, index) {
                      final item = checkoutItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.shopping_bag,
                              color: Colors.blue),
                          title: Text(
                            item.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(item.description),
                          trailing: Text(
                            formatCurrency(item.amount.toInt()),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
