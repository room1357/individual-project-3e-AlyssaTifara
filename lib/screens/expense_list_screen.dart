import 'package:flutter/material.dart';
import '../logic/expense_manager.dart';
import '../logic/checkout_manager.dart';
import '../models/expense_model.dart';

class ExpenseScreen extends StatelessWidget {
  final String category; // kategori yang dipilih dari Home

  const ExpenseScreen({super.key, required this.category});

  String formatCurrency(int amount) {
    return "Rp ${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => "${match[1]}.",
    )}";
  }

  @override
  Widget build(BuildContext context) {
    // Filter expense berdasarkan kategori
    final List<Expense> categoryExpenses = ExpenseManager.expenses
        .where((expense) => expense.category == category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: categoryExpenses.length,
          itemBuilder: (context, index) {
            final expense = categoryExpenses[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  expense.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(expense.description),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatCurrency(expense.amount as int),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart,
                          color: Colors.blue),
                      onPressed: () {
                        CheckoutManager.addToCheckout(expense);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${expense.title} ditambahkan"),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
