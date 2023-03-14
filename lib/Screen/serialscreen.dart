import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SerialNoScreen extends StatefulWidget {
  final String? no;
  const SerialNoScreen({super.key, required this.no});

  @override
  State<SerialNoScreen> createState() => _SerialNoScreenState();
}

class _SerialNoScreenState extends State<SerialNoScreen> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: Get.height * .1,
        child: Center(
          child: Text(
            "Serial No : ${widget.no}",
            style: const TextStyle(fontSize: 30),
          ),
        ),
      ),
    );

    // return AlertDialog(
    //   content: SizedBox(
    //     height: Get.height * .12,
    //     child: Column(
    //       children: [
    //         Container(
    //           width: Get.width,
    //           height: 40,
    //           color: const Color.fromARGB(255, 144, 162, 177),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: const [
    //               Padding(
    //                 padding: EdgeInsets.only(left: 8.0),
    //                 child: Text(
    //                   "Verify Barcode",
    //                   style: TextStyle(color: Colors.white),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         const SizedBox(height: 20),
    //         Row(
    //           children: [
    //             Expanded(
    //               child: GestureDetector(
    //                 onTap: () {
    //                   _repairCenter.verifybarcodeR(
    //                       verifyBarcodeValueR.toString(), widget.ticketno);
    //                   Get.back();
    //                 },
    //                 child: Container(
    //                   child: const Center(child: Text("Reject")),
    //                 ),
    //               ),
    //             ),
    //             const VerticalDivider(
    //               width: 10,
    //               thickness: 2,
    //               indent: 20,
    //               endIndent: 0,
    //               color: Color.fromARGB(255, 144, 162, 177),
    //             ),
    //             Expanded(
    //               child: GestureDetector(
    //                 onTap: () {
    //                   _repairCenter.verifybarcodeA(
    //                       verifyBarcodeValueR.toString(), widget.ticketno);
    //                   Get.back();
    //                 },
    //                 child: Container(
    //                   child: const Center(child: Text("Accept")),
    //                 ),
    //               ),
    //             )
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
