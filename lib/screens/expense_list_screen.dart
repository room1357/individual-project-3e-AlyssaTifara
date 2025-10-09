import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../logic/expense_manager.dart';
import '../models/expense_model.dart';

class ExpenseListScreen extends StatefulWidget {
  final String? initialCategory;

  const ExpenseListScreen({super.key, this.initialCategory});

  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final List<Expense> _allExpenses = ExpenseManager.expenses;
  List<Expense> _filteredExpenses = [];
  String _selectedCategory = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'Semua';
    _allExpenses.sort((a, b) => b.date.compareTo(a.date));
    _filterExpenses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterExpenses() {
    setState(() {
      _filteredExpenses = _allExpenses.where((expense) {
        bool matchesSearch = _searchController.text.isEmpty ||
            expense.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            expense.description.toLowerCase().contains(_searchController.text.toLowerCase());

        bool matchesCategory = _selectedCategory == 'Semua' ||
            expense.category == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Kebutuhan Pokok':
        return Colors.green;
      case 'Produk Segar':
        return Colors.orange;
      case 'Produk Kebersihan':
        return Colors.purple;
      case 'Produk Bernilai Tinggi':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Kebutuhan Pokok':
        return Icons.shopping_basket;
      case 'Produk Segar':
        return Icons.local_grocery_store;
      case 'Produk Kebersihan':
        return Icons.cleaning_services;
      case 'Produk Bernilai Tinggi':
        return Icons.star;
      default:
        return Icons.category;
    }
  }

  void _showExpenseDetails(BuildContext context, Expense expense) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(expense.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                _formatCurrency(expense.amount.toDouble()),
                style: TextStyle(
                    fontSize: 20, color: Colors.red[700], fontWeight: FontWeight.w500),
              ),
              const Divider(height: 24),
              Text(expense.description,
                  style: const TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(_getCategoryIcon(expense.category),
                      color: _getCategoryColor(expense.category), size: 18),
                  const SizedBox(width: 8),
                  Text(expense.category, style: const TextStyle(fontSize: 16)),
                  const Spacer(),
                  const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                  const SizedBox(width: 8),
                  Text(DateFormat('dd MMM yyyy').format(expense.date),
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Semua', ..._allExpenses.map((e) => e.category).toSet().toList()];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedCategory == 'Semua'
            ? 'Semua Pengeluaran'
            : 'Kategori: $_selectedCategory'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari pengeluaran...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => _filterExpenses(),
            ),
          ),

          // Category filter
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    selectedColor: Colors.blue.withOpacity(0.3),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                        _filterExpenses();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Expense list dengan looping manual
          Expanded(
            child: _filteredExpenses.isEmpty
                ? const Center(child: Text('Tidak ada pengeluaran ditemukan'))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var expense in _filteredExpenses)
                          Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getCategoryColor(expense.category),
                                child: Icon(
                                  _getCategoryIcon(expense.category),
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              title: Text(expense.title,
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                '${expense.category} • ${DateFormat('dd MMM yyyy').format(expense.date)}',
                              ),
                              trailing: Text(
                                _formatCurrency(expense.amount.toDouble()),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700],
                                ),
                              ),
                              onTap: () => _showExpenseDetails(context, expense),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
