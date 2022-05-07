// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

class LoadingCallScreen extends StatefulWidget {
  _LoadingCallScreenState createState() => _LoadingCallScreenState();
}

class _LoadingCallScreenState extends State<LoadingCallScreen> {
  String orderId = "";
  String patientName = "";
  String callType = "";
  @override
  void initState() {
    orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";
    patientName = Get.parameters.containsKey('name') ? Get.parameters['name'].toString() : "";
    callType = Get.parameters.containsKey('type') ? Get.parameters['type'].toString() : "";
    if (orderId.isEmpty) {}
    Future.delayed(
      const Duration(seconds: 5),
      () {
        if (GetPlatform.isWeb) {
          if (GetPlatform.isMobile) {
            Get.offAndToNamed(
              "/call-mobile?orderId=$orderId",
              arguments: {
                "patientName": patientName,
                "callType": callType,
              },
            );
          } else {
            Get.offAndToNamed(
              "/call-desktop?orderId=$orderId",
              arguments: {
                "patientName": patientName,
                "callType": callType,
              },
            );
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: const [
            CircularProgressIndicator(),
            Text("Sedang mencoba menghubungkan lagi"),
          ],
        ),
      ),
    );
  }
}
