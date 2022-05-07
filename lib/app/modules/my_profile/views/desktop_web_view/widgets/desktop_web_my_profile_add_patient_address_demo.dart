// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_dropdown_field.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/city.dart' as cities;
import 'package:altea/app/data/model/district.dart' as districts;
import 'package:altea/app/data/model/province.dart';
import 'package:altea/app/data/model/subdistrict.dart' as subdistricts;
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/my_profile/controllers/my_profile_controller.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';

class DesktopWebMyProfileAddPatientAddressDemo extends GetView<AddPatientController> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final MyProfileController myProfileController = Get.find<MyProfileController>();
  final patientDataController = Get.put(PatientDataController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    // final controller = Get.find<AddPatientController>();
    // final patientDataController = Get.find<PatientDataController>();
    final homeController = Get.find<HomeController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            myProfileController.pageControllerProfile.jumpToPage(6);
          },
          child: const Icon(
            Icons.chevron_left_rounded,
            color: kBlackColor,
            size: 28,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "Tambah Alamat Pengiriman",
          style: kPoppinsMedium500.copyWith(fontSize: 16, color: kBlackColor),
        ),
        const SizedBox(
          height: 15,
        ),
        Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Alamat Belum diisi';
                    }
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    errorBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kRedError, width: 2.0)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    fillColor: kTextFieldColor,
                    filled: true,
                    hintText: "Alamat Lengkap",
                    errorStyle: kErrorTextStyle,
                    hintStyle: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray),
                  ),
                  maxLines: 3,
                  onChanged: (val) {
                    controller.street.value = val;
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  child: CustomDropdownField(
                    borderRadius: 8,
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
                    items: controller.listNation
                        .map((data) => DropdownMenuItem(value: data.countryId, child: Text('${data.code!}-${data.name!}')))
                        .toList(),
                    onChanged: (val) {
                      controller.countryId.value = val.toString();
                    },
                    hintText: 'Country Key',
                    value: controller.countryId.value.isEmpty ? null : controller.countryId.value,
                  )),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: Obx(() => FutureBuilder<Province>(
                    future: controller.countryId.value.isEmpty ? null : controller.getProvince(controller.countryId.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        controller.listProvince.value = snapshot.data!.data!;
                      }
                      return CustomDropdownField(
                        borderRadius: 8,
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
                        items: controller.listProvince.map((data) => DropdownMenuItem(value: data.provinceId, child: Text(data.name!))).toList(),
                        onChanged: (val) {
                          controller.provinceId.value = val.toString();
                          controller.cityId.value = "";
                          // print("city IDDDDD ->${controller.cityId.value} ");
                          controller.listCity.value = [];
                          controller.districtId.value = "";
                          controller.listDistrict.value = [];
                          controller.subdistrictId.value = "";
                          controller.listSubdistrict.value = [];
                        },
                        hintText: 'Provinsi',
                        value: controller.provinceId.value.isEmpty ? null : controller.provinceId.value,
                      );
                    })),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: Obx(() => FutureBuilder<cities.City>(
                    future: controller.provinceId.value.isEmpty ? null : controller.getCity(controller.provinceId.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        controller.listCity.value = snapshot.data!.data!;
                      }
                      return Obx(() => CustomDropdownField(
                            borderRadius: 8,
                            onSaved: (val) {
                              // print("Val on Saved -> $val");
                              if (val != null) {
                                controller.cityId.value = val.toString();
                                // print("city ID ->${controller.cityId.value} ");
                              }
                            },
                            validator: (val) {
                              if (val == null) {
                                return 'Kota Belum dipilih';
                              }
                            },
                            items: controller.listCity.map((data) {
                              // print("data city id => ${data.cityId} ");
                              // print("data city name => ${data.name} ");
                              return DropdownMenuItem(value: data.cityId, child: Text(data.name!));
                            }).toList(),
                            onChanged: (val) {
                              controller.cityId.value = val.toString();
                              controller.districtId.value = "";
                              controller.listDistrict.value = [];
                              controller.subdistrictId.value = "";
                              controller.listSubdistrict.value = [];
                            },
                            hintText: 'Kota',
                            value: controller.cityId.value.isEmpty ? null : controller.cityId.value,
                          ));
                    })),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: Obx(() => FutureBuilder<districts.District>(
                    future: controller.cityId.value.isEmpty ? null : controller.getDistrict(controller.cityId.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        controller.listDistrict.value = snapshot.data!.data!;
                      }
                      return Obx(() => CustomDropdownField(
                            borderRadius: 8,
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
                            items: controller.listDistrict.map((data) => DropdownMenuItem(value: data.districtId, child: Text(data.name!))).toList(),
                            onChanged: (val) {
                              controller.districtId.value = val.toString();
                              controller.subdistrictId.value = "";
                              controller.listSubdistrict.value = [];
                            },
                            hintText: 'Kecamatan',
                            value: controller.districtId.value.isEmpty ? null : controller.districtId.value,
                          ));
                    })),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: Obx(() => FutureBuilder<subdistricts.SubDistrict>(
                    future: controller.districtId.value.isEmpty ? null : controller.getSubDistrict(controller.districtId.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        controller.listSubdistrict.value = snapshot.data!.data!;
                      }
                      return Obx(() => CustomDropdownField(
                            borderRadius: 8,
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
                            items: controller.listSubdistrict
                                .map((data) => DropdownMenuItem(value: data.subDistrictId, child: Text(data.name!)))
                                .toList(),
                            onChanged: (val) {
                              controller.subdistrictId.value = val.toString();
                            },
                            hintText: 'Kelurahan',
                            value: controller.subdistrictId.value.isEmpty ? null : controller.subdistrictId.value,
                          ));
                    })),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'RT/RW Belum diisi';
                    }
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      errorBorder:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kRedError, width: 2.0)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      fillColor: kTextFieldColor,
                      filled: true,
                      hintText: "RT/RW",
                      hintStyle: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray)),
                  onChanged: (val) {
                    controller.rtrw.value = val;
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 87,
        ),
        FutureBuilder(
          future: controller.getCountry(),
          builder: (c, d) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              child: CustomFlatButton(
                width: screenWidth,
                text: "Konfirmasi",
                onPressed: () async {
                  final bool res = formKey.currentState!.validate();
                  if (res) {
                    formKey.currentState!.save();
                    final Map<String, dynamic> dataAddress = {
                      "street": controller.street.value,
                      "country": controller.countryId.value,
                      "province": controller.provinceId.value,
                      "city": controller.cityId.value,
                      "district": controller.districtId.value,
                      "sub_district": controller.subdistrictId.value,
                      "rt_rw": controller.rtrw.value,
                    };

                    final results = await controller.addAddressss(dataAddress: dataAddress, accessTokens: homeController.accessTokens.value);

                    if (results.status!) {
                      controller.addressId.value = results.data!.id!;
                      controller.currentStep.value += 1;
                      controller.isChooseStep3.value = true;
                      controller.alamat.value =
                          "${results.data!.street!}, Blok RT/RW${results.data!.rtRw!}, Kel. ${results.data!.subDistrict!.name}, Kec.${results.data!.district!.name} ${results.data!.city!.name} ${results.data!.province!.name} ${results.data!.subDistrict!.postalCode}";
                      patientDataController.pageController.jumpToPage(4);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => CustomSimpleDialog(
                              icon: SizedBox(
                                width: screenWidth * 0.1,
                                child: Image.asset("assets/failed_icon.png"),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              title: 'Add Address failed',
                              buttonTxt: 'Mengerti',
                              subtitle: results.message!));
                    }
                  }
                },
                color: kButtonColor,
              ),
            );
          },
        ),
        const SizedBox(
          height: 28,
        ),
      ],
    );
  }
}

class TambahAlamatDesktopWeb extends StatelessWidget {
  const TambahAlamatDesktopWeb({Key? key}) : super(key: key);
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final controller = Get.find<AddPatientController>();
    final patientDataController = Get.find<PatientDataController>();
    final homeController = Get.find<HomeController>();
    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Alamat Belum diisi';
                    }
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    errorBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kRedError, width: 2.0)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    fillColor: kTextFieldColor,
                    filled: true,
                    hintText: "Alamat Lengkap",
                    errorStyle: kErrorTextStyle,
                    hintStyle: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray),
                  ),
                  maxLines: 3,
                  onChanged: (val) {
                    controller.street.value = val;
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  child: CustomDropdownField(
                    borderRadius: 8,
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
                    items: controller.listNation
                        .map((data) => DropdownMenuItem(value: data.countryId, child: Text('${data.code!}-${data.name!}')))
                        .toList(),
                    onChanged: (val) {
                      controller.countryId.value = val.toString();
                    },
                    hintText: 'Country Key',
                    value: controller.countryId.value.isEmpty ? null : controller.countryId.value,
                  )),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: Obx(() => FutureBuilder<Province>(
                    future: controller.countryId.value.isEmpty ? null : controller.getProvince(controller.countryId.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        controller.listProvince.value = snapshot.data!.data!;
                      }
                      return CustomDropdownField(
                        borderRadius: 8,
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
                        items: controller.listProvince.map((data) => DropdownMenuItem(value: data.provinceId, child: Text(data.name!))).toList(),
                        onChanged: (val) {
                          controller.provinceId.value = val.toString();
                          controller.cityId.value = "";
                          // print("city IDDDDD ->${controller.cityId.value} ");
                          controller.listCity.value = [];
                          controller.districtId.value = "";
                          controller.listDistrict.value = [];
                          controller.subdistrictId.value = "";
                          controller.listSubdistrict.value = [];
                        },
                        hintText: 'Provinsi',
                        value: controller.provinceId.value.isEmpty ? null : controller.provinceId.value,
                      );
                    })),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: Obx(() => FutureBuilder<cities.City>(
                    future: controller.provinceId.value.isEmpty ? null : controller.getCity(controller.provinceId.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        controller.listCity.value = snapshot.data!.data!;
                      }
                      return Obx(() => CustomDropdownField(
                            borderRadius: 8,
                            onSaved: (val) {
                              // print("Val on Saved -> $val");
                              if (val != null) {
                                controller.cityId.value = val.toString();
                                // print("city ID ->${controller.cityId.value} ");
                              }
                            },
                            validator: (val) {
                              if (val == null) {
                                return 'Kota Belum dipilih';
                              }
                            },
                            items: controller.listCity.map((data) {
                              // print("data city id => ${data.cityId} ");
                              // print("data city name => ${data.name} ");
                              return DropdownMenuItem(value: data.cityId, child: Text(data.name!));
                            }).toList(),
                            onChanged: (val) {
                              controller.cityId.value = val.toString();
                              controller.districtId.value = "";
                              controller.listDistrict.value = [];
                              controller.subdistrictId.value = "";
                              controller.listSubdistrict.value = [];
                            },
                            hintText: 'Kota',
                            value: controller.cityId.value.isEmpty ? null : controller.cityId.value,
                          ));
                    })),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: Obx(() => FutureBuilder<districts.District>(
                    future: controller.cityId.value.isEmpty ? null : controller.getDistrict(controller.cityId.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        controller.listDistrict.value = snapshot.data!.data!;
                      }
                      return Obx(() => CustomDropdownField(
                            borderRadius: 8,
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
                            items: controller.listDistrict.map((data) => DropdownMenuItem(value: data.districtId, child: Text(data.name!))).toList(),
                            onChanged: (val) {
                              controller.districtId.value = val.toString();
                              controller.subdistrictId.value = "";
                              controller.listSubdistrict.value = [];
                            },
                            hintText: 'Kecamatan',
                            value: controller.districtId.value.isEmpty ? null : controller.districtId.value,
                          ));
                    })),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: Obx(() => FutureBuilder<subdistricts.SubDistrict>(
                    future: controller.districtId.value.isEmpty ? null : controller.getSubDistrict(controller.districtId.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        controller.listSubdistrict.value = snapshot.data!.data!;
                      }
                      return Obx(() => CustomDropdownField(
                            borderRadius: 8,
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
                            items: controller.listSubdistrict
                                .map((data) => DropdownMenuItem(value: data.subDistrictId, child: Text(data.name!)))
                                .toList(),
                            onChanged: (val) {
                              controller.subdistrictId.value = val.toString();
                            },
                            hintText: 'Kelurahan',
                            value: controller.subdistrictId.value.isEmpty ? null : controller.subdistrictId.value,
                          ));
                    })),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'RT/RW Belum diisi';
                    }
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      errorBorder:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kRedError, width: 2.0)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      fillColor: kTextFieldColor,
                      filled: true,
                      hintText: "RT/RW",
                      hintStyle: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray)),
                  onChanged: (val) {
                    controller.rtrw.value = val;
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 87,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          child: CustomFlatButton(
            width: screenWidth,
            text: "Konfirmasi",
            onPressed: () async {
              final bool res = formKey.currentState!.validate();
              if (res) {
                formKey.currentState!.save();
                final Map<String, dynamic> dataAddress = {
                  "street": controller.street.value,
                  "country": controller.countryId.value,
                  "province": controller.provinceId.value,
                  "city": controller.cityId.value,
                  "district": controller.districtId.value,
                  "sub_district": controller.subdistrictId.value,
                  "rt_rw": controller.rtrw.value,
                };

                final results = await controller.addAddressss(dataAddress: dataAddress, accessTokens: homeController.accessTokens.value);

                if (results.status!) {
                  controller.addressId.value = results.data!.id!;
                  controller.currentStep.value += 1;
                  controller.isChooseStep3.value = true;
                  controller.alamat.value =
                      "${results.data!.street!}, Blok RT/RW${results.data!.rtRw!}, Kel. ${results.data!.subDistrict!.name}, Kec.${results.data!.district!.name} ${results.data!.city!.name} ${results.data!.province!.name} ${results.data!.subDistrict!.postalCode}";
                  patientDataController.pageController.jumpToPage(4);
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => CustomSimpleDialog(
                          icon: SizedBox(
                            width: screenWidth * 0.1,
                            child: Image.asset("assets/failed_icon.png"),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          title: 'Add Address failed',
                          buttonTxt: 'Mengerti',
                          subtitle: results.message!));
                }
              }
            },
            color: kButtonColor,
          ),
        ),
        const SizedBox(
          height: 28,
        ),
      ],
    );
  }
}
