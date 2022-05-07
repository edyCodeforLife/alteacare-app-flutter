// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../data/model/doctors.dart';
import '../../../../routes/app_pages.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../home/views/dekstop_web/widget/footer_section_view.dart';
import '../../../home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import '../../controllers/doctor_controller.dart';

class DesktopWebDoctorSpesialisCategoryView extends GetView<DoctorController> {
  const DesktopWebDoctorSpesialisCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    ScreenSize.recalculate(context);
    final homeController = Get.find<HomeController>();

    return WillPopScope(
        onWillPop: () async {
          homeController.isSelectedTabBeranda.value = true;
          homeController.isSelectedTabDokter.value = false;
          homeController.isSelectedTabKonsultasi.value = false;
          Get.back();
          return true;
        },
        child: Obx(
          () => LoadingOverlay(
            isLoading: controller.isLoading.value,
            color: kButtonColor.withOpacity(0.1),
            opacity: 0.8,
            child: Scaffold(
              backgroundColor: kBackground,
              body: ListView(
                children: [
                  TopNavigationBarSection(
                    screenWidth: screenWidth,
                  ),
                  Column(
                    children: [
                      Obx(() => controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.wb),
                              child: SizedBox(
                                width: 120.wb,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.hb,
                                    ),
                                    Text(
                                      "Spesialis Paling Dicari",
                                      style: kTextInputStyle.copyWith(
                                          color: kBlackColor.withOpacity(0.8), fontSize: 1.15.wb, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 1.hb,
                                    ),
                                    SizedBox(
                                      width: 120.wb,
                                      height: 29.hb,
                                      child: ListView.builder(
                                        itemCount: controller.spesialisMenus.length,
                                        scrollDirection: Axis.horizontal,
                                        // physics:
                                        //     const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            width: 17.wb,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Obx(
                                                  () => MouseRegion(
                                                    cursor: SystemMouseCursors.click,
                                                    onEnter: (event) => controller.onEntered(isHovered: true, index: index, specialistType: 0),
                                                    onExit: (event) => controller.onEntered(isHovered: false, index: index, specialistType: 0),
                                                    child: GestureDetector(
                                                      // borderRadius:
                                                      //     BorderRadius.circular(
                                                      //         124),

                                                      onTap: () async {
                                                        controller.selectedSpesialis.value = controller.spesialisMenus[index];
                                                        controller.selectedSpesialis.refresh();

                                                        if (homeController.menus.isNotEmpty) {
                                                          homeController.menus.removeAt(0);
                                                          homeController.menus.value = [];
                                                        }

                                                        if (homeController.menus.contains("Dokter Spesialis")) {
                                                          homeController.menus.add("Spesialis ${controller.selectedSpesialis.value.name}");
                                                        } else {
                                                          homeController.menus.add("Dokter Spesialis");
                                                          homeController.menus.add("Spesialis ${controller.selectedSpesialis.value.name}");
                                                        }

                                                        // refresh controller value
                                                        controller.refreshController();

                                                        controller.selectedDoctorFilter.value = controller.selectedSpesialis.value.name!;

                                                        // set ID specialist
                                                        controller.selectedDoctorIdFilter.value =
                                                            controller.selectedSpesialis.value.specializationId!;

                                                        // Load data dokter
                                                        final Doctors result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
                                                            selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);

                                                        controller.listFilteredDoctor.value = result.data!;

                                                        Get.toNamed(Routes.DOCTOR_SPESIALIS, arguments: controller.selectedSpesialis.value);
                                                      },
                                                      child: Container(
                                                        width: 16.wb,
                                                        height: 25.hb,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(24),
                                                            color: kWhiteGray,
                                                            border: Border.all(
                                                                width: 1.5,
                                                                color: controller.selectedSpesialis.value == controller.spesialisMenus[index]
                                                                    ? kButtonColor
                                                                    : kWhiteGray)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            SizedBox(
                                                              width: 5.wb,
                                                              child: Obx(() => Image.network(
                                                                  addCDNforLoadImage(controller.spesialisMenus[index].icon!.formats!.thumbnail!))),
                                                            ),
                                                            // SizedBox(
                                                            //   height: 1.hb,
                                                            // ),
                                                            Obx(
                                                              () => SizedBox(
                                                                width: 15.wb,
                                                                child: Text(
                                                                  controller.spesialisMenus[index].name!,
                                                                  style: controller.selectedSpesialis.value == controller.spesialisMenus[index]
                                                                      ? kTextInputStyle.copyWith(
                                                                          color: kDarkBlue, fontSize: 1.wb, fontWeight: FontWeight.w800)
                                                                      : kTextInputStyle.copyWith(
                                                                          color: kBlackColor.withOpacity(0.5),
                                                                          fontSize: 1.wb,
                                                                          fontWeight: FontWeight.w600),
                                                                  maxLines: 2,
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      SizedBox(
                        height: 1.hb,
                      ),
                      Obx(
                        () => controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.wb),
                                child: SizedBox(
                                  width: 120.wb,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 1.hb,
                                      ),
                                      Text(
                                        "Spesialis Lainnya",
                                        style: kTextInputStyle.copyWith(
                                            color: kBlackColor.withOpacity(0.8), fontSize: 1.15.wb, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 1.hb,
                                      ),
                                      SizedBox(
                                        width: 120.wb,
                                        // height: context.height * 1.7,
                                        child: GridView.count(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          crossAxisCount: 5,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          children: List.generate(
                                            controller.spesialisMenusOther.length,
                                            (index) {
                                              return Obx(
                                                () => MouseRegion(
                                                  onEnter: (event) => controller.onEntered(isHovered: true, index: index, specialistType: 1),
                                                  onExit: (event) => controller.onEntered(isHovered: false, index: index, specialistType: 1),
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.circular(22),
                                                    // onHover: (hover) {
                                                    //   print("hover ? $hover");
                                                    //   controller
                                                    //           .selectedSpesialis.value =
                                                    //       controller
                                                    //               .spesialisMenusOther[
                                                    //           index];
                                                    // },
                                                    onTap: () async {
                                                      controller.selectedSpesialis.value = controller.spesialisMenusOther[index];
                                                      controller.selectedSpesialis.refresh();

                                                      if (homeController.menus.isNotEmpty) {
                                                        homeController.menus.removeAt(0);
                                                        homeController.menus.value = [];
                                                      }

                                                      if (homeController.menus.contains("Dokter Spesialis")) {
                                                        homeController.menus.add("Spesialis ${controller.selectedSpesialis.value.name}");
                                                      } else {
                                                        homeController.menus.add("Dokter Spesialis");
                                                        homeController.menus.add("Spesialis ${controller.selectedSpesialis.value.name}");
                                                      }
                                                      // refresh controller value
                                                      controller.refreshController();

                                                      controller.selectedDoctorFilter.value = controller.selectedSpesialis.value.name!;

                                                      // set ID specialist
                                                      controller.selectedDoctorIdFilter.value = controller.selectedSpesialis.value.specializationId!;

                                                      // Load data dokter
                                                      final Doctors result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
                                                          selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);

                                                      controller.listFilteredDoctor.value = result.data!;

                                                      Get.toNamed(Routes.DOCTOR_SPESIALIS, arguments: controller.selectedSpesialis.value);
                                                    },
                                                    child: Container(
                                                      width: 16.wb,
                                                      height: 25.hb,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(22),
                                                          color: kWhiteGray,
                                                          border: Border.all(
                                                              width: 2,
                                                              color: controller.selectedSpesialis.value == controller.spesialisMenusOther[index]
                                                                  ? kButtonColor
                                                                  : kWhiteGray)),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          SizedBox(
                                                            width: 5.wb,
                                                            child: Obx(() => Image.network(
                                                                addCDNforLoadImage(controller.spesialisMenusOther[index].icon!.formats!.thumbnail!))),
                                                          ),
                                                          // const SizedBox(
                                                          //   height: 20,
                                                          // ),
                                                          Obx(
                                                            () => Text(
                                                              controller.spesialisMenusOther[index].name!,
                                                              style: controller.selectedSpesialis.value == controller.spesialisMenusOther[index]
                                                                  ? kTextInputStyle.copyWith(
                                                                      color: kDarkBlue, fontSize: 1.wb, fontWeight: FontWeight.w800)
                                                                  : kTextInputStyle.copyWith(
                                                                      color: kBlackColor.withOpacity(0.5),
                                                                      fontSize: 1.wb,
                                                                      fontWeight: FontWeight.w600),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.hb,
                  ),
                  FooterSectionWidget(screenWidth: screenWidth)
                ],
              ),
            ),
          ),
        ));
  }
}
