// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/patient_data_model.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:altea/app/modules/patient_data/views/mobile_web_view/mobile_web_view.dart';

class DesktopWebPatientDataPage extends StatelessWidget {
  const DesktopWebPatientDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final homeController = Get.find<HomeController>();
    final controller = Get.find<PatientDataController>();
    // final addPatientController = Get.find<AddPatientController>();
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 26,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Data Pasien",
                  style: kPoppinsMedium500.copyWith(fontSize: 17, color: kBlackColor),
                ),
                Text(
                  "Pilih pasien yang akan melakukan konsultasi.",
                  style: kPoppinsRegular400.copyWith(fontSize: 10, color: kLightGray),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          FutureBuilder<PatientData>(
              future: controller.getPatientList(homeController.accessTokens.value),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  final PatientData result = snapshot.data!;

                  if (result.status!) {
                    return Column(
                      children: List.generate(result.data!.patient.length, (index) {
                        final dataPatient = result.data!.patient[index];
                        String? alamat =
                            "${dataPatient.street!}, Blok RT/RW${dataPatient.rtRw!}, Kel. ${dataPatient.subDistrict!.name}, Kec.${dataPatient.district!.name} ${dataPatient.city!.name} ${dataPatient.province!.name} ${dataPatient.subDistrict!.postalCode}";
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                          child: InkWell(
                            onTap: () {
                              controller.selectedPatient.value = index;
                              controller.selectedPatientData.value = dataPatient;
                              // print(
                              //     "data patient -> ${controller.selectedPatientData.value.firstName}");
                            },
                            child: PatientCardWeb(
                              dataPatient: dataPatient,
                              alamat: alamat,
                              index: index,
                            ),
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
            height: 21,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 1,
                  width: screenWidth * 0.08,
                  color: kLightGray,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  "Belum ada daftar keluarga?",
                  style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 10),
                ),
                const SizedBox(
                  width: 4,
                ),
                Container(
                  height: 1,
                  width: screenWidth * 0.08,
                  color: kLightGray,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 21,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    color: kBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(blurRadius: 12, offset: const Offset(0, 3), color: kLightGray)]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tambah Data Pasien",
                      style: kPoppinsSemibold600.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                    ),
                    IconButton(
                        onPressed: () {
                          final addPatientcontroller = Get.put(AddPatientController());

                          controller.pageController.jumpToPage(2);
                        },
                        icon: Icon(
                          Icons.add_circle_outlined,
                          color: kButtonColor,
                        ))
                  ],
                )),
          ),
          const SizedBox(
            height: 28,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Obx(() => CustomFlatButton(
                width: screenWidth,
                text: "Pilih",
                onPressed: controller.selectedPatient.value == -1
                    ? null
                    : () async {
                        controller.pageController.jumpToPage(5);
                      },
                color: controller.selectedPatient.value == -1 ? kLightGray : kButtonColor)),
          ),
          const SizedBox(
            height: 28,
          ),
        ],
      ),
    );
  }
}
