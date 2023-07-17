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
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  NumberFormat rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
  );
  String _tanggal(String tanggal) {
    return DateFormat('EEEE, dd MMMM yyyy, HH:mm:ss', 'id_ID')
        .format(DateTime.parse(tanggal));
  }

  @override
  void initState() {
    super.initState();
    _getData(widget.id);
  }

  Future<void> _saveToLocalStorage(Map<String, dynamic> data) async {
    try {
      String dataJSON = jsonEncode(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> historyList = prefs.getStringList('riwayat') ?? [];

      if (historyList.isEmpty) {
        historyList.add(dataJSON);
        debugPrint("Datanya gaada, list baru ditambahkan");
      }

      int isExist = historyList.indexWhere((element) {
        return jsonDecode(element)["_idBarang"].toString() ==
                data["_idBarang"].toString() &&
            jsonDecode(element)["barangKe"].toString() ==
                data["barangKe"].toString();
      });
      debugPrint("isExist: $isExist");

      if (isExist != -1) {
        historyList.removeAt(isExist);
        historyList.add(dataJSON);
        debugPrint("Datanya udah ada, dihapus dulu");
      } else {
        historyList.add(dataJSON);
        debugPrint("Datanya gaada, list baru ditambahkan");
      }

      if (historyList.length > 5) {
        historyList.removeAt(0);
      }

      prefs.setStringList('riwayat', historyList);
    } catch (err) {
      // handling error
    }
  }

  Future<void> _getData(String id) async {
    final url =
        "https://be.sibesti.com/api/kualitas/$id"; // Ganti dengan URL API yang sesuai
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode.toString().startsWith("2")) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _isLoading = false;
          _response = data;
        });
        await _saveToLocalStorage(data["data"]);
        await _getFileFromUrl(
                "https://www.be.sibesti.com/${data["data"]["dokumenPemegang"]}",
                name: data["data"]["dokumenPemegang"])
            .then(
          (values) => {
            setState(() {
              // ignore: unnecessary_null_comparison
              if (values != null) {
                pathPDF = values.path;
                _isLoading = false;
                _isError = false;
              } else {
                _isError = true;
              }
            })
          },
        );
      } else {
        Map<String, dynamic> err = jsonDecode(response.body);
        String message = err['message'];
        setState(() {
          _isError = true;
          _isLoading = false;
          _errorMsg = message;
        });
      }
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
        _errorMsg = e.toString();
      });
    }
  }

  Future<File> _getFileFromUrl(String url, {name}) async {
    var fileName = 'noname';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$fileName.pdf");
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
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
        backgroundColor: Colors.white,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF378E55)),
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
                            color: const Color(0xFF257141),
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
                                      color: const Color(0xFF378E55),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _response?['data']['namaPemegang'] ??
                                              "Null",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xffF5F5F5),
                                          ),
                                        ),
                                        Text(
                                          "ID - ${_response?['data']['_uuid'] ?? "Null"}"
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color: Color(0xFF257141),
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
                                            _response?['data']['upb'] ?? "Null",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF378E55),
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
                                              _response?['data']
                                                      ['namaPemegang'] ??
                                                  "Null",
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
                                                            0xFF378E55);
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
                                                            0xFF378E55);
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
                                                              ProductModal(
                                                                barangKe: (_response?['data']
                                                                            [
                                                                            'barangKe'] ??
                                                                        0)
                                                                    .toString(),
                                                                imagaName: _response?[
                                                                            'data']
                                                                        [
                                                                        'gambar'] ??
                                                                    0,
                                                                kondisi: _response?[
                                                                            'data']
                                                                        [
                                                                        'kondisi'] ??
                                                                    0,
                                                                status: _response?[
                                                                            'data']
                                                                        [
                                                                        'status'] ??
                                                                    0,
                                                              )),
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
                                              _response?['data']['nomorSPK'] ??
                                                  "Null"
                                            ],
                                            [
                                              "Tanggal",
                                              _tanggal(_response?['data']
                                                      ['tanggalSPK'] ??
                                                  "1000-01-01T07:00:00.000Z")
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
                                              _response?['data']['nomorSPM'] ??
                                                  "Null"
                                            ],
                                            [
                                              "Tanggal SPM",
                                              _tanggal(_response?['data']
                                                      ['tanggalSPM'] ??
                                                  "1000-01-01T07:00:00.000Z")
                                            ],
                                            [
                                              "Nomor SP2D",
                                              _response?['data']['nomorSP2D'] ??
                                                  "Null"
                                            ],
                                            [
                                              "Tanggal SP2D",
                                              _tanggal(_response?['data']
                                                      ['tanggalSP2D'] ??
                                                  "1000-01-01T07:00:00.000Z")
                                            ],
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        MiniCard(
                                          judul: "Jumlah Total",
                                          dataKolom: [
                                            [
                                              "Jumlah Barang",
                                              (_response?['data']
                                                          ['jumlahBarang'] ??
                                                      0)
                                                  .toString()
                                            ],
                                            [
                                              "Harga Satuan",
                                              rupiah
                                                  .format(_response?['data']
                                                          ['hargaSatuan'] ??
                                                      0)
                                                  .toString()
                                            ],
                                            [
                                              "Jumlah Harga",
                                              rupiah
                                                  .format(_response?['data']
                                                          ['jumlahHarga'] ??
                                                      0)
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
                                            rupiah
                                                .format(_response?['data']
                                                        ['totalBelanja'] ??
                                                    0)
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
