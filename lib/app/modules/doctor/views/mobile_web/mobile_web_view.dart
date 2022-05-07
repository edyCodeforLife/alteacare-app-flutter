// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/doctors.dart';
import 'package:altea/app/modules/doctor/controllers/doctor_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/footer_mobile_web_view.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/routes/app_pages.dart';

class MobileWebDoctorSpesialisCategoryView extends GetView<DoctorController> {
  const MobileWebDoctorSpesialisCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBackground,
      key: scaffoldKey,
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawer: MobileWebHamburgerMenu(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spesialis Paling Dicari',
                    style: kHomeSubHeaderStyle,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // FutureBuilder<DoctorSpecialistCategory>(
                  //   future: controller.getDoctorsPopularCategory(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       // print('data category populer => ${snapshot.data}');
                  //       DoctorSpecialistCategory? popularCategories;
                  //       popularCategories = snapshot.data;
                  //       // return Container();
                  //       return SizedBox(
                  //         width: MediaQuery.of(context).size.width * 0.9,
                  //         height: MediaQuery.of(context).size.height * 0.4,
                  //         child: GridView.builder(
                  //           physics: const NeverScrollableScrollPhysics(),
                  //           gridDelegate:
                  //               const SliverGridDelegateWithFixedCrossAxisCount(
                  //             crossAxisCount: 3,
                  //           ),
                  //           itemCount: popularCategories?.data?.length,
                  //           itemBuilder: (context, index) {
                  //             return SpesialisCard(
                  //                 backgroundClr: kWhiteGray,
                  //                 imgWidth: MediaQuery.of(context).size.width / 7,
                  //                 id: popularCategories
                  //                         ?.data?[index].specializationId ??
                  //                     ' ',
                  //                 onTap: () async {
                  //                   controller.selectedSpesialis.value =
                  //                       controller.spesialisMenus[index];
                  //                   controller.selectedSpesialis.refresh();

                  //                   if (homeController.menus.isNotEmpty) {
                  //                     homeController.menus.removeAt(0);
                  //                   }

                  //                   if (homeController.menus
                  //                       .contains("Dokter Spesialis")) {
                  //                     homeController.menus.add(
                  //                         "Spesialis ${controller.selectedSpesialis.value.name}");
                  //                   } else {
                  //                     homeController.menus.add("Dokter Spesialis");
                  //                     homeController.menus.add(
                  //                         "Spesialis ${controller.selectedSpesialis.value.name}");
                  //                   }

                  //                   controller.selectedDoctorFilter.value =
                  //                       controller.selectedSpesialis.value.name!;

                  //                   // set ID specialist
                  //                   controller.selectedDoctorIdFilter.value =
                  //                       controller.selectedSpesialis.value
                  //                           .specializationId!;

                  //                   // Load data dokter
                  //                   final Doctors result = await controller
                  //                       .getDoctorListBySpecializationAndAllHospitalFilter(
                  //                           selectedDoctorFilterId: controller
                  //                               .selectedDoctorIdFilter.value);

                  //                   controller.listFilteredDoctor.value =
                  //                       result.data!;

                  //                   Get.toNamed(Routes.DOCTOR_SPESIALIS,
                  //                       arguments:
                  //                           controller.selectedSpesialis.value);
                  //                 },
                  //                 width: MediaQuery.of(context).size.width / 3.5,
                  //                 height: MediaQuery.of(context).size.width / 4,
                  //                 text: popularCategories?.data?[index].name ?? ' ',
                  //                 img: popularCategories
                  //                         ?.data?[index].icon?.formats?.thumbnail ??
                  //                     ' ');
                  //           },
                  //         ),
                  //       );
                  //     } else {
                  //       return CupertinoActivityIndicator();
                  //     }
                  //   },
                  // ),
                  SizedBox(
                    width: screenWidth,
                    // height: screenWidth * 0.65,
                    child: GridView.count(
                        shrinkWrap: true,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 3,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(controller.spesialisMenus.length, (index) {
                          return Container(
                            width: screenWidth * 0.15,
                            height: screenWidth * 0.13,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: kWhiteGray,
                              // border: Border.all(
                              //     color: controller.selectedSpesialis.value ==
                              //             controller.spesialisMenus[index]
                              //         ? kButtonColor
                              //         : kWhiteGray),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onHover: (hover) {
                                // print("hover ? $hover");
                                controller.selectedSpesialis.value = controller.spesialisMenus[index];
                              },
                              onTap: () async {
                                controller.selectedSpesialis.value = controller.spesialisMenus[index];
                                controller.selectedSpesialis.refresh();

                                if (homeController.menus.isNotEmpty) {
                                  homeController.menus.removeAt(0);
                                }

                                if (homeController.menus.contains("Dokter Spesialis")) {
                                  homeController.menus.add("Spesialis ${controller.selectedSpesialis.value.name}");
                                } else {
                                  homeController.menus.add("Dokter Spesialis");
                                  homeController.menus.add("Spesialis ${controller.selectedSpesialis.value.name}");
                                }

                                controller.selectedDoctorFilter.value = controller.selectedSpesialis.value.name!;

                                // set ID specialist
                                controller.selectedDoctorIdFilter.value = controller.selectedSpesialis.value.specializationId!;

                                // Load data dokter
                                final Doctors result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
                                    selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);

                                controller.listFilteredDoctor.value = result.data!;

                                Get.toNamed(Routes.DOCTOR_SPESIALIS, arguments: controller.selectedSpesialis.value);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.12,
                                    height: screenWidth * 0.12,
                                    child: Obx(
                                      () => Image.network(
                                        addCDNforLoadImage(controller.spesialisMenus[index].icon!.formats!.thumbnail!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      controller.spesialisMenus[index].name!,
                                      style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.5), fontSize: 8, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Spesialis Lainnya',
                    style: kHomeSubHeaderStyle,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: screenWidth * 0.9,
                    // height: context.height * 1.3,
                    child: GridView.count(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                          controller.spesialisMenusOther.length,
                          (index) => Container(
                                width: screenWidth * 0.15,
                                height: screenWidth * 0.13,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: kWhiteGray,
                                  // border: Border.all(
                                  //     color: controller.selectedSpesialis.value ==
                                  //             controller.spesialisMenusOther[index]
                                  //         ? kButtonColor
                                  //         : kWhiteGray),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    controller.selectedSpesialis.value = controller.spesialisMenusOther[index];
                                    controller.selectedSpesialis.refresh();

                                    if (homeController.menus.isNotEmpty) {
                                      homeController.menus.removeAt(0);
                                    }

                                    if (homeController.menus.contains("Dokter Spesialis")) {
                                      homeController.menus.add("Spesialis ${controller.selectedSpesialis.value.name}");
                                    } else {
                                      homeController.menus.add("Dokter Spesialis");
                                      homeController.menus.add("Spesialis ${controller.selectedSpesialis.value.name}");
                                    }

                                    controller.selectedDoctorFilter.value = controller.selectedSpesialis.value.name!;

                                    // set ID specialist
                                    controller.selectedDoctorIdFilter.value = controller.selectedSpesialis.value.specializationId!;

                                    // Load data dokter
                                    final Doctors result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
                                        selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);

                                    controller.listFilteredDoctor.value = result.data!;

                                    Get.toNamed(Routes.DOCTOR_SPESIALIS, arguments: controller.selectedSpesialis.value);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.12,
                                        height: screenWidth * 0.12,
                                        child: Obx(
                                          () => Image.network(
                                            addCDNforLoadImage(
                                              controller.spesialisMenusOther[index].icon!.formats!.thumbnail!,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Text(
                                          controller.spesialisMenusOther[index].name!,
                                          style:
                                              kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.5), fontSize: 8, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            FooterMobileWebView(screenWidth: screenWidth),
          ],
        ),
      ),
    );
  }
}
