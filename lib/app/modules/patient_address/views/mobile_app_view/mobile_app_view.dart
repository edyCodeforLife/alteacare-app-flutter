// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:altea/app/core/widgets/custom_dropdown_field.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/data/model/city.dart';
import 'package:altea/app/data/model/country.dart' as country;
import 'package:altea/app/data/model/district.dart' as districts;
import 'package:altea/app/data/model/province.dart';
import 'package:altea/app/data/model/subdistrict.dart' as subdistricts;
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/patient_address/controllers/patient_address_controller.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';

class MobileAppView extends StatefulWidget {
  @override
  _MobileAppViewState createState() => _MobileAppViewState();
}

class _MobileAppViewState extends State<MobileAppView> {
  GlobalKey<FormState> _addresskey = GlobalKey<FormState>();
  country.DatumCountry? selectedCountry;

  DatumCity? selectedCity;

  districts.DatumDistrict? selectedDistricts;

  DatumProvince? selectedProvince;

  subdistricts.DatumSubDistrict? selectedSubDistrict;

  String? countryId = null;
  String? cityId = null;
  String? provinceId = null;
  String? districtId = null;
  String? subDistrictId = null;

  PatientAddressController controller = Get.put(PatientAddressController());
  AddPatientController _addPatientController = Get.find<AddPatientController>();
  SpesialisKonsultasiController konsultasiController = Get.find<SpesialisKonsultasiController>();
  HomeController userController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Tambah Alamat',
          style: kAppBarTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: kBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: _addresskey,
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 26,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tambah Alamat",
                        style: kPoppinsMedium500.copyWith(fontSize: 17, color: kBlackColor),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Alamat bertujuan untuk melakukan pengiriman obat, mohon untuk mengisi sesuai KTP",
                        style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kWhiteGray),
                height: 80,
                child: TextFormField(
                  // focusNode: FocusNode(canRequestFocus: false),
                  onSaved: (val) {
                    _addPatientController.selectedAddressString.value = val.toString();
                  },
                  style: kTextInputStyle,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Alamat Lengkap",
                      hintStyle: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray)),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: FutureBuilder<country.Country>(
                  future: controller.getCountry(),
                  builder: (context, snapshot) {
                    List<country.DatumCountry> countryList = [];
                    if (snapshot.hasData) {
                      countryList = snapshot.data!.data ?? [];
                      if (countryList.isEmpty) {
                        countryId = null;
                      }else{
                        if(selectedCountry == null && countryList.where((e) => e.name.toString().toLowerCase() == "indonesia" ).isNotEmpty){
                          // print("indonesia ada");
                          controller.countryId.value =  countryList.firstWhere((e) => e.name.toString().toLowerCase() == "indonesia" ).countryId.toString();
                          countryId =  countryList.firstWhere((e) => e.name.toString().toLowerCase() == "indonesia" ).countryId.toString();
                          selectedCountry = countryList.where((element) => element.countryId == countryId).toList()[0];
                          // print("selected country : $selectedCountry");
                          // print("country ud : $countryId");
                          // print("controller.countryId.value : $controller.countryId.value");
                          provinceId = null;
                          cityId = null;
                          districtId = null;
                          subDistrictId = null;
                        }else{
                          // print("indonesia tidak ada");
                        }
                      }
                    } else {
                      countryList = [];
                      countryId = null;
                    }

                    return CustomDropdownField(
                        onSaved: (val) {
                          if (val != null) {
                            controller.countryId.value = val.toString();
                          }
                        },
                        validator: (val) {
                          if (val == null) {
                            return 'Negara Belum dipilih';
                          }
                        },
                        items:
                            countryList.map((data) => DropdownMenuItem(value: data.countryId, child: Text('${data.code!}-${data.name!}'))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            // print('countryId => $val');
                            setState(() {
                              countryId = val as String;
                              if (countryList.isEmpty) {
                                selectedCountry = null;
                              } else {
                                selectedCountry = countryList.where((element) => element.countryId == val).toList()[0];
                              }
                              provinceId = null;
                              cityId = null;
                              districtId = null;
                              subDistrictId = null;
                            });
                          }
                        },
                        hintText: 'Negara',
                        value: countryId);
                  }),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: FutureBuilder<Province>(
                  future: countryId == null ? null : controller.getProvince(countryId!),
                  builder: (context, snapshot) {
                    List<DatumProvince> provinceList = [];
                    if (snapshot.hasData) {
                      provinceList = snapshot.data!.data!;
                      if (provinceList.isEmpty) {
                        provinceId = null;
                      }
                    } else {
                      provinceList = [];
                      provinceId = null;
                    }
                    return CustomDropdownField(
                      onSaved: (val) {
                        if (val != null) {
                          controller.provinceId.value = val.toString();
                        }
                      },
                      validator: (val) {
                        if (val == null) {
                          return 'Provinsi Belum dipilih';
                        }
                      },
                      items: provinceList.map((data) => DropdownMenuItem(value: data.provinceId, child: Text(data.name!))).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            provinceId = val as String;
                            if (provinceList.isEmpty) {
                              selectedProvince = null;
                            } else {
                              selectedProvince = provinceList.where((element) => element.provinceId == val).toList()[0];
                            }
                            cityId = null;
                            districtId = null;
                            subDistrictId = null;
                          });
                        }
                      },
                      hintText: 'Provinsi',
                      value: provinceId,
                    );
                  }),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: FutureBuilder<City>(
                  future: provinceId == null ? null : controller.getCity(provinceId!),
                  builder: (context, snapshot) {
                    List<DatumCity> cityList = [];
                    if (snapshot.hasData) {
                      cityList = snapshot.data!.data!;
                      if (cityList.isEmpty) {
                        cityId = null;
                      }
                    } else {
                      cityList = [];
                      cityId = null;
                    }
                    return CustomDropdownField(
                        onSaved: (val) {
                          if (val != null) {
                            controller.cityId.value = val.toString();
                          }
                        },
                        validator: (val) {
                          if (val == null) {
                            return 'Kota Belum dipilih';
                          }
                        },
                        items: cityList.map((data) => DropdownMenuItem(value: data.cityId, child: Text(data.name!))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              cityId = val as String;
                              if (cityList.isEmpty) {
                                selectedCity = null;
                              } else {
                                selectedCity = cityList.where((element) => element.cityId == val).toList()[0];
                              }
                              districtId = null;
                              subDistrictId = null;
                            });
                          }
                        },
                        hintText: 'Kota',
                        value: cityId);
                  }),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: FutureBuilder<districts.District>(
                  future: selectedCity == null ? null : controller.getDistrict(selectedCity!.cityId!),
                  builder: (context, snapshot) {
                    List<districts.DatumDistrict> districtList = [];
                    if (snapshot.hasData) {
                      districtList = snapshot.data!.data!;
                      if (districtList.isEmpty) {
                        districtId = null;
                      }
                    } else {
                      districtList = [];
                      districtId = null;
                    }
                    return CustomDropdownField(
                        onSaved: (val) {
                          if (val != null) {
                            controller.districtId.value = val.toString();
                          }
                        },
                        validator: (val) {
                          if (val == null) {
                            return 'Kecamatan Belum dipilih';
                          }
                        },
                        items: districtList.map((data) => DropdownMenuItem(value: data.districtId, child: Text(data.name!))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              districtId = val as String;
                              if (districtList.isEmpty) {
                                selectedDistricts = null;
                              } else {
                                selectedDistricts = districtList.where((element) => element.districtId == val).toList()[0];
                              }
                              subDistrictId = null;
                            });
                          }
                        },
                        hintText: 'Kecamatan',
                        value: districtId);
                  }),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: FutureBuilder<subdistricts.SubDistrict>(
                  future: districtId == null ? null : controller.getSubDistrict(districtId!),
                  builder: (context, snapshot) {
                    List<subdistricts.DatumSubDistrict> subDistrictList = [];
                    if (snapshot.hasData) {
                      subDistrictList = snapshot.data!.data!;
                      if (subDistrictList.isEmpty) {
                        subDistrictId = null;
                      }
                    } else {
                      subDistrictList = [];
                      subDistrictId = null;
                    }
                    return CustomDropdownField(
                        onSaved: (val) {
                          if (val != null) {
                            controller.subdistrictId.value = val.toString();
                          }
                        },
                        validator: (val) {
                          if (val == null) {
                            return 'Kelurahan Belum dipilih';
                          }
                        },
                        items: subDistrictList.map((data) => DropdownMenuItem(value: data.subDistrictId, child: Text(data.name!))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              subDistrictId = val as String;
                              if (subDistrictList.isEmpty) {
                                selectedSubDistrict = null;
                              } else {
                                selectedSubDistrict = subDistrictList.where((element) => element.subDistrictId == val).toList()[0];
                              }
                            });
                          }
                        },
                        hintText: 'Kelurahan',
                        value: subDistrictId);
                  }),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: CustomTextField(
                  onChanged: (val) {},
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Nama Jalan tidak boleh kosong';
                    }
                  },
                  onSaved: (val) {
                    controller.street.value = val!;
                  },
                  hintText: 'Nama Jalan',
                  keyboardType: TextInputType.text),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: CustomTextField(
                  onChanged: (val) {},
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'No. RT/RW tidak boleh kosong';
                    }
                  },
                  onSaved: (val) {
                    controller.rtRw.value = val!;
                  },
                  hintText: 'RT/RW (001/002)',
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+/]'))],
                  keyboardType: TextInputType.numberWithOptions(signed: true)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomFlatButton(
                  width: double.infinity,
                  text: 'Lanjutkan',
                  onPressed: () async {
                    if (_addresskey.currentState!.validate()) {
                      _addresskey.currentState!.save();
                    }
                    // print('----------------');
                    // print(controller.countryId.value);
                    // print(controller.provinceId.value);
                    // print(controller.cityId.value);
                    // print(controller.districtId.value);
                    // print(controller.subdistrictId.value);
                    // print(controller.rtRw.value);
                    // print(controller.street.value);

                    var token = await AppSharedPreferences.getAccessToken();
                    var result = await controller.addAddressss(dataAddress: {
                      "street": controller.street.value,
                      "country": controller.countryId.value,
                      "province": controller.provinceId.value,
                      "city": controller.cityId.value,
                      "district": controller.districtId.value,
                      "sub_district": controller.subdistrictId.value,
                      "rt_rw": controller.rtRw.value
                    }, accessTokens: token);
                    if (result.status == true) {
                      if (ModalRoute.of(context)!.settings.arguments == true) {
                        var res = await controller.updateAddress(dataPatient: {
                          "family_relation_type": konsultasiController.selectedPatientData.value.familyRelationType,
                          "first_name": konsultasiController.selectedPatientData.value.firstName,
                          "last_name": konsultasiController.selectedPatientData.value.lastName,
                          "birth_date": konsultasiController.selectedPatientData.value.birthDate,
                          "birth_country": konsultasiController.selectedPatientData.value.birthCountry,
                          "birth_place": konsultasiController.selectedPatientData.value.birthPlace,
                          "gender": konsultasiController.selectedPatientData.value.gender,
                          "nationality": konsultasiController.selectedPatientData.value.nationality,
                          "card_id": konsultasiController.selectedPatientData.value.cardId,
                          "address_id": result.data!.id.toString(),
                        }, patientId: konsultasiController.selectedUid.value, accessTokens: userController.userData.value.data!.id!);

                        if (res['status'] == true) {
                          konsultasiController.selectedAddress.value = result.data!.id!;
                          Get.back();
                        }
                      } else {
                        _addPatientController.fullAddress.value =
                            "Jl. ${result.data!.street}, Blok RT/RW ${result.data!.rtRw}, Kel. ${result.data!.subDistrict!.name}, Kec.${result.data!.district!.name} ${result.data!.city!.name} ,${result.data!.province!.name} , ${result.data!.subDistrict!.postalCode}";
                        konsultasiController.selectedAddress.value = result.data!.id!;
                        _addPatientController.selectedAddress.value = result.data!.id.toString();
                      }

                      Get.back();
                    } else {
                      // print("res-nya : ${result.data}");
                    }
                    // print('hasil => ${result.data!.id}');
                  },
                  color: kButtonColor),
            )
          ],
        ),
      ),
    );
  }
}
