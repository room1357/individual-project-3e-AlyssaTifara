import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pemrograman_mobile/utils/download_pdf.dart';
import 'package:pemrograman_mobile/utils/save_utils.dart';
import '../logic/expense_manager.dart';
import '../models/expense_model.dart';
import 'edit_expense_screen.dart';

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

  static const Color charcoal = Color(0xFF36454F);
  static const Color bone = Color(0xFFE1D9CC);
  static const Color maroonDark = Color(0xFF4B1C1A);
  static const Color maroonLight = Color(0xFF6E2E2A);

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
        bool matchesCategory =
            _selectedCategory == 'Semua' || expense.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  String _formatCurrency(double amount) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
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
      backgroundColor: bone,
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
                  style:
                      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                _formatCurrency(expense.amount.toDouble()),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.red[700],
                    fontWeight: FontWeight.w500),
              ),
              const Divider(height: 24, color: Color(0xFF434D59)),
              Text(expense.description,
                  style:
                      const TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(_getCategoryIcon(expense.category),
                      color: _getCategoryColor(expense.category), size: 18),
                  const SizedBox(width: 8),
                  Text(expense.category, style: const TextStyle(fontSize: 16)),
                  const Spacer(),
                  const Icon(Icons.calendar_today,
                      color: Colors.grey, size: 16),
                  const SizedBox(width: 8),
                  Text(DateFormat('dd MMM yyyy').format(expense.date),
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit Pengeluaran'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: charcoal,
                  foregroundColor: bone,
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditExpenseScreen(
                        expense: expense,
                        onUpdateExpense: (updatedExpense) {
                          setState(() {
                            final index = _allExpenses.indexOf(expense);
                            if (index != -1) {
                              _allExpenses[index] = updatedExpense;
                            }
                            _filterExpenses();
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Hapus Pengeluaran'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _allExpenses.remove(expense);
                    _filterExpenses();
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _exportToCSV(BuildContext context) async {
    try {
      final allExpenses = ExpenseManager.expenses;
      // pilih data yang akan diexport: jika ada kategori terpilih selain 'Semua', hanya export kategori itu
      final exportList = _selectedCategory == 'Semua'
          ? allExpenses
          : allExpenses.where((e) => e.category == _selectedCategory).toList();

      if (exportList.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Tidak ada data untuk diexport.')));
        return;
      }

      final rows = <List<dynamic>>[];
      if (_selectedCategory != 'Semua') {
        // tambahkan baris keterangan kategori di atas header untuk CSV
        rows.add(['Kategori', _selectedCategory]);
      }
      rows.addAll([
        ['Judul', 'Kategori', 'Tanggal', 'Jumlah (Rp)', 'Deskripsi'],
        ...exportList.map((e) => [
              e.title,
              e.category,
              DateFormat('dd-MM-yyyy').format(e.date),
              e.amount,
              e.description,
            ]),
      ]);

      final csvData = const ListToCsvConverter().convert(rows);
      final csvWithBom = '\uFEFF$csvData';
      final dateStr = DateFormat('ddMMyyyy_HHmm').format(DateTime.now());

      final catSlug = _selectedCategory == 'Semua'
          ? 'semua'
          : _selectedCategory.replaceAll(' ', '_').toLowerCase();

      await saveCSV(csvWithBom, 'pengeluaran_${catSlug}_$dateStr.csv');

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('✅ Data berhasil diexport ke CSV')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal export CSV: $e')));
    }
  }

  Future<void> _exportToPDF(BuildContext context) async {
    try {
      final allExpenses = ExpenseManager.expenses;
      final exportList = _selectedCategory == 'Semua'
          ? allExpenses
          : allExpenses.where((e) => e.category == _selectedCategory).toList();

      if (exportList.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Tidak ada data untuk diexport.')));
        return;
      }

  await DownloadPDF.generateExpenseReport(exportList, category: _selectedCategory == 'Semua' ? null : _selectedCategory);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('✅ Data berhasil diexport ke PDF')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal export PDF: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Semua', ..._allExpenses.map((e) => e.category).toSet()];

    final bool wasPushed = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: bone,
      appBar: (wasPushed && _selectedCategory != 'Semua')
          ? AppBar(
              backgroundColor: maroonDark,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: bone,
                onPressed: () => Navigator.pop(context),
                tooltip: 'Kembali',
              ),
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Kategori: $_selectedCategory',
                  style: const TextStyle(
                    color: Color(0xFFE1D9CC),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header sejajar dengan ikon export
          Container(
            color: bone,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedCategory == 'Semua'
                        ? "Semua Pengeluaran"
                        : "Kategori: $_selectedCategory",
                    style: const TextStyle(
                      color: charcoal,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf, color: charcoal),
                  onPressed: () => _exportToPDF(context),
                  tooltip: 'Export ke PDF',
                ),
                IconButton(
                  icon: const Icon(Icons.file_upload, color: charcoal),
                  onPressed: () => _exportToCSV(context),
                  tooltip: 'Export ke CSV',
                ),
              ],
            ),
          ),

          // 🔹 Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari pengeluaran...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => _filterExpenses(),
            ),
          ),

          // 🔹 Filter kategori
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : charcoal,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    backgroundColor: Colors.white,
                    selectedColor: charcoal,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isSelected
                            ? charcoal
                            : charcoal.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    checkmarkColor: Colors.white,
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

          // 🔹 Daftar pengeluaran
          Expanded(
            child: _filteredExpenses.isEmpty
                ? const Center(child: Text('Tidak ada pengeluaran ditemukan'))
                : SingleChildScrollView(
                    child: Column(
                      children: _filteredExpenses.map((expense) {
                        return Card(
                          color: Colors.white,
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
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
