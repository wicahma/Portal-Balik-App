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
    return Column(
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
                borderRadius: BorderRadius.circular(20),
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
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    fontSize: 25,
                    color: Colors.black),
              ),
              Text(
                'Kualitas: $kualitas',
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black),
              ),
              Text(
                'Status: $status',
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}
