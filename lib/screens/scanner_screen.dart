import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:my_library/models/book.dart';
import 'package:my_library/utils.dart';
import 'package:sqflite/sqflite.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({Key? key, required this.onScanned, required this.db})
      : super(key: key);
  final Function onScanned;
  final Database db;

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        torchEnabled: true,
      ),
      onDetect: (capture) async {
        final List<Barcode> barcodes = capture.barcodes;
        if (barcodes.isEmpty) return;

        var bookData =
            await HttpUtils.getBookData(barcodes.first.rawValue ?? "");
        var bookJson = jsonDecode(bookData.body);

        Book book = Book(
            title: bookJson['title'] as String,
            isbn: barcodes.first.rawValue!,
            nbPages: bookJson['number_of_pages'] as int,
            cover: (bookJson['covers'][0] as int?).toString());

        if (context.mounted) {
          Navigator.pushNamed(context, '/book_screen',
              arguments: {'book': book, 'db': db});
          onScanned();
        }
      },
    );
  }
}
