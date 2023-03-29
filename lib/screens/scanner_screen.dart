
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:my_library/utils.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
        // fit: BoxFit.contain,
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
          torchEnabled: true,
        ),
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          if(barcodes.isEmpty)return;
          
          var bookData = await HttpUtils.getBookData(barcodes.first.rawValue??"");
          debugPrint(bookData.body);
        },
      );
  }
}
