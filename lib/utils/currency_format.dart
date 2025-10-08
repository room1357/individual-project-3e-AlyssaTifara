import 'package:intl/intl.dart';

/// Fungsi untuk format angka menjadi format Rupiah
String formatCurrency(int amount) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}
