import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import '../logic/expense_manager.dart';
import '../models/expense_model.dart';
import '../utils/save_utils.dart';
import '../utils/download_pdf.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    final expenses = ExpenseManager.expenses;
    final filtered = _selectedCategory == 'Semua'
        ? expenses
        : expenses.where((e) => e.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2193b0),
        title: const Text(
          'Checkout App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Bagian Header "Semua Pengeluaran" + Tombol Export
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Semua Pengeluaran',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Export ke CSV',
                      icon: const Icon(Icons.file_present, color: Colors.black54),
                      onPressed: () => _exportToCSV(context),
                    ),
                    IconButton(
                      tooltip: 'Export ke PDF',
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.black54),
                      onPressed: () => _exportToPDF(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔹 Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Cari pengeluaran...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // 🔹 Filter kategori (chips)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildCategoryChip('Semua'),
                _buildCategoryChip('Produk Bernilai Tinggi'),
                _buildCategoryChip('Kebutuhan Pokok'),
                _buildCategoryChip('Produk Segar'),
                _buildCategoryChip('Produk Kebersihan'),
              ],
            ),
          ),

          // 🔹 Daftar Pengeluaran
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final e = filtered[index];
                return ListTile(
                  leading: const Icon(Icons.star, color: Colors.red),
                  title: Text(e.title),
                  subtitle: Text(
                    '${e.category} • ${DateFormat('dd MMM yyyy').format(e.date)}',
                  ),
                  trailing: Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp ',
                      decimalDigits: 0,
                    ).format(e.amount),
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // =================== EXPORT CSV ===================
  Future<void> _exportToCSV(BuildContext context) async {
    try {
      final allExpenses = ExpenseManager.expenses;

      if (allExpenses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada data untuk diexport.')),
        );
        return;
      }

      final rows = [
        ['Judul', 'Kategori', 'Tanggal', 'Jumlah (Rp)', 'Deskripsi'],
        ...allExpenses.map((e) => [
              e.title,
              e.category,
              DateFormat('dd-MM-yyyy').format(e.date),
              e.amount,
              e.description ?? '',
            ]),
      ];

      final csvData = const ListToCsvConverter().convert(rows);
      final csvWithBom = '\uFEFF$csvData';
      final dateStr = DateFormat('ddMMyyyy_HHmm').format(DateTime.now());

      await saveCSV(csvWithBom, 'semua_pengeluaran_$dateStr.csv');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Data berhasil diexport ke CSV')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal export CSV: $e')),
      );
    }
  }

  // =================== EXPORT PDF ===================
  Future<void> _exportToPDF(BuildContext context) async {
    try {
      final allExpenses = ExpenseManager.expenses;

      if (allExpenses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada data untuk diexport.')),
        );
        return;
      }

  await DownloadPDF.generateExpenseReport(allExpenses, category: null);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Data berhasil diexport ke PDF')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal export PDF: $e')),
      );
    }
  }

  // 🔹 Widget kategori chip
  Widget _buildCategoryChip(String name) {
    final isSelected = _selectedCategory == name;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(name),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedCategory = name),
        selectedColor: Colors.blue.shade100,
      ),
    );
  }
}
