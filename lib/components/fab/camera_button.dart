import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventaris/pages/detail_page.dart';
import 'package:scan/scan.dart';

class CameraButton extends StatefulWidget {
  const CameraButton({super.key});

  @override
  State<CameraButton> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  ScanController controllerScanner = ScanController();
  String result = 'Unknown';

  final ImagePicker picker = ImagePicker();
  XFile? image;

  double getSizeWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 1;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "kamera",
      onPressed: () => showModalBottomSheet(
          context: context,
          elevation: 10,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) => Container(
              height: 500,
              decoration: const BoxDecoration(
                  color: Color(0xffF5F5F5),
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
                            const BorderRadius.all(Radius.circular(25)),
                        child: AspectRatio(
                          aspectRatio: 4 / 4.5,
                          child: ScanView(
                            controller: controllerScanner,
                            scanAreaScale: .7,
                            scanLineColor: Colors.white,
                            onCapture: (data) => _onQRFound(data),
                          ),
                        )),
                  ),
                  const Positioned(
                      bottom: 65,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Scan QR Code",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                            Text(
                              "Arahkan kamera ke barcode atau pilih gambar dari galeri.",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  height: 0.8),
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                    bottom: 10,
                    left: getSizeWidth(context) / 4,
                    child: Container(
                      width: getSizeWidth(context) / 2,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Color(0xffF5F5F5),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                controllerScanner.toggleTorchMode();
                                setState(() {});
                              },
                              icon: SvgPicture.asset(
                                "assets/icons/flash - off.svg",
                                colorFilter: const ColorFilter.mode(
                                    Color(0xffF5F5F5), BlendMode.difference),
                              )),
                          IconButton(
                              onPressed: () => _onSearchGallery(context),
                              icon: SvgPicture.asset(
                                "assets/icons/gallery.svg",
                                colorFilter: const ColorFilter.mode(
                                    Color(0xffF5F5F5), BlendMode.difference),
                              )),
                          IconButton(
                              onPressed: () {
                                controllerScanner.pause();
                                Navigator.pop(context);
                                setState(() {});
                              },
                              icon: SvgPicture.asset("assets/icons/close.svg",
                                  colorFilter: const ColorFilter.mode(
                                      Color(0xffF5F5F5),
                                      BlendMode.difference))),
                        ],
                      ),
                    ),
                  )
                ],
              ))),
      backgroundColor: const Color(0xFF378E55),
      child: const Icon(Icons.add_a_photo_outlined),
    );
  }

  void _onQRFound(data) {
    setState(() {
      result = data;
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  id: data,
                )));
  }

  void _onSearchGallery(BuildContext context) async {
    try {
      image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) throw Exception("Image is null");
      String? result = await Scan.parse(image!.path);

      if (result != null && context.mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                      id: result,
                    )));
      }

      // setState(() {});
    } catch (e) {
      // Handling exception
      debugPrint(e.toString());
    }
  }
}
