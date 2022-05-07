// Flutter imports:
// Project imports:
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

class WaitMACallView extends StatelessWidget {
  const WaitMACallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PatientConfirmationController());
    if (GetPlatform.isWeb) {
      return Container();
    } else {
      return Container();
    }
  }
}
