import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteButton extends StatefulWidget {
  const DeleteButton({super.key});

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  double getSizeWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 1;

  Future<void> deleteHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> historyList = prefs.getStringList('riwayat') ?? [];
      historyList.clear();
      await prefs.setStringList('riwayat', historyList);
      setState(() {});
    } catch (err) {
      // handling error
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "delete",
      onPressed: () => showModalBottomSheet(
          context: context,
          elevation: 10,
          backgroundColor: Colors.white,
          showDragHandle: true,
          enableDrag: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          builder: (BuildContext context) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Hapus Riwayat",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const Text(
                      "Anda yakin untuk menghapus semua riwayat?",
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      ElevatedButton.icon(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return const Color(0xFFD35A5A);
                                }
                                return const Color(0xFFE21C1C);
                              },
                            ),
                          ),
                          onPressed: () => {
                                deleteHistory(),
                                Navigator.pop(context),
                              },
                          icon: const Icon(Icons.delete_rounded),
                          label: const Text("DELETE"))
                    ]),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )),
      backgroundColor: const Color(0xFFFC1818),
      // material trashcan
      child: const Icon(Icons.delete_rounded),
    );
  }
}
