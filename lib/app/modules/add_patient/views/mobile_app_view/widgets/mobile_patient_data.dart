// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_dropdown_field.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/data/model/patient_family_type.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Package imports:
import 'package:get/get.dart';

class MobilePatientData extends StatefulWidget {
  final void Function() nextPage;

  const MobilePatientData({required this.nextPage});
  @override
  _MobilePatientDataState createState() => _MobilePatientDataState();
}

class _MobilePatientDataState extends State<MobilePatientData> {
  RegisterController registerController = Get.put(RegisterController());
  HomeController homeController = Get.find<HomeController>();
  AddPatientController controller = Get.put(AddPatientController());
  String? selectedNation;
  final GlobalKey<FormState> _patientKey = GlobalKey<FormState>();
  String? selectedFamily;

  FocusNode focus = FocusNode();

  List<String> genders = ['Laki Laki', 'Perempuan'];
  String? selectedGender;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _patientKey,
                child: Column(
                  children: [
                    CustomTextField(
                        onChanged: (val) {},
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Nama Depan tidak boleh kosong';
                          } else {
                            return null;
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                        ],
                        onSaved: (val) {
                          controller.firstName.value = val!.toString();
                        },
                        hintStyle: kTextHintStyle.copyWith(fontSize: 12),
                        hintText: 'Nama Depan',
                        keyboardType: TextInputType.text),
                    CustomTextField(
                        onChanged: (val) {},
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Nama Belakang tidak boleh kosong';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          controller.lastName.value = val!.toString();
                        },
                        hintStyle: kTextHintStyle.copyWith(fontSize: 12),
                        hintText: 'Nama Belakang',
                        keyboardType: TextInputType.text),
                    CustomTextField(
                        onChanged: (val) {},
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Nama Belakang tidak boleh kosong';
                          } else if (val.length != 16) {
                            return 'No. KTP harus 16 digit';
                          } else {
                            return null;
                          }
                        },
                        hintStyle: kTextHintStyle.copyWith(fontSize: 12),
                        onSaved: (val) {
                          controller.idNo.value = val!.toString();
                        },
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), LengthLimitingTextInputFormatter(16)],
                        hintText: 'No KTP',
                        keyboardType: TextInputType.number),
                    CustomTextField(
                        onChanged: (val) {},
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Tanggal Lahir tidak boleh kosong';
                          } else {
                            return null;
                          }
                        },
                        hintStyle: kTextHintStyle.copyWith(fontSize: 12),
                        onSaved: (val) {
                          controller.birthDate.value = val!.toString();
                        },
                        hintText: 'Tanggal Lahir',
                        keyboardType: TextInputType.datetime),
                    FutureBuilder(
                        future: registerController.getCountry(),
                        builder: (context, snapshot) {
                          List<dynamic> nations = [];
                          if (snapshot.hasData) {
                            nations = snapshot.data as List<dynamic>;
                            if(nations.where((e) => e['name'].toString().toLowerCase() == "indonesia" ).isNotEmpty){
                              print("indonesia ada");
                              controller.nation.value = nations.firstWhere((e) => e['name'].toString().toLowerCase() == "indonesia" )['country_id'];
                              selectedNation =  nations.firstWhere((e) => e['name'].toString().toLowerCase() == "indonesia" )['country_id'];
                              controller.birthCountry.value =
                                  nations.where((element) => element['country_id'] == selectedNation).toList()[0]['name'].toString();
                            }else{
                              print("indonesia tidak ada");
                            }
                          }
                          return CustomDropdownField(
                            onSaved: (val) {
                              FocusScope.of(context).unfocus();

                              if (val != null) {
                                controller.nation.value = val.toString();
                              }
                            },
                            validator: (val) {
                              if (val == null) {
                                return 'Negara Belum dipilih';
                              }
                            },
                            items: nations.map((e) => DropdownMenuItem(value: e['country_id'], child: Text(e['name'].toString()))).toList(),
                            onChanged: (val) {
                              FocusScope.of(context).unfocus();
                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                              setState(() {
                                selectedNation = val.toString();
                              });
                              controller.birthCountry.value =
                                  nations.where((element) => element['country_id'] == selectedNation).toList()[0]['name'].toString();

                              // print('country name => ${registerController.countryName}');
                            },
                            hintText: 'Negara',
                            value: selectedNation,
                          );
                        }),
                    CustomTextField(
                        onChanged: (val) {},
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Kota Kelahiran tidak bisa kosong';
                          } else {
                            return null;
                          }
                        },
                        hintStyle: kTextHintStyle.copyWith(fontSize: 12),
                        onSaved: (val) {
                          controller.birthTown.value = val!.toString();
                        },
                        hintText: 'Kota Kelahiran',
                        keyboardType: TextInputType.text),
                    CustomDropdownField(
                      onSaved: (val) {
                        if (val != null) {
                          controller.gender.value = val!.toString();
                        }
                      },
                      validator: (val) {
                        if (val == null) {
                          return 'Jenis Kelamin belum dipilih';
                        }
                      },
                      items: genders.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedGender = val.toString();
                        });
                      },
                      hintText: 'Jenis Kelamin',
                      value: selectedGender,
                    ),
                    FutureBuilder<PatientFamilyType>(
                      future: controller.getFamilyType(homeController.accessTokens.value),
                      builder: (context, snapshot) {
                        List<FamilyDatumType> familyTypes = [];
                        if (snapshot.hasData) {
                          familyTypes = snapshot.data == null ? [] : snapshot.data!.data as List<FamilyDatumType>;
                        }
                        return CustomDropdownField(
                          onSaved: (val) {
                            if (val != null) {
                              controller.familyRelation.value = selectedFamily!;
                              controller.familyName.value = familyTypes.where((element) => element.id == selectedFamily).toList()[0].name as String;
                              // controller.familyName.value = val.name.toString();
                              // print('id =>${controller.familyRelation.value} | name => ${controller.familyName.value} ');
                            }
                          },
                          validator: (val) {
                            if (val == null) {
                              return 'Hubungan keluarga belum dipilih';
                            }
                          },
                          items: familyTypes.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name.toString()))).toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedFamily = val.toString();
                            });
                          },
                          hintText: 'Hubungan Keluarga',
                          value: selectedFamily,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // Obx(
                    //   () =>
                    //   InkWell(
                    //     onTap: () =>
                    //         Get.toNamed('/patient-address', arguments: false),
                    //     child: Container(
                    //       width: double.infinity,
                    //       padding: EdgeInsets.symmetric(
                    //           horizontal: 16, vertical: 24),
                    //       decoration: BoxDecoration(
                    //           color: kWhiteGray,
                    //           borderRadius: BorderRadius.circular(24)),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             controller.selectedAddressString.value == ''
                    //                 ? 'Alamat'
                    //                 : controller.selectedAddressString.value,
                    //             style: kTextHintStyle,
                    //             overflow: TextOverflow.ellipsis,
                    //           ),
                    //           Icon(
                    //             Icons.arrow_forward_ios,
                    //             color: kBlackColor.withOpacity(0.6),
                    //             size: 20,
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomFlatButton(
              height: MediaQuery.of(context).size.height * 0.06,
              width: double.infinity,
              text: 'Tambahkan',
              onPressed: () async {
                if (_patientKey.currentState!.validate()) {
                  _patientKey.currentState!.save();
                  // print('confirmation ? ');
                  // var result = await controller.addFamily();

                  // if (result['status'] == true) {
                  //   Get.back();
                  // }
                  widget.nextPage();
                  // print(' idx => ${controller.currentIdx.value}');
                }
              },
              color: kButtonColor),
        ),
      ],
    );
  }
}
