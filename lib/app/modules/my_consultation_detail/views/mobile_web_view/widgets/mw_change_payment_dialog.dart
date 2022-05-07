// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

import '../../../../../routes/app_pages.dart';

class MWChangePaymentDialog extends StatelessWidget {
  final String appointmentId;
  MWChangePaymentDialog(this.appointmentId);

  @override
  Widget build(BuildContext context) {
    final screnWidth = context.width;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      backgroundColor: kBackground,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: (screnWidth >= 360) ? 20 : 15, vertical: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            18,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 64,
            ),
            Text(
              "Apakah Anda yakin mau mengganti metode pembayaran?",
              style: kPoppinsRegular400.copyWith(color: kTextHintColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 41,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomFlatButton(
                  width: screnWidth * 0.3,
                  text: "Batal",
                  onPressed: () {
                    Get.back();
                  },
                  color: kBackground,
                  borderColor: kButtonColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                CustomFlatButton(
                  width: screnWidth * 0.3,
                  text: "Ganti",
                  onPressed: () async {
                    Get.put(PatientConfirmationController());
                    Get.toNamed("${Routes.CHOOSE_PAYMENT}?orderId=$appointmentId", arguments: appointmentId);
                  },
                  color: kButtonColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
