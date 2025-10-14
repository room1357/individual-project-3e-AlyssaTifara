import '../models/expense_model.dart';
import 'expense_manager.dart';

/// Class ini berisi berbagai contoh looping dan operasi data pada list Expense.
/// Kamu bisa pakai fungsi di sini untuk latihan atau logika tambahan di UI.
class LoopingExamples {
  // Ambil data langsung dari ExpenseManager
  static List<Expense> expenses = ExpenseManager.expenses;

  // ---------------------------------------------------------------------------
  // 1. Menghitung Total Pengeluaran
  // ---------------------------------------------------------------------------

  /// Cara 1: For loop tradisional
  static double calculateTotalTraditional(List<Expense> expenses) {
    double total = 0;
    for (int i = 0; i < expenses.length; i++) {
      total += expenses[i].amount;
    }
    return total;
  }

  /// Cara 2: For-in loop
  static double calculateTotalForIn(List<Expense> expenses) {
    double total = 0;
    for (Expense expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  /// Cara 3: forEach method
  static double calculateTotalForEach(List<Expense> expenses) {
    double total = 0;
    for (var expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  /// Cara 4: fold method (paling efisien)
  static double calculateTotalFold(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  /// Cara 5: reduce method
  static double calculateTotalReduce(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;
    return expenses.map((e) => e.amount).reduce((a, b) => a + b);
  }

  // ---------------------------------------------------------------------------
  // 2. Mencari Item berdasarkan ID
  // ---------------------------------------------------------------------------

  /// Cara 1: For loop dengan break
  static Expense? findExpenseTraditional(List<Expense> expenses, String id) {
    for (int i = 0; i < expenses.length; i++) {
      if (expenses[i].id == id) {
        return expenses[i];
      }
    }
    return null;
  }

  /// Cara 2: firstWhere method (lebih ringkas)
  static Expense? findExpenseWhere(List<Expense> expenses, String id) {
    try {
      return expenses.firstWhere((expense) => expense.id == id);
    } catch (e) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 3. Filtering berdasarkan kategori
  // ---------------------------------------------------------------------------

  /// Cara 1: Loop manual dengan List.add()
  static List<Expense> filterByCategoryManual(List<Expense> expenses, String category) {
    List<Expense> result = [];
    for (Expense expense in expenses) {
      if (expense.category.toLowerCase() == category.toLowerCase()) {
        result.add(expense);
      }
    }
    return result;
  }

  /// Cara 2: where method (lebih efisien dan mudah dibaca)
  static List<Expense> filterByCategoryWhere(List<Expense> expenses, String category) {
    return expenses.where((expense) =>
        expense.category.toLowerCase() == category.toLowerCase()).toList();
  }

  // ---------------------------------------------------------------------------
  // 4. Contoh tambahan: Mendapatkan item dengan harga tertinggi dan terendah
  // ---------------------------------------------------------------------------

  static Expense? findMostExpensive(List<Expense> expenses) {
    if (expenses.isEmpty) return null;
    expenses.sort((a, b) => b.amount.compareTo(a.amount));
    return expenses.first;
  }

  static Expense? findCheapest(List<Expense> expenses) {
    if (expenses.isEmpty) return null;
    expenses.sort((a, b) => a.amount.compareTo(b.amount));
    return expenses.first;
  }
}
