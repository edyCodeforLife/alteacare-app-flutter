// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/widgets/custom_flat_button.dart';
import '../../../../data/model/payment_type.dart';
import '../../../../routes/app_pages.dart';
import '../../../home/views/mobile_web/mobile_web_hamburger_menu.dart';
import '../../../patient_confirmation/controllers/patient_confirmation_controller.dart';
import '../../../register/presentation/modules/register/views/custom_simple_dialog.dart';
import '../../controllers/choose_payment_controller.dart';
import '../dekstop_web_view/dekstop_web_view.dart';

class MobileWebChoosePaymentView extends StatelessWidget {
  const MobileWebChoosePaymentView({this.appointmentId});
  final String? appointmentId;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;
    // final patientConfirmationController = Get.find<PatientConfirmationController>();
    final controller = Get.find<ChoosePaymentController>();

    // print(
    //     "data appointment -> ${patientConfirmationController.dataAppointment["data"]["appointment_id"].toString()}");
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kBackground,
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawer: MobileWebHamburgerMenu(),
      body: FutureBuilder(
        future: controller.getDetailAppointment(appointmentId!, false
            // ?? patientConfirmationController.dataAppointment["data"]["appointment_id"].toString(),
            ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Map<String, dynamic> result = snapshot.data! as Map<String, dynamic>;
            if (result["status"] == true) {
              final Map<String, dynamic> data = result["data"] as Map<String, dynamic>;
              return Stack(
                children: [
                  ListView(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Row(
                          children: [
                            Text(
                              "Order ID: ",
                              style: kPoppinsRegular400.copyWith(
                                fontSize: 10,
                                color: kTextHintColor,
                              ),
                            ),
                            Text(
                              data["id"].toString(),
                              style: kPoppinsSemibold600.copyWith(
                                fontSize: 10,
                                color: kBlackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Divider(
                        height: 1,
                        color: kLightGray,
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 74,
                              width: 74,
                              child: Image.network(
                                addCDNforLoadImage(data["doctor"]["photo"]["formats"]["thumbnail"].toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 14,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data["doctor"]["name"].toString(),
                                  style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14),
                                ),
                                Text(
                                  data["doctor"]["specialist"]["name"].toString(),
                                  style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 10),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: Image.asset("calendar_icon.png", color: kLightGray),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      DateFormat("EEEE, dd/MM/yyyy", "id").format(DateTime.parse(data["schedule"]["date"].toString())),
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
                                        color: kLightGray,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "${data["schedule"]["time_start"]} - ${data["schedule"]["time_end"]}",
                                      style: kPoppinsRegular400.copyWith(color: kBlackColor, fontSize: 10),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Divider(
                        height: 1,
                        color: kLightGray,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Text(
                          "Pilih Metode Pembayaran",
                          style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: SizedBox(
                          // height: screenWidth * 0.9,
                          child: FutureBuilder<PaymentType>(
                            future: controller.getPaymentTypesModel(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final PaymentType result = snapshot.data!;

                                // check and filter payment type
                                if (data["total_price"].toString() == "0") {
                                  final cc = result.data![0];
                                  final va = result.data![1];
                                  result.data!.remove(cc);
                                  result.data!.remove(va);
                                } else {
                                  for (final item in result.data!) {
                                    if (item.type!.contains("Altea Free Consultation")) {
                                      final alteaFree = result.data![2];
                                      result.data!.remove(alteaFree);
                                    }
                                  }
                                }

                                if (result.status!) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: result.data!.length,
                                    itemBuilder: (context, index) {
                                      final List<PaymentMethod> paymentMethod = result.data![index].paymentMethods!;
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            result.data![index].type!,
                                            style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 11),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          ...List.generate(
                                            paymentMethod.length,
                                            (idx) => Obx(
                                              () => Container(
                                                padding: const EdgeInsets.symmetric(vertical: 16),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          controller.isChoosePayment.value.name == paymentMethod[idx].name ? kDarkBlue : kLightGray),
                                                  borderRadius: BorderRadius.circular(12),
                                                  color: kBackground,
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //       blurRadius: 12,
                                                  //       offset:
                                                  //           const Offset(0, 3),
                                                  //       color: kLightGray),
                                                  // ],
                                                ),
                                                child: ListTile(
                                                  onTap: () {
                                                    controller.isChoosePayment.value = paymentMethod[idx];
                                                    // Get.to(
                                                    //     PaymentDetailConfirmationPage(
                                                    //   selectedPaymentMethod:
                                                    //       paymentMethod[idx],
                                                    // ));
                                                  },
                                                  leading: ClipRRect(
                                                    borderRadius: BorderRadius.circular(100),
                                                    child: SizedBox(
                                                      width: 47,
                                                      height: 47,
                                                      child: Image.network(
                                                        addCDNforLoadImage(paymentMethod[idx].icon!),
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ),
                                                  title: Text(
                                                    paymentMethod[idx].provider!,
                                                    style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
                                                  ),
                                                  subtitle: Text(
                                                    paymentMethod[0].description!,
                                                    style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 10),
                                                  ),
                                                  trailing: const Icon(
                                                    Icons.arrow_forward_ios_rounded,
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // height: 120,
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 13),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                          color: kBackground,
                          boxShadow: [BoxShadow(blurRadius: 12, offset: const Offset(0, -3), color: kLightGray)]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: kButtonColor.withOpacity(0.2),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Image.asset("assets/voucher_icon.png"),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text("Gunakan Voucher",
                                    style: kPoppinsSemibold600.copyWith(
                                      color: kButtonColor,
                                      fontSize: 12,
                                    )),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: kButtonColor,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Biaya Total:",
                                    style: kPoppinsMedium500.copyWith(fontSize: 9, color: kTextHintColor),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.bottomSheet(
                                        DetailPriceSheet(
                                          data: data,
                                        ),
                                        backgroundColor: kBackground,
                                        isDismissible: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(33),
                                            topRight: Radius.circular(33),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "Rp. ${data["total_price"].toString()}",
                                          style: kPoppinsSemibold600.copyWith(fontSize: 14, color: kDarkBlue),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_up_rounded,
                                          size: 14,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Obx(
                                () => CustomFlatButton(
                                    width: 138,
                                    text: "Bayar",
                                    onPressed: controller.isChoosePayment.value.name == null
                                        ? null
                                        : () async {
                                            // print("bayar");
                                            final result = await controller.createPayment(
                                                int.tryParse(appointmentId!) ?? 0,
                                                // patientConfirmationController.dataAppointment["data"]["appointment_id"] as int,
                                                controller.isChoosePayment.value.code!);
                                            if (result.status!) {
                                              if (result.data!.type == controller.ccType) {
                                                Get.dialog(const PopUpCCPayment());

                                                Future.delayed(const Duration(seconds: 4), () {
                                                  // TODO: ke halaman detail konsultasi

                                                  Future.delayed(Duration.zero, () {
                                                    Get.offAndToNamed("/home");
                                                    Get.toNamed(Routes.MY_CONSULTATION);
                                                  });
                                                  // Get.offNamedUntil(Routes.MY_CONSULTATION, ModalRoute.withName(Routes.HOME));
                                                  return launch(result.data!.redirectUrl!);
                                                });
                                              } else if (result.data!.type == controller.vaType) {
                                                controller.resultPayment.value = result;
                                                Get.toNamed("${Routes.SUCCESS_PAYMENT_PAGE}?orderId=$appointmentId", arguments: appointmentId);
                                              } else {
                                                controller.resultPayment.value = result;
                                                Get.toNamed("${Routes.SUCCESS_PAYMENT_PAGE}?orderId=$appointmentId", arguments: appointmentId);
                                              }
                                            } else {
                                              //delete later
                                              // if (result.data!.type == controller.ccType) {
                                              //   Get.dialog(const PopUpCCPayment());
                                              //
                                              //   Future.delayed(const Duration(seconds: 4), () {
                                              //     // TODO: ke halaman detail konsultasi
                                              //     Get.offNamedUntil(Routes.MY_CONSULTATION, ModalRoute.withName(Routes.HOME));
                                              //     return launch(result.data!.redirectUrl!);
                                              //   });
                                              // } else if (result.data!.type == controller.vaType) {
                                              //   controller.resultPayment.value = result;
                                              //   Get.toNamed(Routes.SUCCESS_PAYMENT_PAGE);
                                              // } else {
                                              //   controller.resultPayment.value = result;
                                              //   Get.toNamed(Routes.SUCCESS_PAYMENT_PAGE);
                                              // }
                                              ///end delete later

                                              Get.dialog(
                                                CustomSimpleDialog(
                                                  icon: SizedBox(
                                                    width: screenWidth * 0.1,
                                                    child: Image.asset("assets/failed_icon.png"),
                                                  ),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  title: 'Make payment failed',
                                                  buttonTxt: 'Mengerti',
                                                  subtitle: result.message!,
                                                ),
                                              );
                                            }
                                          },
                                    color: controller.isChoosePayment.value.name == null ? kLightGray : kButtonColor),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Container();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class PaymentDetailConfirmationPage extends StatelessWidget {
  const PaymentDetailConfirmationPage({
    Key? key,
    required this.selectedPaymentMethod,
  }) : super(key: key);

  final PaymentMethod selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChoosePaymentController>();
    final screenWidth = context.width;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                          width: 47,
                          height: 47,
                          child: Image.network(
                            addCDNforLoadImage(selectedPaymentMethod.icon!),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedPaymentMethod.provider!,
                              style: kPoppinsSemibold600.copyWith(color: kTextHintColor, fontSize: 14),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              selectedPaymentMethod.description!,
                              style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 37,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Text(
                    "Panduan Pembayaran",
                    style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 11),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Container(
                    height: Get.height * 0.5,
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: controller.getPaymentGuides(selectedPaymentMethod.code!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final result = snapshot.data!["data"] as List;
                          return ListView.builder(
                            itemCount: result.length,
                            itemBuilder: (context, index) {
                              // return Container(
                              //   child: Column(
                              //     children: [
                              //       Text(
                              //         result[index]["title"].toString(),
                              //         style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kDarkBlue),
                              //       ),
                              //       HtmlWidget(
                              //         result[index]["text"].toString(),
                              //         customStylesBuilder: (e) {
                              //           return {
                              //             "color": "0xFFD8D8D8",
                              //             "font-size": "10px",
                              //             "font-weight": "normal",
                              //           };
                              //         },
                              //       ),
                              //     ],
                              //   ),
                              // );
                              return InkWell(
                                onTap: () {
                                  controller.isExpanded.value ? controller.shrinkTile() : controller.expandTile();
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
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 78,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: CustomFlatButton(
                  width: screenWidth,
                  text: "Konfirmasi",
                  onPressed: () {
                    controller.isChoosePayment.value = selectedPaymentMethod;
                    Get.back();
                  },
                  color: kButtonColor),
            ),
          )
        ],
      ),
    );
  }

  Widget buildExpansionTile(Map<String, dynamic> data) {
    final controller = Get.find<ChoosePaymentController>();

    return Container(
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        key: controller.keyTile,
        initiallyExpanded: controller.isExpanded.value,
        title: Text(
          data["title"].toString(),
          style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kDarkBlue),
        ),
        children: [
          HtmlWidget(
            data["text"].toString(),
            customStylesBuilder: (e) {
              return {
                "color": "0xFFD8D8D8",
                "font-size": "10px",
                "font-weight": "normal",
              };
            },
          )
        ],
      ),
    );
  }
}

class DetailPriceSheet extends StatelessWidget {
  const DetailPriceSheet({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 11,
          ),
          Container(height: 6, width: 48, color: kLightGray),
          const SizedBox(
            height: 46,
          ),
          Text(
            "Biaya Total",
            style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 17),
          ),
          const SizedBox(
            height: 26,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Konsultasi Dokter:",
                style: kPoppinsRegular400.copyWith(fontSize: 13, color: kLightGray),
              ),
              Text(
                "Rp. ${data["total_price"].toString()}",
                style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
              ),
            ],
          ),
          const SizedBox(
            height: 11,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "Biaya Layanan:",
          //       style: kPoppinsRegular400.copyWith(fontSize: 13, color: kLightGray),
          //     ),
          //     Text(
          //       "no data",
          //       style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
          //     ),
          //   ],
          // ),
          // const SizedBox(
          //   height: 11,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "Pajak:",
          //       style: kPoppinsRegular400.copyWith(fontSize: 13, color: kLightGray),
          //     ),
          //     Text(
          //       "no data %}",
          //       style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
          //     ),
          //   ],
          // ),
          const SizedBox(
            height: 11,
          ),
          Divider(
            height: 2,
            color: kLightGray,
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kButtonColor),
              ),
              Text(
                "Rp. ${data["total_price"].toString()}",
                style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kButtonColor),
              ),
            ],
          ),
          const SizedBox(
            height: 48,
          ),
        ],
      ),
    );
  }
}
