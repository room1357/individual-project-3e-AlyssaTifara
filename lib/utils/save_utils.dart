// lib/utils/save_utils.dart
import 'dart:html' as html;
import 'dart:typed_data';

/// 🔹 Simpan file CSV (untuk Flutter Web)
Future<void> saveCSV(String data, String filename) async {
  final csvWithBom = '\uFEFF$data';
  final blob = html.Blob([csvWithBom], 'text/csv;charset=utf-8');
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();

  html.Url.revokeObjectUrl(url);
}

/// 🔹 Simpan file PDF (untuk Flutter Web)
Future<void> savePDF(Uint8List bytes, String filename) async {
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();

  html.Url.revokeObjectUrl(url);
}
