// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/doctors.dart';
import 'package:altea/app/modules/doctor/controllers/doctor_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

class DoctorSpesialisSectionWidget extends GetView<HomeController> {
  DoctorSpesialisSectionWidget({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;
  final DoctorController doctorController = Get.find<DoctorController>();

  @override
  Widget build(BuildContext context) {
    ScreenSize.recalculate(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.wb),
      child: SizedBox(
        // width: screenWidth * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.hb,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dokter Spesialis",
                  style: kPoppinsSemibold600.copyWith(
                    color: kBlackColor.withOpacity(0.8),
                    fontSize: 1.5.wb,
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.isSelectedTabBeranda.value = false;
                    controller.isSelectedTabDokter.value = true;
                    controller.isSelectedTabKonsultasi.value = false;
                    Get.toNamed(
                      Routes.DOCTOR,
                    );
                  },
                  child: Text(
                    "Lihat Semua",
                    style: kTextInputStyle.copyWith(wordSpacing: 0.8, color: kDarkBlue, fontSize: 1.wb, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 1.hb,
            ),
            SizedBox(
              width: 120.wb,
              height: 29.hb,
              child: ListView.builder(
                itemCount: controller.doctorCategory.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 17.wb,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => (controller.doctorCategory.isEmpty || doctorController.spesialisMenus.isEmpty)
                              ? const SizedBox()
                              : MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onEnter: (event) => {doctorController.onEntered(isHovered: true, index: index, specialistType: 0)},
                                  onExit: (event) => doctorController.onEntered(isHovered: false, index: index, specialistType: 0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      doctorController.selectedSpesialis.value = controller.doctorCategory[index];

                                      // doctorController.selectedSpesialis.value =
                                      //     doctorController.spesialisMenus[index];
                                      doctorController.selectedSpesialis.refresh();

                                      controller.menus.value = [];

                                      if (controller.menus.contains("Dokter Spesialis")) {
                                        controller.menus.add("Spesialis ${doctorController.selectedSpesialis.value.name}");
                                      } else {
                                        controller.menus.add("Dokter Spesialis");
                                        controller.menus.add("Spesialis ${doctorController.selectedSpesialis.value.name}");
                                      }
                                      doctorController.selectedDoctorFilter.value = doctorController.selectedSpesialis.value.name!;
                                      // print("habis klik di depan, ${doctorController.selectedDoctorFilter.value}");

                                      // set ID specialist
                                      doctorController.selectedDoctorIdFilter.value = doctorController.selectedSpesialis.value.specializationId!;

                                      // Load data dokter
                                      final Doctors result = await doctorController.getDoctorListBySpecializationAndAllHospitalFilter(
                                          selectedDoctorFilterId: doctorController.selectedDoctorIdFilter.value);

                                      doctorController.listFilteredDoctor.value = result.data!;

                                      controller.isSelectedTabBeranda.value = false;
                                      controller.isSelectedTabDokter.value = true;
                                      controller.isSelectedTabKonsultasi.value = false;

                                      Get.toNamed(Routes.DOCTOR_SPESIALIS, arguments: doctorController.selectedSpesialis.value);
                                    },
                                    child: Container(
                                      width: 16.wb,
                                      height: 29.hb,
                                      decoration: BoxDecoration(
                                          // color: Colors.red,
                                          borderRadius: BorderRadius.circular(22),
                                          color: kBackground,
                                          border: Border.all(
                                              width: 1.5,
                                              color: doctorController.selectedSpesialis.value == doctorController.spesialisMenus[index]
                                                  ? kButtonColor
                                                  : kWhiteGray)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            width: 5.wb,
                                            child: FadeInImage.assetNetwork(
                                              placeholder: "assets/loadingPlaceholder.gif",
                                              image: controller.doctorCategory[index].icon!.formats!.thumbnail != null
                                                  ? addCDNforLoadImage(controller.doctorCategory[index].icon!.formats!.thumbnail!)
                                                  : "http://cdn.onlinewebfonts.com/svg/img_148071.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            // color: Colors.red,
                                            width: 15.wb,
                                            child: Text(
                                              controller.doctorCategory[index].name!,
                                              style: kTextInputStyle.copyWith(
                                                  wordSpacing: 0.5, color: kBlackColor.withOpacity(0.5), fontSize: 1.wb, fontWeight: FontWeight.bold),
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
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
    );
  }
}
