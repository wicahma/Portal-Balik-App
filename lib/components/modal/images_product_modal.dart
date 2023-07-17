import 'package:flutter/material.dart';
import 'package:inventaris/components/cards/image_product_card.dart';
import 'package:inventaris/components/modal/clipper_modal.dart';

class ProductModal extends StatefulWidget {
  final String imagaName;
  final String kondisi;
  final String status;
  final String barangKe;
  const ProductModal(
      {super.key,
      required this.imagaName,
      required this.kondisi,
      required this.status,
      required this.barangKe});

  @override
  State<ProductModal> createState() => _ProductModalState();
}

class _ProductModalState extends State<ProductModal> {
  double getSizeWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 1 / 5;
  double getSizeHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 1 / 5;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                bottom: -getSizeHeight(context) * 0.02,
                child: Container(
                  width: getSizeWidth(context) * 2.72,
                  height: 15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                  left: getSizeWidth(context) * 2.7,
                  bottom: -getSizeHeight(context) * 0.03,
                  child: ClipPath(
                    clipper: ClipperModal(),
                    child: const SizedBox(
                      width: 27,
                      height: 27,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Colors.white,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: const Text(
                  "Foto Kondisi Barang",
                  style: TextStyle(
                    color: Color(0xFF378E55),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Stack(
          fit: StackFit.loose,
          children: [
            Container(
              clipBehavior: Clip.none,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height * 7 / 12,
              child: ImageCard(
                  gambar: widget.imagaName,
                  kondisi: widget.kondisi,
                  status: widget.status,
                  barangKe: widget.barangKe),
            )
          ],
        )
      ],
    );
  }
}
