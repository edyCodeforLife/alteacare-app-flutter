// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/widgets/custom_flat_button.dart';
import '../../../../routes/app_pages.dart';
import '../../../add_patient/controllers/add_patient_controller.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../home/views/mobile_web/mobile_web_hamburger_menu.dart';
import '../../../register/presentation/modules/register/views/custom_simple_dialog.dart';
import '../../../register/presentation/modules/register/views/register_view.dart';

class MobileWebAddPatientConfirmedPage extends GetView<AddPatientController> {
  MobileWebAddPatientConfirmedPage({Key? key, required this.doctorIdFromParam}) : super(key: key);
  final String doctorIdFromParam;

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final screenWidth = MediaQuery.of(context).size.width;

    // WEB STEPPER
    const String textStepper1 = "1";
    const String textStepper2 = "2";
    const String textStepper3 = "3";

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kBackground,
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
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
            // height: screenWidth * 0.2,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: kTextFieldColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 28, left: 18, right: 18),
                child: Column(
                  children: [
                    Text(
                      "Pastikan data yang di isi sudah benar. Hubungi customer service AlteaCare untuk perubahan data.",
                      style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 10),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Nama",
                                    style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Text(
                                        ":",
                                        style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${controller.firstName.value} ${controller.lastName.value}",
                                          style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Umur",
                                    style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Text(
                                        ":",
                                        style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${controller.age.value} Tahun",
                                          style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Status",
                                    style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Text(
                                        ":",
                                        style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller.familyRelation.value,
                                          style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Jenis Kelamin",
                                    style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Text(
                                        ":",
                                        style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller.gender.value == "MALE" ? "Laki-laki" : "Perempuan",
                                          style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Tempat lahir",
                                    style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Text(
                                        ":",
                                        style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${controller.birthPlace.value}, ${controller.birthCountry.value}",
                                          style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Tanggal lahir",
                                    style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Text(
                                        ":",
                                        style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller.birthDate.value,
                                          style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Alamat",
                                    style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ":",
                                        style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller.alamat.value,
                                          style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Obx(
              () => (controller.state == AddPatientState.loading)
                  ? const Text("Mohon tunggu . . .")
                  : CustomFlatButton(
                      width: screenWidth,
                      text: "Konfirmasi",
                      onPressed: controller.confirmSelected.value
                          ? null
                          : () async {
                              controller.confirmSelected.value = true;

                              final Map<String, dynamic> dataPatient = {
                                "family_relation_type": controller.familyTypeId.value,
                                "first_name": controller.firstName.value,
                                "last_name": controller.lastName.value,
                                "birth_date": "${DateTime.parse(controller.birthDate.value)}",
                                "birth_country": controller.countryId.value,
                                "birth_place": controller.birthPlace.value,
                                "gender": controller.gender.value,
                                "nationality": controller.countryId.value,
                                "card_id": controller.cardId.value,
                                "address_id": controller.addressId.value
                              };

                              final result = await controller.addFamilyWeb(homeController.accessTokens.value, dataPatient);

                              if (result["status"] == true) {
                                final resultUpdateNewPatientAddress = await controller.updateNewPatientData(
                                    homeController.accessTokens.value, result["data"]["id"].toString(), result["data"]["address_id"].toString());
                                if (resultUpdateNewPatientAddress["status"] == true) {
                                  controller.confirmSelected.value = false;
                                  controller.refreshThisController();
                                  Get.back();
                                  Get.back();
                                  Get.back();
                                  Get.offAndToNamed("${Routes.PATIENT_DATA}?doctorId=$doctorIdFromParam");
                                  // controller.familyTypeId.value = "";
                                  // controller.countryId.value = "";
                                  // controller.gender.value = "";
                                  // Get.put(AddPatientController()); // reset addPatient controller;
                                } else {
                                  controller.confirmSelected.value = false;

                                  showDialog(
                                      context: context,
                                      builder: (context) => CustomSimpleDialog(
                                          icon: SizedBox(
                                            width: screenWidth * 0.1,
                                            child: Image.asset("assets/failed_icon.png"),
                                          ),
                                          onPressed: () {
                                            Get.back();
                                          },
                                          title: 'Add new patient failed',
                                          buttonTxt: 'Mengerti',
                                          subtitle: result["message"].toString()));
                                }
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) => CustomSimpleDialog(
                                        icon: SizedBox(
                                          width: screenWidth * 0.1,
                                          child: Image.asset("assets/failed_icon.png"),
                                        ),
                                        onPressed: () {
                                          Get.back();
                                        },
                                        title: 'Add new patient failed',
                                        buttonTxt: 'Mengerti',
                                        subtitle: result["message"].toString()));
                              }
                            },
                      color: kButtonColor,
                    ),
            ),
          ),
          const SizedBox(
            height: 28,
          ),
        ],
      ),
    );
  }
}
