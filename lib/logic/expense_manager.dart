import '../models/expense_model.dart';

class ExpenseManager {
  static final List<Expense> _expenses = [
    Expense(
      id: 'e1',
      title: 'Baju Kemeja',
      category: 'Produk Bernilai Tinggi',
      amount: 250000,
      description: 'Kemeja lengan panjang untuk acara formal.',
      date: DateTime.now(),
    ),
    Expense(
      id: 'e2',
      title: 'Celana Jeans',
      category: 'Produk Bernilai Tinggi',
      amount: 450000,
      description: 'Celana jeans slim-fit warna biru.',
      date: DateTime.now(),
    ),
    Expense(
      id: 'e3',
      title: 'Laptop',
      category: 'Produk Bernilai Tinggi',
      amount: 12500000,
      description: 'Laptop untuk keperluan kerja dan hiburan.',
      date: DateTime.now(),
    ),
    Expense(
      id: 'e4',
      title: 'Smartphone',
      category: 'Produk Bernilai Tinggi',
      amount: 8500000,
      description: 'Smartphone dengan kamera canggih.',
      date: DateTime.now(),
    ),
    Expense(
      id: 'e5',
      title: "Beras",
      category: "Kebutuhan Pokok",
      amount: 75000,
      description: "Beras kualitas medium 5kg",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e6',
      title: "Minyak Goreng",
      category: "Kebutuhan Pokok",
      amount: 30000,
      description: "Minyak goreng 2 liter",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e7',
      title: "Gula Pasir",
      category: "Kebutuhan Pokok",
      amount: 15000,
      description: "Gula pasir kemasan 1kg",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e8',
      title: "Cumi-Cumi",
      category: "Produk Segar",
      amount: 35000,
      description: "Cumi-cumi segar 500g",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e9',
      title: "Sayur Brokoli",
      category: "Produk Segar",
      amount: 20000,
      description: "Brokoli segar 1 ikat",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e10',
      title: "Daging Ayam Giling",
      category: "Produk Segar",
      amount: 40000,
      description: "Daging ayam giling 500g",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e11',
      title: "Sabun Mandi",
      category: "Produk Kebersihan",
      amount: 10000,
      description: "Sabun batang 2 pcs",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e12',
      title: "Shampoo Bayi",
      category: "Produk Kebersihan",
      amount: 25000,
      description: "shampoo khusus bayi 200ml",
      date: DateTime.now(),
    ),
  ];

  // static List<Expense> get expenses => _expenses;

  // // ✅ Tambahkan method untuk menambah data baru
  // static void addExpense(Expense expense) {
  //   _expenses.insert(0, expense); // masukkan di awal biar tampil paling atas
  // }

  // getter
static List<Expense> get expenses => _expenses;


// optional helper
static List<Expense> getExpenses() => _expenses;


static void addExpense(Expense expense) {
_expenses.insert(0, expense);
}
}
