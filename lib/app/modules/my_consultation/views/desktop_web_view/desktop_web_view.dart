// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/settings.dart' as setting;
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/hexColor_toColor.dart';
import '../../../../core/utils/styles.dart';
import '../../../../data/model/list_status_appointment.dart';
import '../../../../data/model/my_consultation.dart';
import '../../../../routes/app_pages.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../home/views/dekstop_web/widget/footer_section_view.dart';
import '../../../home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import '../../../my_consultation_detail/controllers/my_consultation_detail_controller.dart';
import '../../controllers/my_consultation_controller.dart';

class DesktopWebMyConsultationView extends GetView<MyConsultationController> {
  DesktopWebMyConsultationView({Key? key}) : super(key: key);
  final myConsultationDetailController = Get.put(MyConsultationDetailController());
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Scaffold(
      backgroundColor: kBackground,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: FutureBuilder<ListStatusAppointment>(
          future: controller.getListStatusAppointmentWeb(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // controller.addToFilterListFromApi(snapshot.data!);
              // controller.filterListFromApi.value = snapshot.data!.data!;

              //marks build terus, aku taruh di getListStatusAppointmentWeb() //NATHAN - 09092021

              // controller.filterList.addAll(controller.filterListFromApi.map((e) => e.child));

              return Column(
                children: [
                  TopNavigationBarSection(screenWidth: screenWidth),
                  Expanded(
                      child: ListView(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Column(
                          children: [
                            Container(
                              color: kBackground,
                              child: DefaultTabController(
                                  length: controller.listConsultationStatus.length,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: kBackground,
                                            border: Border(
                                                bottom: BorderSide(
                                              color: kLightGray,
                                            ))),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TabBar(
                                                  onTap: (index) {
                                                    controller.selectMyConsultationStatus.value =
                                                        controller.listConsultationStatusEndpoint[controller.tabController.index];
                                                    // print(index);
                                                    //! assing tab selected for filter
                                                    if (index == 0) {
                                                      controller.selectMyConsultationStatus.value = "ON_GOING";
                                                    } else if (index == 1) {
                                                      controller.selectMyConsultationStatus.value = "HISTORY";
                                                    } else if (index == 2) {
                                                      controller.selectMyConsultationStatus.value = "CANCEL";
                                                    }
                                                    controller.selectedFilter.value = "Tampilkan Semua";
                                                    controller.getListStatusAppointmentWeb();
                                                  },
                                                  controller: controller.tabController,
                                                  labelColor: kDarkBlue,
                                                  labelPadding: EdgeInsets.zero,
                                                  unselectedLabelColor: kSubHeaderColor.withOpacity(0.5),
                                                  indicatorColor: kDarkBlue,
                                                  labelStyle: kPoppinsMedium500,
                                                  tabs: List.generate(
                                                    controller.listConsultationStatus.length,
                                                    (index) {
                                                      return Tab(
                                                        text: controller.listConsultationStatus[index],
                                                      );
                                                    },
                                                  )),
                                            ),
                                            const Spacer()
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      Obx(
                                        () => Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (!(controller.selectMyConsultationStatus.value == "HISTORY")) ...[
                                              Expanded(
                                                  child: buildFilterMyConsultionSection(
                                                context,
                                              )),
                                            ],
                                            Expanded(
                                              flex: 3,
                                              child: buildMyConsultationListContentSection(context),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 90,
                      ),
                      FooterSectionWidget(screenWidth: screenWidth)
                    ],
                  ))
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildMyConsultationListContentSection(BuildContext context) {
    final screenWidth = context.width;
    return SizedBox(
      width: screenWidth,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: buildSearchMyConsultation(context),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: kButtonColor,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: DropdownButton(
                      icon: Container(),
                      underline: Container(),
                      hint: Text(
                        "Urutkan",
                        style: kPoppinsMedium500.copyWith(
                          color: kButtonColor,
                        ),
                      ),
                      onChanged: (v) {
                        controller.isDescending.value = v as bool;
                        // print(controller.isDescending.value);
                      },
                      value: controller.isDescending.value,
                      items: [
                        DropdownMenuItem(
                          onTap: () {
                            // controller.isDescending.value = true;
                          },
                          value: true,
                          child: Row(
                            children: [
                              Icon(
                                (controller.isDescending.value) ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                color: kButtonColor,
                                size: 15,
                              ),
                              Text(
                                "  Paling Baru",
                                style: kPoppinsMedium500.copyWith(
                                  color: kButtonColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          onTap: () {
                            // controller.isDescending.value = false;
                          },
                          value: false,
                          child: Row(
                            children: [
                              Icon(
                                (controller.isDescending.value) ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                color: kButtonColor,
                                size: 15,
                              ),
                              Text(
                                "  Paling Lama",
                                style: kPoppinsMedium500.copyWith(
                                  color: kButtonColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          // MyConsultationContent(),
          buildMyConsultationListContent(controller, screenWidth),
        ],
      ),
    );
  }

  Widget buildMyConsultationListContent(MyConsultationController controller, double screenWidth) {
    return Obx(() => FutureBuilder<MyConsultation>(
          future: controller.getDataConsultationWeb(
              controller.selectMyConsultationStatus.value == "ON_GOING" ? "on-going" : controller.selectMyConsultationStatus.value.toLowerCase()),
          builder: (context, snapshot) {
            if (controller.myConsultation.value != null && controller.loadingState.value == MCCLoadingState.none) {
              // final result = snapshot.data!;

              if (controller.myConsultation.value!.status ?? false) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                  ),
                  child:
                      // Column(
                      //     children:
                      //     result.data!.where(
                      //             (d) => (controller.selectedFilter.value.toLowerCase() == d.statusDetail!.label!.toLowerCase() ) ||
                      //             (controller.selectedFilter.value.toLowerCase().contains('semua'))
                      //     ).map((dd) => buildDoctorCardMyConsultation(screenWidth, dd)).toList()
                      // )
                      Obx(
                    () => Column(
                      children: controller.myConsultationList
                          // controller.myConsultation.value!.data!
                          // .where(
                          //   (d) => [
                          //     d.doctor!.name,
                          //     d.orderCode,
                          //   ].contains(controller.searchText.value.toLowerCase()),
                          // )
                          .where(
                            (d) =>
                                (controller.selectedFilter.value.toLowerCase() == d.statusDetail!.label!.toLowerCase()) ||
                                (controller.selectedFilter.value.toLowerCase().contains('semua')),
                          )
                          .map(
                            (dd) => buildDoctorCardMyConsultation(
                              screenWidth,
                              dd,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  // Column(
                  //   children: List.generate(
                  //       result.data!.length,
                  //       (index) => buildDoctorCardMyConsultation(
                  //           screenWidth, result.data![index]),
                  //   ),
                  // ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
                  child: Container(
                    height: 400,
                    width: screenWidth,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: kBackground, boxShadow: [
                      BoxShadow(
                        color: fullBlack.withAlpha(15),
                        offset: const Offset(
                          0.0,
                          3.0,
                        ),
                        blurRadius: 12.0,
                      ),
                    ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset("assets/no_doctor_icon.png"),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Text(
                          "Belum ada konsultasi",
                          style: kPoppinsSemibold600.copyWith(fontSize: 16, color: kDarkBlue),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Buat janji konsultasi dengan dokter spesialis AlteaCare",
                          style: kPoppinsRegular400.copyWith(fontSize: 13, color: kSubHeaderColor.withOpacity(0.5), letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text((controller.myConsultation.value != null).toString()),
                    Text(controller.loadingState.value.toString()),
                  ],
                ),
              );
            }
          },
        ));
  }

  Widget buildDoctorCardMyConsultation(double screenWidth, DatumMyConsultation data) {
    final myConsultationDetailController = Get.put(MyConsultationDetailController());
    final homeController = Get.find<HomeController>();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          height: 200,
          width: screenWidth,
          decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(22), boxShadow: [
            BoxShadow(
              color: fullBlack.withAlpha(15),
              offset: const Offset(
                0.0,
                3.0,
              ),
              blurRadius: 12.0,
            ),
          ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Order ID: ",
                            style: kPoppinsRegular400.copyWith(color: kTextHintColor, fontSize: 13, letterSpacing: 0.5),
                          ),
                          TextSpan(
                            text: data.orderCode,
                            style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: HexColor(data.statusDetail!.bgColor!),
                      ),
                      child: Center(
                        child: Text(
                          data.statusDetail!.label!,
                          style: kPoppinsSemibold600.copyWith(color: HexColor(data.statusDetail!.textColor!), fontSize: 12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: searchBarBorderColor.withOpacity(0.7),
              ),
              // Divider(
              //   height: 1,
              //   color: searchBarBorderColor.withOpacity(0.7),
              // ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 115,
                        width: 115,
                        child: data.doctor!.photo!.formats!.thumbnail != null
                            ? Image.network(addCDNforLoadImage(data.doctor!.photo!.formats!.thumbnail!), fit: BoxFit.cover)
                            : Image.asset("assets/account-info@3x.png", fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          data.doctor!.name ?? "No data",
                          style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        Text(
                          data.doctor!.specialist!.name ?? "No data",
                          style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: Image.asset("calendar_icon.png", color: kTextHintColor),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              DateFormat("EEEE, dd/MM/yyyy", "id").format(DateTime.parse(data.schedule!.date!.toString())),
                              style: kPoppinsRegular400.copyWith(color: kBlackColor, fontSize: 12),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: Image.asset(
                                "time_icon.png",
                                color: kTextHintColor,
                              ),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              "${data.schedule!.timeStart} - ${data.schedule!.timeEnd}",
                              style: kPoppinsRegular400.copyWith(color: kBlackColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Container(
                            height: 37,
                            width: 37,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: kTextHintColor),
                            child: InkWell(
                              onTap: () {
                                if (data.transaction == null) {
                                  final patientController = Get.put(PatientConfirmationController());
                                  patientController.dataAppointment.value = {
                                    "data": {"appointment_id": data.id}
                                  };
                                  if (data.status == setting.newOrder) {
                                    Get.toNamed("/onboard-call?orderId=${data.id}");
                                  } else if (data.status == setting.waitingForPayment) {
                                    Get.toNamed("/choose-payment?orderId=${data.id}", arguments: data.id);
                                  }

                                  // Get.toNamed(
                                  //   Routes.CHOOSE_PAYMENT,
                                  //   arguments: data.id,
                                  // );
                                } else {
                                  if (homeController.menus.isNotEmpty) {
                                    homeController.menus.value = <String>[];
                                    homeController.menus.add("Konsultasi Saya");
                                  } else {
                                    homeController.menus.add("Konsultasi Saya");
                                  }

                                  homeController.menus.add("Order ID: ${data.orderCode}");

                                  // Get.toNamed(Routes.MY_CONSULTATION_DETAIL);
                                  myConsultationDetailController.orderId.value = data.id.toString();
                                  Get.toNamed("${Routes.MY_CONSULTATION_DETAIL}?orderId=${data.id}");
                                }
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: kBackground,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget buildSearchMyConsultation(BuildContext context) {
    return TypeAheadField(
        hideOnLoading: true,
        textFieldConfiguration: TextFieldConfiguration(
          style: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 16),
          // onChanged: (String s) {
          //   controller.searchText.value = s.toLowerCase();
          //   print(s);
          // },
          decoration: InputDecoration(
            prefix: const SizedBox(
              width: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(26),
              borderSide: BorderSide(
                color: searchBarBorderColor.withOpacity(0.7),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(26),
              borderSide: BorderSide(
                color: searchBarBorderColor.withOpacity(0.1),
              ),
            ),
            // focusedBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(26),
            //     borderSide: BorderSide(color: kButtonColor)),
            hintText: "Search…",
            hintStyle: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 15),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.search,
                size: 22,
              ),
            ),
            isDense: true,
          ),
        ),
        suggestionsBoxVerticalOffset: 0,
        suggestionsBoxDecoration:
            const SuggestionsBoxDecoration(borderRadius: BorderRadius.all(Radius.circular(26)), elevation: 2, color: kBackground),
        suggestionsCallback: (pattern) async {
          controller.searchText.value = pattern;
          // final result = await searchSpecialistController.searchDoctor(pattern);
          // return result.data!.doctor!.map((e) => e);
          if (controller.myConsultationList
                  .where(
                    (d) =>
                        d.doctor!.name!.contains(controller.searchText.value.toLowerCase()) ||
                        d.orderCode!.toLowerCase().contains(controller.searchText.value.toLowerCase()),
                  )
                  .isEmpty ||
              controller.searchText.value.isEmpty) {
            final List data = [];
            return data.map((e) => e);
          } else {
            // print(controller.searchText.value);

            // print(controller.myConsultationList
            // .where(
            //   (d) => d.doctor!.name!.contains(controller.searchText.value.toLowerCase()),
            // )
            // .length
            // .toString());
            return controller.myConsultationList
                .where(
                  (d) =>
                      d.doctor!.name!.contains(controller.searchText.value.toLowerCase()) ||
                      d.orderCode!.toLowerCase().contains(controller.searchText.value.toLowerCase()),
                )
                // .where(
                //   (d) =>
                //       (controller.selectedFilter.value.toLowerCase() == d.statusDetail!.label!.toLowerCase()) ||
                //       (controller.selectedFilter.value.toLowerCase().contains('semua')),
                // )
                .map((dd) => dd)
                .toList();
          }
        },
        noItemsFoundBuilder: (context) {
          return SizedBox(
            height: 80,
            child: Center(child: Text("Tidak menemukan dokter", style: kPoppinsMedium500.copyWith(color: hinTextColor))),
          );
        },
        itemBuilder: (_, suggestion) {
          return InkWell(
            onTap: () {
              myConsultationDetailController.orderId.value = (suggestion as DatumMyConsultation).id.toString();

              if (homeController.menus.isNotEmpty) {
                homeController.menus.value = <String>[];
                homeController.menus.add("Konsultasi Saya");
              } else {
                homeController.menus.add("Konsultasi Saya");
              }

              homeController.menus.add("Order ID: ${(suggestion as DatumMyConsultation).orderCode}");

              Get.toNamed("${Routes.MY_CONSULTATION_DETAIL}?orderId=${(suggestion as DatumMyConsultation).id}");
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    height: Get.width * 0.05,
                    width: Get.width * 0.05,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage((suggestion as DatumMyConsultation).doctor!.photo!.url!),
                    )),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (suggestion as DatumMyConsultation).doctor!.name!,
                          style: kPoppinsMedium500.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        Text((suggestion as DatumMyConsultation).orderCode!),
                      ],
                    ),
                  )
                ],
              ),

              // ListTile(
              //   leading: SizedBox(
              //     width: 60,
              //     height: 60,
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(12),
              //       child: Image.network(suggestion!.photo == null
              //           ? "http://cdn.onlinewebfonts.com/svg/img_148071.png"
              //           : suggestion.photo!.formats!.thumbnail!),
              //     ),
              //   ),
              //   title: Text(
              //     suggestion.name ?? "No data name",
              //     style: kPoppinsMedium500.copyWith(color: hinTextColor),
              //   ),
              //   subtitle: Text(suggestion.specialization!.name ?? "No Data",
              //       style: kPoppinsSemibold600.copyWith(
              //           color: kMidnightBlue, fontSize: 12)),
              // ),
            ),
          );
        },
        onSuggestionSelected: (suggestion) async {});
  }

  Widget buildFilterMyConsultionSection(BuildContext context) {
    final screenWidth = context.width;

    // controller.filterList.value = ["Tampilkan Semua"];
    // for (final item in controller.filterListFromApi) {
    //   if (controller.selectMyConsultationStatus.value == item.parent) {
    //     for (final data in item.child!) {
    //       controller.filterList.add(data.detail!.label!);
    //     }
    //   }
    // }

    //yg di atas itu aku taruh di addToFilterListFromApi, setelah getListStatusAppointmentWeb() jalan
    return Container(
      padding: const EdgeInsets.all(24),
      // height: screenWidth * 0.25,
      decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(22), boxShadow: [
        BoxShadow(
          color: fullBlack.withAlpha(15),
          offset: const Offset(
            0.0,
            3.0,
          ),
          blurRadius: 12.0,
        ),
      ]),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.tune_rounded,
                color: kTextHintColor,
              ),
              const SizedBox(
                width: 11,
              ),
              Text(
                "Filter Pencarian",
                style: kSubHeaderStyle,
              ),
            ],
          ),
          const SizedBox(
            height: 21,
          ),
          // Divider(
          //   height: 0.5,
          //   color: searchBarBorderColor.withOpacity(0.7),
          // ),
          ExpansionTile(
            childrenPadding: const EdgeInsets.only(bottom: 10),
            key: controller.keyTile,
            initiallyExpanded: controller.isFilterExpanded.value,
            tilePadding: EdgeInsets.zero,
            // iconColor: kButtonColor,
            title: Text(
              "Status",
              style: kPoppinsMedium500.copyWith(
                color: kBlackColor,
              ),
            ),
            children: List.generate(
              controller.filterList.length,
              (index) {
                return Obx(() => InkWell(
                      onTap: () {
                        controller.selectedFilter.value = controller.filterList[index];
                        // print(controller.selectedFilter.value);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Icon(
                              controller.selectedFilter.value == controller.filterList[index]
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_off_rounded,
                              color: controller.selectedFilter.value == controller.filterList[index] ? kButtonColor : kLightGray,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(controller.filterList[index],
                                style: kPoppinsMedium500.copyWith(
                                    color: controller.selectedFilter.value == controller.filterList[index] ? kButtonColor : kLightGray))
                          ],
                        ),
                      ),
                    ));

                // RadioListTile<String>(
                //     activeColor: kButtonColor,
                //     value: controller.filterList[index],
                //     groupValue: controller.selectedFilter.value,
                //     title: Text(controller.filterList[index],
                //         style: kPoppinsMedium500.copyWith(
                //             color: controller.selectedFilter.value ==
                //                     controller.filterList[index]
                //                 ? kButtonColor
                //                 : kLightGray)),
                //     onChanged: (String? value) async {});
              },
            ),
          )
        ],
      ),
    );
  }
}
