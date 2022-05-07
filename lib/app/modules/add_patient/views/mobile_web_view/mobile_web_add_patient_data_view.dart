// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_dropdown_field.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/data/model/country.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/register_view.dart';
import 'package:altea/app/routes/app_pages.dart';

class MobileWebAddPatientDataPage extends GetView<AddPatientController> {
  MobileWebAddPatientDataPage({Key? key, this.doctorIdFromParam}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String? doctorIdFromParam;
  final FocusNode namaDepanFocus = FocusNode();
  final FocusNode namaBelakangFocus = FocusNode();
  final FocusNode cardIdNode = FocusNode();
  final FocusNode tanggalLahirNode = FocusNode();
  final FocusNode kotaNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    // WEB STEPPER
    const String textStepper1 = "1";
    const String textStepper2 = "2";
    const String textStepper3 = "3";

    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kBackground,
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawer: MobileWebHamburgerMenu(),
      body: ListView(
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
                  "Tambah Data Pasien",
                  style: kPoppinsMedium500.copyWith(fontSize: 17, color: kBlackColor),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "Isi Data pasien yang akan melakukan konsultasi.",
                  style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 36,
          ),
          // ? STEPPER SECTION
          Container(
            width: screenWidth * 0.5,
            height: screenWidth * 0.2,
            // padding: EdgeInsets.all(16),
            // color: Colors.pink,
            child: Row(
              children: [
                StepperFirstWidget(
                  screenWidth: screenWidth,
                  text: textStepper1,
                  subtitleText: "Personal Data",
                  isChooseStep: controller.isChooseStep1.value,
                  currentStep: controller.currentStep.value,
                  width: screenWidth * 0.1,
                  height: 2,
                ),
                StepperMiddleWidget(
                  screenWidth: screenWidth,
                  text: textStepper2,
                  subtitleText: "Kontak Data",
                  isChooseStep: controller.isChooseStep2.value,
                  currentStep: controller.currentStep.value,
                  width: screenWidth * 0.1,
                  height: 2,
                ),
                StepperLastWidget(
                  screenWidth: screenWidth,
                  text: textStepper3,
                  subtitleText: "Verifikasi",
                  isChooseStep: controller.isChooseStep3.value,
                  currentStep: controller.currentStep.value,
                  width: screenWidth * 0.1,
                  height: 2,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 17,
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: CustomTextField(
                    onChanged: (val) {
                      controller.firstName.value = val!;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Nama Depan Belum diisi';
                      } else if (val.length < 2) {
                        return 'Nama harus lebih dari dua kata';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) {
                      controller.firstName.value = val!;
                    },
                    hintText: "Nama Depan",
                    keyboardType: TextInputType.text,
                    focusNode: namaDepanFocus,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: CustomTextField(
                    onChanged: (val) {
                      controller.lastName.value = val!;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Nama Belakang Belum diisi';
                      } else if (val.length < 2) {
                        return 'Nama harus lebih dari dua kata';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) {
                      controller.lastName.value = val!;
                    },
                    hintText: "Nama Belakang",
                    keyboardType: TextInputType.text,
                    focusNode: namaBelakangFocus,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: FutureBuilder(
                      future: controller.getFamilyTypeWebDesktop(homeController.accessTokens.value),
                      builder: (context, snapshot) {
                        if (controller.listFamilyType.isNotEmpty) {
                          return CustomDropdownField(
                            onSaved: (val) {
                              if (val != null) {
                                controller.familyTypeId.value = val.toString();
                              }
                            },
                            validator: (val) {
                              if (val == null) {
                                return 'Status Belum dipilih';
                              } else {
                                return null;
                              }
                            },
                            items: controller.listFamilyType.map((data) => DropdownMenuItem(value: data.id, child: Text(data.name))).toList(),
                            onChanged: (val) {
                              FocusManager.instance.primaryFocus?.unfocus();

                              controller.familyTypeId.value = val.toString();
                              for (final item in controller.listFamilyType) {
                                if (item.id == controller.familyTypeId.value) {
                                  controller.familyRelation.value = item.name;
                                }
                              }
                            },
                            hintText: 'Status',
                            value: controller.familyTypeId.value.isEmpty ? null : controller.familyTypeId.value,
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: CustomTextField(
                    onChanged: (val) {
                      controller.cardId.value = val!;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'No. KTP Belum diisi';
                      } else if (val.length != 16) {
                        return 'No. KTP harus 16 digit';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) {
                      controller.cardId.value = val!;
                    },
                    hintText: "No. KTP",
                    keyboardType: TextInputType.text,
                    focusNode: cardIdNode,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(16),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: CustomTextField(
                    onChanged: (val) {
                      controller.birthDate.value = val!;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Tanggal Kelahiran Belum diisi';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) {
                      controller.birthDate.value = val!;
                      DateTime now = DateTime.now();
                      DateTime birtdate = DateTime.parse(controller.birthDate.value);
                      controller.age.value = now.year - birtdate.year;
                      // print("umur ${controller.age.value}");
                    },
                    hintText: "Tanggal Kelahiran",
                    keyboardType: TextInputType.datetime,
                    focusNode: tanggalLahirNode,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: FutureBuilder<Country>(
                    future: controller.getCountry(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        controller.listNation.value = snapshot.data!.data!;
                        for (final item in controller.listNation) {
                          if (item.code == "ID") {
                            controller.countryId.value = item.countryId!;
                          }
                        }
                        return Obx(
                          () => CustomDropdownField(
                            onSaved: (val) {
                              if (val != null) {
                                controller.countryId.value = val.toString();
                              }
                            },
                            validator: (val) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (val == null) {
                                return 'Nationality Belum dipilih';
                              } else {
                                return null;
                              }
                            },
                            items: controller.listNation.map((data) => DropdownMenuItem(value: data.countryId, child: Text(data.name!))).toList(),
                            onChanged: (val) {
                              controller.countryId.value = val.toString();
                            },
                            onTapped: () {},
                            hintText: 'Nationality',
                            value: controller.countryId.value.isEmpty ? null : controller.countryId.value,
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: CustomTextField(
                    onChanged: (val) {
                      controller.birthPlace.value = val!;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Kota Kelahiran Belum diisi';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) {
                      controller.birthPlace.value = val!;
                    },
                    hintText: "Kota Kelahiran",
                    keyboardType: TextInputType.text,
                    focusNode: kotaNode,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: CustomDropdownField(
                    onSaved: (val) {
                      if (val != null) {
                        controller.gender.value = val.toString();
                      }
                    },
                    validator: (val) {
                      if (val == null) {
                        return 'Jenis Kelamin Belum dipilih';
                      } else {
                        return null;
                      }
                    },
                    items: controller.genderType.map((data) => DropdownMenuItem(value: data, child: Text(data.capitalize!))).toList(),
                    onChanged: (val) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      controller.gender.value = val.toString();
                    },
                    hintText: 'Jenis Kelamin',
                    value: controller.gender.value.isEmpty ? null : controller.gender.value,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: CustomFlatButton(
                width: screenWidth,
                text: "Lanjut",
                onPressed: () async {
                  final bool res = formKey.currentState!.validate();

                  if (res) {
                    controller.currentStep.value += 1;
                    controller.isChooseStep2.value = true;

                    formKey.currentState!.save();
                    Get.toNamed("${Routes.ADD_PATIENT_ADDRESS}?doctorId=$doctorIdFromParam");
                  }
                },
                color: kButtonColor),
          ),
          const SizedBox(
            height: 28,
          ),
        ],
      ),
    );
  }
}
