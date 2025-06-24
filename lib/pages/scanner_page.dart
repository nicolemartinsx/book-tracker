import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                var value = capture.barcodes.first.rawValue;
                if (value != null) {
                  Navigator.pop(context, value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
