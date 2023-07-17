import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventaris/components/cards/history_card.dart';
import 'package:inventaris/components/fab/camera_button.dart';
import 'package:inventaris/components/fab/delete_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String?, dynamic>> _historyList = [];
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _getFromLocalStorage();
  }

  Future<void> _getFromLocalStorage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> historyList = prefs.getStringList('riwayat') ?? [];
      setState(() {
        _historyList = historyList
            .map((e) => jsonDecode(e) as Map<String, dynamic>)
            .toList();
      });
    } catch (err) {
      // handling error
    }
  }

  Future<void> onRefresh() async {
    await _getFromLocalStorage();
  }

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
        // floatingActionButton:

        persistentFooterButtons: const [CameraButton(), DeleteButton()],
        backgroundColor: Colors.white,
        body: RefreshIndicator(
            onRefresh: onRefresh,
            color: const Color(0xFF257141),
            child: _historyList.isEmpty
                ? ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: Colors.white,
                      showTrailing: false,
                      showLeading: false,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/no-data.png',
                                  width: 250,
                                  height: 250,
                                ),
                                const Text(
                                  "Tidak ada riwayat scan",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(10),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      for (int i = _historyList.length - 1; i >= 0; i--)
                        HistoryCard(
                          namaBarang: _historyList[i]['jenisBarang'] ?? '',
                          harga: _historyList[i]['hargaSatuan'] ?? 00,
                          id: _historyList[i]['_uuid'] ?? "",
                          kondisi: _historyList[i]['kondisi'] ?? "",
                          tanggalBeli: _historyList[i]['tanggalSP2D'] ?? "",
                          barangKe: _historyList[i]['barangKe'] ?? "",
                        ),
                    ],
                  )));
  }
}
