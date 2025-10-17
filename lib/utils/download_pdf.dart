// ignore_for_file: avoid_print
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'save_utils.dart';
import '../models/expense_model.dart';

class DownloadPDF {
  static Future<void> generateExpenseReport(List<Expense> expenses) async {
    final pdf = pw.Document();
    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final dateNow = DateTime.now();
    final dateStr = DateFormat('ddMMyyyy_HHmm').format(dateNow);
    final dateHeader = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dateNow);

    // Warna tema korporat
    const primaryColor = PdfColor.fromInt(0xFF1E88E5); // biru elegan
    const secondaryColor = PdfColor.fromInt(0xFF1565C0);
    const textColor = PdfColors.black;

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(32),
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              alignment: pw.Alignment.bottomRight,
              margin: const pw.EdgeInsets.only(right: 20, bottom: 40),
              child: pw.Opacity(
                opacity: 0.07,
                child: pw.Text(
                  'CONFIDENTIAL',
                  style: pw.TextStyle(
                    fontSize: 70,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ),
          ),
        ),
        build: (context) => [
          // ===== HEADER =====
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 16),
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Checkout App',
                      style: pw.TextStyle(
                        color: primaryColor,
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Laporan Semua Pengeluaran',
                      style: pw.TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  dateHeader,
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // ===== TABEL DATA =====
          pw.Table.fromTextArray(
            headers: [
              'Judul',
              'Kategori',
              'Tanggal',
              'Jumlah (Rp)',
              'Deskripsi',
            ],
            data: expenses.map((e) {
              return [
                e.title,
                e.category,
                DateFormat('dd-MM-yyyy').format(e.date),
                NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(e.amount),
                e.description ?? '-',
              ];
            }).toList(),
            headerDecoration: const pw.BoxDecoration(
              color: secondaryColor,
            ),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
            cellStyle: const pw.TextStyle(
              fontSize: 9,
              color: PdfColors.black,
            ),
            border: pw.TableBorder.symmetric(
              inside: const pw.BorderSide(color: PdfColors.grey300),
              outside: const pw.BorderSide(color: PdfColors.grey400),
            ),
            cellAlignment: pw.Alignment.centerLeft,
            cellHeight: 22,
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(1.5),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(3),
            },
          ),

          pw.SizedBox(height: 20),

          // ===== TOTAL =====
          pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: primaryColor,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                'Total Pengeluaran: ${NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(total)}',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),

          pw.SizedBox(height: 30),

          // ===== FOOTER =====
          pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              '© ${DateTime.now().year} Checkout App — Generated Automatically',
              style: pw.TextStyle(
                fontSize: 9,
                color: PdfColors.grey600,
              ),
            ),
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    await savePDF(Uint8List.fromList(bytes), 'pengeluaran_$dateStr.pdf');
    print('✅ PDF laporan pengeluaran berhasil dibuat');
  }
}
