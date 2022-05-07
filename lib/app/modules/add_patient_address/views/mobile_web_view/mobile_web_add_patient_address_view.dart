// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/list_address.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/add_patient_address/views/mobile_web_view/widgets/mobile_web_tambah_alamat_section.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/register_view.dart';
import 'package:altea/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

class MobileWebAddPatientAddressView extends GetView<AddPatientController> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final String doctorIdFromParam;
  MobileWebAddPatientAddressView({required this.doctorIdFromParam});
  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final screenWidth = MediaQuery.of(context).size.width;

    // WEB STEPPER
    const String textStepper1 = "1";
    const String textStepper2 = "2";
    const String textStepper3 = "3";

    return WillPopScope(
      onWillPop: () async {
        if (controller.isTambahAlamatSelected.value) {
          controller.isTambahAlamatSelected.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: kBackground,
        appBar: MobileWebMainAppbar(scaffoldKey: scaffoldKey),
        drawer: MobileWebHamburgerMenu(),
        body: ListView(
          children: [
            const SizedBox(
              height: 26,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tambah Data Pasien",
                    style: kPoppinsMedium500.copyWith(fontSize: 17, color: kBlackColor),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Isi Data pasien yang akan melakukan konsultasi.",
                    style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            // ? STEPPER SECTION
            Container(
              width: screenWidth * 0.5,
              height: screenWidth * 0.2,
              // padding: EdgeInsets.all(16),
              // color: Colors.pink,
              child: Row(
                children: [
                  StepperFirstWidget(
                    screenWidth: screenWidth,
                    text: textStepper1,
                    subtitleText: "Personal Data",
                    isChooseStep: controller.isChooseStep1.value,
                    currentStep: controller.currentStep.value,
                    width: screenWidth * 0.1,
                    height: 2,
                  ),
                  StepperMiddleWidget(
                    screenWidth: screenWidth,
                    text: textStepper2,
                    subtitleText: "Kontak Data",
                    isChooseStep: controller.isChooseStep2.value,
                    currentStep: controller.currentStep.value,
                    width: screenWidth * 0.1,
                    height: 2,
                  ),
                  StepperLastWidget(
                    screenWidth: screenWidth,
                    text: textStepper3,
                    subtitleText: "Verifikasi",
                    isChooseStep: controller.isChooseStep3.value,
                    currentStep: controller.currentStep.value,
                    width: screenWidth * 0.1,
                    height: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 17,
            ),

            Obx(() => controller.isTambahAlamatSelected.value
                ? MobileWebTambahAlamatSection(
                    doctorIdFromParam: doctorIdFromParam,
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      children: [
                        FutureBuilder<ListAddress>(
                            future: controller.getListAddress(homeController.accessTokens.value),
                            builder: (_, snapshot) {
                              if (snapshot.hasData) {
                                final ListAddress result = snapshot.data!;

                                if (result.status!) {
                                  return Column(
                                    children: List.generate(result.data!.address!.length, (index) {
                                      final dataAddress = result.data!.address![index];
                                      String? alamat =
                                          "${dataAddress.street!}, Blok RT/RW${dataAddress.rtRw!}, Kel. ${dataAddress.subDistrict!.name}, Kec.${dataAddress.district!.name} ${dataAddress.city!.name} ${dataAddress.province!.name} ${dataAddress.subDistrict!.postalCode}";

                                      return InkWell(
                                        onTap: () {
                                          controller.selectedAddressCard.value = index;
                                          controller.addressId.value = dataAddress.id!;
                                          controller.alamat.value = alamat;
                                        },
                                        child: ListAddressCardWeb(
                                          alamat: alamat,
                                          index: index,
                                        ),
                                      );
                                    }),
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      "No Data",
                                      style: kPoppinsMedium500.copyWith(color: kBlackColor),
                                    ),
                                  );
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                        const SizedBox(
                          height: 115,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: CustomFlatButton(
                              width: screenWidth,
                              text: "Lanjut",
                              onPressed: () {
                                controller.currentStep.value += 1;
                                controller.isChooseStep3.value = true;

                                Get.toNamed("${Routes.ADD_PATIENT_CONFIRMED}?doctorId=$doctorIdFromParam");
                              },
                              color: kButtonColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: CustomFlatButton(
                              borderColor: kButtonColor,
                              width: screenWidth,
                              text: "Tambah Alamat",
                              onPressed: () {
                                controller.isTambahAlamatSelected.value = true;
                              },
                              color: kBackground),
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                      ],
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}

class ListAddressCardWeb extends StatefulWidget {
  const ListAddressCardWeb({
    Key? key,
    required this.index,
    required this.alamat,
  }) : super(key: key);

  final int index;
  final String alamat;

  @override
  _ListAddressCardWebState createState() => _ListAddressCardWebState();
}

class _ListAddressCardWebState extends State<ListAddressCardWeb> {
  bool isExpanded = false;
  final controller = Get.find<AddPatientController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
              color: kBackground,
              border: Border.all(color: controller.selectedAddressCard.value == widget.index ? kDarkBlue : kBackground),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(blurRadius: 12, offset: const Offset(0, 3), color: kLightGray)]),
          child: isExpanded
              ? buildExpandPatientCard(
                  alamat: widget.alamat,
                )
              : buildPatientCard(
                  alamat: widget.alamat,
                ),
          // Container(
          //     padding: const EdgeInsets.all(8),
          //     margin: const EdgeInsets.only(bottom: 8),
          //     decoration: BoxDecoration(
          //         color: kBackground,
          //         borderRadius: BorderRadius.circular(12),
          //         boxShadow: [
          //           BoxShadow(
          //               blurRadius: 12,
          //               offset: const Offset(0, 3),
          //               color: kLightGray)
          //         ]),
          //     child: Center(
          //       child: Theme(
          //         data: Theme.of(context).copyWith(
          //             dividerColor: Colors.transparent),
          //         child: ExpansionTile(
          //           key: controller.keyTile,
          //           initiallyExpanded:
          //               controller.isExpanded.value,
          //           childrenPadding:
          //               const EdgeInsets.symmetric(
          //                   horizontal: 16),

          //           children: [

          //           ],
          //         ),
          //       ),
          //     )),
        ));
  }

  Widget buildPatientCard({required String alamat}) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            alamat,
            style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        IconButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 14,
            ))
      ],
    );
  }

  Widget buildExpandPatientCard({
    required String alamat,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                alamat,
                style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
              ),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 14,
                ))
          ],
        ),
        const SizedBox(
          width: 16,
        ),
      ],
    );
  }
}
