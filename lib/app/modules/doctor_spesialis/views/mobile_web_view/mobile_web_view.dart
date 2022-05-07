// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// Project imports:
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/routes/app_pages.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/widgets/custom_flat_button.dart';
import '../../../../data/model/doctors.dart';
import '../../../doctor/controllers/doctor_controller.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../home/views/mobile_web/mobile_web_hamburger_menu.dart';
import '../../../home/views/mobile_web/widgets/footer_mobile_web_view.dart';
import '../../../spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import '../widgets/doctor_content_section.dart';
import '../widgets/doctor_text_field.dart';

class DoctorSpesialisByCategoryMobileWeb extends GetView<DoctorController> {
  const DoctorSpesialisByCategoryMobileWeb({Key? key}) : super(key: key);

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // final doctor_specialist.Datum data =
    //     Get.arguments as doctor_specialist.Datum;
    final screenWidth = context.width;
    final screenHeight = context.height;

    final panelController = PanelController();

    // final List<Map<String, String>> menuList = [
    //   {"title": "Beranda", "image": "assets/path.png", "path": "/home"},
    //   {
    //     "title": "Dokter Spesialis",
    //     "image": "assets/spesialis.png",
    //     "path": "/doctor"
    //   },
    //   {
    //     "title": "Konsultasi Saya",
    //     "image": "assets/icon.png",
    //     "path": "/consult"
    //   },
    //   {"title": "Notifikasi", "image": "assets/group-2.png", "path": "/notif"},
    // ];

    final homeController = Get.find<HomeController>();
    final spesialisController = Get.put(SpesialisKonsultasiController());
    final SearchSpecialistMWSearchBar searchBar = SearchSpecialistMWSearchBar();

    return WillPopScope(
        onWillPop: () async {
          homeController.menus.value = [""];
          spesialisController.isLoading.value = false;
          // Get.back();
          if (searchBar.searchBarFocus.hasFocus) {
            // print("kebuka searchbar-nya");
            Navigator.pop(context);
            // searchBar.closeSearchBar();
          } else {
            // Navigator.pop(context);
            try {
              if (panelController.isPanelOpen) {
                panelController.close();
              } else {
                homeController.menus.value = [""];
                Get.back();
              }
            } catch (e) {
              // print(e.toString());
              Get.back();
            }
          }
          return false;
        },
        child: Obx(
          () => LoadingOverlay(
            isLoading: spesialisController.isLoading.value,
            color: kButtonColor.withOpacity(0.1),
            // progressIndicator: Dialog(
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: const [
            //       CircularProgressIndicator(),
            //       Text("Mohon tunggu "),
            //     ],
            //   ),
            // ),
            opacity: 0.8,
            child: GestureDetector(
              onTap: () {
                return FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                key: scaffoldKey,
                appBar: MobileWebMainAppbar(
                  scaffoldKey: scaffoldKey,
                ),
                drawer: MobileWebHamburgerMenu(),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => BreadCrumb.builder(
                                itemCount: homeController.menus.length,
                                builder: (index) {
                                  // print("menus ->${homeController.menus[index]}");
                                  // print(
                                  //     "selection dokter -> ${controller.spesialisMenus[index].name!}");
                                  return BreadCrumbItem(
                                    content: Text(
                                      homeController.menus[index],
                                      style: kSubHeaderStyle.copyWith(
                                          fontSize: 8,
                                          color: homeController.menus[index].contains(controller.selectedDoctorFilter) ? kDarkBlue : kLightGray),
                                    ),
                                    onTap: index < homeController.menus.length
                                        ? () {
                                            // TODO: CEK LAGI NANTI YA
                                            if (index == 0) {
                                              homeController.menus.removeAt(index + 1);
                                              Get.offNamed(Routes.DOCTOR);

                                              // Get.back();
                                            }
                                          }
                                        : null,
                                    // textColor: ,
                                  );
                                },
                                divider: const Text(" / "),
                              ),
                            ),
                            SizedBox(
                              height: screenWidth * 0.03,
                            ),
                            SizedBox(
                              // height: screenWidth * 0.12,
                              child: searchBar,
                            ),
                          ],
                        ),
                      ),
                      //filter dll
                      Container(
                        margin: const EdgeInsets.only(left: 16),
                        height: screenWidth * 0.1,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.bottomSheet(
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: buildSlidingUpPanel(screenWidth: screenWidth),
                                  ),
                                  enableDrag: true,
                                  backgroundColor: kBackground,
                                  isDismissible: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(33),
                                      topRight: Radius.circular(33),
                                    ),
                                  ),
                                );
                                // if (panelController.isAttached) {
                                //   if (panelController.isPanelClosed) {
                                //     panelController.open();
                                //   } else {
                                //     panelController.close();
                                //   }
                                // } else {
                                //   print("panel controller belum ada");
                                // }
                              },
                              child: Container(
                                height: screenWidth * 0.1,
                                width: screenWidth * 0.23,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: kLightGray)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.tune_rounded,
                                      color: kSubHeaderColor,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "Filter",
                                      style: kSubHeaderStyle.copyWith(fontSize: 8),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: controller.dokterSpesialisFilter.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Obx(() => InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: () async {
                                          homeController.menus[1] = "Spesialis ${controller.dokterSpesialisFilter[index].name!}";
                                          // print(
                                          //     "menus -> ${homeController.menus[1]}");
                                          homeController.menus.refresh();
                                          controller.selectedDoctorFilter.value = controller.dokterSpesialisFilter[index].name!;
                                          controller.selectedDoctorIdFilter.value = controller.dokterSpesialisFilter[index].specializationId!;

                                          Doctors result;
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
                                          } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                                              controller.selectedHospitalIdFilter.value.isNotEmpty) {
                                            result = await controller.getDoctorListBySpecializationAndChooseHospital(
                                                selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
                                                selectedHospitalFilterId: controller.selectedHospitalIdFilter.value);
                                            controller.listFilteredDoctor.value = result.data!;
                                          } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
                                              controller.selectedHospitalIdFilter.value.isEmpty) {
                                            result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
                                                selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);
                                            controller.listFilteredDoctor.value = result.data!;
                                          }
                                        },
                                        child: Container(
                                          height: screenWidth * 0.1,
                                          width: screenWidth * 0.25,
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          margin: const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: controller.selectedDoctorFilter.value == controller.dokterSpesialisFilter[index].name
                                                      ? kDarkBlue
                                                      : kLightGray)),
                                          child: Center(
                                            child: Text(
                                              controller.dokterSpesialisFilter[index].name!,
                                              style: kSubHeaderStyle.copyWith(
                                                  fontSize: 8,
                                                  color: controller.selectedDoctorFilter.value == controller.dokterSpesialisFilter[index].name
                                                      ? kDarkBlue
                                                      : kLightGray),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Obx(
                          () => Container(
                            // height: controller.listFilteredDoctor.isEmpty
                            //     ? screenWidth
                            //     : screenWidth *
                            //         controller.listFilteredDoctor.length /
                            //         1.85,
                            child: controller.listFilteredDoctor.isEmpty
                                ? Center(
                                    child: Text(
                                      "No Doctor Found",
                                      style: kSubHeaderStyle,
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: controller.listFilteredDoctor.length,
                                    itemBuilder: (_, index) {
                                      return buildContentListDoctor(screenHeight, screenWidth, controller.listFilteredDoctor[index], context);
                                    },
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.05,
                      ),
                      FooterMobileWebView(screenWidth: screenWidth),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget buildSlidingUpPanel({required double screenWidth}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          // Container(
          //   width: 48,
          //   height: 6,
          //   decoration: BoxDecoration(
          //     color: kBlackColor.withOpacity(0.5),
          //     borderRadius: BorderRadius.circular(3),
          //   ),
          // ),
          const SizedBox(
            height: 38,
          ),
          Expanded(
            child: ListView(
              children: [
                Text(
                  "Filter",
                  style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 18),
                ),
                const SizedBox(
                  height: 28,
                ),
                Text(
                  "Spesialis",
                  style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 14),
                ),
                const SizedBox(
                  height: 13,
                ),
                Column(
                  children: [
                    Obx(
                      () =>
                          slidingPanelSpesialisContent(screenWidth: screenWidth, isReadMore: controller.isShowMoreSpesialisFilterSlidingPanel.value),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Divider(
                      height: 1,
                      color: kLightGray,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    buildShowMoreButton("spesialis")
                  ],
                ),
                const SizedBox(
                  height: 28,
                ),
                Text(
                  "Rumah Sakit",
                  style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 14),
                ),
                const SizedBox(
                  height: 13,
                ),
                Column(
                  children: [
                    Obx(
                      () => slidingPanelHospitalContent(screenWidth: screenWidth, isReadMore: controller.isShowMoreHospitalFilterSlidingPanel.value),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Divider(
                      height: 1,
                      color: kLightGray,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    buildShowMoreButton("hospital")
                  ],
                ),
                Text(
                  "Harga",
                  style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 14),
                ),
                const SizedBox(
                  height: 13,
                ),
                slidingPanelHargaContent(
                  screenWidth: screenWidth,
                ),
                Text(
                  "Urutkan",
                  style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 14),
                ),
                const SizedBox(
                  height: 13,
                ),
                slidingPanelSortContent(
                  screenWidth: screenWidth,
                ),
                const SizedBox(
                  height: 37,
                ),
                CustomFlatButton(
                    width: screenWidth * 0.8,
                    text: "Terapkan",
                    onPressed: () async {
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
                      Get.back();
                      // panelController.close();
                    },
                    color: kButtonColor),
                const SizedBox(
                  height: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildShowMoreButton(String filterType) => TextButton(
      onPressed: () {
        filterType == "spesialis"
            ? controller.isShowMoreSpesialisFilterSlidingPanel.value = !controller.isShowMoreSpesialisFilterSlidingPanel.value
            : controller.isShowMoreHospitalFilterSlidingPanel.value = !controller.isShowMoreHospitalFilterSlidingPanel.value;
      },
      child: Obx(() => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              controller.isShowMoreSpesialisFilterSlidingPanel.value ? "Show Less" : "Show More",
              style: kPoppinsMedium500.copyWith(fontSize: 10, color: kLightGray),
            ),
            const SizedBox(
              width: 4,
            ),
            Icon(
              controller.isShowMoreSpesialisFilterSlidingPanel.value ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_rounded,
              size: 12,
              color: kLightGray,
            )
          ])));

  Widget slidingPanelSpesialisContent({required double screenWidth, required bool isReadMore}) {
    final homeController = Get.find<HomeController>();
    return Wrap(
      children: List.generate(
        isReadMore ? controller.dokterSpesialisFilter.length : 4,
        (index) => Obx(
          () => InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              controller.selectedDoctorFilter.value = controller.dokterSpesialisFilter[index].name!;
              controller.selectedDoctorIdFilter.value = controller.dokterSpesialisFilter[index].specializationId!;
              // controller.selectedDoctorFilter.refresh();
              homeController.menus[1] = "Spesialis ${controller.selectedDoctorFilter.value}";
            },
            child: Container(
              height: screenWidth * 0.1,
              width: screenWidth * 0.25,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.only(right: 8, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: controller.selectedDoctorFilter.value == controller.dokterSpesialisFilter[index].name ? kDarkBlue : kLightGray)),
              child: Center(
                child: Text(
                  controller.dokterSpesialisFilter[index].name!,
                  style: kSubHeaderStyle.copyWith(
                      fontSize: 8,
                      color: controller.selectedDoctorFilter.value == controller.dokterSpesialisFilter[index].name ? kDarkBlue : kLightGray),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget slidingPanelHospitalContent({required double screenWidth, required bool isReadMore}) {
    return Wrap(
      children: List.generate(
        isReadMore ? controller.allHospitalFilterName.length : 4,
        (index) => Obx(
          () => InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              controller.selectedHospitalFilter.value = controller.allHospitalFilterName[index];

              for (final item in controller.allHospital) {
                if (controller.selectedHospitalFilter.value == "Semua") {
                  controller.selectedHospitalIdFilter.value = "";
                } else if (controller.selectedHospitalFilter.value == item.name) {
                  controller.selectedHospitalIdFilter.value = item.hospitalId!;
                }
              }
              // controller.selectedHospitalFilter.refresh();
            },
            child: Container(
              height: screenWidth * 0.11,
              width: screenWidth * 0.25,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.only(right: 8, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: controller.selectedHospitalFilter.value == controller.allHospitalFilterName[index] ? kDarkBlue : kLightGray)),
              child: Center(
                child: Text(
                  controller.allHospitalFilterName[index],
                  style: kSubHeaderStyle.copyWith(
                      fontSize: 8,
                      color: controller.selectedHospitalFilter.value == controller.allHospitalFilterName[index] ? kDarkBlue : kLightGray),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget slidingPanelHargaContent({required double screenWidth}) {
    return Wrap(
      children: List.generate(
        controller.hargaFilter.length,
        (index) => Obx(
          () => InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              controller.selectedHargaFilter.value = controller.hargaFilter[index];
              if (controller.selectedHargaFilter.value == controller.hargaFilter[0]) {
                controller.selectedLowPriceFilter.value = "0";
                controller.selectedHighPriceFilter.value = "9999999";
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

              Doctors result;
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
            },
            child: Container(
              height: screenWidth * 0.1,
              width: screenWidth * 0.25,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.only(right: 8, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: controller.selectedHargaFilter.value == controller.hargaFilter[index] ? kDarkBlue : kLightGray)),
              child: Center(
                child: Text(
                  controller.hargaFilter[index],
                  style: kSubHeaderStyle.copyWith(
                      fontSize: 8, color: controller.selectedHargaFilter.value == controller.hargaFilter[index] ? kDarkBlue : kLightGray),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget slidingPanelSortContent({required double screenWidth}) {
    return Wrap(
      children: List.generate(
        controller.sort.length,
        (index) => Obx(
          () => InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              controller.valueChoose.value = controller.sort[index];
              // print("urutkan -> ${controller.valueChoose.value}");
              Doctors result;
              // print("value choose?");
              // print(controller.valueChoose.toString());
              // DO SORT BY Spesialis
              // if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isNotEmpty &&
              //     controller.selectedHighPriceFilter.value.isNotEmpty &&
              //     controller.selectedLowPriceFilter.value.isNotEmpty &&
              //     controller.valueChoose.value.isEmpty) {
              //   result = await controller.getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
              //     selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
              //     selectedHospitalFilterId: controller.selectedHospitalIdFilter.value,
              //     selectedLowPrice: controller.selectedLowPriceFilter.value,
              //     selectedHighPrice: controller.selectedHighPriceFilter.value,
              //   );
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isNotEmpty &&
              //     controller.selectedHighPriceFilter.value.isNotEmpty &&
              //     controller.selectedLowPriceFilter.value.isNotEmpty &&
              //     controller.valueChoose.value.isNotEmpty) {
              //   result = await controller.getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
              //     selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
              //     selectedHospitalFilterId: controller.selectedHospitalIdFilter.value,
              //     selectedLowPrice: controller.selectedLowPriceFilter.value,
              //     selectedHighPrice: controller.selectedHighPriceFilter.value,
              //   );
              //   if (controller.valueChoose.value == controller.sort[0]) {
              //     result.data!.sort((a, b) => a.price!.raw!.toInt().compareTo(b.price!.raw!.toInt()));
              //   } else if (controller.valueChoose.value == controller.sort[1]) {
              //     result.data!.sort((b, a) => b.price!.raw!.toInt().compareTo(a.price!.raw!.toInt()));
              //   } else if (controller.valueChoose.value == controller.sort[2]) {
              //
              //     result.data!.sort((b, a) {
              //       print("sort b a");
              //       // int tahun1 = int.parse(a.experience!.substring(0, 2));
              //       // int tahun2 = int.parse(b.experience!.substring(0, 2));
              //       int tahun1 = int.tryParse(a.experience!.split(" ").first) ?? -99;
              //       int tahun2 = int.tryParse(b.experience!.split(" ").first) ?? -99;
              //       return tahun1.compareTo(tahun2);
              //     });
              //   } else {
              //     result.data!.sort((a, b) {
              //       print("sort a b");
              //
              //       int tahun2 = int.tryParse(a.experience!.split(" ").first) ?? -99;
              //       int tahun1 = int.tryParse(b.experience!.split(" ").first) ?? -99;
              //       return tahun2.compareTo(tahun1);
              //     });
              //   }
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isEmpty &&
              //     controller.selectedLowPriceFilter.value.isNotEmpty &&
              //     controller.selectedHighPriceFilter.value.isNotEmpty) {
              //   result = await controller.getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
              //     selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
              //     selectedLowPrice: controller.selectedLowPriceFilter.value,
              //     selectedHighPrice: controller.selectedHighPriceFilter.value,
              //   );
              //
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isEmpty &&
              //     controller.selectedLowPriceFilter.value.isNotEmpty &&
              //     controller.selectedHighPriceFilter.value.isNotEmpty &&
              //     controller.valueChoose.isNotEmpty) {
              //   result = await controller.getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
              //     selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
              //     selectedLowPrice: controller.selectedLowPriceFilter.value,
              //     selectedHighPrice: controller.selectedHighPriceFilter.value,
              //   );
              //
              //   if (controller.valueChoose.value == controller.sort[0]) {
              //     result.data!.sort((a, b) => a.price!.raw!.toInt().compareTo(b.price!.raw!.toInt()));
              //   } else if (controller.valueChoose.value == controller.sort[1]) {
              //     result.data!.sort((b, a) => b.price!.raw!.toInt().compareTo(a.price!.raw!.toInt()));
              //   } else if (controller.valueChoose.value == controller.sort[2]) {
              //     result.data!.sort((b, a) {
              //       print("sort b a");
              //       int tahun1 = int.tryParse(a.experience!.split(" ").first) ?? -99;
              //       int tahun2 = int.tryParse(b.experience!.split(" ").first) ?? -99;
              //       return tahun1.compareTo(tahun2);
              //     });
              //   } else {
              //     result.data!.sort((a, b) {
              //       print("sort a b");
              //
              //       int tahun2 = int.tryParse(a.experience!.split(" ").first) ?? -99;
              //       int tahun1 = int.tryParse(b.experience!.split(" ").first) ?? -99;
              //       return tahun2.compareTo(tahun1);
              //     });
              //   }
              //
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isNotEmpty) {
              //   result = await controller.getDoctorListBySpecializationAndChooseHospital(
              //       selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
              //       selectedHospitalFilterId: controller.selectedHospitalIdFilter.value);
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isNotEmpty) {
              //   result = await controller.getDoctorListBySpecializationAndChooseHospital(
              //       selectedDoctorFilterId: controller.selectedDoctorIdFilter.value,
              //       selectedHospitalFilterId: controller.selectedHospitalIdFilter.value);
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isEmpty &&
              //     controller.valueChoose.isNotEmpty) {
              //   result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
              //       selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);
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
              //       print("sort b a");
              //       int tahun1 = int.tryParse(a.experience!.split(" ").first) ?? -99;
              //       int tahun2 = int.tryParse(b.experience!.split(" ").first) ?? -99;
              //       return tahun1.compareTo(tahun2);
              //     });
              //   } else {
              //     result.data!.sort((a, b) {
              //       print("sort a b");
              //
              //       int tahun2 = int.tryParse(a.experience!.split(" ").first) ?? -99;
              //       int tahun1 = int.tryParse(b.experience!.split(" ").first) ?? -99;
              //       return tahun2.compareTo(tahun1);
              //     });
              //   }
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isEmpty) {
              //   result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
              //       selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);
              //   controller.listFilteredDoctor.value = result.data!;
              // } else if (controller.selectedDoctorIdFilter.value.isNotEmpty &&
              //     controller.selectedHospitalIdFilter.value.isEmpty &&
              //     controller.valueChoose.isNotEmpty) {
              //   result = await controller.getDoctorListBySpecializationAndAllHospitalFilter(
              //       selectedDoctorFilterId: controller.selectedDoctorIdFilter.value);
              //
              //   if (controller.valueChoose.value == controller.sort[0]) {
              //     result.data!.sort((a, b) => a.price!.raw!.toInt().compareTo(b.price!.raw!.toInt()));
              //   } else if (controller.valueChoose.value == controller.sort[1]) {
              //     result.data!.sort((b, a) => b.price!.raw!.toInt().compareTo(a.price!.raw!.toInt()));
              //   } else if (controller.valueChoose.value == controller.sort[2]) {
              //     result.data!.sort((b, a) {
              //       print("sort b a");
              //       int tahun1 = int.tryParse(a.experience!.split(" ").first) ?? -99;
              //       int tahun2 = int.tryParse(b.experience!.split(" ").first) ?? -99;
              //       return tahun1.compareTo(tahun2);
              //     });
              //   } else {
              //     result.data!.sort((a, b) {
              //       print("sort a b");
              //
              //       int tahun2 = int.tryParse(a.experience!.split(" ").first) ?? -99;
              //       int tahun1 = int.tryParse(b.experience!.split(" ").first) ?? -99;
              //       return tahun2.compareTo(tahun1);
              //     });
              //   }
              //   controller.listFilteredDoctor.value = result.data!;
              // }
            },
            child: Container(
              height: screenWidth * 0.1,
              width: screenWidth * 0.25,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.only(right: 8, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: controller.valueChoose.value == controller.sort[index] ? kDarkBlue : kLightGray)),
              child: Center(
                child: Text(
                  controller.sort[index],
                  style:
                      kSubHeaderStyle.copyWith(fontSize: 8, color: controller.valueChoose.value == controller.sort[index] ? kDarkBlue : kLightGray),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
