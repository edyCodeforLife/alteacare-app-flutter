// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../data/model/doctor_category_specialist.dart';
import '../../../../data/model/doctors.dart';
import '../../../../data/model/search_doctor.dart';
import '../../../../routes/app_pages.dart';
import '../../../doctor/controllers/doctor_controller.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../home/views/mobile_web/mobile_web_hamburger_menu.dart';
import '../../../home/views/mobile_web/widgets/footer_mobile_web_view.dart';
import '../../../spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import '../../controllers/search_specialist_controller.dart';

class MobileWebViewSearchDoctorSpesialis extends GetView<SearchSpecialistController> {
  const MobileWebViewSearchDoctorSpesialis({Key? key}) : super(key: key);

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    DoctorController doctorController = Get.find<DoctorController>();
    HomeController homeController = Get.find<HomeController>();
    final spesialisController = Get.put(SpesialisKonsultasiController());

    return GestureDetector(
      onTap: () {
        return FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: kBackground,
        appBar: MobileWebMainAppbar(
          scaffoldKey: scaffoldKey,
        ),
        drawer: MobileWebHamburgerMenu(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "Apakah ada gejala yang mengganggu ",
                          style: kPoppinsRegular400.copyWith(fontSize: 12, color: kButtonColor.withOpacity(0.5))),
                      TextSpan(text: "Anda?", style: kPoppinsMedium500.copyWith(fontSize: 12, color: kButtonColor)),
                    ])),
                    const SizedBox(
                      height: 4,
                    ),
                    buildSearchBarMaterial(screenWidth, context),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Konsultasi Spesialis",
                      style: kPoppinsMedium500.copyWith(fontSize: 14, color: grayTitleColor),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed("/doctor");
                      },
                      child: Text(
                        "Lihat Semua",
                        style: kPoppinsSemibold600.copyWith(fontSize: 10, color: kDarkBlue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Container(
                height: 86,
                width: screenWidth,
                padding: const EdgeInsets.only(left: 25),
                child: FutureBuilder(
                    future: controller.getDoctorsPopularCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final DoctorSpecialistCategory result = snapshot.data! as DoctorSpecialistCategory;

                        if (result.status!) {
                          controller.spesialisMenus.value = result.data!;
                          return ListView.builder(
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 86,
                                width: 86,
                                margin: const EdgeInsets.only(right: 9),
                                decoration: BoxDecoration(color: kWhiteGray, borderRadius: BorderRadius.circular(18)),
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
                                    // doctorController.selectedSpesialis.value = doctorController.spesialisMenus[index];
                                    // doctorController.selectedSpesialis.refresh();

                                    // if (homeController.menus.contains("Dokter Spesialis")) {
                                    //   homeController.menus.add("Spesialis ${doctorController.selectedSpesialis.value.name}");
                                    // } else {
                                    //   homeController.menus.add("Dokter Spesialis");
                                    //   homeController.menus.add("Spesialis ${doctorController.selectedSpesialis.value.name}");
                                    // }

                                    // doctorController.selectedDoctorFilter.value = doctorController.selectedSpesialis.value.name!;

                                    // // set ID specialist
                                    // doctorController.selectedDoctorIdFilter.value = doctorController.selectedSpesialis.value.specializationId!;
                                    // // Load data dokter
                                    // final Doctors result = await doctorController.getDoctorListBySpecializationAndAllHospitalFilter(
                                    //     selectedDoctorFilterId: doctorController.selectedDoctorIdFilter.value);

                                    // doctorController.listFilteredDoctor.value = result.data!;

                                    // Get.toNamed(Routes.DOCTOR_SPESIALIS, arguments: doctorController.selectedSpesialis.value);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: 34,
                                          height: 34,
                                          child: FadeInImage.assetNetwork(
                                            placeholder: "assets/loadingPlaceholder.gif",
                                            image: controller.spesialisMenus[index].icon!.formats!.thumbnail ??
                                                "http://cdn.onlinewebfonts.com/svg/img_148071.png",
                                            fit: BoxFit.cover,
                                          )),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        controller.spesialisMenus[index].name!,
                                        style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 10),
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
                height: 245,
              ),
              FooterMobileWebView(screenWidth: screenWidth)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchBarMaterial(double screenWidth, BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    final spesialisController = Get.find<SpesialisKonsultasiController>();
    return Container(
      constraints: BoxConstraints.expand(width: screenWidth, height: 37),
      width: screenWidth,
      child: TypeAheadFormField<Doctor?>(
          hideSuggestionsOnKeyboardHide: false,
          hideOnLoading: true,
          textFieldConfiguration: TextFieldConfiguration(
            controller: textEditingController,
            style: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 11),
            decoration: InputDecoration(
              prefix: const SizedBox(
                width: 10,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: BorderSide(color: grayBorderColor)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: BorderSide(color: kButtonColor)),
              hintText: "Tulis keluhan atau nama dokter",
              hintStyle: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 11),
              suffixIcon: const Icon(Icons.search),
              isDense: true,
            ),
          ),
          suggestionsBoxVerticalOffset: 0,
          suggestionsBoxDecoration:
              const SuggestionsBoxDecoration(borderRadius: BorderRadius.all(Radius.circular(26)), elevation: 2, color: kBackground),
          suggestionsCallback: (pattern) async {
            final result = await controller.searchDoctor(pattern);
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      suggestion!.photo == null
                          ? "http://cdn.onlinewebfonts.com/svg/img_148071.png"
                          : addCDNforLoadImage(suggestion.photo!.formats!.thumbnail!),
                    ),
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
          }),
    );
  }

  // Widget buildSearchBarMaterial(double screenWidth) {
  //   return Container(
  //     height: 100,
  //     width: screenWidth,
  //     child: FloatingSearchBar(
  //       hint: "Tulis keluhan atau nama dokter",
  //       scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
  //       transitionDuration: const Duration(milliseconds: 800),
  //       transitionCurve: Curves.easeInOut,
  //       physics: const BouncingScrollPhysics(),
  //       width: 500,
  //       debounceDelay: const Duration(milliseconds: 500),
  //       onQueryChanged: (query) {
  //         // Call your model, bloc, controller here.
  //       },
  //       // Specify a custom transition to be used for
  //       // animating between opened and closed stated.
  //       transition: CircularFloatingSearchBarTransition(),
  //       builder: (context, transition) {
  //         return ClipRRect(
  //           borderRadius: BorderRadius.circular(8),
  //           child: Material(
  //             color: Colors.white,
  //             elevation: 4.0,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: Colors.accents.map((color) {
  //                 return Container(height: 112, color: color);
  //               }).toList(),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
