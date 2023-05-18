import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  const ImageCard(
      {super.key,
      required this.gambar,
      required this.kualitas,
      required this.status,
      required this.barangKe});

  final String gambar, kualitas, status, barangKe;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(0, 3))
          ],
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xff37718E)),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            gambar,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              // if (wasSynchronouslyLoaded) {
              //   return child;
              // }
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: child,
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Barang $barangKe',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Text(
                  'Kualitas: $kualitas',
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.white),
                ),
                Text(
                  'Status: $status',
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
