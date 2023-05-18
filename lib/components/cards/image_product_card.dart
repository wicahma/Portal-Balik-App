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
                borderRadius: BorderRadius.circular(15),
              ),
              child: child,
            );
          },
        ),
        Text(kualitas),
        Text(status),
        Text(barangKe)
      ],
    );
  }
}
