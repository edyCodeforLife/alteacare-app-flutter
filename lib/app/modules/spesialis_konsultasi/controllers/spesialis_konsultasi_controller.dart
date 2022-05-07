// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/data/model/address.dart';
import 'package:altea/app/data/model/cms_block_model.dart';
import 'package:altea/app/data/model/doctor_schedules.dart';
import 'package:altea/app/data/model/patient_data_model.dart';
import 'package:altea/app/data/model/search_doctor.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';

class SpesialisKonsultasiController extends GetxController with SingleGetTickerProviderMixin {
  final http.Client client = http.Client();

  RxMap<String, dynamic> selectedDoctorData = Map<String, dynamic>().obs;
  final String? doctorIdFromParam;
  SpesialisKonsultasiController({this.doctorIdFromParam}) {
    if (GetPlatform.isWeb) {
      // print("doctor id from param + $doctorIdFromParam");
      if (doctorIdFromParam != null) {
        if (doctorIdFromParam!.isNotEmpty) {
          getDoctorInfoWWW(doctorIdFromParam!);
          // getDoctorSchedule(doctorId: doctorIdFromParam!, date: DateTime.now().toString());
        }
      }
    }
  }
  final HomeController homeController = Get.find();

  final Rx<SpesialisKonsultasiState> _state = SpesialisKonsultasiState.ok.obs;
  SpesialisKonsultasiState get state => _state.value;

  RxBool isReadmore = false.obs;
  RxString fullAddress = ''.obs;
  RxInt maxLines = 0.obs;
  RxBool isLoading = false.obs;
  RxString selectedTime = ''.obs;
  RxString selectedDoctor = ''.obs;
  RxString consultBy = "Video Call".obs;
  RxString doctorName = ''.obs;
  RxString doctorAvatar = ''.obs;
  RxString doctorSpecialist = ''.obs;
  RxString doctorPrice = ''.obs;
  RxString accessTokens = ''.obs;
  Rx<DataDoctorSchedule> selectedDoctorTime = DataDoctorSchedule().obs;
  RxString selectedAddress = ''.obs;
  RxString selectedUid = ''.obs;
  RxBool scheduleLoad = false.obs;
  RxBool needUpdated = false.obs;
  RxString appointmentId = ''.obs;
  Rx<Patient> selectedPatientData = Patient(
    id: "",
    refId: "",
    familyRelationType: null,
    firstName: "",
    lastName: "",
    email: "",
    phone: "",
    gender: "",
    birthCountry: null,
    birthPlace: "",
    birthDate: DateTime.now(),
    age: null,
    nationality: null,
    street: "",
    rtRw: "",
    country: null,
    province: null,
    city: null,
    district: null,
    subDistrict: null,
    cardType: "",
    cardId: "",
    cardPhoto: "",
    addressId: "",
    externalPatientId: "",
    insurance: "",
    status: "",
    isValid: false,
  ).obs;
  RxBool toMemo = false.obs;

  Rx<Doctor> doctorInfo = Doctor().obs;

  RxList<DateTime> listDate = <DateTime>[].obs;
  List<String> tabDesktopMenuDoctorProfile = <String>['Konsultasi', 'Terms & Conditions'];

  RxString selectedPatient = ''.obs;
  RxString selectedPatientName = ''.obs;

  RxList<bool> isDisabled = <bool>[].obs;

  RxString selectDate = ''.obs;
  late TabController tabController;

  RxList<String> menus = <String>["Cari Spesialis"].obs;

  void getTodayPlusSeven() {
    for (var i = 0; i < 7; i++) {
      final DateTime hariIni = DateTime.now();

      if (i == 0) {
        listDate.add(hariIni);
      } else {
        final DateTime otherDay = DateTime.now().add(Duration(days: i));
        listDate.add(otherDay);
      }
    }
  }

  Future<DoctorSchedules> getDoctorSchedule({required String doctorId, required String date}) async {
    _state.value = SpesialisKonsultasiState.loading;
    if (needUpdated.value) {
      scheduleLoad.value = true;
    }
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/doctor-schedules?doctor_id=$doctorId&date=$date"),
      );
      // print("get doctor schedule");
      // print(response.body);
      if (needUpdated.value) {
        scheduleLoad.value = false;
        needUpdated.value = false;
      }
      if (response.statusCode == 200) {
        _state.value = SpesialisKonsultasiState.ok;

        return DoctorSchedules.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        _state.value = SpesialisKonsultasiState.ok;

        return DoctorSchedules.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      if (needUpdated.value) {
        scheduleLoad.value = false;
        needUpdated.value = false;
      }
      _state.value = SpesialisKonsultasiState.error;

      // print("masuk catch $e");
      return DoctorSchedules.fromJsonErrorCatch(e.toString());
    }
  }

  Future<void> checkDoctorNoSchedule({required String doctorId}) async {
    isDisabled.value = [];
    isLoading.value = true;
    for (var i = 0; i < listDate.length; i++) {
      final dateCheck = DateFormat('yyyy-MM-dd').format(listDate[i]);

      final DoctorSchedules result = await getDoctorSchedule(doctorId: doctorId, date: dateCheck);
      if (result.data == null) print("get doctor schedule data kok null");
      if (result.data!.isNotEmpty) {
        isDisabled.add(result.status!);
      } else {
        if (dateCheck == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          isDisabled.add(true);
        } else {
          isDisabled.add(result.status!);
        }
      }
    }
    isLoading.value = false;
  }

  void onTap() {
    if (isDisabled[tabController.index] == false) {
      final int index = tabController.previousIndex;
      tabController.index = index;
      update();
    }
  }

  Future<Address> checkAddress() async {
    try {
      final response = await client.get(
        Uri.parse(
          "$alteaURL/user/address",
        ),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $accessTokens"},
      );

      if (response.statusCode == 200) {
        // print('hasil 200 => ${response.body}');
        return Address.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return Address.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return Address.fromJsonErrorCatch(e.toString());
    }
  }

  Future<void> getDoctorInfoWWW(String doctorId) async {
    _state.value = SpesialisKonsultasiState.loading;

    //doctor info val
    homeController.menus.value = ["Cari Spesialis"];
    try {
      final response = await client.get(
        Uri.parse(
          "$alteaURL/data/doctors?id=$doctorId",
        ),
        headers: {
          "Content-Type": "application/json",
        },
      );
      // print("$alteaURL/data/doctors?id=$doctorId");
      // print(response.body);

      if (response.statusCode == 200) {
        // print('hasil 200 => ${response.body}');
        if ((jsonDecode(response.body)['data'] as List).isNotEmpty) {
          _state.value = SpesialisKonsultasiState.ok;

          doctorInfo.value = Doctor.fromJson(jsonDecode(response.body)['data'][0] as Map<String, dynamic>);
        }
      } else {
        _state.value = SpesialisKonsultasiState.ok;

        Get.toNamed("/err_404");
      }
    } catch (e) {
      _state.value = SpesialisKonsultasiState.error;

      Get.toNamed("/err_404");

      // print("masuk catch $e");
    }
  }

  final Rxn<CMSBlock> _tncBlock = Rxn<CMSBlock>();
  CMSBlock? get tncBlock => _tncBlock.value;

  Future<void> getTNCBlock() async {
    try {
      final response = await client.get(
        Uri.parse(
          "$alteaURL/data/blocks?type=TERM_REFUND_CANCEL",
        ),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // print('hasil 200 => ${response.body}');
        _tncBlock.value = CMSBlock.fromJson(jsonDecode(response.body)['data'][0] as Map<String, dynamic>);
      } else {}
    } catch (e) {
      // print("masuk catch $e");
    }
  }

  @override
  void onInit() {
    initializeDateFormatting();

    super.onInit();
  }

  @override
  void onReady() {
    getTodayPlusSeven();
    getTNCBlock();

    tabController = TabController(vsync: this, length: listDate.length);
    tabController.addListener(onTap);
    selectDate.value = DateFormat("yyyy-MM-dd").format(listDate[tabController.index]);
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

enum SpesialisKonsultasiState { ok, loading, error }
