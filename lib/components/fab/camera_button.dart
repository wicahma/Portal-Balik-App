import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CameraButton extends StatefulWidget {
  const CameraButton({super.key});

  @override
  State<CameraButton> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String flashDir = "assets/icons/flash - off.svg";

  final ImagePicker picker = ImagePicker();

  late final XFile? image;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  double getSizeWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 1;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet(
          context: context,
          elevation: 10,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) => Container(
              height: 500,
              decoration: const BoxDecoration(
                  color: Color(0xff37718E),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: getSizeWidth(context),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: AspectRatio(
                          aspectRatio: 4 / 4.5,
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                            overlay: QrScannerOverlayShape(
                                borderRadius: 20,
                                overlayColor: Colors.white24,
                                borderColor: Colors.white,
                                borderLength: 30,
                                cutOutBottomOffset: 25,
                                borderWidth: 5,
                                cutOutSize: 350),
                          ),
                        )),
                  ),
                  // TextButton(onPressed: () {}, child: const Text("flash")),
                  Positioned(
                    bottom: 0,
                    left: getSizeWidth(context) / 4,
                    child: Container(
                      width: getSizeWidth(context) / 2,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () async {
                                await controller!.toggleFlash();
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.flash_on,
                              )),
                          IconButton(
                              onPressed: () async {
                                image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                              icon: const Icon(Icons.photo_library)),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {});
                              },
                              icon: const Icon(Icons.close_rounded)),
                        ],
                      ),
                    ),
                  )
                ],
              ))),
      backgroundColor: const Color(0xff37718E),
      child: const Icon(Icons.add_a_photo_outlined),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    // controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }
}
