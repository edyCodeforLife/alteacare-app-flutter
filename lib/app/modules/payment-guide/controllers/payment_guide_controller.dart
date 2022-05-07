import 'dart:convert';

import 'package:altea/app/core/utils/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PaymentGuideController extends GetxController {
  //TODO: Implement PaymentGuideController

  RxMap<String, dynamic> selectedPaymentMethod = Map<String, dynamic>().obs;
  final http.Client client = http.Client();
  Future getPaymentGuide() async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/blocks?type=PAYMENT_GUIDE_BCA_VA"),
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

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

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
}
