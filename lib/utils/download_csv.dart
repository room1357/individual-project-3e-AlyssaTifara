import 'dart:html' as html;

Future<void> saveCSV(String data, String filename) async {
  final blob = html.Blob([data], 'text/csv;charset=utf-8');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}
