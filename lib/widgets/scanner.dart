import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fidelity/const/color.dart';
import 'package:fidelity/providers/auth.dart';
import 'package:fidelity/providers/users.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          FittedBox(
            fit: BoxFit.contain,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              return Text('Flash: ${snapshot.data}', style: const TextStyle(color: bkColor),);
                            },
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Text(
                                  style: const TextStyle(
                                    color: bkColor
                                  ),
                                    'Camera facing ${describeEnum(snapshot.data!)}');
                              } else {
                                return const Text('loading', style: TextStyle(color: bkColor),);
                              }
                            },
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        onPressed: () async {
                          controller?.pauseCamera();
                          await Navigator.pushNamed(context, '/home');
                        },
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            color: bkColor
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {

    final user = Provider.of<Users>(context);

    var scanArea = (MediaQuery.of(context).size.width < 400 ||
      MediaQuery.of(context).size.height < 400)
      ? 150.0
      : 300.0;



    void _onQRViewCreated(QRViewController controller) {
      setState(() {
        this.controller = controller;
      });
      controller.scannedDataStream.listen((scanData) async {
        if(scanData.code == "") {
          logger.d(scanData.code);
        } else {
          var decodedCode = jsonDecode(scanData.code.toString());
          if(decodedCode['type'] == 'customer') {
            controller.pauseCamera();
            await user.getOneUser(decodedCode['content']);
            await Navigator.pushReplacementNamed(context, '/userPage');
          }
        }
      });
    }

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
}

