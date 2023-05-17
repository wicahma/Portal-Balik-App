import 'package:flutter/material.dart';

class MiniCard extends StatelessWidget {
  const MiniCard({super.key, required this.judul, required this.dataKolom});

  final String judul;
  final List<List<String>> dataKolom;
  final double roundedHeader = 8, roundedBody = 20;

  double getSizeWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 1 / 5;
  double getSizeHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 1 / 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: getSizeWidth(context) * 1.75,
                bottom: -getSizeHeight(context) * 0.01,
                child: Container(
                  width: 17,
                  height: 15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color(0xffF5F5F5),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: -getSizeHeight(context) * 0.02,
                child: Container(
                  width: getSizeWidth(context) * 1.8,
                  height: 15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color(0xffF5F5F5),
                  ),
                ),
              ),
              Positioned(
                left: getSizeWidth(context) * 1.8,
                bottom: 0,
                child: Container(
                  width: getSizeWidth(context) / 3,
                  height: getSizeWidth(context) / 3,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    // 0xff255771
                    color: Color(0xff255771),
                  ),
                ),
              ),
              Container(
                width: getSizeWidth(context) * 1.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(roundedHeader),
                      topRight: Radius.circular(roundedHeader)),
                  color: const Color(0xffF5F5F5),
                ),
                // margin: const EdgeInsets.only(top: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Text(
                  judul,
                  style: const TextStyle(
                    color: Color(0xff37718E),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(roundedBody),
                  bottomRight: Radius.circular(roundedBody),
                  topRight: Radius.circular(roundedBody)),
              color: const Color(0xffF5F5F5),
            ),
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xffEBEBEB),
              ),
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < dataKolom.length; i++)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dataKolom[i][0],
                            style: const TextStyle(
                              color: Color(0xff3C3C3C),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            dataKolom[i][1],
                            style: const TextStyle(
                                color: Color(0xff3C3C3C),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      )
                  ]),
            )),
      ],
    );
  }
}
