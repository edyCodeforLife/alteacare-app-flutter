// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/my_consultation_detail/models/my_consultation_detail_model.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgets/mw_konsultasi_list_obat_container_demo.dart';

class MWCDMemoAltea extends StatelessWidget {
  final MedicalResume? dataMedicalResume;
  final String noteFromAlteaMADashbobard;
  final String noteFromAlteaSender;
  final String noteFromAlteaCreatedAt;
  final double screenWidth = Get.width;
  MWCDMemoAltea(
      {required this.dataMedicalResume,
      required this.noteFromAlteaMADashbobard,
      required this.noteFromAlteaCreatedAt,
      required this.noteFromAlteaSender});

  @override
  Widget build(BuildContext context) {
    return dataMedicalResume == null
        ? Container(
            height: 50,
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Tidak ada memo Altea tersedia",
              textAlign: TextAlign.center,
            ),
          )
        : Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 31,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Keluhan", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 16)),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      dataMedicalResume?.symptom.toString() ?? "",
                      style: kPoppinsRegular400.copyWith(fontSize: 13, color: kSubHeaderColor),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Diagnosis", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 16)),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      dataMedicalResume?.diagnosis.toString() ?? "",
                      style: kPoppinsRegular400.copyWith(fontSize: 13, color: kSubHeaderColor),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Resep Obat", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 16)),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      dataMedicalResume?.drugResume.toString() ?? "",
                      style: kPoppinsRegular400.copyWith(fontSize: 13, color: kSubHeaderColor),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rekomendasi dokter", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 16)),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      dataMedicalResume?.drugResume.toString() ?? "",
                      style: kPoppinsRegular400.copyWith(fontSize: 13, color: kSubHeaderColor),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomFlatButton(width: 185, text: "Info Pemesanan Obat", onPressed: () {}, color: kButtonColor)
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Catatan lain", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 16)),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      dataMedicalResume?.additionalResume.toString() ?? "",
                      style: kPoppinsRegular400.copyWith(fontSize: 13, color: kSubHeaderColor),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                // MWKonsultasiListObatContainerDemo(),
                // if (dataMedicalResume!.symptom)
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text("Keluhan", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 13)),
                //       const SizedBox(
                //         height: 8,
                //       ),
                //       Text(
                //         dataMedicalResume!["symptom_note"].toString(),
                //         style: kPoppinsRegular400.copyWith(fontSize: 11, color: kSubHeaderColor),
                //       ),
                //       const SizedBox(
                //         height: 15,
                //       ),
                //     ],
                //   ),

                // if (dataMedicalResume!.containsKey("diagnosis"))
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text("Diagnosis", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 13)),
                //       const SizedBox(
                //         height: 8,
                //       ),
                //       Text(
                //         dataMedicalResume!["diagnosis"].toString(),
                //         style: kPoppinsRegular400.copyWith(fontSize: 11, color: kSubHeaderColor),
                //       ),
                //       const SizedBox(
                //         height: 15,
                //       ),
                //     ],
                //   ),
                // if (dataMedicalResume!.containsKey("drug_resume"))
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text("Resep Obat", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 13)),
                //       const SizedBox(
                //         height: 8,
                //       ),
                //       Column(
                //         children: (dataMedicalResume!['drug_resume'] as List<dynamic>)
                //             .map((e) => Row(
                //                   children: [
                //                     const Text("-"),
                //                     Container(
                //                       padding: const EdgeInsets.only(left: 10),
                //                       width: screenWidth * 0.67,
                //                       child: Text(
                //                         e.toString(),
                //                         style: kPoppinsRegular400.copyWith(fontSize: 11, color: kSubHeaderColor),
                //                       ),
                //                     ),
                //                   ],
                //                 ))
                //             .toList(),
                //       ),
                //       // Text(
                //       //   dataMedicalResume!["drug_resume"].toString(),
                //       //   style: kPoppinsRegular400.copyWith(fontSize: 11, color: kSubHeaderColor),
                //       // ),
                //       const SizedBox(
                //         height: 15,
                //       ),
                //     ],
                //   ),

                // if (dataMedicalResume!.containsKey("doctor_note"))
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text("Rekomendasi dokter", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 13)),
                //       const SizedBox(
                //         height: 8,
                //       ),
                //       Column(
                //         children: (dataMedicalResume!['doctor_note'] as List<dynamic>)
                //             .map((e) => Row(
                //                   children: [
                //                     const Text("-"),
                //                     Container(
                //                       padding: const EdgeInsets.only(left: 10),
                //                       width: screenWidth * 0.67,
                //                       child: Text(
                //                         e.toString(),
                //                         style: kPoppinsRegular400.copyWith(fontSize: 11, color: kSubHeaderColor),
                //                       ),
                //                     )
                //                   ],
                //                 ))
                //             .toList(),
                //       ),
                //       // Text(
                //       //   dataMedicalResume!["drug_resume"].toString(),
                //       //   style: kPoppinsRegular400.copyWith(fontSize: 11, color: kSubHeaderColor),
                //       // ),

                //       const SizedBox(
                //         height: 15,
                //       ),
                //     ],
                //   ),
                // // CustomFlatButton(width: 185, text: "Info Pemesanan Obat", onPressed: () {
                // //   Get.toNamed('/pharmacy-information');
                // // }, color: kButtonColor),
                // const SizedBox(
                //   height: 15,
                // ),
                // if (dataMedicalResume!.containsKey("additional_resume"))
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text("Catatan lain", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 13)),
                //       const SizedBox(
                //         height: 8,
                //       ),
                //       Text(
                //         dataMedicalResume!["additional_resume"].toString(),
                //         style: kPoppinsRegular400.copyWith(fontSize: 11, color: kSubHeaderColor),
                //       ),
                //       const SizedBox(
                //         height: 15,
                //       ),
                //     ],
                //   ),
                // //memo dari dashboard altea
                // if (noteFromAlteaMADashbobard.isNotEmpty)
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text("Note", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 13)),
                //       const SizedBox(
                //         height: 8,
                //       ),
                //       SelectableText(
                //         noteFromAlteaMADashbobard,
                //         style: kPoppinsRegular400.copyWith(fontSize: 11, color: kSubHeaderColor),
                //       ),
                //       Text(
                //         noteFromAlteaSender['email'].toString(),
                //         style: kPoppinsRegular400.copyWith(fontSize: 11, color: kSubHeaderColor),
                //       ),
                //       const SizedBox(
                //         height: 15,
                //       ),
                //     ],
                //   ),
              ],
            ),
          );
  }
}
