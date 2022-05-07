// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:altea/app/data/model/add_user_address.dart';
import 'package:altea/app/data/model/city.dart' as cities;
import 'package:altea/app/data/model/country.dart' as country;
import 'package:altea/app/data/model/district.dart' as districts;
import 'package:altea/app/data/model/patient_data_model.dart';
import 'package:altea/app/data/model/province.dart';
import 'package:altea/app/data/model/subdistrict.dart' as subdistricts;
// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PatientAddressController extends GetxController {
  final http.Client client = http.Client();

  RxList<country.DatumCountry> listNation = <country.DatumCountry>[].obs;
  RxList<DatumProvince> listProvince = <DatumProvince>[].obs;
  RxList<cities.DatumCity> listCity = <cities.DatumCity>[].obs;
  RxList<districts.DatumDistrict> listDistrict = <districts.DatumDistrict>[].obs;
  RxList<subdistricts.DatumSubDistrict> listSubdistrict = <subdistricts.DatumSubDistrict>[].obs;

  RxString countryId = ''.obs;
  RxString provinceId = ''.obs;
  RxString cityId = ''.obs;
  RxString districtId = ''.obs;
  RxString subdistrictId = ''.obs;
  RxString rtRw = ''.obs;
  RxString street = ''.obs;

  RxString selectedNation = ''.obs;
  RxString selectedProvince = ''.obs;
  RxString selectedCity = ''.obs;
  RxString selectedDistrict = ''.obs;
  RxString selectedSubdistrict = ''.obs;
  RxBool isLoading = false.obs;
  RxBool confirmSelected = false.obs;

  Future<country.Country> getCountry() async {
    isLoading.value = true;
    const webUrl = "$alteaURL/data/countries?_limit=2000";
    // const mobileUrl = "https://jr6gclz3f0.execute-api.us-east-1.amazonaws.com/dev/country-list";
    const mobileUrl = "$alteaURL/data/countries?_limit=2000";

    try {
      final response = await client.get(
        Uri.parse(GetPlatform.isWeb ? webUrl : mobileUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        isLoading.value = false;

        return country.Country.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        isLoading.value = false;

        return country.Country.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      isLoading.value = false;

      return country.Country.fromJsonErrorCatch(e.toString());
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

  Future<AddAddressUser> addAddressss({required Map<String, dynamic> dataAddress, required String accessTokens}) async {
    try {
      final response = await client.post(Uri.parse("$alteaURL/user/address"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $accessTokens"}, body: jsonEncode(dataAddress));

      if (response.statusCode == 200) {
        return AddAddressUser.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return AddAddressUser.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      return AddAddressUser.fromJsonErrorCatch(e.toString());
    }
  }

  Future<PatientData> getPatientList(String accessToken) async {
    try {
      final response = await client.get(Uri.parse("$alteaURL/user/patient"), headers: {"Authorization": "Bearer $accessToken"});

      if (response.statusCode == 200) {
        // print('hasil 200 => ${response.body}');
        return PatientData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return PatientData.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return PatientData.fromJsonErrorCatch(e.toString());
    }
  }

  Future updateAddress({required Map<String, dynamic> dataPatient, required String patientId, required String accessTokens}) async {
    try {
      final response = await client.post(Uri.parse("$alteaURL/user/patient/$patientId"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $accessTokens"}, body: jsonEncode(dataPatient));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future addAddress() async {
    try {
      var token = await AppSharedPreferences.getAccessToken();
      final response = await client.post(Uri.parse("$alteaURL/user/address"),
          body: jsonEncode({
            "street": street.value,
            "country": countryId.value,
            "province": provinceId.value,
            "city": cityId.value,
            "district": districtId.value,
            "sub_district": subdistrictId.value,
            "rt_rw": rtRw.value
          }),
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"});

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return e.toString();
    }
  }
  //
  // Future addAddress(Country country, Province province, City city,
  //     districts.District district, subdistricts.SubDistrict subDistrict) {}

  Future<void> getCountryWeb() async {
    isLoading.value = true;
    const webUrl = "$alteaURL/data/countries?_limit=2000";
    const mobileUrl = "$alteaURL/data/countries?_limit=2000";

    // const mobileUrl = "https://jr6gclz3f0.execute-api.us-east-1.amazonaws.com/dev/country-list";
    try {
      final response = await client.get(
        Uri.parse(GetPlatform.isWeb ? webUrl : mobileUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        listNation.value = country.Country.fromJson(jsonDecode(response.body) as Map<String, dynamic>).data!;
        isLoading.value = false;

        // return country.Country.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        listNation.value = [];
        isLoading.value = false;

        // return country.Country.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
      for (final item in listNation) {
        if (item.code == "ID") {
          countryId.value = item.countryId!;
        }
      }
    } catch (e) {
      listNation.value = [];
      isLoading.value = false;

      // return country.Country.fromJsonErrorCatch(e.toString());
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    final resultNation = await getCountry();
    bool resultnationBool = resultNation.status ?? false;
    if (resultnationBool) {
      listNation.value = resultNation.data!;
      for (final item in listNation) {
        if (item.code == "ID") {
          countryId.value = item.countryId!;
        }
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
