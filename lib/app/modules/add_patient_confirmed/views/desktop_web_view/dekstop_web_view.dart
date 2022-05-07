// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/controllers/register_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/register_view.dart';
import 'package:altea/app/modules/spesialis_konsultasi/views/desktop_web_view/desktop_web_view.dart';

class DesktopWebAddPatientConfirmedPage extends GetView<AddPatientController> {
  const DesktopWebAddPatientConfirmedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final controller = Get.find<AddPatientController>();
    final patientDataController = Get.find<PatientDataController>();

    // WEB STEPPER
    const String textStepper1 = "1";
    const String textStepper2 = "2";
    const String textStepper3 = "3";
    controller.currentStep.value += 1;
    controller.isChooseStep3.value = true;
    return ListView(
      children: [
        const SizedBox(
          height: 26,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  height: 14,
                  width: 14,
                  child: InkWell(
                    onTap: () {
                      Get.delete<AddPatientController>();
                      Get.delete<RegisterController>();
                      patientDataController.pageController.jumpToPage(3);
                      controller.isChooseStep1.value = true;
                      controller.isChooseStep2.value = true;
                      controller.isChooseStep3.value = false;

                      controller.gender.value = '';
                      controller.countryId.value = '';
                      controller.familyTypeId.value = '';
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: kBlackColor,
                      size: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 26,
              ),
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
                width: screenWidth * 0.02,
                height: 2,
              ),
              StepperMiddleWidget(
                screenWidth: screenWidth,
                text: textStepper2,
                subtitleText: "Kontak Data",
                isChooseStep: controller.isChooseStep2.value,
                currentStep: controller.currentStep.value,
                width: screenWidth * 0.02,
                height: 2,
              ),
              StepperLastWidget(
                screenWidth: screenWidth,
                text: textStepper3,
                subtitleText: "Verifikasi",
                isChooseStep: controller.isChooseStep3.value,
                currentStep: controller.currentStep.value,
                width: screenWidth * 0.02,
                height: 2,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 17,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
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
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          child: Obx(() => (controller.state == AddPatientState.loading)
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
                              // Get.offAndToNamed(Routes.PATIENT_DATA);
                              Get.delete<AddPatientController>();
                              Get.delete<RegisterController>();
                              // Get.delete<PatientDataController>();

                              // controller
                              //     .refreshThisController(); // refresh add patient controller
                              // patientDataController.pageController.jumpToPage(1);
                              patientDataController.refreshPatientDataAndGoToListPatient.value = true;
                              Get.back();
                              Get.dialog(const PatientDataDialog());

                              // controller.familyTypeId.value = "";
                              // // controller.countryId.value = "";
                              // controller.gender.value = "";
                              // controller.isChooseStep1.value = false;
                              // controller.isChooseStep2.value = false;
                              // controller.isChooseStep3.value = false;

                              // Get.put(
                              //     AddPatientController()); // reset addPatient controller;

                              controller.confirmSelected.value = false;
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
                  color: controller.confirmSelected.value ? kLightGray : kButtonColor)),
        ),
        const SizedBox(
          height: 28,
        ),
      ],
    );
  }
}
