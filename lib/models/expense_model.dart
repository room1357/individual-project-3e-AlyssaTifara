import 'package:intl/intl.dart';

class Expense {
  final String id;
  final String title;
  final String category;
  final double amount;
  final String description;
  final DateTime date;
  final List<String> sharedWithUserIds; // IDs of users sharing this expense
  final Map<String, double> splitAmounts; // User ID -> their share amount

  Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
    this.sharedWithUserIds = const [],
    this.splitAmounts = const {},
  });

  String get formattedDate {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }

  String get formattedAmount {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }
}
