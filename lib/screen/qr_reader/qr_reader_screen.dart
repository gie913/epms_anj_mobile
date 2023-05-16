import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRReaderScreen extends StatefulWidget {
  const QRReaderScreen({Key? key}) : super(key: key);

  @override
  State<QRReaderScreen> createState() => _QRReaderScreenState();
}

class _QRReaderScreenState extends State<QRReaderScreen> {
  QRViewController? _controller;

  QRViewController? get controller => _controller;

  final GlobalKey qrKeyTPH = GlobalKey(debugLabel: 'QR');

  final GlobalKey qrKeyOPH = GlobalKey(debugLabel: 'QR');

  Barcode? _result;

  Barcode? get result => _result;

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    return Container(
      height: 300,
      child: QRView(
        key: qrKeyTPH,
        onQRViewCreated: (controller) {
          _controller = controller;
          controller.scannedDataStream.listen((scanData) {
            _result = scanData;
            if (result != null) {
              _controller?.stopCamera();
              Navigator.pop(context, _result?.code);
            }
          });
        },
        overlay: QrScannerOverlayShape(
            borderColor: Colors.blue,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
      ),
    );
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

}
