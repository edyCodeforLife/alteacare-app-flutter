// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/hexColor_toColor.dart';
import 'package:altea/app/core/utils/settings.dart' as setting;
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/my_consultation.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/my_consultation/controllers/my_consultation_controller.dart';
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import '../../../../routes/app_pages.dart';
import '../../../my_consultation_detail/controllers/my_consultation_detail_controller.dart';

class MobileWebMyConsultationView extends GetView<MyConsultationController> {
  MobileWebMyConsultationView({Key? key}) : super(key: key);
  final MyConsultationDetailController myConsultationDetailController = Get.put(MyConsultationDetailController());

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyConsultationController());
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        return FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: scaffoldKey,
        backgroundColor: kBackground,
        appBar: MobileWebMainAppbar(scaffoldKey: scaffoldKey),
        drawer: MobileWebHamburgerMenu(),
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            DefaultTabController(
              length: controller.listConsultationStatus.length,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: kLightGray,
                    ))),
                    child: TabBar(
                        onTap: (index) {
                          controller.selectMyConsultationStatus.value = controller.listConsultationStatusEndpoint[controller.tabController.index];
                          controller.addToFilterListFromApiNoAPI();
                        },
                        controller: controller.tabController,
                        labelColor: kDarkBlue,
                        labelPadding: EdgeInsets.zero,
                        unselectedLabelColor: kLightGray,
                        indicatorColor: kDarkBlue,
                        labelStyle: kPoppinsMedium500.copyWith(fontSize: 10),
                        tabs: List.generate(
                          controller.listConsultationStatus.length,
                          (index) {
                            return Tab(
                              text: controller.listConsultationStatus[index],
                            );
                          },
                        )),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - MobileWebMainAppbar(scaffoldKey: scaffoldKey).preferredSize.height - 40,
                    width: screenWidth,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        controller.listConsultationStatus.length,
                        (index) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 2, child: buildSearchMyConsultation(context)),
                                      // buildSearchMyConsultation(context)
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(child: buildFilterMyConsultation(context))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 21,
                                ),
                                buildMyConsultationListContent(controller, screenWidth),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                              myConsultationDetailController,
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
    //
    // return Obx(() => FutureBuilder<MyConsultation>(
    //   future: controller.getDataConsultationWeb(controller.selectMyConsultationStatus.value == "ON_GOING"
    //       ? "on-going"
    //       : controller.selectMyConsultationStatus.value.toLowerCase()),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           final result = snapshot.data!;
    //
    //           if (result.status ?? false) {
    //             return Padding(
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 25.0,
    //               ),
    //               child: Column(
    //                 children: controller.myConsultationList
    //                     .where(
    //                       (d) =>
    //                           (controller.selectedFilter.value.toLowerCase() == d.statusDetail!.label!.toLowerCase()) ||
    //                           (controller.selectedFilter.value.toLowerCase().contains('semua')),
    //                     )
    //                     .map(
    //                       (dd) => buildDoctorCardMyConsultation(
    //                         myConsultationDetailController,
    //                         screenWidth,
    //                         dd,
    //                       ),
    //                     )
    //                     .toList(),
    //               ),
    //             );
    //           } else {
    //             return Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
    //               child: Container(
    //                 height: 268,
    //                 width: screenWidth,
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(12),
    //                     color: kBackground,
    //                     boxShadow: [BoxShadow(blurRadius: 12, color: kLightGray, offset: const Offset(0, 3))]),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     SizedBox(
    //                       height: 65,
    //                       width: 65,
    //                       child: Image.asset("assets/no_doctor_icon.png"),
    //                     ),
    //                     const SizedBox(
    //                       height: 32,
    //                     ),
    //                     Text(
    //                       "Belum ada konsultasi",
    //                       style: kPoppinsMedium500.copyWith(fontSize: 13, color: kDarkBlue),
    //                     ),
    //                     const SizedBox(
    //                       height: 8,
    //                     ),
    //                     Text(
    //                       "Buat janji konsultasi dengan dokter spesialis AlteaCare",
    //                       style: kPoppinsRegular400.copyWith(fontSize: 10, color: kLightGray),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           }
    //         } else {
    //           return const Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         }
    //       },
    //     ));
  }

  Widget buildDoctorCardMyConsultation(MyConsultationDetailController controller, double screenWidth, DatumMyConsultation data) {
    return InkWell(
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
          controller.orderId.value = data.id.toString();
          Get.toNamed("${Routes.MY_CONSULTATION_DETAIL}?orderId=${data.id.toString()}");
        }
        // if (data.transaction == null &&
        //     ![
        //       setting.canceled,
        //       setting.canceledByGP,
        //       setting.canceledBySystem,
        //       setting.canceledByUser,
        //     ].contains(
        //       data.status.toString(),
        //     )) {
        //   final patientController = Get.put(PatientConfirmationController());
        //   patientController.dataAppointment.value = {
        //     "data": {"appointment_id": data.id}
        //   };
        //   Get.toNamed("/onboard-call?orderId=${data.id}");
        //   // Get.toNamed(
        //   //   Routes.CHOOSE_PAYMENT,
        //   //   arguments: data.id,
        //   // );
        // } else {
        //   controller.orderId.value = data.id.toString();
        //   Get.toNamed("${Routes.MY_CONSULTATION_DETAIL}?orderId=${data.id.toString()}");
        // }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            height: 165,
            width: screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kLightGray),
              color: kBackground,
              // boxShadow: [
              //   BoxShadow(
              //       blurRadius: 12, color: kLightGray, offset: const Offset(0, 3))
              // ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Order ID: ",
                              style: kPoppinsRegular400.copyWith(color: kTextHintColor, fontSize: 10),
                            ),
                            TextSpan(
                              text: data.orderCode,
                              style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 10),
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
                            style: kPoppinsSemibold600.copyWith(color: HexColor(data.statusDetail!.textColor!), fontSize: 9),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                  color: kLightGray,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 52,
                          width: 52,
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/loadingPlaceholder.gif",
                            image: data.doctor!.photo!.formats!.thumbnail ?? "assets/account-info@3x.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.doctor!.name ?? "No data",
                            style: kPoppinsSemibold600.copyWith(color: kBlackColor),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Text(
                            data.doctor!.specialist!.name ?? "No data",
                            style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 10),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: kTextHintColor),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: kBackground,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                  color: kLightGray,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 14,
                        width: 14,
                        child: Image.asset("calendar_icon.png", color: kTextHintColor),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        DateFormat("EEEE, dd/MM/yyyy", "id").format(DateTime.parse(data.schedule!.date!.toString())),
                        style: kPoppinsRegular400.copyWith(color: kBlackColor, fontSize: 10),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        height: 14,
                        width: 14,
                        child: Image.asset(
                          "time_icon.png",
                          color: kTextHintColor,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "${data.schedule!.timeStart} - ${data.schedule!.timeEnd}",
                        style: kPoppinsRegular400.copyWith(color: kBlackColor, fontSize: 10),
                      ),
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
      ),
    );
  }

  Widget buildSearchMyConsultation(BuildContext context) {
    return TypeAheadField(
        hideOnLoading: true,
        textFieldConfiguration: TextFieldConfiguration(
          style: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 10),
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
            hintStyle: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 10),
            suffixIcon: const Icon(
              Icons.search,
              size: 22,
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

              if (suggestion.transaction == null) {
                final patientController = Get.put(PatientConfirmationController());
                patientController.dataAppointment.value = {
                  "data": {"appointment_id": suggestion.id}
                };
                if (suggestion.status == setting.newOrder) {
                  Get.toNamed("/onboard-call?orderId=${suggestion.id}");
                } else if (suggestion.status == setting.waitingForPayment) {
                  Get.toNamed("/choose-payment?orderId=${suggestion.id}", arguments: suggestion.id);
                }

                // Get.toNamed(
                //   Routes.CHOOSE_PAYMENT,
                //   arguments: data.id,
                // );
              } else {
                // controller.orderId.value = suggestion.id.toString();
                Get.toNamed("${Routes.MY_CONSULTATION_DETAIL}?orderId=${suggestion.id.toString()}");
              }

              // myConsultationDetailController.orderId.value = (suggestion as DatumMyConsultation).id.toString();
              // Get.toNamed(Routes.MY_CONSULTATION_DETAIL);

              FocusManager.instance.primaryFocus?.unfocus();
              controller.searchText.value = '';
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
  // Widget buildSearchMyConsultation(BuildContext context) {
  //   return TypeAheadField(
  //       hideOnLoading: true,
  //       textFieldConfiguration: TextFieldConfiguration(
  //         style: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 10),
  //         decoration: InputDecoration(
  //           prefix: const SizedBox(
  //             width: 10,
  //           ),
  //           border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(26), borderSide: BorderSide(color: grayBorderColor)),
  //           focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(26), borderSide: BorderSide(color: kButtonColor)),
  //           hintText: "Search…",
  //           hintStyle: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 10),
  //           suffixIcon: const Icon(Icons.search),
  //           isDense: true,
  //         ),
  //       ),
  //       suggestionsBoxVerticalOffset: 0,
  //       suggestionsBoxDecoration: const SuggestionsBoxDecoration(
  //           borderRadius: BorderRadius.all(Radius.circular(26)), elevation: 2, color: kBackground),
  //       suggestionsCallback: (pattern) async {
  //         // final result = await searchSpecialistController.searchDoctor(pattern);
  //         // return result.data!.doctor!.map((e) => e);

  //         final List data = [];
  //         return data.map((e) => e);
  //       },
  //       noItemsFoundBuilder: (context) {
  //         return SizedBox(
  //           height: 80,
  //           child:
  //               Center(child: Text("Tidak menemukan dokter", style: kPoppinsMedium500.copyWith(color: hinTextColor))),
  //         );
  //       },
  //       itemBuilder: (_, suggestion) {
  //         return Container(margin: const EdgeInsets.only(bottom: 8), child: Container()

  //             // ListTile(
  //             //   leading: SizedBox(
  //             //     width: 60,
  //             //     height: 60,
  //             //     child: ClipRRect(
  //             //       borderRadius: BorderRadius.circular(12),
  //             //       child: Image.network(suggestion!.photo == null
  //             //           ? "http://cdn.onlinewebfonts.com/svg/img_148071.png"
  //             //           : suggestion.photo!.formats!.thumbnail!),
  //             //     ),
  //             //   ),
  //             //   title: Text(
  //             //     suggestion.name ?? "No data name",
  //             //     style: kPoppinsMedium500.copyWith(color: hinTextColor),
  //             //   ),
  //             //   subtitle: Text(suggestion.specialization!.name ?? "No Data",
  //             //       style: kPoppinsSemibold600.copyWith(
  //             //           color: kMidnightBlue, fontSize: 12)),
  //             // ),
  //             );
  //       },
  //       onSuggestionSelected: (suggestion) async {});
  // }

  Widget buildFilterMyConsultation(BuildContext context) {
    final screenWidth = context.width;
    return Container(
      height: screenWidth * 0.1,
      width: screenWidth * 0.23,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: kLightGray)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Get.bottomSheet(buildFilterMyConsultationSlideUpPanel(context));
        },
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
              style: kSubHeaderStyle.copyWith(fontSize: screenWidth * 0.03),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterMyConsultationSlideUpPanel(BuildContext context) {
    final screenWidth = context.width;
    return Container(
      decoration: const BoxDecoration(color: kBackground, borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: kBlackColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
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
                    "Status",
                    style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Obx(
                    () => Wrap(
                      children: controller.filterList
                          .map((e) => InkWell(
                                onTap: () {
                                  controller.selectedFilter.value = e;
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8, right: 8),
                                  decoration: BoxDecoration(
                                      color: controller.selectedFilter.value.toLowerCase() == e.toLowerCase() ? kButtonColor : Colors.white,
                                      border: Border.all(color: kButtonColor),
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  child: Text(
                                    e.toString(),
                                    style: kPoppinsMedium500.copyWith(
                                      color: controller.selectedFilter.value.toLowerCase() == e.toLowerCase() ? Colors.white : kButtonColor,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  Container(
                    height: 1,
                    color: kLightGray,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  Text(
                    "Urutkan",
                    style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Wrap(children: [
                    Obx(
                      () => InkWell(
                        onTap: () {
                          controller.isDescending.value = true;
                          controller.webSortByDateWithBool(true);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8, right: 8),
                          decoration: BoxDecoration(
                              color: (controller.isDescending.value) ? kButtonColor : Colors.white,
                              border: Border.all(color: kButtonColor),
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: Text(
                            "Paling lama".toString(),
                            style: kPoppinsMedium500.copyWith(
                              color: (controller.isDescending.value) ? Colors.white : kButtonColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(() => InkWell(
                          onTap: () {
                            controller.isDescending.value = false;
                            controller.webSortByDateWithBool(false);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8, right: 8),
                            decoration: BoxDecoration(
                                color: (!controller.isDescending.value) ? kButtonColor : Colors.white,
                                border: Border.all(color: kButtonColor),
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            child: Text(
                              "Paling baru".toString(),
                              style: kPoppinsMedium500.copyWith(
                                color: (!controller.isDescending.value) ? Colors.white : kButtonColor,
                              ),
                            ),
                          ),
                        )),
                  ]),
                  Column(
                    children: [
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
                    ],
                  ),
                  // Text(
                  //   "Harga",
                  //   style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 14),
                  // ),
                  const SizedBox(
                    height: 13,
                  ),
                  // Text(
                  //   "Urutkan",
                  //   style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 14),
                  // ),
                  const SizedBox(
                    height: 13,
                  ),
                  // const SizedBox(
                  //   height: 37,
                  // ),
                  // CustomFlatButton(width: screenWidth * 0.8, text: "Terapkan", onPressed: () {}, color: kButtonColor),
                  // const SizedBox(
                  //   height: 28,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
