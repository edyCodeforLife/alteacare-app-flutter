// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../data/model/doctor_category_specialist.dart';
import '../../../../data/model/doctors.dart';
import '../../../../data/model/search_doctor.dart';
import '../../../../routes/app_pages.dart';
import '../../../doctor/controllers/doctor_controller.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../home/views/dekstop_web/widget/footer_section_view.dart';
import '../../../home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import '../../../spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import '../../controllers/search_specialist_controller.dart';

class DesktopWebViewSearchDoctorSpesialis extends GetView<SearchSpecialistController> {
  const DesktopWebViewSearchDoctorSpesialis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    DoctorController doctorController = Get.find<DoctorController>();
    HomeController homeController = Get.find<HomeController>();

    ScreenSize.recalculate(context);

    return GestureDetector(
      onTap: () {
        return FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Obx(() => LoadingOverlay(
            isLoading: doctorController.isLoading.value,
            child: Scaffold(
              body: ListView(
                children: [
                  TopNavigationBarSection(screenWidth: screenWidth),
                  Container(
                    margin: const EdgeInsets.only(top: 65, bottom: 99),
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "Apakah ada gejala yang mengganggu ",
                              style: kPoppinsRegular400.copyWith(fontSize: 18, color: kButtonColor.withOpacity(0.5))),
                          TextSpan(text: "Anda?", style: kPoppinsMedium500.copyWith(fontSize: 18, color: kButtonColor)),
                        ])),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: buildSearchBarMaterial(screenWidth),
                            ),
                            const Spacer()
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Konsultasi Spesialis",
                          style: kPoppinsMedium500.copyWith(fontSize: 20, color: grayTitleColor),
                        ),
                        InkWell(
                          onTap: () {
                            homeController.isSelectedTabBeranda.value = false;
                            homeController.isSelectedTabDokter.value = true;
                            homeController.isSelectedTabKonsultasi.value = false;
                            Get.toNamed("/doctor");
                          },
                          child: Text(
                            "Lihat Semua",
                            style: kPoppinsSemibold600.copyWith(fontSize: 15, color: kDarkBlue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Container(
                    height: 182,
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: FutureBuilder(
                        future: controller.getDoctorsPopularCategory(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final DoctorSpecialistCategory result = snapshot.data! as DoctorSpecialistCategory;

                            if (result.status!) {
                              controller.spesialisMenus.value = result.data!;
                              return ListView.builder(
                                itemCount: 6,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 12.wb,
                                    width: 12.wb,
                                    margin: const EdgeInsets.only(right: 23),
                                    decoration: BoxDecoration(color: kWhiteGray, borderRadius: BorderRadius.circular(22)),
                                    child: InkWell(
                                      onTap: () async {
                                        doctorController.selectedSpesialis.value = controller.spesialisMenus[index];
                                        doctorController.selectedSpesialis.refresh();

                                        if (homeController.menus.isNotEmpty) {
                                          homeController.menus.removeAt(0);
                                          homeController.menus.value = [];
                                        }

                                        if (homeController.menus.contains("Dokter Spesialis")) {
                                          homeController.menus.add("Spesialis ${doctorController.selectedSpesialis.value.name}");
                                        } else {
                                          homeController.menus.add("Dokter Spesialis");
                                          homeController.menus.add("Spesialis ${doctorController.selectedSpesialis.value.name}");
                                        }

                                        doctorController.selectedDoctorFilter.value = doctorController.selectedSpesialis.value.name!;

                                        // set ID specialist
                                        doctorController.selectedDoctorIdFilter.value = doctorController.selectedSpesialis.value.specializationId!;

                                        // Load data dokter
                                        final Doctors result = await doctorController.getDoctorListBySpecializationAndAllHospitalFilter(
                                            selectedDoctorFilterId: doctorController.selectedDoctorIdFilter.value);

                                        doctorController.listFilteredDoctor.value = result.data!;

                                        homeController.isSelectedTabBeranda.value = false;
                                        homeController.isSelectedTabDokter.value = true;
                                        homeController.isSelectedTabKonsultasi.value = false;

                                        Get.toNamed(Routes.DOCTOR_SPESIALIS, arguments: doctorController.selectedSpesialis.value);
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: 77,
                                              height: 77,
                                              child: FadeInImage.assetNetwork(
                                                placeholder: "assets/loadingPlaceholder.gif",
                                                image: controller.spesialisMenus[index].icon!.formats!.thumbnail != null
                                                    ? addCDNforLoadImage(controller.spesialisMenus[index].icon!.formats!.thumbnail!)
                                                    : "http://cdn.onlinewebfonts.com/svg/img_148071.png",
                                                fit: BoxFit.cover,
                                              )),
                                          const SizedBox(
                                            height: 18,
                                          ),
                                          Text(
                                            controller.spesialisMenus[index].name!,
                                            style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 14),
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Text("Failed to load", style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 10)),
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 82,
                  ),
                  FooterSectionWidget(screenWidth: screenWidth)
                ],
              ),
            ),
          )),
    );
  }

  Widget buildSearchBarMaterial(double screenWidth) {
    final spesialisController = Get.put(SpesialisKonsultasiController());
    final searchSpecialistController = Get.put(SearchSpecialistController());

    return TypeAheadField<Doctor?>(
        // hideOnLoading: true,
        textFieldConfiguration: TextFieldConfiguration(
          style: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 14),
          decoration: InputDecoration(
            prefix: const SizedBox(
              width: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: BorderSide(color: grayBorderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: BorderSide(color: kButtonColor)),
            hintText: "Tulis keluhan atau nama dokter",
            hintStyle: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 14),
            suffixIcon: const Icon(Icons.search),
            isDense: true,
          ),
        ),
        suggestionsBoxVerticalOffset: 0,
        suggestionsBoxDecoration:
            const SuggestionsBoxDecoration(borderRadius: BorderRadius.all(Radius.circular(26)), elevation: 2, color: kBackground),
        suggestionsCallback: (pattern) async {
          final result = await searchSpecialistController.searchDoctor(pattern);

          return result.data!.doctor!.map((e) => e);
        },
        noItemsFoundBuilder: (context) {
          return SizedBox(
            height: 80,
            child: Center(child: Text("Tidak menemukan dokter", style: kPoppinsMedium500.copyWith(color: hinTextColor))),
          );
        },
        itemBuilder: (_, Doctor? suggestion) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(suggestion!.photo == null
                      ? "http://cdn.onlinewebfonts.com/svg/img_148071.png"
                      : addCDNforLoadImage(suggestion.photo!.formats!.thumbnail!)),
                ),
              ),
              title: Text(
                suggestion.name ?? "No data name",
                style: kPoppinsMedium500.copyWith(color: hinTextColor),
              ),
              subtitle: Text(suggestion.specialization!.name ?? "No Data", style: kPoppinsSemibold600.copyWith(color: kMidnightBlue, fontSize: 12)),
            ),
          );
        },
        onSuggestionSelected: (Doctor? suggestion) async {
          spesialisController.checkDoctorNoSchedule(doctorId: suggestion!.doctorId!);
          spesialisController.doctorInfo.value = suggestion;
          Get.toNamed("${Routes.SPESIALIS_KONSULTASI}?doctorId=${suggestion.doctorId}");
        });
  }
}
