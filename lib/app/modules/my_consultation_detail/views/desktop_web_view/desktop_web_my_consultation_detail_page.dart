// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:clipboard/clipboard.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_count_down.dart';

// Project imports:
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/call_screen/controllers/call_screen_controller.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/hexColor_toColor.dart';
import '../../../../core/utils/settings.dart';
import '../../../../core/utils/styles.dart';
import '../../../../routes/app_pages.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../home/views/dekstop_web/widget/footer_section_view.dart';
import '../../../home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import '../../../patient_confirmation/controllers/patient_confirmation_controller.dart';
import '../../controllers/my_consultation_detail_controller.dart';
import 'local_widget/personal_data_widget_my_consultation.dart';
import 'local_widget/transaction_data_widget_my_consultation.dart';

class DesktopWebMyConsultationDetailPage extends GetView<MyConsultationDetailController> {
  const DesktopWebMyConsultationDetailPage({Key? key, required this.orderIdFromParam}) : super(key: key);
  final String orderIdFromParam;
  @override
  Widget build(BuildContext context) {
    final CallScreenController callScreenController = Get.put(CallScreenController(orderIdFromParam: orderIdFromParam));
    final screenWidth = context.width;
    final homeController = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: kBackground,
      body: FutureBuilder<Map<String, dynamic>>(
        future: controller.getDataConsultationDetailWeb(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            // print("snapshot -> ${snapshot.data!["data"]}");
            controller.data = snapshot.data!["data"] as Map<String, dynamic>;
            // final dataDetail = controller.dataMyConsultationDetail.value;

            // print("status -> ${controller.data["status_detail"]["code"]}");
            // print("ID -> ${controller.data["id"]}");
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
                      child: Row(
                        children: [
                          BreadCrumb.builder(
                            itemCount: homeController.menus.length,
                            builder: (index) {
                              // print("menus ->${controller.menus[index]}");
                              // print(
                              //     "selection dokter -> ${controller.spesialisMenus[index].name!}");
                              return BreadCrumbItem(
                                content: Text(
                                  homeController.menus[index],
                                  style: kSubHeaderStyle.copyWith(
                                      fontSize: 15,
                                      color:
                                          (homeController.menus[index] == ("Order ID: ${controller.data["order_code"]}")) ? kDarkBlue : kLightGray),
                                ),
                                onTap: index < homeController.menus.length
                                    ? () {
                                        if (index == 0) {
                                          homeController.menus.removeAt(index + 1);
                                          Get.offNamed(Routes.MY_CONSULTATION);
                                        }
                                      }
                                    : null,
                                // textColor: ,
                              );
                            },
                            divider: const Text(" / "),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color:
                                  // HexColor(dataDetail.statusDetail!.bgColor!),
                                  HexColor("${controller.data["status_detail"]["bg_color"]}"),
                            ),
                            child: Center(
                              child: Text(
                                controller.data["status_detail"]["label"].toString(),
                                // controller.dataMyConsultationDetail.value
                                //     .statusDetail!.label!,
                                style:
                                    kPoppinsSemibold600.copyWith(color: HexColor("${controller.data["status_detail"]["text_color"]}"), fontSize: 12),
                              ),
                            ),
                          ),
                          // Container(
                          //   padding: const EdgeInsets.all(8),
                          //   height: 35,
                          //   decoration: BoxDecoration(
                          //     color: kDarkBlue.withOpacity(0.2),
                          //     borderRadius: BorderRadius.circular(4),
                          //   ),
                          //   child: Center(
                          //     child: Text(
                          //       "Temui Dokter",
                          //       style: kPoppinsSemibold600.copyWith(
                          //           fontSize: 12, color: kDarkBlue),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 54,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 160,
                              width: 160,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: controller.data["doctor"]["photo"]["formats"]["thumbnail"] != null
                                    ? Image.network(addCDNforLoadImage(controller.data["doctor"]["photo"]["formats"]["thumbnail"].toString()),
                                        fit: BoxFit.cover)
                                    : Image.asset("assets/account-info@3x.png", fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  controller.data["doctor"]["name"].toString(),
                                  // controller.dataMyConsultationDetail.value
                                  //     .doctor!.name!,
                                  style: kPoppinsSemibold600.copyWith(
                                    color: kBlackColor,
                                    fontSize: 27,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  // "Sp. ${dataDetail.doctor!.specialist!.name!}",
                                  "Sp. ${controller.data["doctor"]["specialist"]["name"]}",
                                  style: kPoppinsSemibold600.copyWith(
                                    color: kDarkBlue,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Divider(
                                  height: 1,
                                  color: kTextHintColor,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: Image.asset(
                                        "assets/calendar_icon.png",
                                        color: kTextHintColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      // DateFormat("EEEE, dd/MM/yyyy", "id")
                                      //     .format(dataDetail.schedule!.date!),
                                      DateFormat("EEEE, dd/MM/yyyy", "id").format(DateTime.parse(controller.data["schedule"]["date"].toString())),
                                      style: kPoppinsRegular400.copyWith(fontSize: 12, color: kTextHintColor),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: Image.asset("assets/time_icon.png", color: kTextHintColor),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      // "${dataDetail.schedule!.timeStart} - ${dataDetail.schedule!.timeEnd}",
                                      "${controller.data["schedule"]["time_start"]} - ${controller.data["schedule"]["time_end"]}",
                                      style: kPoppinsRegular400.copyWith(fontSize: 12, color: kTextHintColor),
                                    ),
                                    const SizedBox(
                                      width: 48,
                                    ),
                                    if (controller.data["status"] == meetSpecialist)
                                      TextButton(
                                        onPressed: () {},
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            bottom: 5, // Space between underline and text
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: kDarkBlue,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "+ Add to Calendar",
                                            style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kDarkBlue),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 180,
                          ),
                          if (controller.data["status"] == meetSpecialist)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 205,
                                height: 40,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      callScreenController.callId.value = "new";
                                      callScreenController.orderId.value = controller.data["id"].toString();
                                      callScreenController.initCallDoctor.value = true;
                                      try {
                                        // print("${controller.data["patient"]["name"]}");
                                      } catch (e) {
                                        await controller.getDataConsultationDetailWeb02();
                                      }
                                      if (GetPlatform.isMobile) {
                                        Get.toNamed(
                                          "/call-mobile?orderId=$orderIdFromParam",
                                          arguments: {"patientName": "${controller.data["patient"]["name"]}", "callType": "doctor"},
                                        );
                                      } else {
                                        Get.toNamed("${Routes.CALL_SCREEN_DESKTOP}?orderId=$orderIdFromParam",
                                            arguments: {"patientName": "${controller.data["patient"]["name"]}", "callType": "calldoc"});
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: kButtonColor,
                                      elevation: 0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 14,
                                          child: Image.asset(
                                            "assets/on_cam_icon.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Temui Dokter",
                                          style: kPoppinsMedium500.copyWith(
                                            fontSize: 13,
                                            color: kBackground,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          //  else if (controller.data["transaction"]["detail"]
                          //         ["code"] ==
                          //     "credit_card") ...[
                          //   ClipRRect(
                          //     borderRadius: BorderRadius.circular(10),
                          //     child: SizedBox(
                          //       width: 205,
                          //       height: 40,
                          //       child: ElevatedButton(
                          //           onPressed: () {
                          //             launch(controller.data["transaction"]
                          //                     ["redirect_url"]
                          //                 .toString());
                          //           },
                          //           style: ElevatedButton.styleFrom(
                          //             primary: kButtonColor,
                          //             elevation: 0,
                          //           ),
                          //           child: Text(
                          //             "Bayar",
                          //             style: kPoppinsMedium500.copyWith(
                          //                 fontSize: 13, color: kBackground),
                          //           )),
                          //     ),
                          //   )
                          // ],
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 96,
                    ),

                    // ! check consultation status
                    if (controller.data["status"] == meetSpecialist || controller.data["status"] == paid || controller.data["status"] == completed)
                      buildPageViewSection(screenWidth)
                    else if (controller.data['transaction'] == null)
                      Container()
                    else
                      buildPaymentSection(screenWidth, controller.data["transaction"] as Map<String, dynamic>, controller.data["fees"] as List,
                          controller.data["created"].toString(), controller.data["id"].toString()),
                    // buildPageViewSection(screenWidth),
                    FooterSectionWidget(screenWidth: screenWidth),
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
    );
  }

  Widget buildPaymentSection(double screenWidth, Map<String, dynamic>? dataTransaction, List fees, String created, String appointmentId) {
    // print("data transaction -> $dataTransaction");
    // print("data fees -> $fees");

    final dateTime = DateTime.tryParse(dataTransaction!["expiredAt"].toString()) ?? DateTime.now();
    final timeStamp = dateTime.toUtc().microsecondsSinceEpoch;
    final date = DateTime.fromMicrosecondsSinceEpoch(timeStamp);

    final endTime = DateTime.parse((DateTime.parse(dataTransaction["expiredAt"].toString())).toIso8601String())
        .difference(DateTime.parse(DateTime.now().toIso8601String()))
        .inSeconds;
    return dataTransaction == null
        ? Container()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: SizedBox(
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status Pembayaran",
                    style: kPoppinsMedium500.copyWith(
                      color: kDarkBlue,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: screenWidth,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: kBackground,
                                boxShadow: [
                                  BoxShadow(
                                    color: fullBlack.withAlpha(15),
                                    offset: const Offset(
                                      0.0,
                                      3.0,
                                    ),
                                    blurRadius: 12.0,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Batas Akhir Pembayaran:",
                                    style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 10),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat("EEEE, dd MMM yyyy", "id")
                                            .format(DateTime.parse((DateTime.parse(dataTransaction["expiredAt"].toString())).toIso8601String())),
                                        style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 13),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        DateFormat.Hm().format(date),
                                        style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Countdown(
                                    seconds: endTime,
                                    build: (BuildContext context, double time) {
                                      final remainingTime = Duration(seconds: time.toInt());
                                      final timeRes = controller.printDuration(remainingTime);
                                      return Text(
                                        timeRes,
                                        style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 22),
                                      );
                                    },
                                    interval: const Duration(milliseconds: 100),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Obx(
                              () => controller.isExpanded.value
                                  ? paymentTypeSectionExpanded(
                                      appointmentId,
                                      dataTransaction,
                                      fees,
                                    )
                                  : paymentTypeSection(dataTransaction, appointmentId),
                            ),
                            const SizedBox(
                              height: 70,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 23,
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 26),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: kBackground,
                            boxShadow: [
                              BoxShadow(
                                color: fullBlack.withAlpha(15),
                                offset: const Offset(
                                  0.0,
                                  3.0,
                                ),
                                blurRadius: 12.0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Panduan Pembayaran",
                                  style: kPoppinsMedium500.copyWith(
                                    fontSize: 12,
                                    color: kSubHeaderColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                Container(
                                  height: screenWidth * 0.18,
                                  child: FutureBuilder<Map<String, dynamic>>(
                                      future: controller.getPaymentGuides(dataTransaction["detail"]["code"].toString()),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final result = snapshot.data!["data"] as List;
                                          return ListView.builder(
                                            itemCount: result.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  controller.isExpandedTile.value ? controller.shrinkTile() : controller.expandTile();
                                                },
                                                child: buildExpansionTile(result[index] as Map<String, dynamic>),
                                              );
                                            },
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  Widget buildExpansionTile(Map<String, dynamic> data) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      key: controller.keyTile,
      initiallyExpanded: controller.isExpanded.value,
      title: Text(
        data["title"].toString(),
        style: kPoppinsSemibold600.copyWith(fontSize: 14, color: kMidnightBlue),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: HtmlWidget(
            data["text"].toString(),
            customStylesBuilder: (e) {
              return {
                "color": "0xFFD8D8D8",
                "font-size": "10px",
                "font-weight": "normal",
              };
            },
          ),
        )
      ],
    );
  }

  Widget paymentTypeSectionExpanded(String appointmentId, Map<String, dynamic> dataTransaction, List fees) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: kBackground,
        boxShadow: [
          BoxShadow(
            color: fullBlack.withAlpha(15),
            offset: const Offset(
              0.0,
              3.0,
            ),
            blurRadius: 12.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  height: 51,
                  width: 51,
                  child: Image.asset(
                    dataTransaction["detail"]["code"].toString() == "credit_card" ? "assets/credit_card_icon.png" : "assets/bca_icon.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${dataTransaction["detail"]["name"]}",
                          style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "${dataTransaction["detail"]["description"]}",
                            style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Container(
                      color: kLightGray,
                      height: 40,
                      width: 1,
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    TextButton(
                        onPressed: () {
                          Get.put(PatientConfirmationController());
                          Get.toNamed("${Routes.CHOOSE_PAYMENT}?orderId=$appointmentId", arguments: appointmentId);
                        },
                        child: Text(
                          "Change",
                          style: kPoppinsSemibold600.copyWith(
                            fontSize: 12,
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (dataTransaction["detail"]["code"].toString() == "bca_va") ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nomor Virtual Account",
                              style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 10),
                            ),
                            Text(
                              "${dataTransaction["va_number"]}",
                              style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 13),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            FlutterClipboard.copy(
                              "${dataTransaction["va_number"]}",
                            );

                            Fluttertoast.showToast(
                              msg: "Va number copied",
                              backgroundColor: kGreenColor.withOpacity(0.2),
                              textColor: kGreenColor,
                              webShowClose: true,
                              timeInSecForIosWeb: 8,
                              fontSize: 13,
                              gravity: ToastGravity.TOP,
                              webPosition: 'center',
                              toastLength: Toast.LENGTH_LONG,
                              webBgColor: '#F8FCF5',
                            );
                          },
                          child: Text(
                            "Salin",
                            style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 11),
                          ),
                        ),
                      ],
                    )
                  ],
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Pembayaran",
                            style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 10),
                          ),
                          Text(
                            NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(dataTransaction["total"]),
                            style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 13),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          FlutterClipboard.copy(
                            "${dataTransaction["total"]}",
                          );

                          Fluttertoast.showToast(
                            msg: "Total price copied",
                            backgroundColor: kGreenColor.withOpacity(0.2),
                            textColor: kGreenColor,
                            webShowClose: true,
                            timeInSecForIosWeb: 8,
                            fontSize: 13,
                            gravity: ToastGravity.TOP,
                            webPosition: 'center',
                            toastLength: Toast.LENGTH_LONG,
                            webBgColor: '#F8FCF5',
                          );
                        },
                        child: Text(
                          "Salin Jumlah",
                          style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Konsultasi Dokter:",
                style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 12),
              ),
              Text(
                NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(fees[0]["amount"]),
                style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(
            height: 11,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Biaya Layanan:",
                style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 12),
              ),
              Text(
                NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(fees[1]["amount"]),
                style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
              ),
            ],
          ),
          if (fees.length > 2)
            Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Diskon:",
                      style: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(fees[2]['amount']),
                      style: kPoppinsRegular400.copyWith(fontSize: 12, color: kTextHintColor),
                      softWrap: true,
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(
            height: 11,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ! pajak belum ada
              Text(
                "Pajak:",
                style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 12),
              ),
              Text(
                "0 %",
                style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(
            height: 11,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: kPoppinsSemibold600.copyWith(color: kTextHintColor, fontSize: 10),
              ),
              Text(
                NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(dataTransaction["total"]),
                style: kPoppinsSemibold600.copyWith(color: kTextHintColor, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Divider(
            height: 1,
            color: kLightGray,
          ),
          const SizedBox(
            height: 8,
          ),
          TextButton(
              onPressed: () {
                controller.isExpanded.value = false;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Detail Pembayaran",
                    style: kPoppinsMedium500.copyWith(
                      color: kTextHintColor,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: kTextHintColor,
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget paymentTypeSection(Map<String, dynamic> dataTransaction, String appointmentId) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: kBackground,
        boxShadow: [
          BoxShadow(
            color: fullBlack.withAlpha(15),
            offset: const Offset(
              0.0,
              3.0,
            ),
            blurRadius: 12.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  height: 51,
                  width: 51,
                  child: Image.asset(
                    dataTransaction["detail"]["code"].toString() == "credit_card" ? "assets/credit_card_icon.png" : "assets/bca_icon.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${dataTransaction["detail"]["name"]}",
                          style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "${dataTransaction["detail"]["description"]}",
                            style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Container(
                      color: kLightGray,
                      height: 40,
                      width: 1,
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    TextButton(
                        onPressed: () {
                          Get.put(PatientConfirmationController());

                          Get.toNamed("${Routes.CHOOSE_PAYMENT}?orderId=$appointmentId", arguments: appointmentId);
                        },
                        child: Text(
                          "Change",
                          style: kPoppinsSemibold600.copyWith(
                            fontSize: 12,
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (dataTransaction["detail"]["code"].toString() == "bca_va") ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nomor Virtual Account",
                              style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 10),
                            ),
                            Text(
                              "${dataTransaction["va_number"]}",
                              style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 13),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            FlutterClipboard.copy(
                              "${dataTransaction["va_number"]}",
                            );

                            Fluttertoast.showToast(
                              msg: "Va number copied",
                              backgroundColor: kGreenColor.withOpacity(0.2),
                              textColor: kGreenColor,
                              webShowClose: true,
                              timeInSecForIosWeb: 8,
                              fontSize: 13,
                              gravity: ToastGravity.TOP,
                              webPosition: 'center',
                              toastLength: Toast.LENGTH_LONG,
                              webBgColor: '#F8FCF5',
                            );
                          },
                          child: Text(
                            "Salin",
                            style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 11),
                          ),
                        ),
                      ],
                    )
                  ],
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Pembayaran",
                            style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 10),
                          ),
                          Text(
                            NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(dataTransaction["total"]),
                            style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 13),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          FlutterClipboard.copy(
                            "${dataTransaction["total"]}",
                          );

                          Fluttertoast.showToast(
                            msg: "Total price copied",
                            backgroundColor: kGreenColor.withOpacity(0.2),
                            textColor: kGreenColor,
                            webShowClose: true,
                            timeInSecForIosWeb: 8,
                            fontSize: 13,
                            gravity: ToastGravity.TOP,
                            webPosition: 'center',
                            toastLength: Toast.LENGTH_LONG,
                            webBgColor: '#F8FCF5',
                          );
                        },
                        child: Text(
                          "Salin Jumlah",
                          style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Divider(
            height: 1,
            color: kLightGray,
          ),
          const SizedBox(
            height: 8,
          ),
          TextButton(
              onPressed: () {
                controller.isExpanded.value = true;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Detail Pembayaran",
                    style: kPoppinsMedium500.copyWith(
                      color: kTextHintColor,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: kTextHintColor,
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget buildPageViewSection(double screenWidth) {
    return DefaultTabController(
        length: controller.tabMenuMyConsultationDetail.length,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: screenWidth,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  width: 1.5,
                  color: kLightGray,
                ))),
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.3,
                      child: TabBar(
                        labelColor: kDarkBlue,
                        labelPadding: EdgeInsets.zero,
                        unselectedLabelColor: kLightGray,
                        indicatorColor: kDarkBlue,
                        labelStyle: kPoppinsMedium500.copyWith(fontSize: 14),
                        tabs: List.generate(
                          controller.tabMenuMyConsultationDetail.length,
                          (index) => Tab(
                            text: controller.tabMenuMyConsultationDetail[index],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 43,
              ),
              SizedBox(
                height: screenWidth * 0.4,
                width: screenWidth,
                child: TabBarView(
                  children: [
                    dataPatientSection(screenWidth),

                    // MEMO ALTEA
                    dataMemoSection(
                        screenWidth, controller.data["medical_resume"] == null ? null : controller.data["medical_resume"] as Map<String, dynamic>),

                    // DOKUMEN MEDIS
                    dataMedicalDocumentsSection(
                        screenWidth, controller.data["medical_document"] == null ? null : controller.data["medical_document"] as List),

                    // BIAYA
                    dataTransaction(controller.data, screenWidth),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget dataMedicalDocumentsSection(double screenWidth, List? medicalDocuments) {
    for (var i = 0; i < medicalDocuments!.length; i++) {
      // cek document baru
      if (i == medicalDocuments.length - 1) {
        controller.newDocument.value = medicalDocuments[i] as Map<String, dynamic>;
      }

      // assign document
      if (medicalDocuments[i]['upload_by_user'] == 0) {
        controller.uploadByAltea.add(medicalDocuments[i] as Map<String, dynamic>);
      } else {
        controller.uploadedByUser.add(medicalDocuments[i] as Map<String, dynamic>);
      }
    }

    return medicalDocuments.isEmpty
        ? const Center(child: Text("Tidak ada dokumen tersedia"))
        : Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    MedicalDocumentContentListWidget(
                      bannerTitle: "Dokumen Terbaru",
                      newDocument: controller.newDocument,
                    ),
                    if (controller.uploadByAltea.isNotEmpty) ...[
                      MedicalDocumentContentListWidget(
                        bannerTitle: "Dokumen AlteaCare",
                        medicalDocuments: controller.uploadByAltea,
                      ),
                    ],
                    if (controller.uploadedByUser.isNotEmpty) ...[
                      MedicalDocumentContentListWidget(
                        bannerTitle: "Dokumen AlteaCare",
                        medicalDocuments: controller.uploadedByUser,
                      ),
                    ]
                  ],
                ),
              ),
              const Spacer()
            ],
          );
  }

  Widget dataMemoSection(double screenWidth, Map<String, dynamic>? dataMedicalResume) {
    return dataMedicalResume == null
        ? const Center(
            child: Text("Memo Altea tidak ada"),
          )
        : Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 31,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Keluhan", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 16)),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          dataMedicalResume["symptom"].toString(),
                          style: kPoppinsRegular400.copyWith(fontSize: 13, color: kSubHeaderColor),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Diagnosis", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 16)),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          dataMedicalResume["diagnosis"].toString(),
                          style: kPoppinsRegular400.copyWith(fontSize: 13, color: kSubHeaderColor),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Resep Obat", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 16)),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          dataMedicalResume["drug_resume"].toString(),
                          style: kPoppinsRegular400.copyWith(fontSize: 13, color: kSubHeaderColor),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Rekomendasi dokter", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 16)),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          dataMedicalResume["drug_resume"].toString(),
                          style: kPoppinsRegular400.copyWith(fontSize: 13, color: kSubHeaderColor),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        CustomFlatButton(width: 185, text: "Info Pemesanan Obat", onPressed: () {}, color: kButtonColor)
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Catatan lain", style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 16)),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          dataMedicalResume["additional_resume"].toString(),
                          style: kPoppinsRegular400.copyWith(fontSize: 13, color: kSubHeaderColor),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
              const Spacer()
            ],
          );
  }

  Widget dataTransaction(
    Map<String, dynamic> data,
    double screenWidth,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 44,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Metode Pembayaran",
                      style: kPoppinsMedium500.copyWith(color: black),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox(
                            height: 48,
                            width: 48,
                            child: Image.asset(
                              data["transaction"]["detail"]["code"].toString() == "credit_card"
                                  ? "assets/credit_card_icon.png"
                                  : "assets/bca_icon.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TransactionDataWidgetMyConsultation(
                dataTitle: "Konsultasi Dokter:",
                dataDescription: NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(data["fees"][1]["amount"]),
              ),
              const SizedBox(
                height: 12,
              ),
              TransactionDataWidgetMyConsultation(
                dataTitle: "Biaya Layanan:",
                dataDescription: NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(data["fees"][0]["amount"]),
              ),
              if ((data["fees"] as List).length > 2)
                Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    TransactionDataWidgetMyConsultation(
                      dataTitle: "Diskon:",
                      dataDescription: NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(data["fees"][2]["amount"]),
                    ),
                  ],
                ),
              const SizedBox(
                height: 12,
              ),
              const TransactionDataWidgetMyConsultation(
                dataTitle: "Pajak:",
                dataDescription: "0%",
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 1,
                width: screenWidth * 0.5,
                color: kTextHintColor,
              ),
              const SizedBox(
                height: 27,
              ),

              // TOTAL
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Total",
                      style: kPoppinsSemibold600.copyWith(fontSize: 14, color: kButtonColor),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(data["total_price"]),
                            style: kPoppinsSemibold600.copyWith(fontSize: 20, color: kButtonColor),
                            softWrap: true,
                          ),
                        ),
                        const Spacer()
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        const Spacer()
      ],
    );
  }

  Widget dataPatientSection(double screenWidth) {
    final String alamat =
        "${controller.data["patient"]["address_raw"][0]["street"]}, Blok RT/RW${controller.data["patient"]["address_raw"][0]["rt_rw"]}, Kel. ${controller.data["patient"]["address_raw"][0]["sub_district"]["name"]}, Kec.${controller.data["patient"]["address_raw"][0]["district"]["name"]} ${controller.data["patient"]["address_raw"][0]["city"]["name"]} ${controller.data["patient"]["address_raw"][0]["province"]["name"]} ${controller.data["patient"]["address_raw"][0]["sub_district"]["postal_code"]}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (controller.data["patient"]["avatar"] == null)
                    const SizedBox()
                  else
                    SizedBox(
                      height: 62,
                      width: 62,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.network(
                          controller.data["patient"]["avatar"].toString(),
                        ),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // dataDetail.patient!.name!,
                        controller.data["patient"]["name"].toString(),
                        style: kPoppinsMedium500.copyWith(
                          color: kBlackColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        // "{${dataDetail.patient!.age!.year} Tahun}",
                        "${controller.data["patient"]["age"]["year"]} Tahun",
                        style: kPoppinsSemibold600.copyWith(
                          color: kDarkBlue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                height: 1,
                width: screenWidth,
                color: kLightGray,
              ),
              const SizedBox(
                height: 13,
              ),
              PersonalDataWidgetMyConsultation(
                dataTitle: "Jenis Kelamin",
                dataDescription: controller.data["patient"]["gender"].toString() == "MALE" ? "Laki-laki" : "Perempuan",
              ),
              const SizedBox(
                height: 8,
              ),
              // PersonalDataWidgetMyConsultation(
              //   dataTitle: "Tempat Lahir",
              //   dataDescription:
              //       controller.data["patient"]["gender"].toString(),
              // ),
              // const SizedBox(height: 8,),
              PersonalDataWidgetMyConsultation(
                dataTitle: "Tanggal Lahir",
                dataDescription: DateFormat("dd/MM/yyyy").format(DateTime.parse(controller.data["patient"]["birthdate"].toString())),
              ),
              const SizedBox(
                height: 8,
              ),
              PersonalDataWidgetMyConsultation(
                dataTitle: "Alamat",
                dataDescription: alamat,
              ),
              const SizedBox(
                height: 48,
              ),

              // ! upload file section
              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              //   decoration: BoxDecoration(
              //     color: bannerUploadFileColor,
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text.rich(TextSpan(children: [
              //             TextSpan(
              //                 text: "Upload file (opsional) ",
              //                 style: kPoppinsMedium500.copyWith(
              //                     color: blackGreyish, fontSize: 13)),
              //             TextSpan(
              //                 text: "Max 10MB",
              //                 style: kPoppinsRegular400.copyWith(
              //                     color: kRedError, fontSize: 13)),
              //           ])),
              //           Text("pemeriksaan penunjang",
              //               style: kPoppinsRegular400.copyWith(
              //                   color: grayDarker, fontSize: 10))
              //         ],
              //       ),
              //       TextButton.icon(
              //           onPressed: () {},
              //           icon: SizedBox(
              //             width: 18,
              //             height: 20,
              //             child: Image.asset("assets/file.png"),
              //           ),
              //           label: Text(
              //             "Unggah File",
              //             style: kPoppinsMedium500.copyWith(
              //                 color: kButtonColor, fontSize: 12),
              //           ))
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 16,
              // ),

              // // FILE List Section
              // Container(
              //   width: screenWidth,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const SizedBox(
              //         height: 38,
              //       ),
              //       SizedBox(
              //         width: 38,
              //         height: 51,
              //         child: Image.asset("assets/no_file_upload_icon.png"),
              //       ),
              //       const SizedBox(
              //         height: 27,
              //       ),
              //       Text(
              //         "Belum ada file yang diunggah",
              //         style: kPoppinsMedium500.copyWith(
              //             fontSize: 14, color: grayLight),
              //       ),
              //       const SizedBox(
              //         height: 131,
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
        const Spacer()
      ],
    );
  }
}

class MedicalDocumentContentListWidget extends StatelessWidget {
  const MedicalDocumentContentListWidget({
    Key? key,
    required this.bannerTitle,
    this.medicalDocuments,
    this.newDocument,
  }) : super(key: key);
  final String bannerTitle;
  final Map<String, dynamic>? newDocument;
  final List<Map<String, dynamic>>? medicalDocuments;

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
          width: screenWidth,
          color: bannerUploadFileColor,
          child: Text(
            bannerTitle,
            style: kPoppinsMedium500.copyWith(fontSize: 10, color: bannerUploadTextColor),
          ),
        ),
        const SizedBox(
          height: 35,
        ),
        if (newDocument != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Row(
              children: [
                Container(
                  width: 49,
                  height: 49,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kDarkBlue.withOpacity(0.1)),
                  child: SizedBox(
                    width: 15,
                    child: Image.asset(
                      "assets/no_file_upload_icon.png",
                      color: kDarkBlue,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newDocument!["original_name"].toString(),
                      style: kPoppinsMedium500.copyWith(color: fullBlack.withOpacity(0.8), fontSize: 11),
                    ),
                    Text(
                      newDocument!["size"].toString(),
                      style: kPoppinsMedium500.copyWith(color: fullBlack.withOpacity(0.5), fontSize: 9),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      newDocument!["date"].toString(),
                      style: kPoppinsRegular400.copyWith(color: fullBlack.withOpacity(0.3), fontSize: 8),
                    ),
                  ],
                )
              ],
            ),
          )
        else
          Column(
            children: List.generate(
                medicalDocuments!.length,
                (index) => Container(
                      padding: EdgeInsets.only(left: 25, bottom: (index == medicalDocuments!.length - 1) ? 0 : 14),
                      margin: const EdgeInsets.only(bottom: 21),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: (index == medicalDocuments!.length - 1) ? BorderSide.none : BorderSide(color: grayLight.withOpacity(0.3)))),
                      child: Row(
                        children: [
                          Container(
                            width: 49,
                            height: 49,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kDarkBlue.withOpacity(0.1)),
                            child: SizedBox(
                              width: 15,
                              child: Image.asset(
                                "assets/no_file_upload_icon.png",
                                color: kDarkBlue,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicalDocuments![index]["original_name"].toString(),
                                style: kPoppinsMedium500.copyWith(color: fullBlack.withOpacity(0.8), fontSize: 11),
                              ),
                              Text(
                                medicalDocuments![index]["size"].toString(),
                                style: kPoppinsMedium500.copyWith(color: fullBlack.withOpacity(0.5), fontSize: 9),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                medicalDocuments![index]["date"].toString(),
                                style: kPoppinsRegular400.copyWith(color: fullBlack.withOpacity(0.3), fontSize: 8),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
          ),
        const SizedBox(
          height: 18,
        )
      ],
    );
  }
}
