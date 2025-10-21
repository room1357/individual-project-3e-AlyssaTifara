import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../logic/expense_manager.dart';
import '../models/expense_model.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  late List<Expense> _expenses;
  late Map<String, double> _byCategory;

  // 🎨 Warna tema
  static const Color maroonDark = Color(0xFF4B1C1A);
  static const Color maroonLight = Color(0xFF6E2E2A);
  static const Color bone = Color(0xFFE1D9CC);
  static const Color charcoal = Color(0xFF36454F); // warna utama teks elegan

  @override
  void initState() {
    super.initState();
    _expenses = ExpenseManager.expenses;
    _calculateByCategory();
  }

  void _calculateByCategory() {
    final Map<String, double> map = {};
    for (var e in _expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount.toDouble();
    }
    _byCategory = map;
  }

  double get _total => _expenses.fold(0, (p, e) => p + e.amount);
  double get _average => _expenses.isEmpty ? 0 : _total / _expenses.length;
  double get _max =>
      _expenses.isEmpty ? 0 : _expenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b).toDouble();

  List<PieChartSectionData> _buildPieSections() {
    final colors = [
      maroonLight,
      Colors.orange.shade400,
      Colors.green.shade600,
      Colors.purple.shade400,
      Colors.blueGrey.shade400,
      Colors.teal.shade400,
    ];

    final entries = _byCategory.entries.toList();
    final total = _byCategory.values.fold<double>(0, (p, v) => p + v);

    return List.generate(entries.length, (i) {
      final e = entries[i];
      final value = e.value;
      final percent = total == 0 ? 0 : (value / total) * 100;
      return PieChartSectionData(
        color: colors[i % colors.length],
        value: value,
        title: '${percent.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  BarChartGroupData _makeGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: maroonLight,
          width: 18,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    final currency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Ringkasan Pengeluaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: charcoal,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem("Total", currency.format(_total)),
                _buildSummaryItem("Rata-rata", currency.format(_average)),
                _buildSummaryItem("Transaksi", '${_expenses.length}x'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaksi Terbesar',
                  style: TextStyle(color: charcoal),
                ),
                Text(
                  currency.format(_max),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: maroonDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: charcoal)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: maroonDark,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = _byCategory.entries.toList();
    final currency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: bone,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟤 Header elegan seperti di HomeScreen
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: bone),
              child: const Text(
                "Statistik Pengeluaran",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: charcoal, // ✅ sudah diganti jadi charcoal
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            _buildSummaryCard(),
            const SizedBox(height: 8),

            // 🔹 Pie Chart Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Distribusi per Kategori',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: charcoal,
                ),
              ),
            ),
            const SizedBox(height: 8),

            if (entries.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Tidak ada data pengeluaran.'),
              )
            else
              Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: _buildPieSections(),
                            centerSpaceRadius: 40,
                            sectionsSpace: 3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: List.generate(entries.length, (i) {
                          final e = entries[i];
                          final colorList = [
                            maroonLight,
                            Colors.orange.shade400,
                            Colors.green.shade600,
                            Colors.purple.shade400,
                            Colors.blueGrey.shade400,
                            Colors.teal.shade400
                          ];
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  width: 12,
                                  height: 12,
                                  color: colorList[i % colorList.length]),
                              const SizedBox(width: 6),
                              Text(
                                '${e.key} (${currency.format(e.value)})',
                                style: const TextStyle(color: charcoal),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // 🔹 Bar Chart Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Pengeluaran per Kategori (Bar Chart)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: charcoal,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 240,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (_byCategory.values.isEmpty
                              ? 1
                              : _byCategory.values
                                      .reduce((a, b) => a > b ? a : b)) *
                          1.2,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return const Text('0');
                              if (value >= 1000000) {
                                return Text('${(value / 1000000).toStringAsFixed(0)}M');
                              } else if (value >= 1000) {
                                return Text('${(value / 1000).toStringAsFixed(0)}K');
                              }
                              return Text(value.toStringAsFixed(0));
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= entries.length) {
                                return const SizedBox.shrink();
                              }
                              String label = entries[idx].key;
                              if (label.length > 12) {
                                label = '${label.substring(0, 12)}...';
                              }
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: charcoal,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles:
                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles:
                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: true, drawVerticalLine: true),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(
                        entries.length,
                        (i) => _makeGroup(i, entries[i].value),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
