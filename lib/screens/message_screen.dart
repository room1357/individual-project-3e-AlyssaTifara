import 'package:flutter/material.dart';
import '../logic/checkout_manager.dart';
import '../models/expense_model.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  static const Color maroonDark = Color(0xFF4B1C1A);
  static const Color maroonLight = Color(0xFF6E2E2A);
  static const Color bone = Color(0xFFE1D9CC);

  String formatCurrency(int amount) {
    return "Rp ${amount.toString().replaceAllMapped(
      RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'),
      (match) => "${match[1]}.",
    )}";
  }

  @override
  Widget build(BuildContext context) {
    final List<Expense> checkoutItems = CheckoutManager.checkoutItems;
    final double totalHarga =
        checkoutItems.fold(0.0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Keranjang Checkout"),
        backgroundColor: maroonDark,
        foregroundColor: bone,
        actions: [
          if (checkoutItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: bone),
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
          if (checkoutItems.isNotEmpty)
            Card(
              color: maroonLight.withOpacity(0.1),
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: maroonLight, width: 1),
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
                        color: maroonDark,
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
          Expanded(
            child: checkoutItems.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada barang di checkout",
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    itemCount: checkoutItems.length,
                    itemBuilder: (context, index) {
                      final item = checkoutItems[index];
                      return Card(
                        color: bone,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: maroonLight, width: 1),
                        ),
                        child: ListTile(
                          leading:
                              const Icon(Icons.shopping_bag, color: maroonDark),
                          title: Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: maroonDark,
                            ),
                          ),
                          subtitle: Text(item.description),
                          trailing: Text(
                            formatCurrency(item.amount.toInt()),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 16,
                            ),
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
