// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:altea/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../data/model/doctors.dart';
import '../../../doctor/controllers/doctor_controller.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../home/views/dekstop_web/widget/footer_section_view.dart';
import '../../../home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import '../../../spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import '../widgets/doctor_content_section.dart';
import '../widgets/doctor_text_field.dart';

class DoctorSpesialisByCategoryDesktop extends GetView<DoctorController> {
  DoctorSpesialisByCategoryDesktop({
    Key? key,
  }) : super(key: key);
  final spesialisController = Get.put(SpesialisKonsultasiController());

  @override
  Widget build(BuildContext context) {
    // final doctor_specialist.Datum data =
    //     Get.arguments as doctor_specialist.Datum;
    // print("data -> $data");
    final screenWidth = context.width;
    final screenHeight = context.height;

    ScreenSize.recalculate(context);

    // print("filtered doctor -> ${controller.listFilteredDoctor.value}");
    final homeController = Get.find<HomeController>();

    return WillPopScope(onWillPop: () async {
      if (homeController.menus.length > 1) {
        homeController.menus.removeAt(1);
      }

      // remove filter select when back
      controller.refreshController();
      // controller.selectedDoctorIdFilter.value = "";
      // controller.selectedDoctorFilter = "".obs;
      // controller.selectedHospitalIdFilter.value = "";
      // controller.selectedHospitalFilter.value = "Semua";
      // controller.selectedHighPriceFilter.value = "";
      // controller.selectedLowPriceFilter.value = "";
      // controller.selectedHargaFilter.value = "Semua harga";
      // controller.valueChoose.value = "";
      Get.back();
      return true;
    }, child: Obx(
      () {
        return controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : LoadingOverlay(
                isLoading: spesialisController.isLoading.value,
                color: kButtonColor.withOpacity(0.1),
                opacity: 0.8,
                child: GestureDetector(
                  onTap: () {
                    return FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Scaffold(
                    backgroundColor: kBackground,
                    body: Scrollbar(
                      isAlwaysShown: true,
                      showTrackOnHover: true,
                      child: ListView(
                        children: [
                          TopNavigationBarSection(
                            screenWidth: screenWidth,
                          ),
                          // SizedBox(
                          //   height: 10.hb,
                          // ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.wb),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10.hb,
                                ),
                                Obx(() => BreadCrumb.builder(
                                      itemCount: homeController.menus.length,
                                      builder: (index) {
                                        // print("menus ->${controller.menus[index]}");
                                        // print(
                                        //     "selection dokter -> ${controller.spesialisMenus[index].name!}");
                                        return BreadCrumbItem(
                                          content: Text(
                                            homeController.menus[index],
                                            style: kPoppinsRegular400.copyWith(
                                                color: (homeController.menus[index] == ("Spesialis ${controller.selectedDoctorFilter}"))
                                                    ? kButtonColor
                                                    : kSubHeaderColor.withOpacity(0.5)),
                                          ),
                                          onTap: index < homeController.menus.length
                                              ? () {
                                                  // TODO: CEK LAGI NANTI YA
                                                  if (index == 0) {
                                                    homeController.menus.removeAt(index + 1);

                                                    // remove filter select when back
                                                    // controller
                                                    //     .selectedDoctorIdFilter
                                                    //     .value = "";
                                                    // controller
                                                    //         .selectedDoctorFilter =
                                                    //     "".obs;
                                                    // controller
                                                    //     .selectedHospitalIdFilter
                                                    //     .value = "";
                                                    // controller
                                                    //     .selectedHospitalFilter
                                                    //     .value = "Semua";
                                                    // controller
                                                    //     .selectedHighPriceFilter
                                                    //     .value = "";
                                                    // controller
                                                    //     .selectedLowPriceFilter
                                                    //     .value = "";
                                                    // controller.selectedHargaFilter
                                                    //     .value = "Semua harga";
                                                    // controller.valueChoose.value =
                                                    //     "";

                                                    controller.refreshController();

                                                    Get.offNamed(Routes.DOCTOR);
                                                  }
                                                }
                                              : null,
                                          // textColor: ,
                                        );
                                      },
                                      divider: const Text(" / "),
                                    )),
                                SizedBox(
                                  height: screenWidth * 0.02,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: SizedBox(
                                        child: buildSearchDoctorTextField(screenWidth),
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.01,
                                    ),
                                    Expanded(
                                      child: buildSortDoctorField(),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: screenWidth * 0.01,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: buildSideSearchFilter(screenHeight, screenWidth, context),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.01,
                                    ),
                                    //? NOTE: Content Section
                                    Expanded(
                                      flex: 3,
                                      child: Obx(() => Container(
                                            height: controller.listFilteredDoctor.isEmpty
                                                ? screenWidth * 0.3
                                                : screenWidth * controller.listFilteredDoctor.length / 8.5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: kBackground,
                                            ),
                                            child: controller.listFilteredDoctor.isEmpty
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: fullBlack.withAlpha(15),
                                                          offset: const Offset(
                                                            0.0,
                                                            3.0,
                                                          ),
                                                          blurRadius: 12.0,
                                                        ),
                                                      ],
                                                      borderRadius: BorderRadius.circular(12),
                                                      color: kBackground,
                                                    ),
                                                    height: screenHeight * 0.2,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          height: 100,
                                                          child: Image.asset(
                                                            "assets/no_doctor_icon.png",
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          "No Doctor Found",
                                                          style: kSubHeaderStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : ListView.builder(
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: controller.listFilteredDoctor.length,
                                                    itemBuilder: (context, index) {
                                                      return Container(
                                                        margin: const EdgeInsets.only(bottom: 8.0),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          color: kBackground,
                                                        ),
                                                        child: buildContentListDoctor(
                                                            screenHeight, screenWidth, controller.listFilteredDoctor[index], context),
                                                      );
                                                    },
                                                  ),
                                          )),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenWidth * 0.04,
                          ),
                          FooterSectionWidget(screenWidth: screenWidth)
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    ));
  }

  Widget buildSideSearchFilter(double screenHeight, double screenWidth, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: fullBlack.withAlpha(15),
            offset: const Offset(
              0.0,
              3.0,
            ),
            blurRadius: 12.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenWidth * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Icon(
                  Icons.tune_rounded,
                  color: kSubHeaderColor,
                ),
                SizedBox(
                  width: screenWidth * 0.01,
                ),
                Text(
                  "Filter Pencarian",
                  style: kSubHeaderStyle,
                )
              ],
            ),
          ),
          SizedBox(
            height: screenWidth * 0.015,
          ),
          // ? DOCTOR Spesialis Section
          Obx(() => Column(
                children: [
                  if (controller.isShowMoreDoctorFilter.value) buildDokterSpesialisFilterAll(context) else buildDokterSpesialisFilter(context),
                ],
              )),
          TextButton(
            onPressed: () {
              controller.isShowMoreDoctorFilter.value = !controller.isShowMoreDoctorFilter.value;
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Show More",
                    style: kSubHeaderStyle.copyWith(color: kDarkBlue),
                  ),
                  Obx(() => Icon(controller.isShowMoreDoctorFilter.value ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded)),
                ],
              ),
            ),
          ),
          // ? Hospital Section
          Obx(() => Column(
                children: [
                  if (controller.isShowMoreHospitalFilter.value) buildHospitalFilterAll(context) else buildHospitalFilter(context),
                ],
              )),
          TextButton(
            onPressed: () {
              controller.isShowMoreHospitalFilter.value = !controller.isShowMoreHospitalFilter.value;
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Show More",
                    style: kSubHeaderStyle.copyWith(color: kDarkBlue),
                  ),
                  Obx(() => Icon(controller.isShowMoreHospitalFilter.value ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded)),
                ],
              ),
            ),
          ),
          buildHargaFilter(context),
          SizedBox(
            height: screenWidth * 0.02,
          ),
        ],
      ),
    );
  }

  Widget buildHargaFilter(BuildContext context) {
    final screenWidth = context.width;
    return ExpansionTile(
      expandedAlignment: Alignment.centerLeft,
      initiallyExpanded: true,
      // iconColor: kBlackColor.withOpacity(0.5),
      title: Text(
        "Harga",
        style: kSubHeaderStyle,
      ),
      children: List.generate(controller.hargaFilter.length, (indexs) {
        return Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () async {
                  controller.selectedHargaFilter.value = controller.hargaFilter[indexs];
                  if (controller.selectedHargaFilter.value == controller.hargaFilter[0]) {
                    controller.selectedLowPriceFilter.value = "";
                    controller.selectedHighPriceFilter.value = "";
                  } else if (controller.selectedHargaFilter.value == controller.hargaFilter[1]) {
                    controller.selectedLowPriceFilter.value = "10000";
                    controller.selectedHighPriceFilter.value = "100000";
                  } else if (controller.selectedHargaFilter.value == controller.hargaFilter[2]) {
                    controller.selectedLowPriceFilter.value = "100000";
                    controller.selectedHighPriceFilter.value = "200000";
                  } else {
                    controller.selectedLowPriceFilter.value = "200000";
                    controller.selectedHighPriceFilter.value = "500000";
                  }

                  Doctors? result;
                  // DO SORT BY Spesialis
                  if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                      controller.selectedHospitalIdFilter.value.isNotEmpty &&
                      controller.selectedHighPriceFilter.value.isNotEmpty &&
                      controller.selectedLowPriceFilter.value.isNotEmpty) {
                    result = await controller.getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
                      selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                      selectedHospitalFilterId: controller.selectedHospitalIdFilter.value,
                      selectedLowPrice: controller.selectedLowPriceFilter.value,
                      selectedHighPrice: controller.selectedHighPriceFilter.value,
                    );
                    controller.listFilteredDoctor.value = result.data!;
                  } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                      controller.selectedHospitalIdFilter.value.isEmpty &&
                      controller.selectedLowPriceFilter.value.isNotEmpty &&
                      controller.selectedHighPriceFilter.value.isNotEmpty) {
                    result = await controller.getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
                      selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                      selectedLowPrice: controller.selectedLowPriceFilter.value,
                      selectedHighPrice: controller.selectedHighPriceFilter.value,
                    );
                    controller.listFilteredDoctor.value = result.data!;
                  } else if (controller.selectedDoctorIdFilter.value.isNotEmpty && controller.selectedHospitalIdFilter.value.isNotEmpty) {
                    result = await controller.getDoctorListBySpecializationAndChooseHospital(
                        selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                        selectedHospitalFilterId: controller.selectedHospitalIdFilter.value);
                    controller.listFilteredDoctor.value = result.data!;
                  } else if (controller.selectedDoctorIdFilter.value.isNotEmpty && controller.selectedHospitalIdFilter.value.isEmpty) {
                    result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
                        selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);
                    controller.listFilteredDoctor.value = result.data!;
                  }

                  if (controller.valueChoose.isNotEmpty) {
                    if (controller.valueChoose.value == controller.sort[0]) {
                      result?.data!.sort((a, b) => b.price!.raw!.toInt().compareTo(a.price!.raw!.toInt()));
                    } else if (controller.valueChoose.value == controller.sort[1]) {
                      result?.data!.sort((a, b) => a.price!.raw!.toInt().compareTo(b.price!.raw!.toInt()));
                    } else if (controller.valueChoose.value == controller.sort[2]) {
                      result?.data!.sort((b, a) {
                        // print("sort b a");
                        int tahun1 = int.tryParse(a.experience!.split(" ").first) ?? -99;
                        int tahun2 = int.tryParse(b.experience!.split(" ").first) ?? -99;
                        return tahun1.compareTo(tahun2);
                      });
                    } else {
                      result?.data!.sort((a, b) {
                        // print("sort a b");

                        int tahun2 = int.tryParse(a.experience!.split(" ").first) ?? -99;
                        int tahun1 = int.tryParse(b.experience!.split(" ").first) ?? -99;
                        return tahun2.compareTo(tahun1);
                      });
                    }
                  }

                  // Doctors result;
                  // // DO SORT BY Spesialis
                  // if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                  //     controller.selectedHospitalIdFilter.value.isNotEmpty &&
                  //     controller.selectedHighPriceFilter.value.isNotEmpty &&
                  //     controller.selectedLowPriceFilter.value.isNotEmpty) {
                  //   result = await controller
                  //       .getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
                  //     selectedDoctorFilterId:
                  //         controller.selectedDoctorIdFilter.value,
                  //     selectedHospitalFilterId:
                  //         controller.selectedHospitalIdFilter.value,
                  //     selectedLowPrice: controller.selectedLowPriceFilter.value,
                  //     selectedHighPrice:
                  //         controller.selectedHighPriceFilter.value,
                  //   );
                  //   controller.listFilteredDoctor.value = result.data!;
                  // } else if (controller
                  //         .selectedDoctorIdFilter.value.isNotEmpty &&
                  //     controller.selectedHospitalIdFilter.value.isEmpty &&
                  //     controller.selectedLowPriceFilter.value.isNotEmpty &&
                  //     controller.selectedHighPriceFilter.value.isNotEmpty) {
                  //   result = await controller
                  //       .getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
                  //     selectedDoctorFilterId:
                  //         controller.selectedDoctorIdFilter.value,
                  //     selectedLowPrice: controller.selectedLowPriceFilter.value,
                  //     selectedHighPrice:
                  //         controller.selectedHighPriceFilter.value,
                  //   );
                  //   controller.listFilteredDoctor.value = result.data!;
                  // } else if (controller
                  //         .selectedDoctorIdFilter.value.isNotEmpty &&
                  //     controller.selectedHospitalIdFilter.value.isNotEmpty) {
                  //   result = await controller
                  //       .getDoctorListBySpecializationAndChooseHospital(
                  //           selectedDoctorFilterId:
                  //               controller.selectedDoctorIdFilter.value,
                  //           selectedHospitalFilterId:
                  //               controller.selectedHospitalIdFilter.value);
                  //   controller.listFilteredDoctor.value = result.data!;
                  // } else if (controller
                  //         .selectedDoctorIdFilter.value.isNotEmpty &&
                  //     controller.selectedHospitalIdFilter.value.isEmpty) {
                  //   result = await controller
                  //       .getDoctorListBySpecializationAndAllHospitalFilter(
                  //           selectedDoctorFilterId:
                  //               controller.selectedDoctorIdFilter.value);
                  //   controller.listFilteredDoctor.value = result.data!;
                  // }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: screenWidth * 0.1,
                  decoration: BoxDecoration(
                      color: controller.selectedHargaFilter.value == controller.hargaFilter[indexs] ? kButtonColor : kBackground,
                      border: Border.all(color: kButtonColor),
                      borderRadius: BorderRadius.circular(22)),
                  child: Text(
                    controller.hargaFilter[indexs],
                    style: kSubHeaderStyle.copyWith(
                        fontSize: 14, color: controller.selectedHargaFilter.value == controller.hargaFilter[indexs] ? kBackground : kButtonColor),
                  ),
                ),
              ),
            ));
      }).toList(),
    );
  }

  Widget buildHospitalFilterAll(BuildContext context) => ExpansionTile(
        initiallyExpanded: true,
        // iconColor: kBlackColor.withOpacity(0.5),
        title: Text(
          "Rumah Sakit",
          style: kSubHeaderStyle,
        ),
        children: List.generate(controller.allHospitalFilterName.length, (index) {
          return Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: RadioListTile<String>(
                    activeColor: kButtonColor,
                    contentPadding: EdgeInsets.zero,
                    value: controller.allHospitalFilterName[index],
                    groupValue: controller.selectedHospitalFilter.value,
                    title: Text(controller.allHospitalFilterName[index]),
                    onChanged: (String? value) async {
                      controller.selectedHospitalFilter.value = value!;

                      for (var item in controller.allHospital) {
                        if (controller.selectedHospitalFilter.value == "Semua") {
                          controller.selectedHospitalIdFilter.value = "";
                        } else if (controller.selectedHospitalFilter.value == item.name) {
                          controller.selectedHospitalIdFilter.value = item.hospitalId!;
                        }
                      }

                      Doctors? result;
                      // DO SORT BY Spesialis
                      if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                          controller.selectedHospitalIdFilter.value.isNotEmpty &&
                          controller.selectedHighPriceFilter.value.isNotEmpty &&
                          controller.selectedLowPriceFilter.value.isNotEmpty) {
                        result = await controller.getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
                          selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                          selectedHospitalFilterId: controller.selectedHospitalIdFilter.value,
                          selectedLowPrice: controller.selectedLowPriceFilter.value,
                          selectedHighPrice: controller.selectedHighPriceFilter.value,
                        );
                        controller.listFilteredDoctor.value = result.data!;
                      } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                          controller.selectedHospitalIdFilter.value.isEmpty &&
                          controller.selectedLowPriceFilter.value.isNotEmpty &&
                          controller.selectedHighPriceFilter.value.isNotEmpty) {
                        result = await controller.getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
                          selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                          selectedLowPrice: controller.selectedLowPriceFilter.value,
                          selectedHighPrice: controller.selectedHighPriceFilter.value,
                        );
                        controller.listFilteredDoctor.value = result.data!;
                      } else if (controller.selectedDoctorIdFilter.value.isNotEmpty && controller.selectedHospitalIdFilter.value.isNotEmpty) {
                        result = await controller.getDoctorListBySpecializationAndChooseHospital(
                            selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                            selectedHospitalFilterId: controller.selectedHospitalIdFilter.value);
                        controller.listFilteredDoctor.value = result.data!;
                      } else if (controller.selectedDoctorIdFilter.value.isNotEmpty && controller.selectedHospitalIdFilter.value.isEmpty) {
                        result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
                            selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);
                        controller.listFilteredDoctor.value = result.data!;
                      }

                      if (controller.valueChoose.isNotEmpty) {
                        if (controller.valueChoose.value == controller.sort[0]) {
                          result?.data!.sort((a, b) => b.price!.raw!.toInt().compareTo(a.price!.raw!.toInt()));
                        } else if (controller.valueChoose.value == controller.sort[1]) {
                          result?.data!.sort((a, b) => a.price!.raw!.toInt().compareTo(b.price!.raw!.toInt()));
                        } else if (controller.valueChoose.value == controller.sort[2]) {
                          result?.data!.sort((b, a) {
                            // print("sort b a");
                            int tahun1 = int.tryParse(a.experience!.split(" ").first) ?? -99;
                            int tahun2 = int.tryParse(b.experience!.split(" ").first) ?? -99;
                            return tahun1.compareTo(tahun2);
                          });
                        } else {
                          result?.data!.sort((a, b) {
                            // print("sort a b");

                            int tahun2 = int.tryParse(a.experience!.split(" ").first) ?? -99;
                            int tahun1 = int.tryParse(b.experience!.split(" ").first) ?? -99;
                            return tahun2.compareTo(tahun1);
                          });
                        }
                      }

                      // Doctors result;
                      // // DO SORT BY Spesialis
                      // if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                      //     controller
                      //         .selectedHospitalIdFilter.value.isNotEmpty &&
                      //     controller.selectedHighPriceFilter.value.isNotEmpty &&
                      //     controller.selectedLowPriceFilter.value.isNotEmpty) {
                      //   result = await controller
                      //       .getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
                      //     selectedDoctorFilterId:
                      //         controller.selectedDoctorIdFilter.value,
                      //     selectedHospitalFilterId:
                      //         controller.selectedHospitalIdFilter.value,
                      //     selectedLowPrice:
                      //         controller.selectedLowPriceFilter.value,
                      //     selectedHighPrice:
                      //         controller.selectedHighPriceFilter.value,
                      //   );
                      //   controller.listFilteredDoctor.value = result.data!;
                      // } else if (controller
                      //         .selectedDoctorIdFilter.value.isNotEmpty &&
                      //     controller.selectedHospitalIdFilter.value.isEmpty &&
                      //     controller.selectedLowPriceFilter.value.isNotEmpty &&
                      //     controller.selectedHighPriceFilter.value.isNotEmpty) {
                      //   result = await controller
                      //       .getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
                      //     selectedDoctorFilterId:
                      //         controller.selectedDoctorIdFilter.value,
                      //     selectedLowPrice:
                      //         controller.selectedLowPriceFilter.value,
                      //     selectedHighPrice:
                      //         controller.selectedHighPriceFilter.value,
                      //   );
                      //   controller.listFilteredDoctor.value = result.data!;
                      // } else if (controller
                      //         .selectedDoctorIdFilter.value.isNotEmpty &&
                      //     controller
                      //         .selectedHospitalIdFilter.value.isNotEmpty) {
                      //   result = await controller
                      //       .getDoctorListBySpecializationAndChooseHospital(
                      //           selectedDoctorFilterId:
                      //               controller.selectedDoctorIdFilter.value,
                      //           selectedHospitalFilterId:
                      //               controller.selectedHospitalIdFilter.value);
                      //   controller.listFilteredDoctor.value = result.data!;
                      // } else if (controller
                      //         .selectedDoctorIdFilter.value.isNotEmpty &&
                      //     controller.selectedHospitalIdFilter.value.isEmpty) {
                      //   result = await controller
                      //       .getDoctorListBySpecializationAndAllHospitalFilter(
                      //           selectedDoctorFilterId:
                      //               controller.selectedDoctorIdFilter.value);
                      //   controller.listFilteredDoctor.value = result.data!;
                      // }
                    }),
              ));
        }).toList(),
      );
  Widget buildHospitalFilter(BuildContext context) => ExpansionTile(
        initiallyExpanded: true,
        // iconColor: kBlackColor.withOpacity(0.5),
        title: Text(
          "Rumah Sakit",
          style: kSubHeaderStyle,
        ),
        children: List.generate(controller.allHospitalFilterName.length > 5 ? 5 : controller.allHospitalFilterName.length, (index) {
          return Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: RadioListTile<String>(
                    activeColor: kButtonColor,
                    contentPadding: EdgeInsets.zero,
                    value: controller.allHospitalFilterName[index],
                    groupValue: controller.selectedHospitalFilter.value,
                    title: Text(controller.allHospitalFilterName[index]),
                    onChanged: (String? value) async {
                      controller.selectedHospitalFilter.value = value!;

                      for (var item in controller.allHospital) {
                        if (controller.selectedHospitalFilter.value == "Semua") {
                          controller.selectedHospitalIdFilter.value = "";
                        } else if (controller.selectedHospitalFilter.value == item.name) {
                          controller.selectedHospitalIdFilter.value = item.hospitalId!;
                        }
                      }

                      Doctors? result;
                      // DO SORT BY Spesialis
                      if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                          controller.selectedHospitalIdFilter.value.isNotEmpty &&
                          controller.selectedHighPriceFilter.value.isNotEmpty &&
                          controller.selectedLowPriceFilter.value.isNotEmpty) {
                        result = await controller.getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
                          selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                          selectedHospitalFilterId: controller.selectedHospitalIdFilter.value,
                          selectedLowPrice: controller.selectedLowPriceFilter.value,
                          selectedHighPrice: controller.selectedHighPriceFilter.value,
                        );
                        controller.listFilteredDoctor.value = result.data!;
                      } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                          controller.selectedHospitalIdFilter.value.isEmpty &&
                          controller.selectedLowPriceFilter.value.isNotEmpty &&
                          controller.selectedHighPriceFilter.value.isNotEmpty) {
                        result = await controller.getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
                          selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                          selectedLowPrice: controller.selectedLowPriceFilter.value,
                          selectedHighPrice: controller.selectedHighPriceFilter.value,
                        );
                        controller.listFilteredDoctor.value = result.data!;
                      } else if (controller.selectedDoctorIdFilter.value.isNotEmpty && controller.selectedHospitalIdFilter.value.isNotEmpty) {
                        result = await controller.getDoctorListBySpecializationAndChooseHospital(
                            selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                            selectedHospitalFilterId: controller.selectedHospitalIdFilter.value);
                        controller.listFilteredDoctor.value = result.data!;
                      } else if (controller.selectedDoctorIdFilter.value.isNotEmpty && controller.selectedHospitalIdFilter.value.isEmpty) {
                        result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
                            selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);
                        controller.listFilteredDoctor.value = result.data!;
                      }

                      if (controller.valueChoose.isNotEmpty) {
                        if (controller.valueChoose.value == controller.sort[0]) {
                          result?.data!.sort((a, b) => b.price!.raw!.toInt().compareTo(a.price!.raw!.toInt()));
                        } else if (controller.valueChoose.value == controller.sort[1]) {
                          result?.data!.sort((a, b) => a.price!.raw!.toInt().compareTo(b.price!.raw!.toInt()));
                        } else if (controller.valueChoose.value == controller.sort[2]) {
                          result?.data!.sort((b, a) {
                            // print("sort b a");
                            int tahun1 = int.tryParse(a.experience!.split(" ").first) ?? -99;
                            int tahun2 = int.tryParse(b.experience!.split(" ").first) ?? -99;
                            return tahun1.compareTo(tahun2);
                          });
                        } else {
                          result?.data!.sort((a, b) {
                            // print("sort a b");

                            int tahun2 = int.tryParse(a.experience!.split(" ").first) ?? -99;
                            int tahun1 = int.tryParse(b.experience!.split(" ").first) ?? -99;
                            return tahun2.compareTo(tahun1);
                          });
                        }
                      }

                      // Doctors result;
                      // // DO SORT BY Spesialis
                      // if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                      //     controller
                      //         .selectedHospitalIdFilter.value.isNotEmpty &&
                      //     controller.selectedHighPriceFilter.value.isNotEmpty &&
                      //     controller.selectedLowPriceFilter.value.isNotEmpty) {
                      //   result = await controller
                      //       .getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
                      //     selectedDoctorFilterId:
                      //         controller.selectedDoctorIdFilter.value,
                      //     selectedHospitalFilterId:
                      //         controller.selectedHospitalIdFilter.value,
                      //     selectedLowPrice:
                      //         controller.selectedLowPriceFilter.value,
                      //     selectedHighPrice:
                      //         controller.selectedHighPriceFilter.value,
                      //   );
                      //   controller.listFilteredDoctor.value = result.data!;
                      // } else if (controller
                      //         .selectedDoctorIdFilter.value.isNotEmpty &&
                      //     controller.selectedHospitalIdFilter.value.isEmpty &&
                      //     controller.selectedLowPriceFilter.value.isNotEmpty &&
                      //     controller.selectedHighPriceFilter.value.isNotEmpty) {
                      //   result = await controller
                      //       .getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
                      //     selectedDoctorFilterId:
                      //         controller.selectedDoctorIdFilter.value,
                      //     selectedLowPrice:
                      //         controller.selectedLowPriceFilter.value,
                      //     selectedHighPrice:
                      //         controller.selectedHighPriceFilter.value,
                      //   );
                      //   controller.listFilteredDoctor.value = result.data!;
                      // } else if (controller
                      //         .selectedDoctorIdFilter.value.isNotEmpty &&
                      //     controller
                      //         .selectedHospitalIdFilter.value.isNotEmpty) {
                      //   result = await controller
                      //       .getDoctorListBySpecializationAndChooseHospital(
                      //           selectedDoctorFilterId:
                      //               controller.selectedDoctorIdFilter.value,
                      //           selectedHospitalFilterId:
                      //               controller.selectedHospitalIdFilter.value);
                      //   controller.listFilteredDoctor.value = result.data!;
                      // } else if (controller
                      //         .selectedDoctorIdFilter.value.isNotEmpty &&
                      //     controller.selectedHospitalIdFilter.value.isEmpty) {
                      //   result = await controller
                      //       .getDoctorListBySpecializationAndAllHospitalFilter(
                      //           selectedDoctorFilterId:
                      //               controller.selectedDoctorIdFilter.value);
                      //   controller.listFilteredDoctor.value = result.data!;
                      // }
                    }),
              ));
        }).toList(),
      );

  Widget buildDokterSpesialisFilterAll(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return ExpansionTile(
      initiallyExpanded: true,
      // iconColor: kBlackColor.withOpacity(0.5),
      title: Text(
        "Dokter Spesialis",
        style: kSubHeaderStyle,
      ),
      children: List.generate(controller.dokterSpesialisFilter.length, (index) {
        return Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RadioListTile<String>(
                  activeColor: kButtonColor,
                  contentPadding: EdgeInsets.zero,
                  value: controller.dokterSpesialisFilter[index].name!,
                  groupValue: controller.selectedDoctorFilter.value,
                  title: Text(controller.dokterSpesialisFilter[index].name!),
                  onChanged: (String? value) async {
                    // ubah selected dokter spesialis name
                    homeController.menus[1] = "Spesialis $value";

                    controller.selectedDoctorFilter.value = value!;
                    controller.selectedDoctorIdFilter.value = controller.dokterSpesialisFilter[index].specializationId!;

                    Doctors? result;
                    // DO SORT BY Spesialis
                    if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                        controller.selectedHospitalIdFilter.value.isNotEmpty &&
                        controller.selectedHighPriceFilter.value.isNotEmpty &&
                        controller.selectedLowPriceFilter.value.isNotEmpty) {
                      result = await controller.getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
                        selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                        selectedHospitalFilterId: controller.selectedHospitalIdFilter.value,
                        selectedLowPrice: controller.selectedLowPriceFilter.value,
                        selectedHighPrice: controller.selectedHighPriceFilter.value,
                      );
                      controller.listFilteredDoctor.value = result.data!;
                    } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                        controller.selectedHospitalIdFilter.value.isEmpty &&
                        controller.selectedLowPriceFilter.value.isNotEmpty &&
                        controller.selectedHighPriceFilter.value.isNotEmpty) {
                      result = await controller.getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
                        selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                        selectedLowPrice: controller.selectedLowPriceFilter.value,
                        selectedHighPrice: controller.selectedHighPriceFilter.value,
                      );
                      controller.listFilteredDoctor.value = result.data!;
                    } else if (controller.selectedDoctorIdFilter.value.isNotEmpty && controller.selectedHospitalIdFilter.value.isNotEmpty) {
                      result = await controller.getDoctorListBySpecializationAndChooseHospital(
                          selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                          selectedHospitalFilterId: controller.selectedHospitalIdFilter.value);
                      controller.listFilteredDoctor.value = result.data!;
                    } else if (controller.selectedDoctorIdFilter.value.isNotEmpty && controller.selectedHospitalIdFilter.value.isEmpty) {
                      result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
                          selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);
                      controller.listFilteredDoctor.value = result.data!;
                    }

                    if (controller.valueChoose.isNotEmpty) {
                      if (controller.valueChoose.value == controller.sort[0]) {
                        result?.data!.sort((a, b) => b.price!.raw!.toInt().compareTo(a.price!.raw!.toInt()));
                      } else if (controller.valueChoose.value == controller.sort[1]) {
                        result?.data!.sort((a, b) => a.price!.raw!.toInt().compareTo(b.price!.raw!.toInt()));
                      } else if (controller.valueChoose.value == controller.sort[2]) {
                        result?.data!.sort((b, a) {
                          // print("sort b a");
                          int tahun1 = int.tryParse(a.experience!.split(" ").first) ?? -99;
                          int tahun2 = int.tryParse(b.experience!.split(" ").first) ?? -99;
                          return tahun1.compareTo(tahun2);
                        });
                      } else {
                        result?.data!.sort((a, b) {
                          // print("sort a b");

                          int tahun2 = int.tryParse(a.experience!.split(" ").first) ?? -99;
                          int tahun1 = int.tryParse(b.experience!.split(" ").first) ?? -99;
                          return tahun2.compareTo(tahun1);
                        });
                      }
                    }

                    // Doctors result;
                    // // DO SORT BY Spesialis
                    // if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                    //     controller.selectedHospitalIdFilter.value.isNotEmpty &&
                    //     controller.selectedHighPriceFilter.value.isNotEmpty &&
                    //     controller.selectedLowPriceFilter.value.isNotEmpty) {
                    //   result = await controller
                    //       .getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
                    //     selectedDoctorFilterId:
                    //         controller.selectedDoctorIdFilter.value,
                    //     selectedHospitalFilterId:
                    //         controller.selectedHospitalIdFilter.value,
                    //     selectedLowPrice:
                    //         controller.selectedLowPriceFilter.value,
                    //     selectedHighPrice:
                    //         controller.selectedHighPriceFilter.value,
                    //   );
                    //   controller.listFilteredDoctor.value = result.data!;
                    // } else if (controller
                    //         .selectedDoctorIdFilter.value.isNotEmpty &&
                    //     controller.selectedHospitalIdFilter.value.isEmpty &&
                    //     controller.selectedLowPriceFilter.value.isNotEmpty &&
                    //     controller.selectedHighPriceFilter.value.isNotEmpty) {
                    //   result = await controller
                    //       .getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
                    //     selectedDoctorFilterId:
                    //         controller.selectedDoctorIdFilter.value,
                    //     selectedLowPrice:
                    //         controller.selectedLowPriceFilter.value,
                    //     selectedHighPrice:
                    //         controller.selectedHighPriceFilter.value,
                    //   );
                    //   controller.listFilteredDoctor.value = result.data!;
                    // } else if (controller
                    //         .selectedDoctorIdFilter.value.isNotEmpty &&
                    //     controller.selectedHospitalIdFilter.value.isNotEmpty) {
                    //   result = await controller
                    //       .getDoctorListBySpecializationAndChooseHospital(
                    //           selectedDoctorFilterId:
                    //               controller.selectedDoctorIdFilter.value,
                    //           selectedHospitalFilterId:
                    //               controller.selectedHospitalIdFilter.value);
                    //   controller.listFilteredDoctor.value = result.data!;
                    // } else if (controller
                    //         .selectedDoctorIdFilter.value.isNotEmpty &&
                    //     controller.selectedHospitalIdFilter.value.isEmpty) {
                    //   result = await controller
                    //       .getDoctorListBySpecializationAndAllHospitalFilter(
                    //           selectedDoctorFilterId:
                    //               controller.selectedDoctorIdFilter.value);
                    //   controller.listFilteredDoctor.value = result.data!;
                    // }
                  }),
            ));
      }).toList(),
    );
  }

  Widget buildDokterSpesialisFilter(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return ExpansionTile(
      initiallyExpanded: true,
      // iconColor: kBlackColor.withOpacity(0.5),
      title: Text(
        "Dokter Spesialis",
        style: kSubHeaderStyle,
      ),
      children: List.generate(controller.dokterSpesialisFilter.length > 5 ? 5 : controller.dokterSpesialisFilter.length, (index) {
        return Obx(() {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              // TODO: ganti radio listilenya
              child: RadioListTile<String>(
                  activeColor: kButtonColor,
                  // dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: controller.dokterSpesialisFilter[index].name!,
                  groupValue: controller.selectedDoctorFilter.value,
                  title: Text(controller.dokterSpesialisFilter[index].name!),
                  onChanged: (String? value) async {
                    // ubah selected dokter spesialis name
                    homeController.menus[1] = "Spesialis $value";

                    controller.selectedDoctorFilter.value = value!;
                    controller.selectedDoctorIdFilter.value = controller.dokterSpesialisFilter[index].specializationId!;

                    // Doctors result;
                    // // DO SORT BY Spesialis
                    // if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                    //     controller.selectedHospitalIdFilter.value.isNotEmpty &&
                    //     controller.selectedHighPriceFilter.value.isNotEmpty &&
                    //     controller.selectedLowPriceFilter.value.isNotEmpty) {
                    //   result = await controller
                    //       .getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
                    //     selectedDoctorFilterId:
                    //         controller.selectedDoctorIdFilter.value,
                    //     selectedHospitalFilterId:
                    //         controller.selectedHospitalIdFilter.value,
                    //     selectedLowPrice:
                    //         controller.selectedLowPriceFilter.value,
                    //     selectedHighPrice:
                    //         controller.selectedHighPriceFilter.value,
                    //   );
                    //   controller.listFilteredDoctor.value = result.data!;
                    // } else if (controller
                    //         .selectedDoctorIdFilter.value.isNotEmpty &&
                    //     controller.selectedHospitalIdFilter.value.isEmpty &&
                    //     controller.selectedLowPriceFilter.value.isNotEmpty &&
                    //     controller.selectedHighPriceFilter.value.isNotEmpty) {
                    //   result = await controller
                    //       .getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
                    //     selectedDoctorFilterId:
                    //         controller.selectedDoctorIdFilter.value,
                    //     selectedLowPrice:
                    //         controller.selectedLowPriceFilter.value,
                    //     selectedHighPrice:
                    //         controller.selectedHighPriceFilter.value,
                    //   );
                    //   controller.listFilteredDoctor.value = result.data!;
                    // } else if (controller
                    //         .selectedDoctorIdFilter.value.isNotEmpty &&
                    //     controller.selectedHospitalIdFilter.value.isNotEmpty) {
                    //   result = await controller
                    //       .getDoctorListBySpecializationAndChooseHospital(
                    //           selectedDoctorFilterId:
                    //               controller.selectedDoctorIdFilter.value,
                    //           selectedHospitalFilterId:
                    //               controller.selectedHospitalIdFilter.value);
                    //   controller.listFilteredDoctor.value = result.data!;
                    // } else if (controller
                    //         .selectedDoctorIdFilter.value.isNotEmpty &&
                    //     controller.selectedHospitalIdFilter.value.isEmpty) {
                    //   result = await controller
                    //       .getDoctorListBySpecializationAndAllHospitalFilter(
                    //           selectedDoctorFilterId:
                    //               controller.selectedDoctorIdFilter.value);
                    //   controller.listFilteredDoctor.value = result.data!;
                    // }

                    Doctors? result;
                    // DO SORT BY Spesialis
                    if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                        controller.selectedHospitalIdFilter.value.isNotEmpty &&
                        controller.selectedHighPriceFilter.value.isNotEmpty &&
                        controller.selectedLowPriceFilter.value.isNotEmpty) {
                      result = await controller.getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
                        selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                        selectedHospitalFilterId: controller.selectedHospitalIdFilter.value,
                        selectedLowPrice: controller.selectedLowPriceFilter.value,
                        selectedHighPrice: controller.selectedHighPriceFilter.value,
                      );
                      controller.listFilteredDoctor.value = result.data!;
                    } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                        controller.selectedHospitalIdFilter.value.isEmpty &&
                        controller.selectedLowPriceFilter.value.isNotEmpty &&
                        controller.selectedHighPriceFilter.value.isNotEmpty) {
                      result = await controller.getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
                        selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                        selectedLowPrice: controller.selectedLowPriceFilter.value,
                        selectedHighPrice: controller.selectedHighPriceFilter.value,
                      );
                      controller.listFilteredDoctor.value = result.data!;
                    } else if (controller.selectedDoctorIdFilter.value.isNotEmpty && controller.selectedHospitalIdFilter.value.isNotEmpty) {
                      result = await controller.getDoctorListBySpecializationAndChooseHospital(
                          selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                          selectedHospitalFilterId: controller.selectedHospitalIdFilter.value);
                      controller.listFilteredDoctor.value = result.data!;
                    } else if (controller.selectedDoctorIdFilter.value.isNotEmpty && controller.selectedHospitalIdFilter.value.isEmpty) {
                      result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
                          selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);
                      controller.listFilteredDoctor.value = result.data!;
                    }

                    if (controller.valueChoose.isNotEmpty) {
                      if (controller.valueChoose.value == controller.sort[0]) {
                        result?.data!.sort((a, b) => b.price!.raw!.toInt().compareTo(a.price!.raw!.toInt()));
                      } else if (controller.valueChoose.value == controller.sort[1]) {
                        result?.data!.sort((a, b) => a.price!.raw!.toInt().compareTo(b.price!.raw!.toInt()));
                      } else if (controller.valueChoose.value == controller.sort[2]) {
                        result?.data!.sort((b, a) {
                          // print("sort b a");
                          int tahun1 = int.tryParse(a.experience!.split(" ").first) ?? -99;
                          int tahun2 = int.tryParse(b.experience!.split(" ").first) ?? -99;
                          return tahun1.compareTo(tahun2);
                        });
                      } else {
                        result?.data!.sort((a, b) {
                          // print("sort a b");

                          int tahun2 = int.tryParse(a.experience!.split(" ").first) ?? -99;
                          int tahun1 = int.tryParse(b.experience!.split(" ").first) ?? -99;
                          return tahun2.compareTo(tahun1);
                        });
                      }
                    }
                  }),
            ),
          );
        });
      }).toList(),
    );
  }

  Container buildSortDoctorField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: kButtonColor),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Obx(() => DropdownButton<String>(
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: kButtonColor,
            ),
            hint: Text(
              controller.hintTextSort,
              style: kSubHeaderStyle.copyWith(color: kButtonColor, fontSize: 15, wordSpacing: 1, fontWeight: FontWeight.w600),
            ),
            elevation: 16,
            style: kSubHeaderStyle.copyWith(color: kButtonColor, fontSize: 15, wordSpacing: 1, fontWeight: FontWeight.w600),
            underline: Container(),
            onChanged: (String? newValue) async {
              controller.valueChoose.value = newValue!;

              // Doctors result;
              // // DO SORT BY Spesialis
              // if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isNotEmpty &&
              //     controller.selectedHighPriceFilter.value.isNotEmpty &&
              //     controller.selectedLowPriceFilter.value.isNotEmpty &&
              //     controller.valueChoose.isEmpty) {
              //   result = await controller
              //       .getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
              //     selectedDoctorFilterId:
              //         controller.selectedDoctorIdFilter.value,
              //     selectedHospitalFilterId:
              //         controller.selectedHospitalIdFilter.value,
              //     selectedLowPrice: controller.selectedLowPriceFilter.value,
              //     selectedHighPrice: controller.selectedHighPriceFilter.value,
              //   );
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isNotEmpty &&
              //     controller.selectedHighPriceFilter.value.isNotEmpty &&
              //     controller.selectedLowPriceFilter.value.isNotEmpty &&
              //     controller.valueChoose.isNotEmpty) {
              //   result = await controller
              //       .getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
              //     selectedDoctorFilterId:
              //         controller.selectedDoctorIdFilter.value,
              //     selectedHospitalFilterId:
              //         controller.selectedHospitalIdFilter.value,
              //     selectedLowPrice: controller.selectedLowPriceFilter.value,
              //     selectedHighPrice: controller.selectedHighPriceFilter.value,
              //   );
              //   if (controller.valueChoose.value == controller.sort[0]) {
              //     result.data!.sort((a, b) =>
              //         a.price!.raw!.toInt().compareTo(b.price!.raw!.toInt()));
              //   } else if (controller.valueChoose.value == controller.sort[1]) {
              //     result.data!.sort((b, a) =>
              //         b.price!.raw!.toInt().compareTo(a.price!.raw!.toInt()));
              //   } else if (controller.valueChoose.value == controller.sort[2]) {
              //     result.data!.sort((b, a) {
              //       int tahun1 = int.parse(a.experience!.substring(0, 2));
              //       int tahun2 = int.parse(b.experience!.substring(0, 2));
              //       return tahun1.compareTo(tahun2);
              //     });
              //   } else {
              //     result.data!.sort((a, b) {
              //       int tahun2 = int.parse(a.experience!.substring(0, 2));
              //       int tahun1 = int.parse(b.experience!.substring(0, 2));
              //       return tahun2.compareTo(tahun1);
              //     });
              //   }
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isEmpty &&
              //     controller.selectedLowPriceFilter.value.isNotEmpty &&
              //     controller.selectedHighPriceFilter.value.isNotEmpty) {
              //   result = await controller
              //       .getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
              //     selectedDoctorFilterId:
              //         controller.selectedDoctorIdFilter.value,
              //     selectedLowPrice: controller.selectedLowPriceFilter.value,
              //     selectedHighPrice: controller.selectedHighPriceFilter.value,
              //   );

              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isEmpty &&
              //     controller.selectedLowPriceFilter.value.isNotEmpty &&
              //     controller.selectedHighPriceFilter.value.isNotEmpty &&
              //     controller.valueChoose.isNotEmpty) {
              //   result = await controller
              //       .getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
              //     selectedDoctorFilterId:
              //         controller.selectedDoctorIdFilter.value,
              //     selectedLowPrice: controller.selectedLowPriceFilter.value,
              //     selectedHighPrice: controller.selectedHighPriceFilter.value,
              //   );

              //   if (controller.valueChoose.value == controller.sort[0]) {
              //     result.data!.sort((a, b) =>
              //         a.price!.raw!.toInt().compareTo(b.price!.raw!.toInt()));
              //   } else if (controller.valueChoose.value == controller.sort[1]) {
              //     result.data!.sort((b, a) =>
              //         b.price!.raw!.toInt().compareTo(a.price!.raw!.toInt()));
              //   } else if (controller.valueChoose.value == controller.sort[2]) {
              //     result.data!.sort((b, a) {
              //       int tahun1 = int.parse(a.experience!.substring(0, 2));
              //       int tahun2 = int.parse(b.experience!.substring(0, 2));
              //       return tahun1.compareTo(tahun2);
              //     });
              //   } else {
              //     result.data!.sort((a, b) {
              //       int tahun2 = int.parse(a.experience!.substring(0, 2));
              //       int tahun1 = int.parse(b.experience!.substring(0, 2));
              //       return tahun2.compareTo(tahun1);
              //     });
              //   }

              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isNotEmpty) {
              //   result = await controller
              //       .getDoctorListBySpecializationAndChooseHospital(
              //           selectedDoctorFilterId:
              //               controller.selectedDoctorIdFilter.value,
              //           selectedHospitalFilterId:
              //               controller.selectedHospitalIdFilter.value);
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isNotEmpty) {
              //   result = await controller
              //       .getDoctorListBySpecializationAndChooseHospital(
              //           selectedDoctorFilterId:
              //               controller.selectedDoctorIdFilter.value,
              //           selectedHospitalFilterId:
              //               controller.selectedHospitalIdFilter.value);
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isEmpty &&
              //     controller.valueChoose.isNotEmpty) {
              //   result = await controller
              //       .getDoctorListBySpecializationAndAllHospitalFilter(
              //           selectedDoctorFilterId:
              //               controller.selectedDoctorIdFilter.value);
              //   if (controller.valueChoose.value == controller.sort[0]) {
              //     result.data!.sort((b, a) {
              //       double harga1 = a.price!.raw!;
              //       double harga2 = b.price!.raw!;
              //       return harga1.compareTo(harga2);
              //     });
              //   } else if (controller.valueChoose.value == controller.sort[1]) {
              //     result.data!.sort((a, b) {
              //       double harga2 = a.price!.raw!;
              //       double harga1 = b.price!.raw!;
              //       return harga2.compareTo(harga1);
              //     });
              //   } else if (controller.valueChoose.value == controller.sort[2]) {
              //     result.data!.sort((b, a) {
              //       int tahun1 = int.parse(a.experience!.substring(0, 2));
              //       int tahun2 = int.parse(b.experience!.substring(0, 2));
              //       return tahun1.compareTo(tahun2);
              //     });
              //   } else {
              //     result.data!.sort((a, b) {
              //       int tahun2 = int.parse(a.experience!.substring(0, 2));
              //       int tahun1 = int.parse(b.experience!.substring(0, 2));
              //       return tahun2.compareTo(tahun1);
              //     });
              //   }
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isEmpty) {
              //   result = await controller
              //       .getDoctorListBySpecializationAndAllHospitalFilter(
              //           selectedDoctorFilterId:
              //               controller.selectedDoctorIdFilter.value);
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isEmpty &&
              //     controller.valueChoose.isNotEmpty) {
              //   result = await controller
              //       .getDoctorListBySpecializationAndAllHospitalFilter(
              //           selectedDoctorFilterId:
              //               controller.selectedDoctorIdFilter.value);

              //   if (controller.valueChoose.value == controller.sort[0]) {
              //     result.data!.sort((a, b) =>
              //         a.price!.raw!.toInt().compareTo(b.price!.raw!.toInt()));
              //   } else if (controller.valueChoose.value == controller.sort[1]) {
              //     result.data!.sort((b, a) =>
              //         b.price!.raw!.toInt().compareTo(a.price!.raw!.toInt()));
              //   } else if (controller.valueChoose.value == controller.sort[2]) {
              //     result.data!.sort((b, a) {
              //       int tahun1 = int.parse(a.experience!.substring(0, 2));
              //       int tahun2 = int.parse(b.experience!.substring(0, 2));
              //       return tahun1.compareTo(tahun2);
              //     });
              //   } else {
              //     result.data!.sort((a, b) {
              //       int tahun2 = int.parse(a.experience!.substring(0, 2));
              //       int tahun1 = int.parse(b.experience!.substring(0, 2));
              //       return tahun2.compareTo(tahun1);
              //     });
              //   }
              //   controller.listFilteredDoctor.value = result.data!;
              // }

              Doctors? result;
              // DO SORT BY Spesialis
              if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                  controller.selectedHospitalIdFilter.value.isNotEmpty &&
                  controller.selectedHighPriceFilter.value.isNotEmpty &&
                  controller.selectedLowPriceFilter.value.isNotEmpty) {
                result = await controller.getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
                  selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                  selectedHospitalFilterId: controller.selectedHospitalIdFilter.value,
                  selectedLowPrice: controller.selectedLowPriceFilter.value,
                  selectedHighPrice: controller.selectedHighPriceFilter.value,
                );
                controller.listFilteredDoctor.value = result.data!;
              } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                  controller.selectedHospitalIdFilter.value.isEmpty &&
                  controller.selectedLowPriceFilter.value.isNotEmpty &&
                  controller.selectedHighPriceFilter.value.isNotEmpty) {
                result = await controller.getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
                  selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                  selectedLowPrice: controller.selectedLowPriceFilter.value,
                  selectedHighPrice: controller.selectedHighPriceFilter.value,
                );
                controller.listFilteredDoctor.value = result.data!;
              } else if (controller.selectedDoctorIdFilter.value.isNotEmpty && controller.selectedHospitalIdFilter.value.isNotEmpty) {
                result = await controller.getDoctorListBySpecializationAndChooseHospital(
                    selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                    selectedHospitalFilterId: controller.selectedHospitalIdFilter.value);
                controller.listFilteredDoctor.value = result.data!;
              } else if (controller.selectedDoctorIdFilter.value.isNotEmpty && controller.selectedHospitalIdFilter.value.isEmpty) {
                result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
                    selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);
                controller.listFilteredDoctor.value = result.data!;
              }

              if (controller.valueChoose.value == controller.sort[0]) {
                result?.data!.sort((a, b) => b.price!.raw!.toInt().compareTo(a.price!.raw!.toInt()));
              } else if (controller.valueChoose.value == controller.sort[1]) {
                result?.data!.sort((a, b) => a.price!.raw!.toInt().compareTo(b.price!.raw!.toInt()));
              } else if (controller.valueChoose.value == controller.sort[2]) {
                result?.data!.sort((b, a) {
                  // print("sort b a");
                  int tahun1 = int.tryParse(a.experience!.split(" ").first) ?? -99;
                  int tahun2 = int.tryParse(b.experience!.split(" ").first) ?? -99;
                  return tahun1.compareTo(tahun2);
                });
              } else {
                result?.data!.sort((a, b) {
                  // print("sort a b");

                  int tahun2 = int.tryParse(a.experience!.split(" ").first) ?? -99;
                  int tahun1 = int.tryParse(b.experience!.split(" ").first) ?? -99;
                  return tahun2.compareTo(tahun1);
                });
              }
            },
            value: controller.valueChoose.value.isEmpty ? null : controller.valueChoose.value,
            items: controller.sort.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    // Icon(Icons.radio_button_off_outlined),
                    // SizedBox(
                    //   width: 4,
                    // ),
                    Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              );
            }).toList(),
          )),
    );
  }
}
