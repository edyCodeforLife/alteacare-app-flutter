// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/widgets/custom_flat_button.dart';
import '../../../../data/model/payment_type.dart';
import '../../../../routes/app_pages.dart';
import '../../../home/views/dekstop_web/widget/footer_section_view.dart';
import '../../../home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import '../../../register/presentation/modules/register/views/custom_simple_dialog.dart';
import '../../controllers/choose_payment_controller.dart';

class DesktopWebChoosePaymentView extends StatelessWidget {
  const DesktopWebChoosePaymentView({required this.appointmentId});
  final String appointmentId;
  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    // final patientConfirmationController = Get.find<PatientConfirmationController>();
    final controller = Get.find<ChoosePaymentController>();

    return Scaffold(
      body: FutureBuilder(
        future: controller.getDetailAppointment(appointmentId, false
            // ?? patientConfirmationController.dataAppointment["data"]["appointment_id"].toString(),
            ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Map<String, dynamic> result = snapshot.data! as Map<String, dynamic>;

            if (result["status"] == true) {
              final Map<String, dynamic> data = result["data"] as Map<String, dynamic>;
              return Column(
                children: [
                  TopNavigationBarSection(
                    screenWidth: screenWidth,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 41,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: ChoosePaymentDetailDoctorAndPaymentSection(
                                screenWidth: screenWidth,
                                controller: controller,
                                data: data,
                              )),
                              Expanded(
                                child: ChoosePaymentDetailConsultationPriceSection(
                                  data: data,
                                  appointmentId: appointmentId,
                                ),
                              )
                            ],
                          ),
                        ),
                        FooterSectionWidget(screenWidth: screenWidth)
                      ],
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

class ChoosePaymentDetailConsultationPriceSection extends StatelessWidget {
  const ChoosePaymentDetailConsultationPriceSection({
    Key? key,
    required this.appointmentId,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final String appointmentId; //-> this data got from my konsultasi change payment method
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChoosePaymentController>();
    // final patientConfirmationController = Get.find<PatientConfirmationController>();
    final screenWidth = context.width;

    // print("DATA PAYMENT fess di choose payment -> ${data['fees']}");
    // print("DATA PAYMENT total di choose payment -> ${data['total_price']}");

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: kBackground,
              boxShadow: [BoxShadow(blurRadius: 12, color: kLightGray, offset: const Offset(0, 3))]),
          // height: 440,
          width: 344,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Order ID: ",
                    style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                  ),
                  Text(
                    data["id"].toString(),
                    style: kPoppinsSemibold600.copyWith(fontSize: 10, color: kBlackColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
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
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Konsultasi Dokter:",
                    style: kPoppinsRegular400.copyWith(fontSize: 13, color: kLightGray),
                  ),
                  Text(
                    "Rp. ${data["fees"][0]["amount"].toString()}",
                    style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
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
                    style: kPoppinsRegular400.copyWith(fontSize: 13, color: kLightGray),
                  ),
                  Text(
                    "${data["fees"][1]["amount"].toString()}",
                    style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
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
                    "Diskon:",
                    style: kPoppinsRegular400.copyWith(fontSize: 13, color: kLightGray),
                  ),
                  Text(
                    data["fees"][2]["amount"].toString(),
                    style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
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
                    "Pajak:",
                    style: kPoppinsRegular400.copyWith(fontSize: 13, color: kLightGray),
                  ),
                  Text(
                    "0 %",
                    style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
                  ),
                ],
              ),
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
                height: 73,
              ),
              Obx(() => CustomFlatButton(
                  width: 138,
                  text: "Bayar",
                  onPressed: controller.isChoosePayment.value.name == null
                      ? null
                      : () async {
                          // print("bayar");

                          final result = await controller.createPayment(
                              int.tryParse(appointmentId) ?? 0,
                              //  ?? patientConfirmationController.dataAppointment["data"]["appointment_id"] as int,
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
                                    title: 'Make payment failed',
                                    buttonTxt: 'Mengerti',
                                    subtitle: result.message!));
                          }
                        },
                  color: controller.isChoosePayment.value.name == null ? kLightGray : kButtonColor)),
              const SizedBox(
                height: 36,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class PopUpCCPayment extends StatelessWidget {
  const PopUpCCPayment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      backgroundColor: kBackground,
      child: Container(
        width: 400,
        height: 350,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            18,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 64,
            ),
            Text(
              "Mohon Tunggu Sebentar",
              style: kPoppinsMedium500.copyWith(fontSize: 25, color: kBlackColor),
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              "Anda akan disambungkan pada halaman pembayaran Visa",
              style: kPoppinsRegular400.copyWith(fontSize: 15, color: kLightGray),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset("assets/loadingPlaceholder.gif"),
            ),
            const SizedBox(
              height: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class ChoosePaymentDetailDoctorAndPaymentSection extends StatelessWidget {
  const ChoosePaymentDetailDoctorAndPaymentSection({
    Key? key,
    required this.screenWidth,
    required this.controller,
    required this.data,
  }) : super(key: key);

  final double screenWidth;
  final ChoosePaymentController controller;
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 173,
              height: 173,
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
                  style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 23),
                ),
                Text(
                  data["doctor"]["specialist"]["name"].toString(),
                  style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 15),
                ),
                const SizedBox(
                  width: 16,
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
                      DateFormat("EEEE, dd/MM/yyyy", "id").format(DateTime.parse(data["schedule"]["date"].toString())),
                      style: kPoppinsRegular400.copyWith(fontSize: 11, color: kTextHintColor),
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
                      "${data["schedule"]["time_start"]} - ${data["schedule"]["time_end"]}",
                      style: kPoppinsRegular400.copyWith(fontSize: 11, color: kTextHintColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 28,
        ),
        Divider(
          height: 2,
          color: kLightGray,
        ),
        const SizedBox(
          height: 28,
        ),
        SizedBox(
          height: screenWidth * 0.5,
          width: screenWidth,
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
                                    border:
                                        Border.all(color: controller.isChoosePayment.value.name == paymentMethod[idx].name ? kDarkBlue : kLightGray),
                                    borderRadius: BorderRadius.circular(12),
                                    color: kBackground,
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      controller.isChoosePayment.value = paymentMethod[idx];
                                      // Get.dialog(
                                      //   PaymentGuideDialog(
                                      //       paymentMethod: paymentMethod[idx]),
                                      // );
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
              }),
        ),
      ],
    );
  }
}

class PaymentGuideDialog extends StatelessWidget {
  const PaymentGuideDialog({
    Key? key,
    required this.paymentMethod,
  }) : super(key: key);

  final PaymentMethod paymentMethod;

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: screenWidth * 0.38,
        width: screenWidth * 0.28,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: screenWidth * 0.06,
              child: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Cancel",
                        style: kPoppinsMedium500.copyWith(fontSize: 14, color: kBackground),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Icon(
                        Icons.close_rounded,
                        color: kBackground,
                      )
                    ],
                  )),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: kBackground),
                child: PaymentGuideDesktopWeb(
                  selectedPaymentMethod: paymentMethod,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentGuideDesktopWeb extends StatelessWidget {
  const PaymentGuideDesktopWeb({
    Key? key,
    required this.selectedPaymentMethod,
  }) : super(key: key);
  final PaymentMethod selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChoosePaymentController>();
    final screenWidth = context.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 35,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  width: 47,
                  height: 47,
                  child: Image.network(
                    selectedPaymentMethod.icon!,
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
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          child: Text(
            "Panduan Pembayaran",
            style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 11),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          child: Container(
            height: screenWidth * 0.18,
            child: FutureBuilder<Map<String, dynamic>>(
                future: controller.getPaymentGuides(selectedPaymentMethod.code!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final result = snapshot.data!["data"] as List;
                    return ListView.builder(
                      itemCount: result.length,
                      itemBuilder: (context, index) {
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
                }),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          child: CustomFlatButton(
              width: screenWidth,
              text: "Konfirmasi",
              onPressed: () {
                controller.isChoosePayment.value = selectedPaymentMethod;
                Get.back();
              },
              color: kButtonColor),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
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
