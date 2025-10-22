import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';
import '../models/user_model.dart';
import '../logic/expense_manager.dart';
import '../logic/user_manager.dart';

// 🎨 Warna tema global senada
const Color charcoal = Color(0xFF434D59); // abu elegan
const Color bone = Color(0xFFE1D9CC); // krem lembut
const Color maroon = Color(0xFF4B1C1A); // maroon tua elegan
const Color maroonLight = Color(0xFF6E2E2A); // maroon hangat

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
    color: maroonLight,
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
    color: charcoal,
  ),
  Category(
    id: 'c4',
    name: 'Produk Bernilai Tinggi',
    icon: Icons.star,
    color: maroon,
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

  // Shared expense fields
  bool _isShared = false;
  List<User> _availableUsers = [];
  List<String> _selectedUserIds = [];
  Map<String, TextEditingController> _splitAmountControllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize available users for sharing
    _availableUsers = UserManager().getAllUsersExceptCurrent();
  }

  @override
  void dispose() {
    // Dispose split amount controllers
    for (var controller in _splitAmountControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// ===================== SIMPAN DATA =====================
  void _submitExpense() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lengkapi semua field dulu')),
        );
        return;
      }

      // Validate shared expense split amounts
      if (_isShared && _selectedUserIds.isNotEmpty) {
        double totalSplit = 0;
        Map<String, double> splitAmounts = {};

        for (String userId in _selectedUserIds) {
          if (_splitAmountControllers.containsKey(userId)) {
            double splitAmount = double.tryParse(_splitAmountControllers[userId]!.text) ?? 0;
            if (splitAmount <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Jumlah split untuk ${_getUserName(userId)} harus lebih dari 0')),
              );
              return;
            }
            splitAmounts[userId] = splitAmount;
            totalSplit += splitAmount;
          }
        }

        double totalAmount = double.parse(_amountController.text);
        if ((totalSplit - totalAmount).abs() > 0.01) { // Allow small floating point differences
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Total split amount harus sama dengan jumlah pengeluaran')),
          );
          return;
        }
      }

      final newExpense = Expense(
        id: DateTime.now().toString(),
        title: _titleController.text,
        category: _selectedCategory!.name,
        amount: double.parse(_amountController.text),
        description: _descController.text,
        date: _selectedDate!,
        sharedWithUserIds: _isShared ? _selectedUserIds : [],
        splitAmounts: _isShared ? _buildSplitAmountsMap() : {},
      );

      ExpenseManager.addExpense(newExpense);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: maroonLight,
          content: Text(
            '✅ Pengeluaran "${_titleController.text}" berhasil disimpan!',
            style: const TextStyle(color: bone),
          ),
        ),
      );

      Navigator.pop(context, true);
    }
  }

  Map<String, double> _buildSplitAmountsMap() {
    Map<String, double> splitAmounts = {};
    for (String userId in _selectedUserIds) {
      if (_splitAmountControllers.containsKey(userId)) {
        double amount = double.tryParse(_splitAmountControllers[userId]!.text) ?? 0;
        splitAmounts[userId] = amount;
      }
    }
    return splitAmounts;
  }

  String _getUserName(String userId) {
    User? user = _availableUsers.firstWhere((u) => u.id == userId);
    return user?.fullName ?? 'Unknown User';
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: maroonLight,
              onPrimary: bone,
              onSurface: charcoal,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bone,
      appBar: AppBar(
        title: const Text(
          'Tambah Pengeluaran',
          style: TextStyle(color: bone, fontWeight: FontWeight.bold),
        ),
        backgroundColor: maroon,
        centerTitle: true,
        iconTheme: const IconThemeData(color: bone),
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
                  prefixIcon: Icon(Icons.description, color: maroonLight),
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
                  prefixIcon: Icon(Icons.attach_money, color: maroonLight),
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
                  prefixIcon: Icon(Icons.category, color: maroonLight),
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
                validator: (value) => value == null ? 'Pilih kategori' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal',
                    prefixIcon: Icon(Icons.calendar_today, color: maroonLight),
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
                  prefixIcon: Icon(Icons.text_snippet, color: maroonLight),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Shared Expense Toggle
              SwitchListTile(
                title: const Text('Bagikan Pengeluaran'),
                subtitle: const Text('Bagi pengeluaran dengan pengguna lain'),
                value: _isShared,
                onChanged: (value) {
                  setState(() {
                    _isShared = value;
                    if (!value) {
                      _selectedUserIds.clear();
                      _splitAmountControllers.clear();
                    }
                  });
                },
                activeColor: maroonLight,
              ),

              // User Selection for Shared Expenses
              if (_isShared) ...[
                const SizedBox(height: 16),
                const Text(
                  'Pilih Pengguna untuk Dibagikan:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _availableUsers.map((user) {
                    bool isSelected = _selectedUserIds.contains(user.id);
                    return FilterChip(
                      label: Text(user.fullName),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedUserIds.add(user.id);
                            _splitAmountControllers[user.id] = TextEditingController();
                          } else {
                            _selectedUserIds.remove(user.id);
                            _splitAmountControllers[user.id]?.dispose();
                            _splitAmountControllers.remove(user.id);
                          }
                        });
                      },
                      selectedColor: maroonLight.withOpacity(0.2),
                      checkmarkColor: maroonLight,
                    );
                  }).toList(),
                ),

                // Split Amount Inputs
                if (_selectedUserIds.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Jumlah Split per Pengguna:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._selectedUserIds.map((userId) {
                    User? user = _availableUsers.firstWhere((u) => u.id == userId);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextFormField(
                        controller: _splitAmountControllers[userId],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Split untuk ${user?.fullName ?? 'Unknown'}',
                          prefixIcon: const Icon(Icons.account_balance_wallet),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Wajib diisi untuk shared expense';
                          }
                          if (double.tryParse(value) == null || double.parse(value) <= 0) {
                            return 'Masukkan angka yang valid dan lebih dari 0';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                ],
              ],

              const SizedBox(height: 24),

              /// ===================== BUTTON SIMPAN =====================
              ElevatedButton.icon(
                onPressed: _submitExpense,
                icon: const Icon(Icons.save, color: bone),
                label: const Text(
                  'Simpan',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: bone),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: maroonLight,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
