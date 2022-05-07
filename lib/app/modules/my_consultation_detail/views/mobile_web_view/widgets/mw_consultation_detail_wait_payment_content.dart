// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:clipboard/clipboard.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_count_down.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/my_consultation_detail/controllers/my_consultation_detail_controller.dart';
import 'package:altea/app/modules/my_consultation_detail/models/my_consultation_detail_model.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgets/mw_change_payment_dialog.dart';

class MWConsultationDetailWaitPaymentContent extends StatelessWidget {
  final Transaction? dataTransaction;
  final List fees;
  final String created;
  final String appointmentId;
  final screenWidth = Get.width;
  final MyConsultationDetailController _controller = Get.find<MyConsultationDetailController>();
  MWConsultationDetailWaitPaymentContent({required this.appointmentId, required this.created, required this.dataTransaction, required this.fees}) {
    if (dataTransaction != null) {
      dateTime = DateTime.parse(dataTransaction!.expiredAt.toString());
      timeStamp = dateTime!.toUtc().microsecondsSinceEpoch;
      date = DateTime.fromMicrosecondsSinceEpoch(timeStamp!);
      endTime = DateTime.parse((DateTime.parse(dataTransaction!.expiredAt.toString())).toIso8601String())
          .difference(DateTime.parse(DateTime.now().toIso8601String()))
          .inSeconds;
    }
  }

  late final DateTime? dateTime;
  late final int? timeStamp;
  late final DateTime? date;
  late final int? endTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      width: screenWidth,
      child: (dataTransaction != null)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
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
                                .format(DateTime.parse((DateTime.parse(dataTransaction!.expiredAt.toString())).toIso8601String())),
                            style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 13),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            DateFormat.Hm().format(date!),
                            style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Countdown(
                        seconds: endTime!,
                        build: (BuildContext context, double time) {
                          final remainingTime = Duration(seconds: time.toInt());
                          final timeRes = _controller.printDuration(remainingTime);
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
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Obx(
                    () => _controller.isExpanded.value
                        ? paymentTypeSectionExpanded(
                            appointmentId,
                            dataTransaction!,
                            fees,
                          )
                        : paymentTypeSection(dataTransaction!, appointmentId),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
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
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                          height: Get.height * 0.5,
                          child: FutureBuilder<Map<String, dynamic>>(
                              future: _controller.getPaymentGuides(dataTransaction!.detail.code.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final result = snapshot.data!["data"] as List;
                                  return ListView.builder(
                                    itemCount: result.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          _controller.isExpandedTile.value ? _controller.shrinkTile() : _controller.expandTile();
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
              ],
            )
          : Center(
              child: Text(
                "data transaction not found",
                style: kTextHintStyle.copyWith(fontSize: 14),
              ),
            ),
    );
  }

  Widget buildExpansionTile(Map<String, dynamic> data) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      key: _controller.keyTile,
      initiallyExpanded: _controller.isExpanded.value,
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

  Widget paymentTypeSectionExpanded(String appointmentId, Transaction dataTransaction, List fees) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  height: screenWidth * 0.15,
                  width: screenWidth * 0.15,
                  child: Image.asset(
                    dataTransaction.detail.code == "credit_card" ? "assets/credit_card_icon.png" : "assets/bca_icon.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              SizedBox(
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataTransaction.detail.name,
                      style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        dataTransaction.detail.description,
                        style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            width: screenWidth,
            child: InkWell(
              onTap: () {
                Get.dialog(MWChangePaymentDialog(appointmentId));
                // Get.put(PatientConfirmationController());
                // Get.toNamed(Routes.CHOOSE_PAYMENT, arguments: appointmentId);
              },
              child: Text(
                "Change",
                style: kPoppinsSemibold600.copyWith(
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (dataTransaction.detail.code == "bca_va") ...[
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
                              dataTransaction.vaNumber,
                              style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 13),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            FlutterClipboard.copy(
                              dataTransaction.vaNumber,
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
                            NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(dataTransaction.total),
                            style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 13),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          FlutterClipboard.copy(
                            "${dataTransaction.total}",
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
                NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(fees[0].amount),
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
                NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(fees[1].amount),
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
                      style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(fees[2].amount),
                      style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor),
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
                NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(dataTransaction.total),
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
                _controller.isExpanded.value = false;
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

  Widget paymentTypeSection(Transaction dataTransaction, String appointmentId) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  height: screenWidth * 0.15,
                  width: screenWidth * 0.15,
                  child: Image.asset(
                    dataTransaction.detail.code.toString() == "credit_card" ? "assets/credit_card_icon.png" : "assets/bca_icon.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              SizedBox(
                height: 40,
                child: SizedBox(
                  height: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataTransaction.detail.name,
                        style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14),
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(
                          dataTransaction.detail.description,
                          style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            width: screenWidth,
            child: InkWell(
              onTap: () {
                Get.dialog(MWChangePaymentDialog(appointmentId));

                // Get.put(PatientConfirmationController());
                // Get.toNamed(Routes.CHOOSE_PAYMENT, arguments: appointmentId);
              },
              child: Text(
                "Change",
                style: kPoppinsSemibold600.copyWith(
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (dataTransaction.detail.code == "bca_va") ...[
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
                              dataTransaction.vaNumber,
                              style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 13),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            FlutterClipboard.copy(
                              dataTransaction.vaNumber,
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
                            NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(dataTransaction.total),
                            style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 13),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          FlutterClipboard.copy(
                            "${dataTransaction.total}",
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
                _controller.isExpanded.value = true;
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
}
