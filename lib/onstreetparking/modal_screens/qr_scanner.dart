import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../onstreetparking/modal_screens/qr_web_view.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart';
class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {

  Barcode? result;
  QRViewController? controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }



  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }
  String finalQr = "";
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        _handleURLButtonPress(context,'${result!.code}');
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

        children:  <Widget>[

          Expanded(flex: 4, child: _buildQrView(context)),
          // Expanded(
          //   flex: 1,
          //   child: FittedBox(
          //     fit: BoxFit.contain,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         if (result != null)
          //           Text( 'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //         else
          //           const Text('Scan a code'),
          //         // Row(
          //         //   mainAxisAlignment: MainAxisAlignment.center,
          //         //   crossAxisAlignment: CrossAxisAlignment.center,
          //         //   children: <Widget>[
          //         //     // Container(
          //         //     //   margin: const EdgeInsets.all(8),
          //         //     //   child: ElevatedButton(
          //         //     //       onPressed: () async {
          //         //     //         // await controller?.toggleFlash();
          //         //     //         // setState(() {});
          //         //     //         _handleURLButtonPress(context,'${result!.code}');
          //         //     //       },
          //         //     //       child: const Text("Open"),
          //         //     //     style: ElevatedButton.styleFrom(
          //         //     //         onPrimary: Colors.black,
          //         //     //         primary: const Color(0xffffcc00)),),
          //         //     //
          //         //     // ),
          //         //
          //         //     // MaterialButton(
          //         //     //   minWidth: double.infinity,
          //         //     //   height: 60,
          //         //     //   color: Color(0xffffcc00),
          //         //     //   onPressed: () async {
          //         //     //     await controller?.flipCamera();
          //         //     //     setState(() {});
          //         //     //   },
          //         //     //   // defining the shape
          //         //     //   shape: RoundedRectangleBorder(
          //         //     //       side: const BorderSide(
          //         //     //           color: Colors.black
          //         //     //       ),
          //         //     //       borderRadius: BorderRadius.circular(50)
          //         //     //   ),
          //         //     //   child: const Text(
          //         //     //     "Open",
          //         //     //     style: TextStyle(
          //         //     //         fontWeight: FontWeight.w600,
          //         //     //         fontSize: 18
          //         //     //     ),
          //         //     //   ),
          //         //     // )
          //         //   ],
          //         // ),
          //
          //       ],
          //     ),
          //   ),
          // )

        ],


      ),



    );
  }

}
void _handleURLButtonPress(BuildContext context, String url) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => load_Qr(url)));
}