import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventaris/components/cards/detail_minicard.dart';
import 'package:inventaris/components/fab/camera_button.dart';
import 'package:inventaris/components/modal/images_product_modal.dart';
import 'package:inventaris/components/modal/pdf_view_modal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String id;

  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? _response;
  bool _isLoading = true;
  bool _isError = false;
  String _errorMsg =
      "Waduh data yang kamu cari gaada nih, bisa jadi udah dihapus sama si mimin, maaf yaa";
  String pathPDF = "";
  late String error;

  @override
  void initState() {
    super.initState();
    _getData(widget.id);
    fromAsset('assets/dokumen_testing.pdf', 'dokumen_testing.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
  }

  Future<void> _getData(String id) async {
    final url =
        "https://be.sibesti.com/api/kualitas/$id"; // Ganti dengan URL API yang sesuai
    try {
      final response = await http.get(Uri.parse(url));
      debugPrint(response.statusCode.toString());
      if (response.statusCode.toString().startsWith("2")) {
        debugPrint(response.body);
        setState(() {
          _isLoading = false;
          _response = jsonDecode(response.body);
        });
      } else {
        Map<String, dynamic> err = jsonDecode(response.body);
        String message = err['message'];
        setState(() {
          _isError = true;
          _isLoading = false;
          _errorMsg = message;
        });
        debugPrint(message);
      }
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
        _errorMsg = e.toString();
      });
    }
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
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xff37718E)),
              )
            : _isError
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/not-found.png',
                        width: 250,
                        height: 250,
                      ),
                      Text(
                        _errorMsg,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ))
                : ListView(
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _response!['data']['namaPemegang'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xffF5F5F5),
                                          ),
                                        ),
                                        Text(
                                          "ID - ${_response!['data']['_uuid']}"
                                              .toUpperCase(),
                                          style: const TextStyle(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF5F5F5),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Text(
                                            _response!['data']['upb'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff37718E),
                                            ),
                                          ),
                                        ),
                                        ListView(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          children: [
                                            const Text(
                                              "Pemegang barang",
                                              style: TextStyle(
                                                color: Color(0xffF5F5F5),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              _response!['data']
                                                  ['namaPemegang'],
                                              style: const TextStyle(
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
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    )),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith<Color>(
                                                      (Set<MaterialState>
                                                          states) {
                                                        if (states.contains(
                                                            MaterialState
                                                                .pressed)) {
                                                          return const Color(
                                                              0xFF72ADCB);
                                                        }
                                                        return const Color(
                                                            0xff37718E);
                                                      },
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      showModalBottomSheet(
                                                          enableDrag: false,
                                                          context: context,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          isScrollControlled:
                                                              true,
                                                          builder: (BuildContext
                                                              context) {
                                                            if (pathPDF
                                                                .isNotEmpty) {
                                                              return PdfViewModal(
                                                                  pathPDF:
                                                                      pathPDF);
                                                            } else {
                                                              return const PdfViewModal(
                                                                  pathPDF: "");
                                                            }
                                                          }),
                                                  icon: const Icon(Icons
                                                      .description_rounded),
                                                  label:
                                                      const Text("Lihat PDF")),
                                              ElevatedButton.icon(
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    )),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith<Color>(
                                                      (Set<MaterialState>
                                                          states) {
                                                        if (states.contains(
                                                            MaterialState
                                                                .pressed)) {
                                                          return const Color(
                                                              0xFF72ADCB);
                                                        }
                                                        return const Color(
                                                            0xff37718E);
                                                      },
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      showModalBottomSheet(
                                                          context: context,
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              const ProductModal()),
                                                  icon: const Icon(
                                                      Icons.image_rounded),
                                                  label: const Text(
                                                      "Lihat Barang")),
                                            ],
                                          ),
                                        ),
                                        MiniCard(
                                          judul: "SPK/Kontrak",
                                          dataKolom: [
                                            [
                                              "Nomor",
                                              _response!['data']['nomorSPK']
                                            ],
                                            [
                                              "Tanggal",
                                              _response!['data']['tanggalSPK']
                                            ],
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        MiniCard(
                                          judul: "Bukti Pembayaran",
                                          dataKolom: [
                                            [
                                              "Nomor SPM",
                                              _response!['data']['nomorSPM']
                                            ],
                                            [
                                              "Tanggal SPM",
                                              _response!['data']['tanggalSPM']
                                            ],
                                            [
                                              "Tanggal SP2D",
                                              _response!['data']['tanggalSP2D']
                                            ],
                                            [
                                              "Nomor SP2D",
                                              _response!['data']['nomorSP2D']
                                            ]
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        MiniCard(
                                          judul: "Jumlah Total",
                                          dataKolom: [
                                            [
                                              "Jumlah",
                                              _response!['data']['hargaSatuan']
                                                  .toString()
                                            ],
                                            [
                                              "Harga Satuan",
                                              _response!['data']['jumlahBarang']
                                                  .toString()
                                            ],
                                            [
                                              "Jumlah Harga",
                                              _response!['data']['jumlahHarga']
                                                  .toString()
                                            ]
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
                                        Text(
                                            _response!['data']['totalBelanja']
                                                .toString(),
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
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
