import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventaris/components/modal/clipper_modal.dart';

class PdfViewModal extends StatefulWidget {
  const PdfViewModal({super.key, required this.pathPDF});

  final String pathPDF;

  @override
  State<PdfViewModal> createState() => _PdfViewModalState();
}

class _PdfViewModalState extends State<PdfViewModal> {
  final Completer<PDFViewController> _controllerPDF =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  double getSizeWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 1 / 5;
  double getSizeHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 1 / 5;

  @override
  void initState() {
    super.initState();
    if (widget.pathPDF.isEmpty) {
      setState(() {
        errorMessage = 'File tidak ditemukan di telepon anda';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                bottom: -getSizeHeight(context) * 0.02,
                child: Container(
                  width: getSizeWidth(context) * 2.75,
                  height: 15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                  left: getSizeWidth(context) * 2.755,
                  bottom: -getSizeHeight(context) * 0.03,
                  child: ClipPath(
                    clipper: ClipperModal(),
                    child: const SizedBox(
                      width: 27,
                      height: 27,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Colors.white,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: const Text(
                  "Dokumen Pemegang",
                  style: TextStyle(
                    color: Color(0xff37718E),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(30)),
                  color: Colors.white,
                ),
                height: MediaQuery.of(context).size.height * 7 / 12,
                child: PDFView(
                  fitEachPage: true,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageSnap: true,
                  defaultPage: currentPage!,
                  fitPolicy: FitPolicy.WIDTH,
                  nightMode: false,
                  preventLinkNavigation: true,
                  filePath: widget.pathPDF,
                  onRender: (pagesPDF) {
                    setState(() {
                      pages = pagesPDF;
                      isReady = true;
                    });
                  },
                  onError: (error) {
                    setState(() {
                      errorMessage = error.toString();
                    });
                    debugPrint(error.toString());
                  },
                  onPageError: (page, error) {
                    setState(() {
                      errorMessage = '$page: ${error.toString()}';
                    });
                    debugPrint('$page: ${error.toString()}');
                  },
                  onViewCreated: (PDFViewController pdfViewController) {
                    if (!_controllerPDF.isCompleted) {
                      _controllerPDF.complete(pdfViewController);
                    }
                  },
                )),
            Container(
              padding: const EdgeInsets.all(13),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
                color: Colors.white,
              ),
              child: errorMessage.isEmpty
                  ? !isReady
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container()
                  : Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          'Error: $errorMessage',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                            "Coba untuk menghapus data barang lalu scan ulang barcode.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1,
                            ))
                      ]),
                    ),
            )
          ],
        )
      ],
    );
  }
}
