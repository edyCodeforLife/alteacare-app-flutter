// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/data/model/patient_data_model.dart';
import 'package:altea/app/modules/my_consultation_detail/models/my_consultation_detail_model.dart' as mcdm;
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/use_shared_pref.dart';

class OnboardCallController extends GetxController {
  //TODO: Implement OnboardCallController
  final http.Client client = http.Client();

  final Rx<OnboardCallState> _state = OnboardCallState.ok.obs;
  OnboardCallState get state => _state.value;
  String? orderIdFromParam;
  final PatientDataController patientDataController = Get.find<PatientDataController>();

  OnboardCallController({this.orderIdFromParam}) {
    // if (GetPlatform.isWeb) {
    //   initOnboardCallForWeb();
    // }
  }

  Future<void> initOnboardCallForWeb() async {
    // print("INIT ONBOARD CALL FROM WEBBBBB");
    if (orderIdFromParam != null) {
      if (orderIdFromParam!.isNotEmpty) {
        setSelectedPatientDataFromOrderId(orderIdFromParam!);
      } else {
        Future.delayed(Duration.zero, () {
          Get.offAndToNamed("/err_404");
        });
      }
    } else {
      Future.delayed(Duration.zero, () {
        Get.offAndToNamed("/err_404");
      });
    }
  }

  Rxn<mcdm.MyConsultationDetail> _mcdmForOnboardCall = Rxn<mcdm.MyConsultationDetail>();
  mcdm.MyConsultationDetail? get mcdmForOnboardCall => _mcdmForOnboardCall.value;
  RxString _patientName = "".obs;
  String get patientName => _patientName.value;

  Future<void> setSelectedPatientDataFromOrderId(String orderId) async {
    _state.value = OnboardCallState.loading;
    final token = AppSharedPreferences.getAccessToken();
    try {
      final response = await client.get(
          Uri.parse(
            // "$alteaURL/appointment/detail/$orderId",
            "$alteaURL/appointment/v1/consultation/$orderId",
          ),
          headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        _mcdmForOnboardCall.value = mcdm.MyConsultationDetail.fromJson(jsonDecode(response.body)['data'] as Map<String, dynamic>);

        if (_mcdmForOnboardCall.value!.patient != null) {
          patientDataController.selectedPatientData.value = Patient(
            firstName: _mcdmForOnboardCall.value!.patient!.firstName,
            lastName: _mcdmForOnboardCall.value!.patient!.lastName,
            id: _mcdmForOnboardCall.value!.patient!.id,
          );
          _patientName.value = "${_mcdmForOnboardCall.value!.patient!.firstName} ${_mcdmForOnboardCall.value!.patient!.lastName}";
        } else {
          Future.delayed(Duration.zero, () {
            // print("onboard ctrl pasien nda ada");

            Get.offAndToNamed("/err_404");
          });
        }
        _state.value = OnboardCallState.ok;
      } else {
        _state.value = OnboardCallState.error;

        Future.delayed(Duration.zero, () {
          // print("onboard ctrl pasien 500");

          Get.offAndToNamed("/err_404");
        });
      }
    } catch (e) {
      _state.value = OnboardCallState.error;

      Future.delayed(Duration.zero, () {
        Get.offAndToNamed("/err_404");
      });
    }
  }

  mcdm.MyConsultationDetail? mcdmForCheck;
  RxBool _isMyConsultationStatusOK = false.obs;
  bool get isMyConsultationOk => _isMyConsultationStatusOK.value;

  Future<void> checkMtConsultationStatusForNTimes({required String status, required int times, required String orderId}) async {
    _isMyConsultationStatusOK.value = false;
    _state.value = OnboardCallState.loading;
    final token = AppSharedPreferences.getAccessToken();
    for (int i = 0; i < times; i++) {
      try {
        Future.delayed(const Duration(seconds: 3), () async {
          final response = await client.get(
              Uri.parse(
                // "$alteaURL/appointment/detail/$orderId",
                "$alteaURL/appointment/v1/consultation/$orderId",
              ),
              headers: {"Authorization": "Bearer $token"});
          if (response.statusCode == 200) {
            mcdmForCheck = mcdm.MyConsultationDetail.fromJson(jsonDecode(response.body)['data'] as Map<String, dynamic>);
            if (mcdmForCheck!.status == status) {
              _isMyConsultationStatusOK.value = true;
              _state.value = OnboardCallState.ok;
            }
          } else {}
        });
      } catch (e) {
        _isMyConsultationStatusOK.value = false;
      }
    }
    _state.value = OnboardCallState.ok;
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
}

enum OnboardCallState { ok, loading, error }
