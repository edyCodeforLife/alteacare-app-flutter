// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/my_consultation/controllers/my_consultation_controller.dart';
import 'package:altea/app/modules/my_consultation/views/desktop_web_view/widgets/doctor_card_my_consultation.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

class MyConsultationContent extends StatelessWidget {
  final MyConsultationController controller = Get.find<MyConsultationController>();
  final double screenWidth = Get.width;

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.myConsultation.value != null && controller.loadingState.value == MCCLoadingState.none)
        ? Padding(
            padding: EdgeInsets.zero,
            child: (controller.myConsultation.value!.status ?? false)
                ? Obx(() => Column(
                      children: controller.myConsultationList
                          // .where(
                          //   (d) => [
                          //     d.doctor!.name,
                          //     d.orderCode,
                          //   ].contains(controller.searchText.value.toLowerCase()),
                          // )
                          .where(
                            (d) =>
                                (controller.selectedFilter.value.toLowerCase() == d.statusDetail!.label!.toLowerCase()) ||
                                (controller.selectedFilter.value.toLowerCase().contains('semua')),
                          )
                          .map(
                            (dd) => DoctorCardMyConsultation(
                              screenWidth: screenWidth,
                              data: dd,
                            ),
                          )
                          .toList(),
                    ))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
                    child: Container(
                      height: 400,
                      width: screenWidth,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: kBackground, boxShadow: [
                        BoxShadow(
                          color: fullBlack.withAlpha(15),
                          offset: const Offset(
                            0.0,
                            3.0,
                          ),
                          blurRadius: 12.0,
                        ),
                      ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset("assets/no_doctor_icon.png"),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Text(
                            "Belum ada konsultasi",
                            style: kPoppinsSemibold600.copyWith(fontSize: 16, color: kDarkBlue),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Buat janji konsultasi dengan dokter spesialis AlteaCare",
                            style: kPoppinsRegular400.copyWith(fontSize: 13, color: kSubHeaderColor.withOpacity(0.5), letterSpacing: 1),
                          ),
                        ],
                      ),
                    ),
                  ),
          )
        : const Center(child: CircularProgressIndicator()));

    // if (controller.myConsultation.value != null &&
    //     controller.loadingState.value == MCCLoadingState.none) {
    //   if (controller.myConsultation.value!.status ?? false) {
    //     return Padding(
    //       padding: const EdgeInsets.symmetric(
    //         horizontal: 25.0,
    //       ),
    //       child: Obx(
    //         () => Column(
    //           children: controller.myConsultation.value!.data!
    //               // .where(
    //               //   (d) => [
    //               //     d.doctor!.name,
    //               //     d.orderCode,
    //               //   ].contains(controller.searchText.value.toLowerCase()),
    //               // )
    //               .where(
    //                 (d) =>
    //                     (controller.selectedFilter.value.toLowerCase() ==
    //                         d.statusDetail!.label!.toLowerCase()) ||
    //                     (controller.selectedFilter.value
    //                         .toLowerCase()
    //                         .contains('semua')),
    //               )
    //               .map(
    //                 (dd) => DoctorCardMyConsultation(
    //                   screenWidth: screenWidth,
    //                   data: dd,
    //                 ),
    //               )
    //               .toList(),
    //         ),
    //       ),
    //     );
    //   } else {
    //     return Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
    //       child: Container(
    //         height: 400,
    //         width: screenWidth,
    //         decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(12),
    //             color: kBackground,
    //             boxShadow: [
    //               BoxShadow(
    //                 color: fullBlack.withAlpha(15),
    //                 offset: const Offset(
    //                   0.0,
    //                   3.0,
    //                 ),
    //                 blurRadius: 12.0,
    //               ),
    //             ]),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             SizedBox(
    //               height: 100,
    //               width: 100,
    //               child: Image.asset("assets/no_doctor_icon.png"),
    //             ),
    //             const SizedBox(
    //               height: 32,
    //             ),
    //             Text(
    //               "Belum ada konsultasi",
    //               style: kPoppinsSemibold600.copyWith(
    //                   fontSize: 16, color: kDarkBlue),
    //             ),
    //             const SizedBox(
    //               height: 8,
    //             ),
    //             Text(
    //               "Buat janji konsultasi dengan dokter spesialis AlteaCare",
    //               style: kPoppinsRegular400.copyWith(
    //                   fontSize: 13,
    //                   color: kSubHeaderColor.withOpacity(0.5),
    //                   letterSpacing: 1),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   }
    // } else {
    //   return Center(
    //     child: Column(
    //       children: [
    //         CircularProgressIndicator(),
    //         Text(controller.myConsultation.value?.status.toString() ?? "??")
    //       ],
    //     ),
    //   );
    // }
  }
}
