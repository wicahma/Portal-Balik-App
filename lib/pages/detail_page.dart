import 'dart:async';
import 'dart:io';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventaris/components/cards/detail_minicard.dart';
import 'package:inventaris/components/fab/camera_button.dart';
import 'package:inventaris/components/modal/images_product_modal.dart';
import 'package:inventaris/components/modal/pdf_view_modal.dart';
import 'package:path_provider/path_provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String pathPDF = "";

  late String error;

  @override
  void initState() {
    super.initState();
    fromAsset('assets/dokumen_testing.pdf', 'dokumen_testing.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();
    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      error = 'Error: ${e.toString()}';
    }
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: const Text('Detail Barang'),
          centerTitle: true,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
          backgroundColor: Colors.white,
        ),
        floatingActionButton: const CameraButton(),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xff255771),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff37718E),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Printer HP",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffF5F5F5),
                                ),
                              ),
                              Text(
                                "ID - A3SU5S123MN4C7U23S3U7",
                                style: TextStyle(
                                  color: Color(0xff255771),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF5F5F5),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text(
                                  "UPB BAGIAN UMUM",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff37718E),
                                  ),
                                ),
                              ),
                              ListView(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: const [
                                  Text(
                                    "Pemegang barang",
                                    style: TextStyle(
                                      color: Color(0xffF5F5F5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "Al Husain Mardani",
                                    style: TextStyle(
                                        color: Color(0xffF5F5F5),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        height: 1),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          )),
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.pressed)) {
                                                return const Color(0xFF72ADCB);
                                              }
                                              return const Color(0xff37718E);
                                            },
                                          ),
                                        ),
                                        onPressed: () => showModalBottomSheet(
                                            enableDrag: false,
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            builder: (BuildContext context) {
                                              if (pathPDF.isNotEmpty) {
                                                return PdfViewModal(
                                                    pathPDF: pathPDF);
                                              } else {
                                                return const PdfViewModal(
                                                    pathPDF: "");
                                              }
                                            }),
                                        icon: const Icon(
                                            Icons.description_rounded),
                                        label: const Text("Lihat PDF")),
                                    ElevatedButton.icon(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          )),
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.pressed)) {
                                                return const Color(0xFF72ADCB);
                                              }
                                              return const Color(0xff37718E);
                                            },
                                          ),
                                        ),
                                        onPressed: () => showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (BuildContext context) =>
                                                const ProductModal()),
                                        icon: const Icon(Icons.image_rounded),
                                        label: const Text("Lihat Barang")),
                                  ],
                                ),
                              ),
                              const MiniCard(
                                judul: "SPK/Kontrak",
                                dataKolom: [
                                  [
                                    "Nomor",
                                    "B/027/274/KPA/PPK/Umum.2/III/2022"
                                  ],
                                  ["Tanggal", "21, Maret 2022"],
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const MiniCard(
                                judul: "Bukti Pembayaran",
                                dataKolom: [
                                  [
                                    "Nomor SPM",
                                    "B/027/274/KPA/PPK/Umum.2/III/2022"
                                  ],
                                  ["Tanggal SPM", "21, Maret 2022"],
                                  ["Tanggal SP2D", "10, Mei 2022"],
                                  [
                                    "Nomor SP2D",
                                    "15.13/04.0/000337/LS/4.01.0.00.0.00.01.0000/M/5/2022"
                                  ]
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const MiniCard(
                                judul: "Jumlah Total",
                                dataKolom: [
                                  ["Jumlah", "2"],
                                  ["Harga Satuan", "Rp. 2.000.000,00"],
                                  ["Jumlah Harga", "Rp. 4.000.000,00"]
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("Total Belanja",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffF5F5F5),
                                  )),
                              const Text("Rp. 4.000.000,00",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    height: 1.1,
                                    fontSize: 33,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xffF5F5F5),
                                  ))
                            ],
                          ))
                    ])),
            const SizedBox(
              height: 80,
            )
          ],
        ));
  }
}
