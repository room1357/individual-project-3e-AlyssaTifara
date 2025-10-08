import 'package:flutter/material.dart';
import '../logic/expense_manager.dart';
import '../logic/checkout_manager.dart';
import '../models/expense_model.dart';
import '../utils/currency_format.dart';

class ExpenseScreen extends StatelessWidget {
  final String category; // simpan kategori

  const ExpenseScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Filter hanya item dari kategori yang dipilih
    final List<Expense> filteredExpenses = ExpenseManager.expenses
        .where((expense) => expense.category == category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Barang - $category"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, "/checkout");
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredExpenses.length,
        itemBuilder: (context, index) {
          final expense = filteredExpenses[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              title: Text(
                expense.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(expense.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatCurrency(expense.amount.toInt()),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
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
    );
  }
}
