// class Expense {
//   final String title;
//   final String description;
//   final double amount;
//   final DateTime date;
//   final String category;

//   Expense({
//     required this.title,
//     required this.description,
//     required this.amount,
//     required this.date,
//     required this.category,
//   });

//   @override
//   String toString() {
//     return 'Expense(title: $title, amount: $amount, date: $date, category: $category)';
//   }
// }

class Expense {
  final String title;
  final String category;
  final double amount;
  final String description;

  Expense({
    required this.title,
    required this.category,
    required this.amount,
    required this.description,
  });
}

