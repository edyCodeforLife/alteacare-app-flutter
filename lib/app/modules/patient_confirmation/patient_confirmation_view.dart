// Flutter imports:
// Project imports:
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import 'package:altea/app/modules/patient_confirmation/views/mobile_app_view/mobile_app_view.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'views/desktop_web_view/desktop_web_view.dart';
import 'views/mobile_web_view/mobile_web_view.dart';

class PatientConfirmationPage extends StatelessWidget {
  const PatientConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PatientConfirmationController());
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          final String doctorId = Get.parameters.containsKey('doctorId') ? Get.parameters['doctorId'].toString() : "";
          if (doctorId.isEmpty) {
            Future.delayed(Duration.zero, () {
              Get.offAndToNamed("/err_404");
            });
          }
          try {
            final SpesialisKonsultasiController spesialisKonsultasiController = Get.find<SpesialisKonsultasiController>();
          } catch (e) {
            // print(e.toString());
            Future.delayed(const Duration(milliseconds: 300), () {
              Get.offAndToNamed('/home/search-specialist/spesialis-konsultasi?doctorId=$doctorId');
            });
          }
          return MobileWebPatientConfirmationPage(
            doctorIdFromParam: doctorId,
          );
        } else {
          return const DesktopWebPatientConfirmationPage();
        }
      });
    } else {
      return MobileAppView();
    }
  }
}
