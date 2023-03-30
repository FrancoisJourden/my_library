import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:my_library/models/book.dart';
import 'package:my_library/utils.dart';
import 'package:sqflite/sqflite.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key, required this.onScanned, required this.db}) : super(key: key);
  final Function onScanned;
  final Database db;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController cameraController = MobileScannerController(
    torchEnabled: false,
  );
  bool lockDetect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) => _onDetect(context, capture),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: cameraController.toggleTorch,
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                return Icon((state == TorchState.off) ? Icons.flash_off : Icons.flash_on);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onDetect(BuildContext context, BarcodeCapture capture) async {
    //to avoid scanning the code again when fetching data from the API
    if (lockDetect) return;
    lockDetect = true;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) {
      lockDetect = false;
      return;
    }

    var bookData = await HttpUtils.getBookData(barcodes.first.rawValue ?? "");
    try {
      var bookJson = jsonDecode(bookData.body);

      Book book = Book(
        title: bookJson['title'] as String,
        isbn: barcodes.first.rawValue!,
        nbPages: bookJson['number_of_pages'] as int,
        cover: (bookJson['covers'][0] as int?).toString(),
      );

      if (context.mounted) {
        Navigator.pushNamed(context, '/book_screen', arguments: {'book': book, 'db': widget.db});
        widget.onScanned();
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Code incorrect ou livre inconnu")));
      }
    }
    lockDetect = false;
  }
}
