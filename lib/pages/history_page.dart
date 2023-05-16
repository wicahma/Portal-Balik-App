import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventaris/components/cards/history_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Scan'),
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
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            for (int i = 0; i < 20; i++)
              const HistoryCard(
                namaBarang: "Printer HP",
                harga: 2000000,
                id: "a3su5s123mn4c7i23s3u7",
                jumlah: 2,
                tanggalBeli: "2021-10-10 10:10:10",
              ),
          ],
        ));
  }
}
