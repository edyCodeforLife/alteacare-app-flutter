// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/widgets/custom_dropdown_field.dart';
import '../../../../core/widgets/custom_flat_button.dart';
import '../../../../data/model/city.dart' as cities;
import '../../../../data/model/country.dart' as country;
import '../../../../data/model/district.dart' as districts;
import '../../../../data/model/province.dart';
import '../../../../data/model/subdistrict.dart' as subdistricts;
import '../../../home/controllers/home_controller.dart';
import '../../../register/presentation/modules/register/views/custom_simple_dialog.dart';
import '../../../spesialis_konsultasi/views/desktop_web_view/desktop_web_view.dart';
import '../../controllers/patient_address_controller.dart';

class DesktopWebAddAddressOnlyPage extends StatelessWidget {
  const DesktopWebAddAddressOnlyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final controller = Get.put(PatientAddressController());
    final homeController = Get.find<HomeController>();

    return ListView(
      children: [
        const SizedBox(
          height: 26,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
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
                child: FutureBuilder(
                    future: controller.getCountryWeb(),
                    builder: (context, snapshot) {
                      if (controller.listNation.isNotEmpty) {
                        return Obx(() => CustomDropdownField(
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
                              value: controller.countryId.value.isEmpty ? null : controller.countryId.value,
                            ));
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
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
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          child: Obx(() => CustomFlatButton(
                width: screenWidth,
                text: "Konfirmasi",
                onPressed: controller.confirmSelected.value
                    ? null
                    : () async {
                        controller.confirmSelected.value = true;
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
                            "rt_rw": controller.rtRw.value,
                          };

                          final results = await controller.addAddressss(dataAddress: dataAddress, accessTokens: homeController.accessTokens.value);

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
                                  dataPatient: dataAddress, patientId: result.data!.patient[0].id!, accessTokens: homeController.accessTokens.value);
                              if (resultUpdateAddressPatient["status"] == true) {
                                Get.back();
                                Get.dialog(const PatientDataDialog());
                                controller.confirmSelected.value = false;
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
                                        subtitle: resultUpdateAddressPatient["message"].toString()));
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
                                      subtitle: result.message!));
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
                                    subtitle: results.message!));
                          }
                        } else {
                          controller.confirmSelected.value = false;
                        }
                      },
                color: kButtonColor,
              )),
        ),
        const SizedBox(
          height: 28,
        ),
      ],
    );
  }
}
