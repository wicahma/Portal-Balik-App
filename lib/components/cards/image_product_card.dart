import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  const ImageCard(
      {super.key,
      required this.gambar,
      required this.kondisi,
      required this.status,
      required this.barangKe});

  final String gambar, kondisi, status, barangKe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: NetworkImage(
            "https://be.sibesti.com/$gambar",
          ),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: child,
              );
            }
            if (frame == null) {
              return Container(
                clipBehavior: Clip.antiAlias,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF378E55)),
                ),
              );
            }
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: child,
            );
          },
        ),
        // Image.asset(
        //   gambar,
        // ),
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
                'Kondisi: $kondisi',
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
