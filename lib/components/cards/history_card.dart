import 'package:flutter/material.dart';
import 'package:inventaris/pages/detail_page.dart';

class HistoryCard extends StatefulWidget {
  const HistoryCard(
      {super.key,
      required this.namaBarang,
      required this.tanggalBeli,
      required this.harga,
      required this.kondisi,
      required this.barangKe,
      required this.id});

  final String namaBarang, kondisi, tanggalBeli, id;
  final int harga, barangKe;

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

Route _createRoute(String id) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => DetailPage(id: id),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class _HistoryCardState extends State<HistoryCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(_createRoute(widget.id));
        },
        child: Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.namaBarang} - ${widget.barangKe}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffF5F5F5),
                            ),
                          ),
                          Text(
                            "ID - ${widget.id.toUpperCase()}",
                            style: const TextStyle(
                                color: Color(0xFF257141),
                                fontSize: 12,
                                height: 1),
                          ),
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flex(
                            mainAxisSize: MainAxisSize.max,
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Kondisi",
                                style: TextStyle(
                                    color: Color(0xffF5F5F5),
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.kondisi,
                                style: const TextStyle(
                                    color: Color(0xffF5F5F5),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          const Flex(
                            mainAxisSize: MainAxisSize.max,
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tanggal Beli",
                                style: TextStyle(
                                    color: Color(0xffF5F5F5),
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Senin, 22 Oktober 2023",
                                style: TextStyle(
                                    color: Color(0xffF5F5F5),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          const Flex(
                            mainAxisSize: MainAxisSize.max,
                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Harga",
                                style: TextStyle(
                                    color: Color(0xFF268F4E),
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "Rp. 2.000.000,00",
                                style: TextStyle(
                                    color: Color(0xffF5F5F5),
                                    fontSize: 30,
                                    height: 1,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          )
                        ],
                      ))
                ])));
  }
}
