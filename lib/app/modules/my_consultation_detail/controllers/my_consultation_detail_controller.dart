// Dart imports:
import 'dart:convert';

import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/my_consultation_detail/models/my_consultation_detail_model.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/settings.dart';
import '../../../core/utils/use_shared_pref.dart';
import '../../../data/model/my_consultation_detail_model.dart';

class MyConsultationDetailController extends GetxController with SingleGetTickerProviderMixin {
  final http.Client client = http.Client();
  String? orderIdFromParam;

  MyConsultationDetailController({this.orderIdFromArgs}) {
    if (orderIdFromArgs != null) {
      if (GetPlatform.isWeb && orderIdFromArgs!.isNotEmpty) {
        // print("order id from param : $orderIdFromArgs");
        if (orderIdFromArgs != "") {
          Get.lazyPut<PatientDataController>(
            () => PatientDataController(),
          );
          orderId.value = orderIdFromArgs!;
          getDataConsultationDetailWeb02();
        }
      } else {
        // print("order id from args nda ada ????????????????");
      }
    } else {
      // print("order id from args nda ada");
    }
  }
  String? orderIdFromArgs;

  Rx<DataMyConsultationDetail> dataMyConsultationDetail = DataMyConsultationDetail().obs;
  final HomeController homeController = Get.find<HomeController>();
  Map<String, dynamic> data = {};

  final Rxn<MyConsultationDetail> _myConsultationDetail = Rxn<MyConsultationDetail>();
  MyConsultationDetail? get myConsultationDetail => _myConsultationDetail.value;
  Rx<MyConsultationDetailState> _state = MyConsultationDetailState.ok.obs;
  MyConsultationDetailState get state => _state.value;

  Future<Map<String, dynamic>> getDataConsultationDetailWeb() async {
    final token = AppSharedPreferences.getAccessToken();
    // print("order id -> $orderId");
    final PatientDataController _patientDataController = Get.find<PatientDataController>();

    try {
      final response = await client.get(
          Uri.parse(
            // "$alteaURL/appointment/detail/$orderId",
            "$alteaURL/appointment/v1/consultation/$orderId",
          ),
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"});
      // print("$alteaURL/appointment/detail/$orderId");
      if (response.statusCode == 200) {
        String code = "";
        try {
          code = jsonDecode(response.body)['data']['order_code'].toString();
        } catch (e) {}
        homeController.menus.value = ["Konsultasi Saya", "Order ID: $code"];
        if (jsonDecode(response.body)['data']['transaction'] == null &&
            (jsonDecode(response.body)['data']['status'].toString().toLowerCase().contains("new"))) {
          final String orderId = jsonDecode(response.body)['data']['id'].toString();
          // print("my consul controller -- transaction null");
          Get.toNamed("/onboard-call?orderId=$orderId");
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        // print("my consul controller -- not 200");

        Get.toNamed("/err_404");

        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      // print("my consul controller -- 500??");

      Get.toNamed("/err_404");
      return {};
    }
  }

  Future<void> getDataConsultationDetailWeb02() async {
    _state.value = MyConsultationDetailState.loading;
    final token = AppSharedPreferences.getAccessToken();
    // print("order id -> $orderId");

    try {
      final response = await client.get(
          Uri.parse(
            // "$alteaURL/appointment/detail/$orderId",
            "$alteaURL/appointment/v1/consultation/$orderId",
          ),
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"});
      // print("$alteaURL/appointment/detail/$orderId");

      if (response.statusCode == 200) {
        // print("get consultation");
        _myConsultationDetail.value = MyConsultationDetail.fromJson(jsonDecode(response.body)['data'] as Map<String, dynamic>);
        data = jsonDecode(response.body) as Map<String, dynamic>;

        // print('get patient id');
        // print("appointment id : ${myConsultationDetail!.id.toString()}");

        // print("dokter : ${myConsultationDetail!.doctor!.name}");
        // await _patientDataController.setPatientFromId(myConsultationDetail!.patientId);
        if (_myConsultationDetail.value!.transaction == null && _myConsultationDetail.value!.status.toLowerCase().contains('new')) {
          final String orderId = _myConsultationDetail.value!.id.toString();
          Get.toNamed("/onboard-call?orderId=$orderId");
        }
        // print('yihuy');

        _state.value = MyConsultationDetailState.ok;

        // return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        // print("get data consul web 02 not found?");
        Get.toNamed("/err_404");
        _state.value = MyConsultationDetailState.ok;
        _myConsultationDetail.value = null;
      }
    } catch (e) {
      // print("get data consul web 500");
      // print(e.toString());
      Get.toNamed("/err_404");

      _state.value = MyConsultationDetailState.error;
      _myConsultationDetail.value = null;
      // print(e);
    }
  }

  RxString orderId = "".obs;
  List<String> tabMenuMyConsultationDetail = <String>[
    'Data Pasien',
    'Memo Altea',
    'Dokumen Medis',
    'Biaya',
  ];
  late TabController tabController;
  RxBool isExpanded = false.obs;
  UniqueKey keyTile = UniqueKey();
  RxBool isExpandedTile = false.obs;

  void expandTile() {
    isExpandedTile.value = true;
    keyTile = UniqueKey();
    update();
  }

  void shrinkTile() {
    isExpandedTile.value = false;
    keyTile = UniqueKey();
    update();
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

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "00:$twoDigitMinutes:$twoDigitSeconds";
  }

  RxList<Map<String, dynamic>> uploadedByUser = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> uploadByAltea = <Map<String, dynamic>>[].obs;
  RxMap<String, dynamic> newDocument = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: tabMenuMyConsultationDetail.length);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}

enum MyConsultationDetailState { ok, loading, error }
