// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:altea/app/data/model/add_user_address.dart';
import 'package:altea/app/data/model/city.dart' as cities;
import 'package:altea/app/data/model/country.dart' as country;
import 'package:altea/app/data/model/district.dart' as districts;
import 'package:altea/app/data/model/list_address.dart';
import 'package:altea/app/data/model/patient_family_type.dart';
import 'package:altea/app/data/model/province.dart';
import 'package:altea/app/data/model/subdistrict.dart' as subdistricts;
import 'package:altea/app/modules/home/controllers/home_controller.dart';

class AddPatientController extends GetxController {
  final homeController = Get.find<HomeController>();
  RxInt currentIdx = 0.obs;
  final http.Client client = http.Client();
  RxString selectedPatient = ''.obs;
  RxString familyRelation = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString idNo = ''.obs;
  RxString birthDate = ''.obs;
  RxString nation = ''.obs;
  RxString birthTown = ''.obs;
  RxString gender = ''.obs;
  RxString selectedAddress = ''.obs;
  RxString selectedAddressString = ''.obs;
  RxInt selectedAddressCard = (-1).obs;
  RxString familyTypeId = ''.obs;
  RxString countryId = ''.obs;
  RxString birthCountry = ''.obs;
  RxString birthPlace = ''.obs;
  RxString cardId = ''.obs;
  RxString addressId = ''.obs;
  RxString street = ''.obs;
  RxBool isTambahAlamatSelected = false.obs;
  RxString alamat = ''.obs;

  RxString provinceId = ''.obs;
  RxString cityId = ''.obs;
  RxString districtId = ''.obs;
  RxString subdistrictId = ''.obs;
  RxString rtRw = ''.obs;

  RxString rtrw = ''.obs;
  RxString familyName = ''.obs;
  RxString fullAddress = ''.obs;

  RxBool confirmSelected = false.obs;

  RxInt age = 0.obs;

  RxList<country.DatumCountry> listNationForAddress = <country.DatumCountry>[].obs;
  RxList<DatumProvince> listProvince = <DatumProvince>[].obs;
  RxList<cities.DatumCity> listCity = <cities.DatumCity>[].obs;
  RxList<districts.DatumDistrict> listDistrict = <districts.DatumDistrict>[].obs;
  RxList<subdistricts.DatumSubDistrict> listSubdistrict = <subdistricts.DatumSubDistrict>[].obs;

  RxList<FamilyDatumType> listFamilyType = <FamilyDatumType>[].obs;
  RxList<country.DatumCountry> listNation = <country.DatumCountry>[].obs;
  RxList<String> genderType = <String>["MALE", "FEMALE"].obs;
  Future<PatientFamilyType> getFamilyType(String accessTokens) async {
    try {
      var token = AppSharedPreferences.getAccessToken();
      final response = await client.get(
        Uri.parse("$alteaURL/data/family-relation-types"),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
      );

      // print('family type => ${response.statusCode} : ${response.body}');

      if (response.statusCode == 200) {
        return PatientFamilyType.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return PatientFamilyType.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      return PatientFamilyType.fromJsonErrorCatch(e.toString());
    }
  }

  Future<country.Country> getCountry() async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/countries?_limit=2000"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return country.Country.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return country.Country.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      return country.Country.fromJsonErrorCatch(e.toString());
    }
  }

  Future updateAddress(String patientId, String addressId) async {
    // print('address id from update => $addressId from $patientId');
    try {
      var token = AppSharedPreferences.getAccessToken();
      final response = await client.post(Uri.parse("$alteaURL/user/patient/$patientId"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"}, body: jsonEncode({"address_id": addressId}));

      // print('update patient address => ${response.statusCode} : ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future addFamily() async {
    try {
      var token = AppSharedPreferences.getAccessToken();
      final response = await client.post(Uri.parse("$alteaURL/user/patient"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
          body: jsonEncode({
            "family_relation_type": familyRelation.value,
            "first_name": firstName.value,
            "last_name": lastName.value,
            "birth_date": birthDate.value,
            "birth_country": nation.value,
            "birth_place": birthTown.value,
            "gender": gender == 'Perempuan' ? 'FEMALE' : 'MALE',
            "nationality": nation.value,
            "card_id": idNo.value,
            "address_id": selectedAddress.value
          }));

      // print('family type => ${response.statusCode} : ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future addFamilyWeb(String accessTokens, Map<String, dynamic> dataPatient) async {
    try {
      final response = await client.post(Uri.parse("$alteaURL/user/patient"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $accessTokens"}, body: jsonEncode(dataPatient));

      // print('family type => ${response.statusCode} : ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future updateNewPatientData(String accessTokens, String patientId, String addressId) async {
    _state.value = AddPatientState.loading;
    try {
      final response = await client.post(Uri.parse("$alteaURL/user/patient/$patientId"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $accessTokens"}, body: jsonEncode({"address_id": addressId}));

      // print('family type => ${response.statusCode} : ${response.body}');

      if (response.statusCode == 200) {
        _state.value = AddPatientState.ok;

        return jsonDecode(response.body);
      } else {
        _state.value = AddPatientState.ok;

        return jsonDecode(response.body);
      }
    } catch (e) {
      _state.value = AddPatientState.ok;

      return e.toString();
    }
  }

  Future<ListAddress> getListAddress(String accessTokens) async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/user/address"),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $accessTokens"},
      );

      if (response.statusCode == 200) {
        return ListAddress.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return ListAddress.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      return ListAddress.fromJsonErrorCatch(e.toString());
    }
  }

  Future<Province> getProvince(String countryId) async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/provinces?country=$countryId"),
      );

      if (response.statusCode == 200) {
        return Province.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return Province.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      return Province.fromJsonErrorCatch(e.toString());
    }
  }

  Future<cities.City> getCity(String provinceId) async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/cities?province=$provinceId"),
      );

      if (response.statusCode == 200) {
        return cities.City.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return cities.City.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      return cities.City.fromJsonErrorCatch(e.toString());
    }
  }

  Future<districts.District> getDistrict(String cityId) async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/districts?city=$cityId"),
      );

      if (response.statusCode == 200) {
        return districts.District.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return districts.District.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      return districts.District.fromJsonErrorCatch(e.toString());
    }
  }

  Future<subdistricts.SubDistrict> getSubDistrict(String districtId) async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/sub-districts?district=$districtId"),
      );

      if (response.statusCode == 200) {
        return subdistricts.SubDistrict.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return subdistricts.SubDistrict.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      return subdistricts.SubDistrict.fromJsonErrorCatch(e.toString());
    }
  }

  Future<AddAddressUser> addAddressss({
    required Map<String, dynamic> dataAddress,
    required String accessTokens,
  }) async {
    _state.value = AddPatientState.loading;
    try {
      final response = await client.post(Uri.parse("$alteaURL/user/address"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $accessTokens"}, body: jsonEncode(dataAddress));

      if (response.statusCode == 200) {
        _state.value = AddPatientState.ok;
        return AddAddressUser.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        _state.value = AddPatientState.ok;
        return AddAddressUser.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      _state.value = AddPatientState.error;
      return AddAddressUser.fromJsonErrorCatch(e.toString());
    }
  }

  RxBool isChooseStep1 = true.obs;
  RxBool isChooseStep2 = false.obs;
  RxBool isChooseStep3 = false.obs;

  RxInt currentStep = 0.obs;

  void refreshThisController() {
    currentIdx = 0.obs;
    selectedPatient = ''.obs;
    familyRelation = ''.obs;
    firstName = ''.obs;
    lastName = ''.obs;
    idNo = ''.obs;
    birthDate = ''.obs;
    nation = ''.obs;
    birthTown = ''.obs;
    gender = ''.obs;
    selectedAddress = ''.obs;
    selectedAddressString = ''.obs;
    selectedAddressCard = (-1).obs;
    familyTypeId = ''.obs;
    countryId = ''.obs;
    birthCountry = ''.obs;
    birthPlace = ''.obs;
    cardId = ''.obs;
    addressId = ''.obs;
    street = ''.obs;
    isTambahAlamatSelected = false.obs;
    alamat = ''.obs;
    provinceId = ''.obs;
    cityId = ''.obs;
    districtId = ''.obs;
    subdistrictId = ''.obs;
    rtRw = ''.obs;
    rtrw = ''.obs;
    familyName = ''.obs;
    fullAddress = ''.obs;
    confirmSelected = false.obs;
    age = 0.obs;
    isChooseStep1 = true.obs;
    isChooseStep2 = false.obs;
    isChooseStep3 = false.obs;
    currentStep = 0.obs;
    listNationForAddress = <country.DatumCountry>[].obs;
    listProvince = <DatumProvince>[].obs;
    listCity = <cities.DatumCity>[].obs;
    listDistrict = <districts.DatumDistrict>[].obs;
    listSubdistrict = <subdistricts.DatumSubDistrict>[].obs;

    listFamilyType = <FamilyDatumType>[].obs;
    listNation = <country.DatumCountry>[].obs;
    genderType = <String>["MALE", "FEMALE"].obs;
  }

  final Rx<AddPatientState> _state = AddPatientState.ok.obs;
  AddPatientState get state => _state.value;

  Future<void> getFamilyTypeWebDesktop(String accessTokens) async {
    _state.value = AddPatientState.loading;
    try {
      var token = AppSharedPreferences.getAccessToken();
      final response = await client.get(
        Uri.parse("$alteaURL/data/family-relation-types"),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
      );

      // print('family type => ${response.statusCode} : ${response.body}');

      if (response.statusCode == 200) {
        listFamilyType.value = PatientFamilyType.fromJson(jsonDecode(response.body) as Map<String, dynamic>).data!;
        _state.value = AddPatientState.ok;
      } else {
        _state.value = AddPatientState.ok;

        listFamilyType.value = [];
      }
    } catch (e) {
      _state.value = AddPatientState.ok;

      listFamilyType.value = [];
      // return PatientFamilyType.fromJsonErrorCatch(e.toString());
    }
  }

  Future<void> getCountryWebDesktop() async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/countries?_limit=2000"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        listNation.value = country.Country.fromJson(jsonDecode(response.body) as Map<String, dynamic>).data!;
      } else {
        listNation.value = [];
        // return country.Country.fromJsonError(
        //     jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      listNation.value = [];

      // return country.Country.fromJsonErrorCatch(e.toString());
    }
  }

  @override
  onInit() {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await getFamilyTypeWebDesktop(homeController.accessTokens.value);
    await getCountryWebDesktop();
  }

  @override
  void onClose() {}
}

enum AddPatientState { ok, loading, error }
