import '../models/expense_model.dart';

class ExpenseManager {
  static final List<Expense> expenses = [
    Expense(
      title: "Beras",
      category: "Kebutuhan Pokok",
      amount: 50000,
      description: "Beras kualitas medium 5kg",
    ),
    Expense(
      title: "Minyak Goreng",
      category: "Kebutuhan Pokok",
      amount: 30000,
      description: "Minyak goreng 2 liter",
    ),
    Expense(
      title: "Gula Pasir",
      category: "Kebutuhan Pokok",
      amount: 15000,
      description: "Gula pasir kemasan 1kg",
    ),
    Expense(
      title: "Cumi-Cumi",
      category: "Produk Segar",
      amount: 35000,
      description: "Cumi-Cumi 500g",
    ),
    Expense(
      title: "Sayur Brokoli",
      category: "Produk Segar",
      amount: 20000,
      description: "Brokoli segar 1 ikat",
    ),
    Expense(
      title: "Daging Ayam Giling",
      category: "Produk Segar",
      amount: 40000,
      description: "Daging ayam giling 500g",
    ),
    Expense(
      title: "Sabun Mandi",
      category: "Produk Kebersihan",
      amount: 10000,
      description: "Sabun batang 2 pcs",
    ),
    Expense(
      title: "Vitamin C",
      category: "Produk Bernilai Tinggi",
      amount: 25000,
      description: "Vitamin C 500mg 10 tablet",
    ),
    Expense(
      title: "Liptint BnB",
      category: "Produk Bernilai Tinggi",
      amount: 55000,
      description: "Liptint merk BnB shade natural",
    ),
  ];
}
