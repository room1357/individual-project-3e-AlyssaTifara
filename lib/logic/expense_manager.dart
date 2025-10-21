import '../models/expense_model.dart';

class ExpenseManager {
  static final List<Expense> _expenses = [
    // 🔹 Produk Bernilai Tinggi
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
      title: 'Headset Bluetooth',
      category: 'Produk Bernilai Tinggi',
      amount: 250000,
      description: 'Perangkat audio nirkabel.',
      date: DateTime.now(),
    ),

    // 🔹 Kebutuhan Pokok
    Expense(
      id: 'e4',
      title: "Beras",
      category: "Kebutuhan Pokok",
      amount: 75000,
      description: "Beras kualitas medium 5kg",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e5',
      title: "Minyak Goreng",
      category: "Kebutuhan Pokok",
      amount: 30000,
      description: "Minyak goreng 2 liter",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e6',
      title: "Gula Pasir",
      category: "Kebutuhan Pokok",
      amount: 15000,
      description: "Gula pasir kemasan 1kg",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e13',
      title: "Telur Ayam 5 Kg",
      category: "Kebutuhan Pokok",
      amount: 160000,
      description: "Telur ayam ras segar isi 15 butir",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e14',
      title: "Air Mineral Galon",
      category: "Kebutuhan Pokok",
      amount: 25000,
      description: "Air mineral isi ulang 19 liter",
      date: DateTime.now(),
    ),

    // 🔹 Produk Segar
    Expense(
      id: 'e7',
      title: "Cumi-Cumi",
      category: "Produk Segar",
      amount: 35000,
      description: "Cumi-cumi segar 500g",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e8',
      title: "Sayur Brokoli",
      category: "Produk Segar",
      amount: 20000,
      description: "Brokoli segar 1 ikat",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e9',
      title: "Daging Ayam Giling",
      category: "Produk Segar",
      amount: 40000,
      description: "Daging ayam giling 500g",
      date: DateTime.now(),
    ),
    // 🆕 Tambahan
    Expense(
      id: 'e15',
      title: "Buah Apel Fuji",
      category: "Produk Segar",
      amount: 55000,
      description: "Apel fuji impor 1 kg",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e16',
      title: "Ikan Salmon Fillet",
      category: "Produk Segar",
      amount: 185000,
      description: "Fillet salmon segar 500g",
      date: DateTime.now(),
    ),

    // 🔹 Produk Kebersihan
    Expense(
      id: 'e10',
      title: "Sabun Mandi",
      category: "Produk Kebersihan",
      amount: 10000,
      description: "Sabun batang 2 pcs",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e11',
      title: "Shampoo Bayi",
      category: "Produk Kebersihan",
      amount: 25000,
      description: "Shampoo khusus bayi 200ml",
      date: DateTime.now(),
    ),
    Expense(
      id: 'e12',
      title: "Set Pembersih Kamar Mandi Premium",
      category: "Produk Kebersihan",
      amount: 210000,
      description: "Paket cairan + sikat berkualitas",
      date: DateTime.now(),
    ),
  ];

  static List<Expense> get expenses => _expenses;

  static List<Expense> getExpenses() => _expenses;

  static void addExpense(Expense expense) {
    _expenses.insert(0, expense);
  }
}
