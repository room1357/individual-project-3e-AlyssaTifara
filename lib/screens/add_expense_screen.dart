import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';
import '../logic/expense_manager.dart';
import '../utils/save_utils.dart'; // ✅ untuk fungsi saveCSV

// 🔹 Model Kategori
class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

// 🔹 Daftar kategori tetap
final List<Category> categories = [
  Category(
    id: 'c1',
    name: 'Kebutuhan Pokok',
    icon: Icons.shopping_basket,
    color: Colors.green,
  ),
  Category(
    id: 'c2',
    name: 'Produk Segar',
    icon: Icons.local_grocery_store,
    color: Colors.orange,
  ),
  Category(
    id: 'c3',
    name: 'Produk Kebersihan',
    icon: Icons.cleaning_services,
    color: Colors.purple,
  ),
  Category(
    id: 'c4',
    name: 'Produk Bernilai Tinggi',
    icon: Icons.star,
    color: Colors.red,
  ),
];

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DateTime? _selectedDate;
  Category? _selectedCategory;

  /// ===================== SIMPAN DATA =====================
  void _submitExpense() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lengkapi semua field dulu')),
        );
        return;
      }

      final newExpense = Expense(
        id: DateTime.now().toString(),
        title: _titleController.text,
        category: _selectedCategory!.name,
        amount: double.parse(_amountController.text),
        description: _descController.text,
        date: _selectedDate!,
      );

      ExpenseManager.addExpense(newExpense);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Pengeluaran "${_titleController.text}" berhasil disimpan!',
          ),
        ),
      );

      Navigator.pop(context, true);
    }
  }

  /// ===================== EXPORT CSV =====================
  Future<void> _exportSingleToCSV() async {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi semua field sebelum export!')),
      );
      return;
    }

    final csv = 'Judul,Kategori,Tanggal,Jumlah (Rp),Deskripsi\n'
        '${_titleController.text},'
        '${_selectedCategory!.name},'
        '${DateFormat('dd-MM-yyyy').format(_selectedDate!)},'
        '${_amountController.text},'
        '${_descController.text.isEmpty ? '-' : _descController.text}';

    await saveCSV(csv, 'pengeluaran_baru.csv');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Data berhasil diexport ke CSV')),
    );
  }

  /// ===================== PICK DATE =====================
  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Pengeluaran',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2193b0),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Pengeluaran',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah (Rp)',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Category>(
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Row(
                            children: [
                              Icon(cat.icon, color: cat.color),
                              const SizedBox(width: 8),
                              Text(cat.name),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) =>
                    value == null ? 'Pilih kategori' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Pilih tanggal'
                        : DateFormat('dd MMMM yyyy', 'id_ID')
                            .format(_selectedDate!),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (Opsional)',
                  prefixIcon: Icon(Icons.text_snippet),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              /// ===================== BUTTONS =====================
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submitExpense,
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'Simpan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2193b0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _exportSingleToCSV,
                      icon: const Icon(Icons.file_download),
                      label: const Text(
                        'Export CSV',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
