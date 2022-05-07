// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';

class SuccessPaymentPageController extends GetxController {
  final http.Client client = http.Client();

  Future getPaymentTypes() async {
    try {
      var token = AppSharedPreferences.getAccessToken();
      final response = await client.get(
        Uri.parse("$alteaURL/data/payment-types"),
        // headers: {"Authorization": "Bearer $token"}
      );
      // print('statusCode => ${response.statusCode} : ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // print("masuk catch $e");
      return e.toString();
    }
  }

  Future<Map<String, dynamic>> getPaymentGuides(String paymentCode) async {
    // print(paymentCode.toUpperCase());
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/blocks?type=PAYMENT_GUIDE_${paymentCode.toUpperCase()}"),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      // print("masuk catch $e");
      return e as Map<String, dynamic>;
    }
  }

  Future getDetailAppointment(String appointmentId) async {
    try {
      var token = AppSharedPreferences.getAccessToken();
      final response = await client.get(
        // Uri.parse("$alteaURL/appointment/detail/$appointmentId"),
        Uri.parse("$alteaURL/appointment/v1/consultation/$appointmentId"),

        headers: {"Authorization": "Bearer $token"},
      );
      // print('statusCode => ${response.statusCode} : ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // print("masuk catch $e");
      return e.toString();
    }
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "00:$twoDigitMinutes:$twoDigitSeconds";
  }

  UniqueKey keyTile = UniqueKey();
  RxBool isExpanded = false.obs;

  void expandTile() {
    isExpanded.value = true;
    keyTile = UniqueKey();
    update();
  }

  void shrinkTile() {
    isExpanded.value = false;
    keyTile = UniqueKey();
    update();
  }

  RxString appointmentId = "".obs;

  late StreamController vaCheckStreamController;

  loadChangesData(String appointmentId) async => getDetailAppointment(appointmentId).then((res) {
        return vaCheckStreamController.add(res);
      });

  //TODO: Implement SuccessPaymentPageController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    vaCheckStreamController = StreamController();

    Timer.periodic(const Duration(seconds: 1), (_) {
      loadChangesData(appointmentId.value);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
