// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:altea/app/core/utils/styles.dart';

class MWConsultationDetailCancelledContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.topCenter,
      child: Text(
        "Maaf, jadwal konsultasi Anda dibatalkan. Silakan pilih jadwal ulang untuk konsultasi",
        style: kPoppinsRegular400.copyWith(
          color: Colors.black,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
