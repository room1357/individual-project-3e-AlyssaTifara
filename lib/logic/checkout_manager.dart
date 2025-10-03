import '../models/expense_model.dart';

class CheckoutManager {
  static final List<Expense> checkoutItems = [];

  static void addToCheckout(Expense expense) {
    checkoutItems.add(expense);
  }

  static void clearCheckout() {
    checkoutItems.clear();
  }
}
