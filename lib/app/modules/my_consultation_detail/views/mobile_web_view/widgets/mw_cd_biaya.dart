// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/my_consultation_detail/models/my_consultation_detail_model.dart';

class MWCDBiaya extends StatelessWidget {
  final Transaction? transaction;
  final List<Fee> fees;
  final int totalPrice;
  final screenWidth = Get.width;
  MWCDBiaya({
    required this.transaction,
    required this.fees,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: (transaction == null)
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
                          transaction!.detail.code == "credit_card" ? "assets/credit_card_icon.png" : "assets/bca_icon.png",
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
                      style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(fees[0].amount),
                      style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor),
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
                      style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(fees[1].amount),
                      style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor),
                      softWrap: true,
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
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pajak:",
                      style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor),
                    ),
                    Text(
                      "0%",
                      style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor),
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
                      style: kPoppinsSemibold600.copyWith(fontSize: 14, color: kButtonColor),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(totalPrice),
                      style: kPoppinsSemibold600.copyWith(fontSize: 20, color: kButtonColor),
                      softWrap: true,
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
