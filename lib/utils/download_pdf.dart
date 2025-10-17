// lib/utils/download_pdf.dart
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
    final dateStr = DateFormat('ddMMyyyy_HHmm').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Laporan Semua Pengeluaran',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
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
                e.description ?? '',
              ];
            }).toList(),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.blueGrey900),
            border: pw.TableBorder.all(color: PdfColors.grey400),
            cellStyle: const pw.TextStyle(fontSize: 10),
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.SizedBox(height: 20),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Total Pengeluaran: ${NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              ).format(total)}',
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    await savePDF(Uint8List.fromList(bytes), 'pengeluaran_$dateStr.pdf');
  }
}
