// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MWCDBiaya extends StatelessWidget {
  final dynamic dataBiaya;
  final screenWidth = Get.width;
  MWCDBiaya({
    required this.dataBiaya,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: (dataBiaya == null)
          ? const Center(
              child: Text("Tidak ada data biaya"),
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Metode Pembayaran",
                      style: kPoppinsMedium500.copyWith(color: black),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        height: 48,
                        width: 48,
                        child: Image.asset(
                          dataBiaya["transaction"]["detail"]["code"]
                                      .toString() ==
                                  "credit_card"
                              ? "assets/credit_card_icon.png"
                              : "assets/bca_icon.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Konsultasi Dokter:",
                      style: kPoppinsRegular400.copyWith(
                          fontSize: 14, color: kTextHintColor),
                    ),
                    Text(
                      NumberFormat.currency(
                              locale: 'id', name: "IDR ", decimalDigits: 0)
                          .format(dataBiaya["fees"][0]["amount"]),
                      style: kPoppinsRegular400.copyWith(
                          fontSize: 14, color: kTextHintColor),
                      softWrap: true,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Biaya Layanan:",
                      style: kPoppinsRegular400.copyWith(
                          fontSize: 14, color: kTextHintColor),
                    ),
                    Text(
                      NumberFormat.currency(
                              locale: 'id', name: "IDR ", decimalDigits: 0)
                          .format(dataBiaya["fees"][1]["amount"]),
                      style: kPoppinsRegular400.copyWith(
                          fontSize: 14, color: kTextHintColor),
                      softWrap: true,
                    ),
                  ],
                ),
                if ((dataBiaya["fees"] as List).length > 2)
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
                            style: kPoppinsRegular400.copyWith(
                                fontSize: 14, color: kTextHintColor),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: 'id',
                                    name: "IDR ",
                                    decimalDigits: 0)
                                .format(dataBiaya["fees"][2]["amount"]),
                            style: kPoppinsRegular400.copyWith(
                                fontSize: 14, color: kTextHintColor),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pajak:",
                      style: kPoppinsRegular400.copyWith(
                          fontSize: 14, color: kTextHintColor),
                    ),
                    Text(
                      "0%",
                      style: kPoppinsRegular400.copyWith(
                          fontSize: 14, color: kTextHintColor),
                      softWrap: true,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 1,
                  width: screenWidth,
                  color: kLightGray,
                ),
                const SizedBox(
                  height: 27,
                ),

                // TOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: kPoppinsSemibold600.copyWith(
                          fontSize: 14, color: kButtonColor),
                    ),
                    Text(
                      NumberFormat.currency(
                              locale: 'id', name: "IDR ", decimalDigits: 0)
                          .format(dataBiaya["total_price"]),
                      style: kPoppinsSemibold600.copyWith(
                          fontSize: 20, color: kButtonColor),
                      softWrap: true,
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
