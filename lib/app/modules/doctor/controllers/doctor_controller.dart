// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Project imports:
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:altea/app/data/model/doctor_category_specialist.dart' as doctorSpecialist;
import 'package:altea/app/data/model/doctors.dart';
import 'package:altea/app/data/model/hospital.dart' as hospital;
import 'package:altea/app/modules/home/controllers/home_controller.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/settings.dart';

class DoctorController extends GetxController {
  final homeController = Get.find<HomeController>();
  final http.Client client = http.Client();

  final spesialisAnakId = "607d01ca3925ca001231fae3"; // -> untuk handle refresh di page doctor specialist

  RxBool isLoading = false.obs;
  RxBool isShowMoreSpesialisFilterSlidingPanel = false.obs;
  RxBool isShowMoreHospitalFilterSlidingPanel = false.obs;

  RxList<doctorSpecialist.Datum> spesialisMenus = <doctorSpecialist.Datum>[].obs;

  RxList<doctorSpecialist.Datum> spesialisMenusOther = <doctorSpecialist.Datum>[].obs;

  RxList<doctorSpecialist.Datum> allSpecialistList = <doctorSpecialist.Datum>[].obs;
  RxList<hospital.Datum> allHospital = <hospital.Datum>[].obs;

  final List<String> sort = <String>["Harga Tertinggi", "Harga Terendah", "Pengalaman Terlama", "Pengalaman Terbaru"];

  final RxList<doctorSpecialist.Datum> dokterSpesialisFilter = <doctorSpecialist.Datum>[].obs;
  final RxList<doctorSpecialist.Datum> dokterSpesialisFilterMobile = <doctorSpecialist.Datum>[doctorSpecialist.Datum(name: "Filter")].obs;
  final List<String> allHospitalFilterName = ["Semua"];
  final List<String> hargaFilter = [
    "Semua harga",
    "10rb - 100rb",
    "100rb - 200rb",
    "200rb - 500rb",
  ];

  RxList<DatumDoctors> listFilteredDoctor = <DatumDoctors>[].obs;

  Rx<doctorSpecialist.Datum> selectedSpesialis = doctorSpecialist.Datum().obs;

  RxString selectedDoctorFilter = "".obs;
  RxString selectedHospitalFilter = "Semua".obs;
  RxString selectedHargaFilter = "Semua harga".obs;

  RxString selectedDoctorIdFilter = "".obs;
  RxString selectedHospitalIdFilter = "".obs;
  RxString selectedLowPriceFilter = "".obs;
  RxString selectedHighPriceFilter = "".obs;

  RxString valueChoose = ''.obs;
  String hintTextSort = 'Urutkan';
  RxBool isShowMoreDoctorFilter = false.obs;
  RxBool isShowMoreHospitalFilter = false.obs;

  Future<doctorSpecialist.DoctorSpecialistCategory> getDoctorsPopularCategory() async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/specializations/?is_popular=YES"),
      );

      if (response.statusCode == 200) {
        return doctorSpecialist.DoctorSpecialistCategory.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return doctorSpecialist.DoctorSpecialistCategory.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return doctorSpecialist.DoctorSpecialistCategory.fromJsonErrorCatch(e.toString());
    }
  }

  Future<doctorSpecialist.DoctorSpecialistCategory> getDoctorsOthersCategory() async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/specializations/"),
      );

      if (response.statusCode == 200) {
        return doctorSpecialist.DoctorSpecialistCategory.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return doctorSpecialist.DoctorSpecialistCategory.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return doctorSpecialist.DoctorSpecialistCategory.fromJsonErrorCatch(e.toString());
    }
  }

  Future getOngoingAppointment() async {
    try {
      var token = AppSharedPreferences.getAccessToken();
      final response = await client.post(
          Uri.parse(
            // "$alteaURL/appointment/on-going",
            "$alteaURL/appointment/v1/consultation/ongoing",
          ),
          body: jsonEncode({
            "date_start": "",
            "date_end": "",
            "doctor_id": "",
            "user_id": "",
            "consultation_method": "",
            "hospital_id": "",
            "specialist_id": "",
            "status": ["MEET_SPECIALIST"],
          }),
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"});

      return jsonDecode(response.body);
      // print('balikan => ${response.statusCode} : ${response.body}');
    } catch (e) {
      // print('error => $e');
    }
  }

  Future<Doctors> searchDoctor(String query) async {
    try {
      final response = await client.get(
        Uri.parse(
          "$alteaURL/data/doctors?_q=$query",
        ),
      );

      // print('search url di controller => ${"$alteaURL/data/doctors?_q=$query"}');
      // print('balikan => ${response.statusCode} : ${response.body}');
      if (response.statusCode == 200) {
        // print('masuk 200');
        return Doctors.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // print('masuk $response.body');
        return Doctors.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return Doctors.fromJsonErrorCatch(e.toString());
    }
  }

  Future<Doctors> getDoctorsBySpesialisAndQuery(String query, String id) async {
    try {
      final response = await client.get(
        Uri.parse(
          "$alteaURL/data/doctors?_q=$query&specialis.id_in=$id",
        ),
      );

      // print('balikan => ${response.statusCode} : ${response.body}');
      if (response.statusCode == 200) {
        // print('masuk 200');
        return Doctors.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // print('masuk $response.body');
        return Doctors.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return Doctors.fromJsonErrorCatch(e.toString());
    }
  }

  Future<hospital.Hospital> getHospitalListFilter() async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/hospitals?_sort=name:asc"),
      );

      if (response.statusCode == 200) {
        return hospital.Hospital.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return hospital.Hospital.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return hospital.Hospital.fromJsonErrorCatch(e.toString());
    }
  }

  Future getHospitals() async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/hospitals?_sort=name:asc"),
      );

      // print('hospitals json => ${jsonDecode(response.body)}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // print("masuk catch $e");
      return hospital.Hospital.fromJsonErrorCatch(e.toString());
    }
  }

  Future<Doctors> getDoctorListBySpecializationChooseHospitalAndChoosePriceFilter(
      {required String selectedDoctorFilterId,
      required String selectedHospitalFilterId,
      required String selectedLowPrice,
      required String selectedHighPrice}) async {
    try {
      final response = await client.get(
        Uri.parse(
          "$alteaURL/data/doctors?specialis.id_in=$selectedDoctorFilterId&hospital.id_in=$selectedHospitalFilterId&price_lte=$selectedHighPrice&price_gte=$selectedLowPrice",
        ),
      );
      // print(
      // "$alteaURL/data/doctors?specialis.id_in=$selectedDoctorFilterId&hospital.id_in=$selectedHospitalFilterId&price_lte=$selectedHighPrice&price_gte=$selectedLowPrice");
      if (response.statusCode == 200) {
        // log(response.body);

        return Doctors.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return Doctors.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return Doctors.fromJsonErrorCatch(e.toString());
    }
  }

  Future getDoctorsByQuery({required String query}) async {
    try {
      final response = await client.get(Uri.parse("$alteaURL/data/doctors?_q=$query"));

      // log('balikan search dokter => ${response.statusCode} : ${response.body}');

      return jsonDecode(response.body)['data'];
    } catch (e) {
      return Doctors.fromJsonErrorCatch(e.toString());
    }
  }

  Future<Doctors> getDoctorListBySpecializationAndAllHospitalFilter({required String selectedDoctorFilterId}) async {
    try {
      final response = await client.get(
        Uri.parse(
          "$alteaURL/data/doctors?specialis.id_in=$selectedDoctorFilterId",
        ),
      );
      // print(
      //   "$alteaURL/data/doctors?specialis.id_in=$selectedDoctorFilterId",
      // );

      // print('balikan => ${response.statusCode} : ${response.body}');
      if (response.statusCode == 200) {
        // print('masuk 200');
        // log(selectedDoctorFilterId);
        // log(response.body);
        return Doctors.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // print('masuk $response.body');

        return Doctors.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");

      return Doctors.fromJsonErrorCatch(e.toString());
    }
  }

  Future<Doctors> getDoctorListBySpecializationAllHospitalAndChoosePriceFilter(
      {required String selectedDoctorFilterId, required String selectedLowPrice, required String selectedHighPrice}) async {
    try {
      final response = await client.get(
        Uri.parse(
          "$alteaURL/data/doctors?specialis.id_in=$selectedDoctorFilterId&price_lte=$selectedHighPrice&price_gte=$selectedLowPrice",
        ),
      );
      // print("$alteaURL/data/doctors?specialis.id_in=$selectedDoctorFilterId&price_lte=$selectedHighPrice&price_gte=$selectedLowPrice");
      log(response.body);

      if (response.statusCode == 200) {
        return Doctors.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return Doctors.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return Doctors.fromJsonErrorCatch(e.toString());
    }
  }

  Future<Doctors> getDoctorFilteredAndSorted(String url) async {
    // print('ini url => $url');
    try {
      final response = await client.get(
        Uri.parse(url),
      );

      // print('balikan => ${response.statusCode} : ${response.body}');
      if (response.statusCode == 200) {
        // print('masuk 200');
        // print('response body : ${response.body}');
        return Doctors.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // print('masuk $response.body');
        return Doctors.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return Doctors.fromJsonErrorCatch(e.toString());
    }
  }

  Future<Doctors> getDoctorListBySpecializationAndChooseHospital({
    required String selectedDoctorFilterId,
    required String selectedHospitalFilterId,
  }) async {
    try {
      final response = await client.get(
        Uri.parse(
          "$alteaURL/data/doctors?specialis.id_in=$selectedDoctorFilterId&hospital.id_in=$selectedHospitalFilterId",
        ),
      );

      if (response.statusCode == 200) {
        return Doctors.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return Doctors.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return Doctors.fromJsonErrorCatch(e.toString());
    }
  }

  void onEntered({required bool isHovered, required int index, required int specialistType}) {
    if (isHovered && specialistType == 0) {
      selectedSpesialis.value = spesialisMenus[index];
    } else if (isHovered && specialistType == 1) {
      selectedSpesialis.value = spesialisMenusOther[index];
    } else {
      selectedSpesialis.value = doctorSpecialist.Datum();
    }
  }

  void refreshController() {
    // remove filter select when back
    selectedDoctorIdFilter.value = "";
    selectedDoctorFilter = "".obs;
    selectedHospitalIdFilter.value = "";
    selectedHospitalFilter.value = "Semua";
    selectedHighPriceFilter.value = "";
    selectedLowPriceFilter.value = "";
    selectedHargaFilter.value = "Semua harga";
    valueChoose.value = "";
  }

  @override
  Future<void> onInit() async {
    if (GetPlatform.isWeb) {
      // print("arguments yg didapat : ");
      // print(Get.arguments.toString());
      try {
        final doctorSpecialist.Datum dd = Get.arguments as doctorSpecialist.Datum;
        selectedSpesialis.value = dd;
        selectedDoctorIdFilter.value = dd.specializationId.toString();
        selectedDoctorFilter.value = dd.name.toString();
        final Doctors result = await getDoctorListBySpecializationAndAllHospitalFilter(selectedDoctorFilterId: selectedDoctorIdFilter.value);
        listFilteredDoctor.value = result.data!;
      } catch (e) {
        // print("fail to pass arguments - doctor specialist $e");
      }
    }
    isLoading.value = true;
    final doctorSpecialist.DoctorSpecialistCategory result = await getDoctorsPopularCategory();
    final doctorSpecialist.DoctorSpecialistCategory otherResult = await getDoctorsOthersCategory();

    final hospital.Hospital hospitalList = await getHospitalListFilter();

    spesialisMenus.value = result.data!;
    allSpecialistList.value = otherResult.data!;

    // print("DATA LENGTH HOSPITAL ${hospitalList.data!.length}");
    if (hospitalList.data != null) {
      allHospital.value = hospitalList.data!;
    }

    for (final doctorSpecialist.Datum item in allSpecialistList) {
      dokterSpesialisFilter.value = allSpecialistList;
      dokterSpesialisFilterMobile.add(item);
    }

    for (final doctorSpecialist.Datum item in otherResult.data!) {
      if (item.isPopular == false) {
        spesialisMenusOther.add(item);
      }
    }

    for (final hospital.Datum item in allHospital) {
      allHospitalFilterName.add(item.name!);
    }

    /// kondisi ini dipanggil ketika page docter specialist di refresh, agar tidak null
    if (homeController.menus.isEmpty) {
      // ini buat add breadcrumbnya
      homeController.menus.add("Dokter Spesialis");
      homeController.menus.add("Spesialis Anak");

      // set ID specialist
      selectedDoctorIdFilter.value = spesialisAnakId;
      selectedDoctorFilter.value = "Anak";

      // Load data dokter , default adalah anak
      final Doctors result = await getDoctorListBySpecializationAndAllHospitalFilter(selectedDoctorFilterId: selectedDoctorIdFilter.value);

      listFilteredDoctor.value = result.data!;
    }

    isLoading.value = false;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    spesialisMenus.value = homeController.doctorCategory.toList();
  }

  @override
  void onClose() {}
}
