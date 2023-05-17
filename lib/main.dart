import 'package:flutter/material.dart';
import 'package:inventaris/pages/history_page.dart';

void main() {
  runApp(const Portal());
}

class Portal extends StatefulWidget {
  const Portal({super.key});

  @override
  State<Portal> createState() => _PortalState();
}

class _PortalState extends State<Portal> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Inventaris',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const HistoryPage(),
      // routes: {
      //   '/riwayat': (context) => const HistoryPage(),
      //   '/detail': (context) => const _createRoute(),
      // },
    );
  }
}
