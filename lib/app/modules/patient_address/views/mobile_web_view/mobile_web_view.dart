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
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/patient_address/controllers/patient_address_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:altea/app/routes/app_pages.dart';

class MobileWebAddAddressOnlyPage extends GetView<PatientAddressController> {
  const MobileWebAddAddressOnlyPage({Key? key, required this.doctorIdFromParam}) : super(key: key);

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String doctorIdFromParam;

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: kBackground,
        appBar: MobileWebMainAppbar(
          scaffoldKey: scaffoldKey,
        ),
        drawer: MobileWebHamburgerMenu(),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    const SizedBox(
                      height: 26,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Column(
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
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                            child: TextFormField(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Alamat Belum diisi';
                                }
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kRedError, width: 2.0)),
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
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                              hintText: 'Negara',
                              value: controller.countryId.value,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                                    items: controller.listProvince
                                        .map((data) => DropdownMenuItem(value: data.provinceId, child: Text(data.name!)))
                                        .toList(),
                                    onChanged: (val) {
                                      controller.provinceId.value = val.toString();
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
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                            child: Obx(() => FutureBuilder<cities.City>(
                                future: controller.provinceId.value.isEmpty ? null : controller.getCity(controller.provinceId.value),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    controller.listCity.value = snapshot.data!.data!;
                                  }
                                  return CustomDropdownField(
                                    borderRadius: 8,
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
                                    items: controller.listCity.map((data) => DropdownMenuItem(value: data.cityId, child: Text(data.name!))).toList(),
                                    onChanged: (val) {
                                      controller.cityId.value = val.toString();
                                    },
                                    hintText: 'Kota',
                                    value: controller.cityId.value.isEmpty ? null : controller.cityId.value,
                                  );
                                })),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                            child: Obx(() => FutureBuilder<districts.District>(
                                future: controller.cityId.value.isEmpty ? null : controller.getDistrict(controller.cityId.value),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    controller.listDistrict.value = snapshot.data!.data!;
                                  }
                                  return CustomDropdownField(
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
                                    items: controller.listDistrict
                                        .map((data) => DropdownMenuItem(value: data.districtId, child: Text(data.name!)))
                                        .toList(),
                                    onChanged: (val) {
                                      controller.districtId.value = val.toString();
                                    },
                                    hintText: 'Kecamatan',
                                    value: controller.districtId.value.isEmpty ? null : controller.districtId.value,
                                  );
                                })),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                            child: Obx(() => FutureBuilder<subdistricts.SubDistrict>(
                                future: controller.districtId.value.isEmpty ? null : controller.getSubDistrict(controller.districtId.value),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    controller.listSubdistrict.value = snapshot.data!.data!;
                                  }
                                  return CustomDropdownField(
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
                                  );
                                })),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                            child: TextFormField(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'RT/RW Belum diisi';
                                }
                              },
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kRedError, width: 2.0)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  fillColor: kTextFieldColor,
                                  filled: true,
                                  hintText: "RT/RW",
                                  hintStyle: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray)),
                              onChanged: (val) {
                                controller.rtRw.value = val;
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
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Obx(() => CustomFlatButton(
                            width: screenWidth,
                            text: "Konfirmasi",
                            onPressed: () async {
                              // print("yihuy");
                              // print(controller.confirmSelected.value.toString());
                              final bool res = formKey.currentState!.validate();
                              controller.confirmSelected.value = true;
                              if (controller.confirmSelected.value) {
                                if (res) {
                                  formKey.currentState!.save();
                                  final Map<String, dynamic> dataAddress = {
                                    "street": controller.street.value,
                                    "country": controller.countryId.value,
                                    "province": controller.provinceId.value,
                                    "city": controller.cityId.value,
                                    "district": controller.districtId.value,
                                    "sub_district": controller.subdistrictId.value,
                                    "rt_rw": controller.rtRw.value,
                                  };

                                  final results =
                                      await controller.addAddressss(dataAddress: dataAddress, accessTokens: homeController.accessTokens.value);

                                  if (results.status!) {
                                    final String addressId = results.data!.id!;

                                    final result = await controller.getPatientList(
                                      homeController.accessTokens.value,
                                    );

                                    if (result.status!) {
                                      final Map<String, dynamic> dataAddress = {
                                        "address_id": addressId,
                                      };
                                      final resultUpdateAddressPatient = await controller.updateAddress(
                                          dataPatient: dataAddress,
                                          patientId: result.data!.patient[0].id!,
                                          accessTokens: homeController.accessTokens.value);
                                      if (resultUpdateAddressPatient["status"] == true) {
                                        controller.confirmSelected.value = false;
                                        // Get.back();
                                        Get.toNamed("${Routes.PATIENT_DATA}?doctorId=$doctorIdFromParam");
                                      } else {
                                        controller.confirmSelected.value = false;

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
                                            title: 'Update Address failed',
                                            buttonTxt: 'Mengerti',
                                            subtitle: resultUpdateAddressPatient["message"].toString(),
                                          ),
                                        );
                                      }
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
                                            title: 'Update Address failed',
                                            buttonTxt: 'Mengerti',
                                            subtitle: result.message!),
                                      );
                                    }
                                    // if (result["status"] == true) {
                                    // } else {
                                    //   showDialog(
                                    //       context: context,
                                    //       builder: (context) => CustomSimpleDialog(
                                    //           icon: SizedBox(
                                    //             width: screenWidth * 0.1,
                                    //             child: Image.asset("assets/failed_icon.png"),
                                    //           ),
                                    //           onPressed: () {
                                    //             Get.back();
                                    //           },
                                    //           title: 'Add Address failed',
                                    //           buttonTxt: 'Mengerti',
                                    //           subtitle: result["message"].toString()));
                                    // }
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
                                          subtitle: results.message!),
                                    );
                                  }
                                }
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
                                      title: 'Gagal Menambah Alamat',
                                      buttonTxt: 'Mengerti',
                                      subtitle: "Silakan lengkapi form yang ada"),
                                );
                              }
                            },
                            color: kButtonColor,
                          )),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                  ],
                ),
        ));
  }
}
