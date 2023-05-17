import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventaris/components/cards/detail_minicard.dart';
import 'package:inventaris/components/fab/camera_button.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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
                                margin: const EdgeInsets.only(bottom: 15),
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
