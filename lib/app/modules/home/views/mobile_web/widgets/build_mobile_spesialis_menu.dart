// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/data/model/doctors.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/spesialis_card.dart';
import '../../../../../data/model/doctor_category_specialist.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../doctor/controllers/doctor_controller.dart';
import '../../../controllers/home_controller.dart';

Column buildMobileSpesialisMenu(BuildContext context) {
  DoctorController doctorController = Get.find<DoctorController>();
  HomeController controller = Get.find<HomeController>();

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Konsultasi Spesialis',
            style: kHomeSubHeaderStyle,
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () {
                if (GetPlatform.isWeb) {
                  Get.toNamed('/doctor');
                } else {
                  controller.currentIdx.value = 1;
                }
              },
              child: Text(
                'Lihat Semua',
                style: kHomeSmallText,
              ),
            ),
          )
        ],
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 3.2,
        child: FutureBuilder<DoctorSpecialistCategory>(
            future: doctorController.getDoctorsPopularCategory(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DoctorSpecialistCategory? popularCategories;
                popularCategories = snapshot.data;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularCategories?.data?.length,
                  itemBuilder: (context, idx) {
                    return SpesialisCard(
                      onTap: () async {
                        if (GetPlatform.isWeb) {
                          doctorController.selectedSpesialis.value = doctorController.spesialisMenus[idx];
                          doctorController.selectedSpesialis.refresh();

                          controller.menus.value = [];

                          if (controller.menus.contains("Dokter Spesialis")) {
                            controller.menus.add("Spesialis ${doctorController.selectedSpesialis.value.name}");
                          } else {
                            controller.menus.add("Dokter Spesialis");
                            controller.menus.add("Spesialis ${doctorController.selectedSpesialis.value.name}");
                          }

                          doctorController.selectedDoctorFilter.value = doctorController.selectedSpesialis.value.name!;

                          // set ID specialist
                          doctorController.selectedDoctorIdFilter.value = doctorController.selectedSpesialis.value.specializationId!;

                          final Doctors result = await doctorController.getDoctorListBySpecializationAndAllHospitalFilter(
                              selectedDoctorFilterId: doctorController.selectedDoctorIdFilter.value);

                          doctorController.listFilteredDoctor.value = result.data!;

                          // print(
                          // 'specialization id -> ${doctorController.selectedSpesialis.value}');
                          Get.toNamed(Routes.DOCTOR_SPESIALIS, arguments: doctorController.selectedSpesialis.value);
                        } else {
                          Get.toNamed(Routes.DOCTOR_SPESIALIS, arguments: popularCategories!.data![idx].specializationId);
                        }
                      },
                      id: "",
                      width: MediaQuery.of(context).size.width / 3.2,
                      height: MediaQuery.of(context).size.width / 6,
                      img: popularCategories?.data?[idx].icon?.formats?.thumbnail ?? ' ',
                      imgWidth: MediaQuery.of(context).size.width / 10,
                      text: popularCategories?.data?[idx].name ?? ' ',
                      isShadow: true,
                    );
                  },
                  // children: popularCategories.data
                  // .map((e) => SpesialisCard(
                  //
                  //     ))
                  // .toList(),
                );
              } else {
                return CupertinoActivityIndicator();
              }
            }),
      )
    ],
  );
}
