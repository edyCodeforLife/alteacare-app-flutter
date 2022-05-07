// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:email_validator/email_validator.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:timer_count_down/timer_count_down.dart';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/widgets/custom_dropdown_field.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/core/widgets/validation_card.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/my_profile/views/desktop_web_view/widgets/desktop_web_my_profile_add_patient_address_demo.dart';
import 'package:altea/app/modules/profile-edit-detail/controllers/profile_edit_detail_controller.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/utils/use_shared_pref.dart';
import '../../../../core/widgets/custom_flat_button.dart';
import '../../../../data/model/my_profile.dart';
import '../../../../routes/app_pages.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../home/views/dekstop_web/widget/footer_section_view.dart';
import '../../../home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import '../../../register/presentation/modules/register/views/custom_simple_dialog.dart';
import '../../controllers/my_profile_controller.dart';

class DesktopWebMyProfileView extends GetView<MyProfileController> {
  const DesktopWebMyProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final screenWidth = context.width;
    return Obx(() => LoadingOverlay(
          isLoading: controller.isLoading.value,
          color: kButtonColor.withOpacity(0.1),
          opacity: 0.8,
          child: Scaffold(
            backgroundColor: kBackground,
            body: FutureBuilder<MyProfile>(
              future: controller.getProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final result = snapshot.data!;
                  // homeController.avatarUrl.value = result
                  //     .data!.userDetails!.avatar["formats"]["thumbnail"]
                  //     .toString();

                  // if (result.data!.userDetails!.avatar != null) {
                  // homeController.avatarUrl.value = result
                  //     .data!.userDetails!.avatar["formats"]["thumbnail"]
                  //     .toString();
                  // }

                  return Column(
                    children: [
                      TopNavigationBarSection(screenWidth: screenWidth),
                      Expanded(
                        child: ListView(
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: MyProfileMenuSection(
                                      data: result.data!,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 28,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Obx(
                                      () => controller.showWidget(controller.selectedMyProfileMenu.value, result.data!),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 75,
                            ),
                            FooterSectionWidget(screenWidth: screenWidth)
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ));
  }
}

class AlteaContactCareSection extends StatefulWidget {
  const AlteaContactCareSection({Key? key}) : super(key: key);

  static final GlobalKey<FormState> _verifKey = GlobalKey<FormState>();

  @override
  _AlteaContactCareSectionState createState() => _AlteaContactCareSectionState();
}

class _AlteaContactCareSectionState extends State<AlteaContactCareSection> {
  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final controller = Get.find<MyProfileController>();
    final screenWidth = context.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 49),
      height: screenWidth * 0.42,
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: kLightGray,
            blurRadius: 12,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kontak AlteaCare",
                      style: kPoppinsMedium500.copyWith(fontSize: 13, color: kLightGray),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Form(
                      key: AlteaContactCareSection._verifKey,
                      child: Column(
                        children: [
                          FutureBuilder<Map<String, dynamic>>(
                              future: controller.getMessageAlteaCareType(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final result = snapshot.data!["data"] as List;
                                  return Obx(() => CustomDropdownField(
                                        borderRadius: 8,
                                        onSaved: (val) {
                                          if (val != null) {}
                                        },
                                        validator: (val) {
                                          if (val == null) {
                                            return 'Message type belum dipilih';
                                          }
                                        },
                                        items: result
                                            .map((data) => DropdownMenuItem(value: data["id"].toString(), child: Text(data["name"].toString())))
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != "") {
                                            AlteaContactCareSection._verifKey.currentState?.validate();
                                          }
                                          controller.messageType.value = val.toString();
                                        },
                                        hintText: 'Pilih Kategori Pesan',
                                        value: controller.messageType.value.isEmpty ? null : controller.messageType.value,
                                      ));
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Pesan Belum diisi';
                              }
                            },
                            controller: controller.messageAlteaController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kRedError, width: 2.0)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              fillColor: kTextFieldColor,
                              filled: true,
                              hintText: "Tulis Pesan Anda",
                              errorStyle: kErrorTextStyle,
                              hintStyle: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray),
                            ),
                            maxLines: 5,
                            onChanged: (val) {
                              if (val != "") {
                                AlteaContactCareSection._verifKey.currentState?.validate();
                              }
                              controller.messageAltea.value = val;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: screenWidth,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () async {
                            controller.isLoading.value = true;
                            // print("noHape -> ${controller.noHp.value}");

                            final res = AlteaContactCareSection._verifKey.currentState?.validate();

                            if (res == true) {
                              final String userName =
                                  "${homeController.userData.value.data!.firstName} ${homeController.userData.value.data!.lastName}";
                              final String userPhoneNum = homeController.userData.value.data!.phone!;
                              final String emailuser = homeController.userData.value.data!.email!;
                              final String userId = homeController.userData.value.data!.id!;

                              final result = await controller.contactAlteaCare(
                                  messageType: controller.messageType.value,
                                  message: controller.messageAltea.value,
                                  userName: userName,
                                  emailuser: emailuser,
                                  userId: userId,
                                  userPhoneNum: userPhoneNum);

                              if (result["status"] == true) {
                                setState(() {
                                  // reset
                                  controller.messageType.value = "";
                                  controller.messageAltea.value = "";
                                  FocusScope.of(context).unfocus();
                                  controller.messageAlteaController.clear();
                                });

                                Fluttertoast.showToast(
                                  msg: "Pesan anda berhasil dikirim ke Altea Care",
                                  backgroundColor: kGreenColor.withOpacity(0.2),
                                  textColor: kGreenColor,
                                  webShowClose: true,
                                  timeInSecForIosWeb: 8,
                                  fontSize: 13,
                                  gravity: ToastGravity.TOP,
                                  webPosition: 'center',
                                  toastLength: Toast.LENGTH_LONG,
                                  webBgColor: '#F8FCF5',
                                );
                                controller.isLoading.value = false;
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
                                    title: 'Gagal mengirim pesan ke Altea Care',
                                    buttonTxt: 'Mengerti',
                                    subtitle: result["message"].toString(),
                                  ),
                                );
                              }

                              controller.isLoading.value = false;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: kButtonColor,
                            elevation: 0,
                          ),
                          child: Text(
                            "Kirim Pesan",
                            style: kPoppinsMedium500.copyWith(
                              fontSize: 13,
                              color: kBackground,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 58,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Email:",
                        style: kPoppinsRegular400.copyWith(color: kTextHintColor.withOpacity(0.5), fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.email_rounded,
                            color: kButtonColor,
                            size: 18,
                          ),
                          label: Text("cs@alteacare.com", style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor))),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Hotline WA:",
                        style: kPoppinsRegular400.copyWith(color: kTextHintColor.withOpacity(0.5), fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.call,
                            color: kButtonColor,
                            size: 18,
                          ),
                          label: Text("+62 813 1573 9235", style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.call,
                            color: kButtonColor,
                            size: 18,
                          ),
                          label: Text("+62 813 1573 9245", style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor))),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class MyProfilePrivacyPolicyContentSection extends GetView<MyProfileController> {
  const MyProfilePrivacyPolicyContentSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return FutureBuilder<Map<String, dynamic>>(
        future: controller.getPrivacyPolicyData(),
        builder: (context, snapshot) {
          final result = snapshot.data;

          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 49),
              decoration: BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: kLightGray,
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 130,
                          child: Image.asset(
                            "assets/altea_logo.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 33,
                        ),
                        Text(
                          "Privacy Policy",
                          style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          height: screenWidth * 0.5,
                          child: HtmlWidget(
                            result!["data"][0]["text"].toString(),
                            customStylesBuilder: (_) {
                              return {'color': "0xFF606D77", 'font-size': '11px'};
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class MyProfileTnCContentSection extends GetView<MyProfileController> {
  const MyProfileTnCContentSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: controller.getTnCData(),
        builder: (context, snapshot) {
          final result = snapshot.data;

          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 49),
              decoration: BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: kLightGray,
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 130,
                          child: Image.asset(
                            "assets/altea_logo.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 33,
                        ),
                        Text(
                          "Syarat & Ketentuan",
                          style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        HtmlWidget(
                          result!["data"][0]["text"].toString(),
                          customStylesBuilder: (_) {
                            return {'color': "0xFF606D77", 'font-size': '11px'};
                          },
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class MyProfileSettingMenuContentSection extends GetView<MyProfileController> {
  const MyProfileSettingMenuContentSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 49),
      height: screenWidth * 0.42,
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: kLightGray,
            blurRadius: 12,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageControllerProfile,
        onPageChanged: (index) {
          controller.currentpage.value = index;
        },
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bahasa",
                          style: kPoppinsMedium500.copyWith(fontSize: 13, color: kLightGray),
                        ),
                        TextButton(
                            onPressed: () {
                              controller.pageControllerProfile.jumpToPage(1);
                            },
                            child: Text(
                              "Ubah",
                              style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      width: screenWidth,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                      decoration: BoxDecoration(
                        color: kWhiteGray,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        "Bahasa",
                        style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: screenWidth,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Password",
                                style: kPoppinsMedium500.copyWith(fontSize: 13, color: kLightGray),
                              ),
                              TextButton(
                                  onPressed: () {
                                    controller.pageControllerProfile.jumpToPage(2);
                                  },
                                  child: Text(
                                    "Ubah",
                                    style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                              width: screenWidth,
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                              decoration: BoxDecoration(
                                color: kWhiteGray,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                "Bahasa".replaceAll(RegExp(r"."), "*"),
                                style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
          ChangeLanguageSection(
            screenWidth: screenWidth,
            controller: controller,
          ),
          ChangePasswordSection(
            screenWidth: screenWidth,
            controller: controller,
          )
        ],
      ),
    );
  }
}

class ChangePasswordSection extends StatefulWidget {
  const ChangePasswordSection({
    Key? key,
    required this.screenWidth,
    required this.controller,
  }) : super(key: key);

  final double screenWidth;
  final MyProfileController controller;

  @override
  _ChangePasswordSectionState createState() => _ChangePasswordSectionState();
}

class _ChangePasswordSectionState extends State<ChangePasswordSection> {
  bool minCharacter = false;
  bool capsCharacter = false;
  bool smallCharacter = false;
  bool numCharacter = false;
  String password = '';

  bool passwordDone = false;
  bool correct = false;
  String confirmPass = '';
  final GlobalKey<FormState> _verifKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                child: Form(
                  key: _verifKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          widget.controller.pageControllerProfile.jumpToPage(0);
                        },
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          color: kBlackColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          "Ubah Password",
                          style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 13),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomTextField(
                          smallBorderRadius: true,
                          correctPass: correct,
                          onChanged: (val) {
                            widget.controller.oldPassword.value = val!;
                            _verifKey.currentState?.validate();
                          },
                          hintText: 'Masukkan Password Lama',
                          keyboardType: TextInputType.visiblePassword,
                          onSaved: (val) {
                            // if (val != null) {
                            //   widget.controller.confirmPassword.value = val;
                            // }
                          },
                          validator: (val) {
                            // print('val => $val');
                            if (val == '') {
                              return 'Password lama tidak boleh kosong';
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomTextField(
                          smallBorderRadius: true,
                          onChanged: (val) {
                            _verifKey.currentState?.validate();
                            setState(() {
                              correct = false;
                            });
                            if (val != '') {
                              setState(() {
                                password = val.toString();
                              });
                            }
                            if (val != null) {
                              if (val.contains(new RegExp(r'[A-Z]'))) {
                                setState(() {
                                  capsCharacter = true;
                                });
                              } else {
                                setState(() {
                                  capsCharacter = false;
                                });
                              }

                              if (val.contains(new RegExp(r'[a-z]'))) {
                                setState(() {
                                  smallCharacter = true;
                                });
                              } else {
                                setState(() {
                                  smallCharacter = false;
                                });
                              }

                              if (val.contains(new RegExp(r'[0-9]'))) {
                                setState(() {
                                  numCharacter = true;
                                });
                              } else {
                                setState(() {
                                  numCharacter = false;
                                });
                              }

                              if (val.length >= 8) {
                                setState(() {
                                  minCharacter = true;
                                });
                              } else {
                                setState(() {
                                  minCharacter = false;
                                });
                              }

                              if (minCharacter && numCharacter && smallCharacter && capsCharacter) {
                                passwordDone = true;
                              } else {
                                passwordDone = false;
                              }

                              if (val.toString() == confirmPass) {
                                _verifKey.currentState?.validate();
                                setState(() {
                                  correct = true;
                                });
                              } else {
                                setState(() {
                                  correct = false;
                                });
                              }
                            }
                          },
                          hintText: 'Masukkan Password Baru',
                          keyboardType: TextInputType.visiblePassword,
                          onSaved: (val) {
                            // if (val != null) {
                            //   widget.controller.password.value = val;
                            // }
                          },
                          validator: (val) {
                            // print('val => $val');
                            if (val == '') {
                              return 'Password tidak boleh kosong';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      if (password == '')
                        Container()
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            children: [
                              ValidationCard(
                                condition: minCharacter,
                                text: 'Minimal 8 Karakter',
                              ),
                              ValidationCard(
                                condition: capsCharacter,
                                text: 'Huruf Kapital',
                              ),
                              ValidationCard(
                                condition: smallCharacter,
                                text: 'Huruf Kecil',
                              ),
                              ValidationCard(
                                condition: numCharacter,
                                text: 'Angka',
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomTextField(
                          smallBorderRadius: true,
                          correctPass: correct,
                          onChanged: (val) {
                            if (val != null) {
                              confirmPass = val;
                            }
                            // print('$val');
                            if (val.toString() == password) {
                              setState(() {
                                correct = true;
                              });
                              _verifKey.currentState?.validate();
                            } else {
                              setState(() {
                                correct = false;
                              });
                              _verifKey.currentState?.validate();
                            }
                          },
                          hintText: 'Masukkan Password Baru Kembali',
                          keyboardType: TextInputType.visiblePassword,
                          onSaved: (val) {
                            // if (val != null) {
                            //   widget.controller.confirmPassword.value = val;
                            // }
                          },
                          validator: (val) {
                            // print('val => $val');
                            if (val == '' || !correct) {
                              setState(() {
                                correct = false;
                              });
                              return 'Password tidak sesuai';
                            }
                          },
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: correct
                              ? Text(
                                  'Password Sesuai',
                                  style: kPswValidText,
                                )
                              : Container()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SizedBox(
                          width: widget.screenWidth,
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () async {
                                widget.controller.isLoading.value = true;
                                // print("noHape -> ${controller.noHp.value}");
                                widget.controller.password.value = password;
                                widget.controller.confirmPassword.value = password;

                                final res = _verifKey.currentState?.validate();

                                if (res == true) {
                                  _verifKey.currentState?.save();

                                  final resultOld = await widget.controller.checkOldPassword(oldPassword: widget.controller.oldPassword.value);
                                  if (resultOld["status"] == true) {
                                    final result = await widget.controller.requestChangeUserPassword(
                                        password: widget.controller.password.value, passwordConfirmation: widget.controller.confirmPassword.value);
                                    if (result["status"] == true) {
                                      widget.controller.pageControllerProfile.jumpToPage(0);

                                      setState(() {
                                        minCharacter = false;
                                        capsCharacter = false;
                                        smallCharacter = false;
                                        numCharacter = false;
                                        password = '';
                                        passwordDone = false;
                                        correct = false;
                                        confirmPass = '';
                                      });

                                      Fluttertoast.showToast(
                                        msg: "Password Berhasil Diubah",
                                        backgroundColor: kGreenColor.withOpacity(0.2),
                                        textColor: kGreenColor,
                                        webShowClose: true,
                                        timeInSecForIosWeb: 5,
                                        fontSize: 13,
                                        gravity: ToastGravity.TOP,
                                        webPosition: 'center',
                                        toastLength: Toast.LENGTH_LONG,
                                        webBgColor: '#F8FCF5',
                                      );
                                      widget.controller.isLoading.value = false;
                                    } else {
                                      widget.controller.isLoading.value = false;
                                      setState(() {
                                        minCharacter = false;
                                        capsCharacter = false;
                                        smallCharacter = false;
                                        numCharacter = false;
                                        password = '';
                                        passwordDone = false;
                                        correct = false;
                                        confirmPass = '';
                                      });

                                      return showDialog(
                                          context: context,
                                          builder: (context) => CustomSimpleDialog(
                                              icon: SizedBox(
                                                width: widget.screenWidth * 0.1,
                                                child: Image.asset("assets/failed_icon.png"),
                                              ),
                                              onPressed: () {
                                                Get.back();
                                              },
                                              title: 'Change Password Gagal',
                                              buttonTxt: 'Mengerti',
                                              subtitle: result["message"].toString()));
                                    }
                                  } else {
                                    widget.controller.isLoading.value = false;
                                    setState(() {
                                      minCharacter = false;
                                      capsCharacter = false;
                                      smallCharacter = false;
                                      numCharacter = false;
                                      password = '';
                                      passwordDone = false;
                                      correct = false;
                                      confirmPass = '';
                                    });
                                    return showDialog(
                                        context: context,
                                        builder: (context) => CustomSimpleDialog(
                                            icon: SizedBox(
                                              width: widget.screenWidth * 0.1,
                                              child: Image.asset("assets/failed_icon.png"),
                                            ),
                                            onPressed: () {
                                              Get.back();
                                            },
                                            title: 'Change Password Gagal',
                                            buttonTxt: 'Mengerti',
                                            subtitle: resultOld["message"].toString()));
                                  }
                                }
                                widget.controller.isLoading.value = false;
                              },
                              style: ElevatedButton.styleFrom(
                                primary: kButtonColor,
                                elevation: 0,
                              ),
                              child: Text(
                                "Konfirmasi",
                                style: kPoppinsMedium500.copyWith(
                                  fontSize: 13,
                                  color: kBackground,
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class ChangeLanguageSection extends StatelessWidget {
  const ChangeLanguageSection({
    Key? key,
    required this.screenWidth,
    required this.controller,
  }) : super(key: key);

  final double screenWidth;
  final MyProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.pageControllerProfile.jumpToPage(0);
                      },
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: kBlackColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Pilih Bahasa",
                        style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 13),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: InkWell(
                        onTap: () {
                          controller.selectedLanguange.value = "Bahasa";
                          controller.selectLanguange.value = 0;
                        },
                        child: Obx(() => Container(
                              padding: const EdgeInsets.only(
                                left: 22,
                                top: 12,
                              ),
                              height: 45,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                border: Border.all(color: controller.selectLanguange.value == 0 ? kButtonColor : kWhiteGray),
                                borderRadius: BorderRadius.circular(8),
                                color: kWhiteGray,
                              ),
                              child: Text("Bahasa", style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 13)),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: InkWell(
                        onTap: () {
                          controller.selectedLanguange.value = "English";
                          controller.selectLanguange.value = 1;
                        },
                        child: Obx(() => Container(
                              padding: const EdgeInsets.only(
                                left: 22,
                                top: 12,
                              ),
                              height: 45,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                border: Border.all(color: controller.selectLanguange.value == 1 ? kButtonColor : kWhiteGray),
                                borderRadius: BorderRadius.circular(8),
                                color: kWhiteGray,
                              ),
                              child: Text("English", style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 13)),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SizedBox(
                        width: screenWidth,
                        height: 45,
                        child: Obx(() => ElevatedButton(
                            onPressed: controller.selectLanguange.value == -1
                                ? null
                                : () async {
                                    // print("noHape -> ${controller.noHp.value}");
                                    // TODO: HIT API CHANGE LANGUAGE

                                    controller.pageControllerProfile.jumpToPage(0);
                                  },
                            style: ElevatedButton.styleFrom(
                              primary: kButtonColor,
                              elevation: 0,
                            ),
                            child: Text(
                              "Konfirmasi",
                              style: kPoppinsMedium500.copyWith(
                                fontSize: 13,
                                color: kBackground,
                              ),
                            ))),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class MyProfileFAQSection extends GetView<MyProfileController> {
  const MyProfileFAQSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Container(
        height: screenWidth * 0.5,
        width: screenWidth,
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 49),
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: kLightGray,
              blurRadius: 12,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "FAQ",
                        style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor.withOpacity(0.8)),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        height: screenWidth * 0.4,
                        child: FutureBuilder<Map<String, dynamic>>(
                            future: controller.getFAQWEb(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final faqListResult = snapshot.data;

                                final resultList = faqListResult!["data"] as List;

                                return Column(
                                  children: List.generate(
                                      resultList.length,
                                      (idx) => FAQCardWeb(
                                          text: resultList[idx]['answer'].toString(), title: resultList[idx]['question'].toString(), idx: idx)),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                      )
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ));
  }
}

class FAQCardWeb extends StatefulWidget {
  final String text;
  final String title;
  final int idx;

  const FAQCardWeb({required this.text, required this.title, required this.idx});
  @override
  _FAQCardWebState createState() => _FAQCardWebState();
}

class _FAQCardWebState extends State<FAQCardWeb> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kWhiteGray, borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Text(
                  widget.title,
                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_rounded,
                  color: kBlackColor,
                ),
              ),
            ],
          ),
          if (isExpanded)
            Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: kBlackColor.withOpacity(0.2),
                ),
                const SizedBox(
                  height: 8,
                ),
                HtmlWidget(
                  widget.text,
                  textStyle: kPoppinsRegular400.copyWith(color: kBlackColor.withOpacity(0.5), fontSize: 9),
                )
              ],
            )
          else
            Container()
        ],
      ),
    );
  }
}

class MyProfileMenuContentSection extends GetView<MyProfileController> {
  const MyProfileMenuContentSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final DataMyProfile data;

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final String alamat;
    if (data.userAddresses!.isNotEmpty) {
      alamat =
          "${data.userAddresses![0].street!}, Blok RT/RW${data.userAddresses![0].rtRw!}, Kel. ${data.userAddresses![0].subDistrict!.name}, Kec.${data.userAddresses![0].district!.name} ${data.userAddresses![0].city!.name} ${data.userAddresses![0].province!.name} ${data.userAddresses![0].subDistrict!.postalCode}";
    } else {
      alamat = "Alamat belum ada";
    }
    return Container(
      // height: screenWidth * 0.5,
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 49),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: kLightGray,
            blurRadius: 12,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: ExpandablePageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageControllerProfile,
        onPageChanged: (index) {
          controller.currentpage.value = index;
        },
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SizedBox(
                      width: screenWidth,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Personal Data",
                                style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor.withOpacity(0.8)),
                              ),
                              TextButton(
                                  onPressed: () {
                                    controller.pageControllerProfile.jumpToPage(1);
                                  },
                                  child: Text(
                                    "Ubah",
                                    style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                            decoration: BoxDecoration(
                              color: kWhiteGray,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Column(
                              children: [
                                PersonalDataRowWidget(
                                  dataName: "Nama",
                                  dataValue: "${data.firstName} ${data.lastName}",
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                PersonalDataRowWidget(
                                  dataName: "Umur",
                                  dataValue: "${data.userDetails!.age!.year} Tahun",
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                PersonalDataRowWidget(
                                  dataName: "Jenis Kelamin",
                                  dataValue: data.userDetails!.gender ?? "No data",
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                PersonalDataRowWidget(
                                  dataName: "Tempat Lahir",
                                  dataValue: "${data.userDetails!.birthCountry?.name}, ${data.userDetails!.birthPlace}",
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                PersonalDataRowWidget(
                                  dataName: "Tanggal Lahir",
                                  dataValue: DateFormat("dd/MM/yyyy", 'id').format(data.userDetails!.birthDate!),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                PersonalDataRowWidget(
                                  dataName: "Alamat",
                                  dataValue: alamat,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: screenWidth,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "No. Handphone",
                                style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor.withOpacity(0.8)),
                              ),
                              TextButton(
                                  onPressed: () {
                                    controller.pageControllerProfile.jumpToPage(2);
                                  },
                                  child: Text(
                                    "Ubah",
                                    style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                              width: screenWidth,
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                              decoration: BoxDecoration(
                                color: kWhiteGray,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                "+${data.phone!}",
                                style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: screenWidth,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Alamat Email",
                                style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor.withOpacity(0.8)),
                              ),
                              TextButton(
                                  onPressed: () {
                                    controller.pageControllerProfile.jumpToPage(4);
                                  },
                                  child: Text(
                                    "Ubah",
                                    style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                              width: screenWidth,
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                              decoration: BoxDecoration(
                                color: kWhiteGray,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                data.email!,
                                style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
                              )),
                        ],
                      ),
                    ),

                    //! Alamat pengiriman masih masih dummy

                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: screenWidth,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Alamat Pengiriman",
                                style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor.withOpacity(0.8)),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.put(ProfileEditDetailController());
                                    controller.pageControllerProfile.jumpToPage(6);
                                  },
                                  child: Text(
                                    "Ubah",
                                    style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                              width: screenWidth,
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                              decoration: BoxDecoration(
                                color: kWhiteGray,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                controller.selectedShippingAddress.value,
                                style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
                              )),
                          //! Alamat pengiriman masih dihide
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),

          // page berikutnya
          ChangeProfileDataSection(screenWidth: screenWidth, controller: controller),
          ChangePhoneNumberInputSection(screenWidth: screenWidth, controller: controller),

          ChangePhoneNumberInputOTP(
            screenWidth: screenWidth,
            controller: controller,
            data: data,
          ),

          ChangeEmailInputSection(
            screenWidth: screenWidth,
            controller: controller,
          ),
          ChangeEmailInputOTP(
            screenWidth: screenWidth,
            controller: controller,
            data: data,
          ),
          ChangeShipmentAddress(
            screenWidth: screenWidth,
            controller: controller,
          ),
          DesktopWebMyProfileAddPatientAddressDemo(),
        ],
      ),
    );
  }
}

class ChangeEmailInputOTP extends StatefulWidget {
  const ChangeEmailInputOTP({
    Key? key,
    required this.screenWidth,
    required this.controller,
    required this.data,
  }) : super(key: key);

  final double screenWidth;
  final DataMyProfile data;

  final MyProfileController controller;

  @override
  _ChangeEmailInputOTPState createState() => _ChangeEmailInputOTPState();
}

class _ChangeEmailInputOTPState extends State<ChangeEmailInputOTP> {
  final controller = Get.find<MyProfileController>();
  static final GlobalKey<FormState> _verifKey = GlobalKey<FormState>();
  bool countdownDone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.countdownCtrl.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              SizedBox(
                width: widget.screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        widget.controller.pageControllerProfile.jumpToPage(0);
                      },
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: kBlackColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: "Kode verifikasi telah dikirim via Email ke ",
                                style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 13)),
                            TextSpan(text: widget.data.email, style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 13))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 37,
                    ),
                    Form(
                      child: PinPut(
                        onChanged: (val) {
                          if (val != "") {
                            widget.controller.otp.value = val;
                          }
                        },

                        // keyboardType: TextInputType.number,
                        fieldsCount: 6,
                        eachFieldHeight: 90,
                        eachFieldWidth: 90,
                        textStyle: kPinStyle,
                        followingFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        submittedFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        selectedFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(
                      height: 29,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: countdownDone
                                  ? () async {
                                      if (countdownDone) {
                                        setState(() {
                                          countdownDone = false;
                                        });
                                        widget.controller.countdownCtrl.restart();
                                      }
                                    }
                                  : null,
                              child: Text(
                                'Kirim Ulang Kode ',
                                style: kVerifText1.copyWith(fontWeight: FontWeight.w400),
                              )),
                          Countdown(
                            seconds: 60,
                            interval: Duration(seconds: 1),
                            controller: widget.controller.countdownCtrl,
                            build: (context, time) {
                              // print(time);
                              // widget.controller.countdownCtrl.start();
                              String minutes = '0';
                              String seconds = '0';
                              if (time >= 120) {
                                minutes = '02';
                                seconds = (time - 120).toStringAsFixed(0).length == 2
                                    ? (time - 120).toStringAsFixed(0)
                                    : '0${(time - 120).toStringAsFixed(0)}';
                              } else if (time >= 60) {
                                minutes = '01';
                                seconds = (time - 60).toStringAsFixed(0).length == 2
                                    ? (time - 60).toStringAsFixed(0)
                                    : '0${(time - 60).toStringAsFixed(0)}';
                              } else {
                                minutes = '00';
                                seconds = time.toStringAsFixed(0).length == 2 ? time.toStringAsFixed(0) : '0${time.toStringAsFixed(0)}';
                              }
                              // print('$minutes : $seconds');

                              return Text(
                                '$minutes : $seconds',
                                style: kVerifText2.copyWith(color: kRedError),
                              );
                            },
                            onFinished: () {
                              // print('countdown done!');
                              setState(() {
                                countdownDone = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: kButtonColor,
                          elevation: 0,
                        ),
                        onPressed: () async {
                          controller.isOtpCorrect.value = true;

                          final result = await controller.changeEmail(newEmail: controller.email.value, otpNum: controller.otp.value);

                          if (result["status"] == true) {
                            widget.controller.pageControllerProfile.jumpToPage(0);
                            Fluttertoast.showToast(
                              msg: "Alamat Email Berhasil Diubah",
                              backgroundColor: kGreenColor.withOpacity(0.2),
                              textColor: kGreenColor,
                              webShowClose: true,
                              timeInSecForIosWeb: 5,
                              fontSize: 13,
                              gravity: ToastGravity.TOP,
                              webPosition: 'center',
                              toastLength: Toast.LENGTH_LONG,
                              webBgColor: '#F8FCF5',
                            );
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
                                    title: 'Wrong Input OTP Number',
                                    buttonTxt: 'Mengerti',
                                    subtitle: result["message"].toString()));
                            controller.isOtpCorrect.value = false;
                            _verifKey.currentState?.validate();
                          }
                        },
                        child: Text(
                          'Verifikasi',
                          style: kPoppinsMedium500.copyWith(
                            color: kBackground,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

// ! Ini code for otp no hp
class ChangePhoneNumberInputOTP extends StatefulWidget {
  const ChangePhoneNumberInputOTP({
    Key? key,
    required this.screenWidth,
    required this.controller,
    required this.data,
  }) : super(key: key);

  final double screenWidth;
  final MyProfileController controller;
  final DataMyProfile data;

  @override
  _ChangePhoneNumberInputOTPState createState() => _ChangePhoneNumberInputOTPState();
}

class _ChangePhoneNumberInputOTPState extends State<ChangePhoneNumberInputOTP> {
  final controller = Get.find<MyProfileController>();
  static final GlobalKey<FormState> _verifKey = GlobalKey<FormState>();
  bool countdownDone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.countdownCtrl.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              SizedBox(
                width: widget.screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        widget.controller.pageControllerProfile.jumpToPage(0);
                      },
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: kBlackColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: "Kode verifikasi telah dikirim via SMS ke ",
                                  style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 13)),
                              TextSpan(text: widget.data.phone, style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 13))
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 37,
                    ),
                    Form(
                      key: _verifKey,
                      child: SizedBox(
                        height: 90,
                        child: PinPut(
                          onChanged: (val) {
                            if (val != "") {
                              widget.controller.otp.value = val;
                            }
                          },
                          // keyboardType: TextInputType.number,
                          fieldsCount: 6,
                          eachFieldHeight: 90,
                          eachFieldWidth: 90,

                          textStyle: kPinStyle,

                          followingFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          submittedFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          selectedFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 29,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: countdownDone
                                  ? () async {
                                      if (countdownDone) {
                                        // await controller.forgotPasswordAccount(
                                        //     email: controller.email.value);

                                        setState(() {
                                          countdownDone = false;
                                        });
                                        widget.controller.countdownCtrl.restart();
                                      }
                                    }
                                  : null,
                              child: Text(
                                'Kirim Ulang Kode ',
                                style: kVerifText1.copyWith(fontWeight: FontWeight.w400),
                              )),
                          Countdown(
                            seconds: 60,
                            controller: widget.controller.countdownCtrl,
                            interval: Duration(seconds: 1),
                            build: (context, time) {
                              // print(time);
                              // widget.controller.countdownCtrl.start();
                              String minutes = '0';
                              String seconds = '0';
                              if (time >= 120) {
                                minutes = '02';
                                seconds = (time - 120).toStringAsFixed(0).length == 2
                                    ? (time - 120).toStringAsFixed(0)
                                    : '0${(time - 120).toStringAsFixed(0)}';
                              } else if (time >= 60) {
                                minutes = '01';
                                seconds = (time - 60).toStringAsFixed(0).length == 2
                                    ? (time - 60).toStringAsFixed(0)
                                    : '0${(time - 60).toStringAsFixed(0)}';
                              } else {
                                minutes = '00';
                                seconds = time.toStringAsFixed(0).length == 2 ? time.toStringAsFixed(0) : '0${time.toStringAsFixed(0)}';
                              }
                              // print('$minutes : $seconds');

                              return Text(
                                '$minutes : $seconds',
                                style: kVerifText2.copyWith(color: kRedError),
                              );
                            },
                            onFinished: () {
                              // print('countdown done!');
                              setState(() {
                                countdownDone = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: kButtonColor,
                          elevation: 0,
                        ),
                        onPressed: () async {
                          controller.isOtpCorrect.value = true;
                          final res = _verifKey.currentState?.validate();

                          if (res == true) {
                            final result =
                                await controller.changePhoneNumber(newPhoneNum: widget.controller.noHp.value, otpNum: widget.controller.otp.value);
                            if (result["status"] == true) {
                              widget.controller.pageControllerProfile.jumpToPage(0);
                              Fluttertoast.showToast(
                                msg: "No Handphone Berhasil Diubah",
                                backgroundColor: kGreenColor.withOpacity(0.2),
                                textColor: kGreenColor,
                                webShowClose: true,
                                timeInSecForIosWeb: 5,
                                fontSize: 13,
                                gravity: ToastGravity.TOP,
                                webPosition: 'center',
                                toastLength: Toast.LENGTH_LONG,
                                webBgColor: '#F8FCF5',
                              );
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
                                      title: 'Wrong Input OTP Number',
                                      buttonTxt: 'Mengerti',
                                      subtitle: result["message"].toString()));
                              controller.isOtpCorrect.value = false;
                              _verifKey.currentState?.validate();
                            }
                          } else {
                            controller.isOtpCorrect.value = false;
                            _verifKey.currentState?.validate();
                          }
                        },
                        child: Text(
                          'Verifikasi',
                          style: kPoppinsMedium500.copyWith(
                            color: kBackground,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

// ! end off code for otp no hp

// ? check codingan apa ini
// class ChangePhoneNumberVerificationSection extends StatelessWidget {
//   static final GlobalKey<FormState> _verifKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = context.width;
//     final controller = Get.find<MyProfileController>();
//     return Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: Column(
//             children: [
//               SizedBox(
//                 width: screenWidth,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         controller.pageControllerProfile.jumpToPage(0);
//                       },
//                       child: const Icon(
//                         Icons.chevron_left_rounded,
//                         color: kBlackColor,
//                         size: 28,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 25,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                       child: Text(
//                         'Kode verifikasi telah dikirim via SMS ke ${controller.noHp.value}',
//                         style: kVerifText1,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 18,
//                     ),
//                     Form(
//                       key: _verifKey,
//                       child: CustomTextField(
//                         smallBorderRadius: true,
//                         onChanged: (val) {
//                           if (val!.isNotEmpty) {
//                             _verifKey.currentState!
//                                 .validate(); // to set when user type again from empty
//                           }

//                           controller.noHp.value = val;
//                         },
//                         validator: (val) {
//                           if (val == "") {
//                             return 'No handphone tidak boleh kosong';
//                           }
//                         },
//                         onSaved: (val) {},
//                         hintText: "Masukkan No. Handphone Baru",
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 18,
//                     ),
//                     SizedBox(
//                       width: screenWidth,
//                       height: 45,
//                       child: ElevatedButton(
//                           onPressed: () async {
//                             final bool res = _verifKey.currentState!.validate();

//                             if (res) {
//                               // print("noHape -> ${controller.noHp.value}");
//                               final result =
//                                   await controller.requestChangePhoneNumber(
//                                       controller.noHp.value);

//                               if (result["status"] == true) {
//                               } else {
//                                 showDialog(
//                                     context: context,
//                                     builder: (context) => CustomSimpleDialog(
//                                         icon: SizedBox(
//                                           width: screenWidth * 0.1,
//                                           child: Image.asset(
//                                               "assets/failed_icon.png"),
//                                         ),
//                                         onPressed: () {
//                                           Get.back();
//                                         },
//                                         title:
//                                             'Failed to request change phone number',
//                                         buttonTxt: 'Mengerti',
//                                         subtitle:
//                                             result["message"].toString()));
//                               }
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary: kButtonColor,
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             "Konfirmasi",
//                             style: kPoppinsMedium500.copyWith(
//                               fontSize: 13,
//                               color: kBackground,
//                             ),
//                           )),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const Spacer(),
//       ],
//     );
//   }
// }

class ChangePhoneNumberInputSection extends StatelessWidget {
  const ChangePhoneNumberInputSection({
    Key? key,
    required this.screenWidth,
    required this.controller,
  }) : super(key: key);

  final double screenWidth;
  final MyProfileController controller;
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.pageControllerProfile.jumpToPage(0);
                      },
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: kBlackColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Ubah No. Handphone",
                        style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 13),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Form(
                      key: formKey,
                      child: CustomTextField(
                        smallBorderRadius: true,
                        onChanged: (val) {
                          if (val!.isNotEmpty) {
                            formKey.currentState!.validate(); // to set when user type again from empty
                          }

                          controller.noHp.value = val;
                        },
                        validator: (val) {
                          if (val == "") {
                            return 'No handphone tidak boleh kosong';
                          }
                        },
                        onSaved: (val) {},
                        hintText: "Masukkan No. Handphone Baru",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    SizedBox(
                      width: screenWidth,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () async {
                            final bool res = formKey.currentState!.validate();

                            if (res) {
                              // print("noHape -> ${controller.noHp.value}");
                              final result = await controller.requestChangePhoneNumber(controller.noHp.value);

                              if (result["status"] == true) {
                                controller.pageControllerProfile.jumpToPage(3);
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
                                        title: 'Failed to request change phone number',
                                        buttonTxt: 'Mengerti',
                                        subtitle: result["message"].toString()));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: kButtonColor,
                            elevation: 0,
                          ),
                          child: Text(
                            "Konfirmasi",
                            style: kPoppinsMedium500.copyWith(
                              fontSize: 13,
                              color: kBackground,
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class ChangeEmailInputSection extends StatelessWidget {
  const ChangeEmailInputSection({
    Key? key,
    required this.screenWidth,
    required this.controller,
  }) : super(key: key);

  final double screenWidth;
  final MyProfileController controller;
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.pageControllerProfile.jumpToPage(0);
                      },
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: kBlackColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Ubah Alamat Email",
                        style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 13),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Form(
                      key: formKey,
                      child: CustomTextField(
                        smallBorderRadius: true,
                        onChanged: (val) {
                          if (val!.isNotEmpty) {
                            formKey.currentState!.validate(); // to set when user type again from empty
                          }

                          controller.email.value = val;
                        },
                        validator: (val) {
                          if (val == "") {
                            return 'Alamat email tidak boleh kosong';
                          } else if (EmailValidator.validate(val!) == false) {
                            return "Please enter a valid email";
                          }
                        },
                        onSaved: (val) {},
                        hintText: "Masukkan Alamat Email Yang Baru",
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    SizedBox(
                      width: screenWidth,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () async {
                            final bool res = formKey.currentState!.validate();

                            if (res) {
                              // print("noHape -> ${controller.noHp.value}");
                              final result = await controller.requestChangeEmail(controller.email.value);

                              if (result["status"] == true) {
                                controller.pageControllerProfile.jumpToPage(5);
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
                                        title: 'Failed to request change email address',
                                        buttonTxt: 'Mengerti',
                                        subtitle: result["message"].toString()));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: kButtonColor,
                            elevation: 0,
                          ),
                          child: Text(
                            "Konfirmasi",
                            style: kPoppinsMedium500.copyWith(
                              fontSize: 13,
                              color: kBackground,
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class ChangeProfileDataSection extends StatelessWidget {
  const ChangeProfileDataSection({
    Key? key,
    required this.screenWidth,
    required this.controller,
  }) : super(key: key);

  final double screenWidth;
  final MyProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.pageControllerProfile.jumpToPage(0);
                      },
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: kBlackColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Personal Data tidak dapat diubah. Perubahan data hanya dapat diajukan dengan menghubungi customer service AlteaCare.",
                        style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 13),
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Email:",
                        style: kPoppinsRegular400.copyWith(color: kTextHintColor.withOpacity(0.5), fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.email_rounded,
                            color: kButtonColor,
                            size: 18,
                          ),
                          label: Text("cs@alteacare.com", style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor))),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Hotline WA:",
                        style: kPoppinsRegular400.copyWith(color: kTextHintColor.withOpacity(0.5), fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.call,
                            color: kButtonColor,
                            size: 18,
                          ),
                          label: Text("+62 813 1573 9235", style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.call,
                            color: kButtonColor,
                            size: 18,
                          ),
                          label: Text("+62 813 1573 9245", style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor))),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class ChangeShipmentAddress extends StatefulWidget {
  final double screenWidth;
  final MyProfileController controller;
  ChangeShipmentAddress({required this.screenWidth, required this.controller});

  @override
  _MWEditProfileAddressState createState() => _MWEditProfileAddressState();
}

class _MWEditProfileAddressState extends State<ChangeShipmentAddress> {
  String selectedId = '';
  ProfileEditDetailController controller = Get.find<ProfileEditDetailController>();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  widget.controller.pageControllerProfile.jumpToPage(0);
                },
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: kBlackColor,
                  size: 28,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'List Alamat Pengiriman',
                    style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor.withOpacity(0.5)),
                  ),
                  InkWell(
                    onTap: () async {
                      Get.put(AddPatientController());
                      Get.put(SpesialisKonsultasiController());
                      widget.controller.pageControllerProfile.jumpToPage(7);
                      // print('wew');
                      // await Get.toNamed('/patient-address');
                      // setState(() {});
                    },
                    child: Text(
                      'Tambah Alamat',
                      style: kPoppinsSemibold600.copyWith(fontSize: 11, color: kDarkBlue),
                    ),
                  )
                ],
              ),
              FutureBuilder(
                future: controller.getAddresses(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // print('snapshot data => ${snapshot.data}');
                    List<dynamic> addressess = (snapshot.data as Map<String, dynamic>)['data']['address'] as List<dynamic>;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: addressess.length,
                      itemBuilder: (context, idx) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedId = addressess[idx]['id'].toString();
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: kWhiteGray,
                                border: Border.all(color: addressess[idx]['id'] == selectedId ? kDarkBlue : kWhiteGray, width: 2)),
                            child: Text(
                              "Jl. ${addressess[idx]['street'] == null ? " " : addressess[idx]['street']!}, Blok RT/RW${addressess[idx]['rt_rw'] == null ? " " : addressess[idx]['rt_rw']!}, Kel. ${addressess[idx]['subdistrict'] == null ? " " : addressess[idx]['subdistrict']!.name}, Kec.${addressess[idx]['district'] == null ? "" : addressess[idx]['district']!['name']} ${addressess[idx]['city'] == null ? "" : addressess[idx]['city']!['name']} ${addressess[idx]['province'] == null ? " " : addressess[idx]['province']!['name']} ${addressess[idx]['subdistrict'] == null ? " " : addressess[idx]['subdistrict']!['postal_code']}",
                              style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: widget.screenWidth,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    // final bool res = _verifKey.currentState!.validate();

                    // if (res) {
                    //   // print("noHape -> ${controller.noHp.value}");
                    //   final result = await controller.requestChangePhoneNumber(controller.noHp.value);

                    //   if (result["status"] == true) {
                    //   } else {
                    //     showDialog(
                    //         context: context,
                    //         builder: (context) => CustomSimpleDialog(
                    //             icon: SizedBox(
                    //               width: screenWidth * 0.1,
                    //               child: Image.asset("assets/failed_icon.png"),
                    //             ),
                    //             onPressed: () {
                    //               Get.back();
                    //             },
                    //             title: 'Failed to request change phone number',
                    //             buttonTxt: 'Mengerti',
                    //             subtitle: result["message"].toString()));
                    //   }
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: kButtonColor,
                    elevation: 0,
                  ),
                  child: Text(
                    "Konfirmasi",
                    style: kPoppinsMedium500.copyWith(
                      fontSize: 13,
                      color: kBackground,
                    ),
                  ),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: 12),
              //   child: CustomFlatButton(
              //       width: double.infinity,
              //       text: 'Konfirmasi',
              //       onPressed: () async {
              //         var res = await controller.updatePrimaryAddress(selectedId);

              //         print('hasil res => $res');
              //         if (res['data'] as bool) {
              //           Get.back();
              //         }
              //       },
              //       color: kButtonColor),
              //   // color: Colors.blue,
              // ),
            ],
          ),
        ),
        const Spacer()
      ],
    );
  }
}

class PersonalDataRowWidget extends StatelessWidget {
  PersonalDataRowWidget({
    Key? key,
    required this.dataName,
    required this.dataValue,
  }) : super(key: key);

  final String dataName;
  final String dataValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            dataName,
            style: kPoppinsRegular400.copyWith(fontSize: 12, color: kTextHintColor.withOpacity(0.8)),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ":",
                style: kPoppinsRegular400.copyWith(fontSize: 12, color: kTextHintColor),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  dataValue,
                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kTextHintColor),
                  softWrap: true,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class MyProfileMenuSection extends GetView<MyProfileController> {
  MyProfileMenuSection({
    Key? key,
    required this.data,
  }) : super(key: key);
  final DataMyProfile data;

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    // print("profile image -> ${data.userDetails!.avatar["formats"]["thumbnail"].toString()}");

    // print(screenWidth * 0.02);
    return Container(
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: kLightGray,
            blurRadius: 12,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 39,
          ),
          SizedBox(
            width: screenWidth * 0.06,
            height: screenWidth * 0.06,
            child: Stack(
              children: [
                SizedBox(
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      data.userDetails!.avatar != null
                          ? addCDNforLoadImage(data.userDetails!.avatar["formats"]["thumbnail"].toString())
                          : "assets/account-info@3x.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: screenWidth * 0.015,
                        height: screenWidth * 0.015,
                        decoration: BoxDecoration(color: kButtonColor, shape: BoxShape.circle, border: Border.all(color: kBackground, width: 2)),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              controller.pickPhotoFile();
                            },
                            child: const Icon(
                              Icons.add,
                              color: kBackground,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "${data.firstName} ${data.lastName}",
            style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 17),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            data.email!,
            style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 13),
          ),
          const SizedBox(
            height: 43,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              controller.myProfileMenuList.length,
              (index) => InkWell(
                onTap: () {
                  controller.selectedMyProfileMenu.value = controller.myProfileMenuList[index];
                  if (controller.selectedMyProfileMenu.value == "Keluar") {
                    Get.dialog(PopUpLogOutAccount(
                      userName: "${data.firstName} ${data.lastName}",
                    ));
                  }
                  controller.pageControllerProfile.jumpToPage(0);
                },
                child: Obx(() => Container(
                      width: screenWidth,
                      padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 18),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: controller.selectedMyProfileMenu.value == controller.myProfileMenuList[index] ? kButtonColor : kBackground,
                            width: 4,
                          ),
                        ),
                        color: controller.selectedMyProfileMenu.value == controller.myProfileMenuList[index]
                            ? kButtonColor.withOpacity(0.1)
                            : kBackground,
                      ),
                      child: Text(
                        controller.myProfileMenuList[index],
                        style: kPoppinsRegular400.copyWith(
                            color: controller.selectedMyProfileMenu.value == controller.myProfileMenuList[index] ? kButtonColor : kLightGray,
                            fontSize: controller.selectedMyProfileMenu.value == controller.myProfileMenuList[index] ? 13 : 12,
                            fontWeight:
                                controller.selectedMyProfileMenu.value == controller.myProfileMenuList[index] ? FontWeight.w500 : FontWeight.w400),
                      ),
                    )),
              ),
            ),
          ),
          const SizedBox(
            height: 28,
          ),
        ],
      ),
    );
  }
}

class PopUpLogOutAccount extends GetView<MyProfileController> {
  PopUpLogOutAccount({
    Key? key,
    required this.userName,
  }) : super(key: key);

  final String userName;

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final screnWidth = context.width;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      backgroundColor: kBackground,
      child: Container(
        width: 400,
        height: 250,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            18,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 64,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "Apakah Anda yakin mau keluar dari akun\n", style: kPoppinsRegular400.copyWith(color: kTextHintColor)),
                  TextSpan(text: userName, style: kPoppinsSemibold600.copyWith(color: kBlackColor)),
                  TextSpan(text: "?", style: kPoppinsRegular400.copyWith(color: kTextHintColor)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 41,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomFlatButton(
                  width: screnWidth * 0.1,
                  text: "Batal",
                  onPressed: () {
                    controller.selectedMyProfileMenu.value = controller.myProfileMenuList[0];
                    Get.back();
                  },
                  color: kBackground,
                  borderColor: kButtonColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                CustomFlatButton(
                  width: screnWidth * 0.1,
                  text: "Keluar",
                  onPressed: () async {
                    homeController.avatarUrl.value = "";
                    final result = await controller.userLogout();

                    if (result["status"] == true) {
                      await AppSharedPreferences.deleteAccessToken();
                      homeController.accessTokens.value = "";
                      homeController.isSelectedTabBeranda.value = true;
                      homeController.isSelectedTabDokter.value = false;
                      homeController.isSelectedTabKonsultasi.value = false;
                      Future.delayed(Duration.zero, () {
                        Get.offNamedUntil("/home", (route) => false);
                      });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => CustomSimpleDialog(
                              icon: SizedBox(
                                width: screnWidth * 0.1,
                                child: Image.asset("assets/failed_icon.png"),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              title: 'Login Gagal',
                              buttonTxt: 'Mengerti',
                              subtitle: result["message"].toString()));
                    }
                  },
                  color: kButtonColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
