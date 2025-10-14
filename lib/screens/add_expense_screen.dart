import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../logic/expense_manager.dart';
import '../models/expense_model.dart';
import 'expense_list_screen.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'Kebutuhan Pokok';
  DateTime _selectedDate = DateTime.now();

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final newExpense = Expense(
        id: const Uuid().v4(),
        title: _titleController.text,
        category: _selectedCategory,
        amount: double.parse(_amountController.text),
        description: _descController.text,
        date: _selectedDate,
      );

      ExpenseManager.expenses.add(newExpense);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengeluaran berhasil ditambahkan!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ExpenseListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Kebutuhan Pokok',
      'Produk Segar',
      'Produk Kebersihan',
      'Produk Bernilai Tinggi',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengeluaran'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nama Pengeluaran'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama pengeluaran tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan jumlah pengeluaran' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                initialValue: _selectedCategory,
                items: categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Tanggal: ${DateFormat('dd MMM yyyy').format(_selectedDate)}',
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: const Text('Pilih Tanggal'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16)),
                child: const Text('SIMPAN PENGELUARAN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
