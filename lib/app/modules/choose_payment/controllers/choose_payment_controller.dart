// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:altea/app/data/model/payment.dart';
import 'package:altea/app/data/model/payment_type.dart';
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';

class ChoosePaymentController extends GetxController {
  //TODO: Implement ChoosePaymentController
  final http.Client client = http.Client();
  RxBool fromConsultationDetail = false.obs;
  RxBool fromConsultationPayment = false.obs;
  Future getDetailAppointment(String appointmentId, bool goToCall) async {
    try {
      var token = AppSharedPreferences.getAccessToken();
      final response = await client.get(
          Uri.parse(
            // "$alteaURL/appointment/detail/$appointmentId",
            "$alteaURL/appointment/v1/consultation/$appointmentId",
          ),
          headers: {"Authorization": "Bearer $token"});
      log('statusCode => ${response.statusCode} : ${response.body}');

      if (response.statusCode == 200) {
        // print('status di controller => ${jsonDecode(response.body)['data']['id']}');
        if (goToCall) {
          if (jsonDecode(response.body)['data']['status'] == 'NEW') {
            Get.put(PatientConfirmationController());

            SpesialisKonsultasiController controller = Get.put(SpesialisKonsultasiController());
            controller.appointmentId.value = jsonDecode(response.body)['data']['id'].toString();
            controller.selectedPatientName.value = jsonDecode(response.body)['data']['patient']['name'].toString();
            fromConsultationDetail.value = true;

            // print('ini appointment id yg di tuju dari controller => ${controller.appointmentId.value}');
            Get.toNamed('/call-screen');
          }
        }

        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // print("masuk catch $e");
      return e.toString();
    }
  }

  // Stream getDetailAppointmentStream(String appointmentId) async* {
  //   try {
  //     var token = AppSharedPreferences.getAccessToken();
  //     final response = await client.get(
  //         Uri.parse("$alteaURL/appointment/detail/$appointmentId"),
  //         headers: {"Authorization": "Bearer $token"});
  //     // print('statusCode => ${response.statusCode} : ${response.body}');

  //     if (response.statusCode == 200) {
  //       yield jsonDecode(response.body);
  //     } else {
  //       yield jsonDecode(response.body);
  //     }
  //   } catch (e) {
  //     // print("masuk catch $e");
  //     yield e.toString();
  //   }
  // }

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

  Future<Payment> createPayment(int appId, String method) async {
    try {
      final token = AppSharedPreferences.getAccessToken();
      final response = await client.post(
          Uri.parse(
            // "$alteaURL/appointment/pay",
            "$alteaURL/appointment/v1/payment",
          ),
          body: jsonEncode({"appointment_id": appId, "method": method}),
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"});
      // print('statusCode => ${response.statusCode} : ${response.body}');

      if (response.statusCode == 200) {
        return Payment.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {}
      return Payment.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      // print("masuk catch $e");
      return Payment.fromJsonErrorCatch(e.toString());
    }
  }

  Future createPaymentNonModel(int appId, String method) async {
    try {
      var token = AppSharedPreferences.getAccessToken();
      final response = await client.post(
          Uri.parse(
            // "$alteaURL/appointment/pay",
            "$alteaURL/appointment/v1/payment",
          ),
          body: jsonEncode({"appointment_id": appId, "method": method}),
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"});
      print('statusCode => ${response.statusCode} : ${response.body}');

      return jsonDecode(response.body);
      // if (response.statusCode == 200) {
      //   return Payment.fromJson(
      //       jsonDecode(response.body) as Map<String, dynamic>);
      // } else {}
      // return Payment.fromJsonError(
      //     jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      // print("masuk catch $e");
      return e.toString();
    }
  }

  Future<PaymentType> getPaymentTypesModel() async {
    try {
      var token = AppSharedPreferences.getAccessToken();
      final response = await client.get(
        Uri.parse("$alteaURL/data/payment-types"),
        // headers: {"Authorization": "Bearer $token"}
      );
      // print('statusCode => ${response.statusCode} : ${response.body}');
      if (response.statusCode == 200) {
        return PaymentType.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return PaymentType.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return PaymentType.fromJsonErrorCatch(e.toString());
    }
  }

  Rx<PaymentMethod> isChoosePayment = PaymentMethod().obs;

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

  Rx<Payment> resultPayment = Payment().obs;

  final count = 0.obs;

  String ccType = "MIDTRANS_SNAP";
  String vaType = "ALTEA_PAYMENT_WEBVIEW";

  String providerPaymentVa = "MIDTRANS";

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
}
