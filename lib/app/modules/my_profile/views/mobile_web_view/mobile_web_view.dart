// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:email_validator/email_validator.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:timer_count_down/timer_count_down.dart';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/widgets/custom_dropdown_field.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/core/widgets/validation_card.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/my_profile/views/desktop_web_view/desktop_web_view.dart';
import 'package:altea/app/modules/my_profile/views/mobile_web_view/widgets/mw_edit_profile_address.dart';
import 'package:altea/app/modules/profile-edit-detail/controllers/profile_edit_detail_controller.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/utils/use_shared_pref.dart';
import '../../../../core/widgets/custom_flat_button.dart';
import '../../../../data/model/my_profile.dart';
import '../../../../routes/app_pages.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../home/views/mobile_web/mobile_web_hamburger_menu.dart';
import '../../../register/presentation/modules/register/views/custom_simple_dialog.dart';
import '../../controllers/my_profile_controller.dart';

class MobileWebMyProfileView extends GetView<MyProfileController> {
  const MobileWebMyProfileView({Key? key}) : super(key: key);

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;

    return Scaffold(
      key: scaffoldKey,
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawer: MobileWebHamburgerMenu(),
      body: Obx(() => LoadingOverlay(
            isLoading: controller.isLoading.value,
            color: kButtonColor.withOpacity(0.1),
            opacity: 0.8,
            child: FutureBuilder<MyProfile>(
                future: controller.getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final result = snapshot.data;
                    return ListView(
                      children: [
                        const SizedBox(
                          height: 35,
                        ),
                        Center(
                          child: SizedBox(
                            width: screenWidth * 0.3,
                            height: screenWidth * 0.3,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.3,
                                  height: screenWidth * 0.3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: result!.data!.userDetails!.avatar != null
                                        ? Image.network(addCDNforLoadImage(result.data!.userDetails!.avatar["formats"]["thumbnail"].toString()),
                                            fit: BoxFit.cover)
                                        : Image.asset(
                                            "assets/account-info@3x.png",
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
                                        width: screenWidth * 0.08,
                                        height: screenWidth * 0.08,
                                        decoration: BoxDecoration(
                                            color: kButtonColor, shape: BoxShape.circle, border: Border.all(color: kBackground, width: 2)),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              controller.pickPhotoFile();
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: kBackground,
                                              size: 22,
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
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: Text(
                            "${result.data!.firstName} ${result.data!.lastName}",
                            style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 17),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Center(
                          child: Text(
                            result.data!.email!,
                            style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 13),
                          ),
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Column(
                          children: List.generate(
                              controller.myProfileMenuList.length,
                              (index) => InkWell(
                                    onTap: () {
                                      controller.selectedMyProfileMenu.value = controller.myProfileMenuList[index];
                                      if (controller.selectedMyProfileMenu.value == "Keluar") {
                                        Get.dialog(
                                          MyProfileMobileWebPopUpLogOutAccount(
                                            userName: "${result.data!.firstName} ${result.data!.lastName}",
                                          ),
                                        );
                                      } else {
                                        controller.goToProfileSectionMobileWeb(
                                            selectedMyProfileMenu: controller.selectedMyProfileMenu.value, data: result.data!);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 33,
                                        vertical: 14,
                                      ),
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                          border: index == 0
                                              ? Border(top: BorderSide(color: kLightGray), bottom: BorderSide(color: kLightGray))
                                              : Border(bottom: BorderSide(color: kLightGray))),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.myProfileMenuList[index],
                                            style: kPoppinsRegular400.copyWith(
                                                color: controller.selectedMyProfileMenu.value == controller.myProfileMenuList[index]
                                                    ? kTextHintColor.withOpacity(0.8)
                                                    : kTextHintColor.withOpacity(0.8),
                                                fontSize: controller.selectedMyProfileMenu.value == controller.myProfileMenuList[index] ? 13 : 12,
                                                fontWeight: controller.selectedMyProfileMenu.value == controller.myProfileMenuList[index]
                                                    ? FontWeight.w500
                                                    : FontWeight.w400),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            size: 18,
                                            color: kTextHintColor.withOpacity(0.8),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                        )
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          )),
    );
  }
}

class MyProfleMobileWebAlteaContactCareSection extends StatefulWidget {
  const MyProfleMobileWebAlteaContactCareSection({Key? key}) : super(key: key);

  @override
  _MyProfleMobileWebAlteaContactCareSectionState createState() => _MyProfleMobileWebAlteaContactCareSectionState();
}

class _MyProfleMobileWebAlteaContactCareSectionState extends State<MyProfleMobileWebAlteaContactCareSection> {
  static final GlobalKey<FormState> _verifKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final controller = Get.find<MyProfileController>();
    final screenWidth = context.width;
    final screenHeight = context.height;
    return ResponsiveBuilder(builder: (_, sizingInformation) {
      if (sizingInformation.isDesktop || sizingInformation.isTablet) {
        return const DesktopWebMyProfileView();
      } else {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kBackground,
            centerTitle: false,
            leadingWidth: 0,
            title: InkWell(
              onTap: () {
                Get.offNamed("/home");
              },
              child: Image.asset(
                'assets/altea_logo.png',
                width: MediaQuery.of(context).size.width / 3,
              ),
            ),
            actions: [
              InkWell(
                  onTap: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  child: Icon(
                    Icons.menu,
                    color: kButtonColor,
                    size: screenWidth * 0.08,
                  ))
            ],
          ),
          drawer: MobileWebHamburgerMenu(),
          body: ListView(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                height: screenHeight,
                decoration: BoxDecoration(
                  color: kBackground,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 36,
                        ),
                        Text(
                          "Kontak AlteaCare",
                          style: kPoppinsMedium500.copyWith(fontSize: 17, color: kBlackColor),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Form(
                          key: _verifKey,
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
                                                _verifKey.currentState?.validate();
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
                                    _verifKey.currentState?.validate();
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

                                final res = _verifKey.currentState?.validate();

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
                                            subtitle: result["message"].toString()));
                                  }

                                  controller.isLoading.value = false;
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
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}

class MyProfileMobileWebPrivacyPolicySectionContent extends GetView<MyProfileController> {
  const MyProfileMobileWebPrivacyPolicySectionContent({Key? key}) : super(key: key);
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return ResponsiveBuilder(
      builder: (_, sizingInformation) {
        if (sizingInformation.isDesktop || sizingInformation.isTablet) {
          return const DesktopWebMyProfileView();
        } else {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kBackground,
              centerTitle: false,
              leadingWidth: 0,
              title: InkWell(
                onTap: () {
                  Get.offNamed("/home");
                },
                child: Image.asset(
                  'assets/altea_logo.png',
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: kButtonColor,
                      size: screenWidth * 0.08,
                    ))
              ],
            ),
            drawer: MobileWebHamburgerMenu(),
            body: FutureBuilder<Map<String, dynamic>>(
                future: controller.getPrivacyPolicyData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final result = snapshot.data;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 49),
                      decoration: BoxDecoration(
                        color: kBackground,
                        boxShadow: [
                          BoxShadow(
                            color: kLightGray,
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: ListView(
                        children: [
                          Text(
                            "Privacy Policy",
                            style: kPoppinsMedium500.copyWith(fontSize: 13, color: kBlackColor),
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
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          );
        }
      },
    );
  }
}

class MyProfileMobileWebTnCContentSection extends GetView<MyProfileController> {
  const MyProfileMobileWebTnCContentSection({Key? key}) : super(key: key);
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;

    // final text = ameno(paragraphs: 4, words: 1000);
    return ResponsiveBuilder(
      builder: (_, sizingInformation) {
        if (sizingInformation.isDesktop || sizingInformation.isTablet) {
          return DesktopWebMyProfileView();
        } else {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kBackground,
              centerTitle: false,
              leadingWidth: 0,
              title: InkWell(
                onTap: () {
                  Get.offNamed("/home");
                },
                child: Image.asset(
                  'assets/altea_logo.png',
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: kButtonColor,
                      size: screenWidth * 0.08,
                    ))
              ],
            ),
            drawer: MobileWebHamburgerMenu(),
            body: FutureBuilder<Map<String, dynamic>>(
                future: controller.getTnCData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final result = snapshot.data;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      decoration: BoxDecoration(
                        color: kBackground,
                        boxShadow: [
                          BoxShadow(
                            color: kLightGray,
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: ListView(
                        children: [
                          Text(
                            "Syarat & Ketentuan",
                            style: kPoppinsMedium500.copyWith(fontSize: 17, color: kBlackColor),
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
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          );
        }
      },
    );
  }
}

class ChangeLanguageMobileWebSection extends StatelessWidget {
  const ChangeLanguageMobileWebSection({
    Key? key,
    required this.screenWidth,
    required this.controller,
  }) : super(key: key);

  final double screenWidth;
  final MyProfileController controller;
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (_, sizingInformation) {
        if (sizingInformation.isDesktop || sizingInformation.isTablet) {
          return const DesktopWebMyProfileView();
        } else {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kBackground,
              centerTitle: false,
              leadingWidth: 0,
              title: InkWell(
                onTap: () {
                  Get.offNamed("/home");
                },
                child: Image.asset(
                  'assets/altea_logo.png',
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: kButtonColor,
                      size: screenWidth * 0.08,
                    ))
              ],
            ),
            drawer: MobileWebHamburgerMenu(),
            body: Column(
              children: [
                SizedBox(
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          "Pilih Bahasa",
                          style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 17),
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

                                      Get.back();
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
          );
        }
      },
    );
  }
}

class ChangePasswordSectionMobileWebSection extends StatefulWidget {
  const ChangePasswordSectionMobileWebSection({
    Key? key,
    required this.screenWidth,
    required this.controller,
  }) : super(key: key);

  final double screenWidth;
  final MyProfileController controller;

  @override
  _ChangePasswordSectionMobileWebSectionState createState() => _ChangePasswordSectionMobileWebSectionState();
}

class _ChangePasswordSectionMobileWebSectionState extends State<ChangePasswordSectionMobileWebSection> {
  bool minCharacter = false;
  bool capsCharacter = false;
  bool smallCharacter = false;
  bool numCharacter = false;
  String password = '';

  bool passwordDone = false;
  bool correct = false;
  String confirmPass = '';
  final GlobalKey<FormState> _verifKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return ResponsiveBuilder(
      builder: (_, sizingInformation) {
        if (sizingInformation.isDesktop || sizingInformation.isTablet) {
          return const DesktopWebMyProfileView();
        } else {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kBackground,
              centerTitle: false,
              leadingWidth: 0,
              title: InkWell(
                onTap: () {
                  Get.offNamed("/home");
                },
                child: Image.asset(
                  'assets/altea_logo.png',
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: kButtonColor,
                      size: screenWidth * 0.08,
                    ))
              ],
            ),
            drawer: MobileWebHamburgerMenu(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: widget.screenWidth,
                    child: Form(
                      key: _verifKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              "Ubah Password",
                              style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 17),
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
                          const SizedBox(
                            height: 20,
                          ),
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
                                            password: widget.controller.password.value,
                                            passwordConfirmation: widget.controller.confirmPassword.value);
                                        if (result["status"] == true) {
                                          Get.back();
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
          );
        }
      },
    );
  }
}

class MyProfileWebSettingMenuSection extends GetView<MyProfileController> {
  const MyProfileWebSettingMenuSection({Key? key}) : super(key: key);
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return ResponsiveBuilder(
      builder: (_, sizingInformation) {
        if (sizingInformation.isDesktop || sizingInformation.isTablet) {
          return const DesktopWebMyProfileView();
        } else {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kBackground,
              centerTitle: false,
              leadingWidth: 0,
              title: InkWell(
                onTap: () {
                  Get.offNamed("/home");
                },
                child: Image.asset(
                  'assets/altea_logo.png',
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: kButtonColor,
                      size: screenWidth * 0.08,
                    ))
              ],
            ),
            drawer: MobileWebHamburgerMenu(),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: BoxDecoration(
                color: kBackground,
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
                  SizedBox(
                    width: screenWidth,
                    child: Row(
                      children: [
                        Expanded(
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
                                        Get.to(() => ChangeLanguageMobileWebSection(
                                              screenWidth: screenWidth,
                                              controller: controller,
                                            ));
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
                                              Get.to(() => ChangePasswordSectionMobileWebSection(
                                                    screenWidth: screenWidth,
                                                    controller: controller,
                                                  ));
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class MyProfileWebSection extends GetView<MyProfileController> {
  const MyProfileWebSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final DataMyProfile data;
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final screenHeight = context.height;
    final String alamat;

    if (data.userAddresses!.isNotEmpty) {
      alamat =
          "${data.userAddresses![0].street!}, Blok RT/RW${data.userAddresses![0].rtRw!}, Kel. ${data.userAddresses![0].subDistrict!.name}, Kec.${data.userAddresses![0].district!.name} ${data.userAddresses![0].city!.name} ${data.userAddresses![0].province!.name} ${data.userAddresses![0].subDistrict!.postalCode}";
    } else {
      alamat = "Alamat belum ada";
    }
    return ResponsiveBuilder(builder: (_, sizingInformation) {
      if (sizingInformation.isDesktop || sizingInformation.isTablet) {
        return const DesktopWebMyProfileView();
      } else {
        return Scaffold(
            key: scaffoldKey,
            appBar: MobileWebMainAppbar(
              scaffoldKey: scaffoldKey,
            ),
            drawer: MobileWebHamburgerMenu(),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                decoration: BoxDecoration(
                  color: kBackground,
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
                                    Get.to(() => const MyProfileMobileWebChangeProfileDataSection());
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
                    Container(
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
                                    Get.to(() => MyProfileMobileWebChangeNumberInputSection(
                                          data: data,
                                        ));
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
                    Container(
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
                                    Get.to(() => MyProfileMobileWebChangeEmailInputSection(
                                          data: data,
                                        ));
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
                            ),
                          ),

                          //! Alamat pengiriman masih dihide
                        ],
                      ),
                    ),
                    //coba dibuka coba dibuka alamat pengirimannya~

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
                                "Alamat Pengiriman",
                                style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor.withOpacity(0.8)),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.put(ProfileEditDetailController());
                                    Get.to(() => MWEditProfileAddress(
                                        // data: data,
                                        ));
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
                              alamat,
                              style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ));
      }
    });
  }
}

class MyProfileMobileWebChangeEmailInputOTP extends StatefulWidget {
  const MyProfileMobileWebChangeEmailInputOTP({
    Key? key,
    required this.screenWidth,
    required this.controller,
    required this.data,
  }) : super(key: key);

  final double screenWidth;
  final MyProfileController controller;
  final DataMyProfile data;

  @override
  _MyProfileMobileWebChangeEmailInputOTPState createState() => _MyProfileMobileWebChangeEmailInputOTPState();
}

class _MyProfileMobileWebChangeEmailInputOTPState extends State<MyProfileMobileWebChangeEmailInputOTP> {
  final controller = Get.find<MyProfileController>();
  static final GlobalKey<FormState> _verifKey = GlobalKey<FormState>();
  bool countdownDone = false;
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
    return ResponsiveBuilder(builder: (_, sizingInformation) {
      if (sizingInformation.isDesktop || sizingInformation.isTablet) {
        controller.selectedMyProfileMenu.value = "";

        return const DesktopWebMyProfileView();
      } else {
        return Scaffold(
            backgroundColor: kBackground,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kBackground,
              centerTitle: false,
              leadingWidth: 0,
              title: InkWell(
                onTap: () {
                  Get.offNamed("/home");
                },
                child: Image.asset(
                  'assets/altea_logo.png',
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: kButtonColor,
                      size: screenWidth * 0.08,
                    ))
              ],
            ),
            drawer: MobileWebHamburgerMenu(),
            body: Column(
              children: [
                SizedBox(
                  width: widget.screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 64,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: "Kode verifikasi telah dikirim via Email ke ",
                                    style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 11)),
                                TextSpan(text: widget.data.email, style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 12))
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 26,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Form(
                          key: _verifKey,
                          child: SizedBox(
                            height: 48,
                            width: screenWidth,
                            child: PinPut(
                              onChanged: (val) {
                                if (val != "") {
                                  widget.controller.otp.value = val;
                                }
                              },
                              // keyboardType: TextInputType.number,
                              fieldsCount: 6,
                              eachFieldHeight: 48,
                              eachFieldWidth: 48,
                              eachFieldMargin: const EdgeInsets.all(4),

                              textStyle: kPinStyle,

                              followingFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                              submittedFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                              selectedFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 53,
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
                                  style: kVerifText1.copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                                )),
                            Countdown(
                              seconds: 60,
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
                        height: 53,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: SizedBox(
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
                                Get.offNamed(Routes.MY_PROFILE);
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
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ));
      }
    });
  }
}

class MyProfileMobileWebChangeEmailInputSection extends GetView<MyProfileController> {
  const MyProfileMobileWebChangeEmailInputSection({Key? key, required this.data}) : super(key: key);
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final DataMyProfile data;

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return ResponsiveBuilder(
      builder: (_, sizingInformation) {
        if (sizingInformation.isDesktop || sizingInformation.isTablet) {
          controller.selectedMyProfileMenu.value = "";
          // controller.currentpage.value = 1;

          return const DesktopWebMyProfileView();
        } else {
          return Scaffold(
            backgroundColor: kBackground,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kBackground,
              centerTitle: false,
              leadingWidth: 0,
              title: InkWell(
                onTap: () {
                  Get.offNamed("/home");
                },
                child: Image.asset(
                  'assets/altea_logo.png',
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: kButtonColor,
                      size: screenWidth * 0.08,
                    ))
              ],
            ),
            drawer: MobileWebHamburgerMenu(),
            body: Column(
              children: [
                SizedBox(
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Text(
                          "Ubah Alamat Email",
                          style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 17),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Form(
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
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: SizedBox(
                          width: screenWidth,
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () async {
                                final bool res = formKey.currentState!.validate();

                                if (res) {
                                  // print("noHape -> ${controller.noHp.value}");
                                  final result = await controller.requestChangeEmail(controller.email.value);

                                  if (result["status"] == true) {
                                    Get.to(() => MyProfileMobileWebChangeEmailInputOTP(
                                          controller: controller,
                                          data: data,
                                          screenWidth: screenWidth,
                                        ));
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
          );
        }
      },
    );
  }
}

class MyProfileMobileWebChangePhoneNumberInputOTP extends StatefulWidget {
  const MyProfileMobileWebChangePhoneNumberInputOTP({
    Key? key,
    required this.screenWidth,
    required this.controller,
    required this.data,
  }) : super(key: key);

  final double screenWidth;
  final MyProfileController controller;
  final DataMyProfile data;

  @override
  _MyProfileMobileWebChangePhoneNumberInputOTPState createState() => _MyProfileMobileWebChangePhoneNumberInputOTPState();
}

class _MyProfileMobileWebChangePhoneNumberInputOTPState extends State<MyProfileMobileWebChangePhoneNumberInputOTP> {
  final controller = Get.find<MyProfileController>();
  static final GlobalKey<FormState> _verifKey = GlobalKey<FormState>();
  bool countdownDone = false;
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
    return ResponsiveBuilder(builder: (_, sizingInformation) {
      if (sizingInformation.isDesktop || sizingInformation.isTablet) {
        controller.selectedMyProfileMenu.value = "";

        return const DesktopWebMyProfileView();
      } else {
        return Scaffold(
            backgroundColor: kBackground,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kBackground,
              centerTitle: false,
              leadingWidth: 0,
              title: InkWell(
                onTap: () {
                  Get.offNamed("/home");
                },
                child: Image.asset(
                  'assets/altea_logo.png',
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: kButtonColor,
                      size: screenWidth * 0.08,
                    ))
              ],
            ),
            drawer: MobileWebHamburgerMenu(),
            body: Column(
              children: [
                SizedBox(
                  width: widget.screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 64,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: "Kode verifikasi telah dikirim via SMS ke ",
                                    style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 11)),
                                TextSpan(text: widget.data.phone, style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 12))
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 26,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Form(
                          key: _verifKey,
                          child: SizedBox(
                            height: 48,
                            width: screenWidth,
                            child: PinPut(
                              onChanged: (val) {
                                if (val != "") {
                                  widget.controller.otp.value = val;
                                }
                              },
                              // keyboardType: TextInputType.number,
                              fieldsCount: 6,
                              eachFieldHeight: 48,
                              eachFieldWidth: 48,
                              eachFieldMargin: const EdgeInsets.all(4),

                              textStyle: kPinStyle,

                              followingFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                              submittedFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                              selectedFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 53,
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
                                  style: kVerifText1.copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                                )),
                            Countdown(
                              seconds: 60,
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
                        height: 53,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: SizedBox(
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
                                final result = await controller.changePhoneNumber(
                                    newPhoneNum: widget.controller.noHp.value, otpNum: widget.controller.otp.value);
                                if (result["status"] == true) {
                                  Future.delayed(Duration.zero, () {
                                    Get.offNamedUntil(Routes.MY_PROFILE, (route) => false);
                                  });
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
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ));
      }
    });
  }
}

class MyProfileMobileWebChangeNumberInputSection extends GetView<MyProfileController> {
  const MyProfileMobileWebChangeNumberInputSection({Key? key, required this.data}) : super(key: key);
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final DataMyProfile data;

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return ResponsiveBuilder(
      builder: (_, sizingInformation) {
        if (sizingInformation.isDesktop || sizingInformation.isTablet) {
          controller.selectedMyProfileMenu.value = "";
          // controller.currentpage.value = 1;

          return const DesktopWebMyProfileView();
        } else {
          return Scaffold(
            backgroundColor: kBackground,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kBackground,
              centerTitle: false,
              leadingWidth: 0,
              title: InkWell(
                onTap: () {
                  Get.offNamed("/home");
                },
                child: Image.asset(
                  'assets/altea_logo.png',
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: kButtonColor,
                      size: screenWidth * 0.08,
                    ))
              ],
            ),
            drawer: MobileWebHamburgerMenu(),
            body: Column(
              children: [
                SizedBox(
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Text(
                          "Ubah No. Handphone",
                          style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 17),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Form(
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
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: SizedBox(
                          width: screenWidth,
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () async {
                                final bool res = formKey.currentState!.validate();

                                if (res) {
                                  // print("noHape -> ${controller.noHp.value}");
                                  final result = await controller.requestChangePhoneNumber(controller.noHp.value);

                                  if (result["status"] == true) {
                                    Get.to(() => MyProfileMobileWebChangePhoneNumberInputOTP(
                                          controller: controller,
                                          data: data,
                                          screenWidth: screenWidth,
                                        ));
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
          );
        }
      },
    );
  }
}

class MyProfileMobileWebFAQSection extends GetView<MyProfileController> {
  const MyProfileMobileWebFAQSection({Key? key}) : super(key: key);

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return ResponsiveBuilder(builder: (_, sizingInformation) {
      if (sizingInformation.isDesktop || sizingInformation.isTablet) {
        return const DesktopWebMyProfileView();
      } else {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kBackground,
            centerTitle: false,
            leadingWidth: 0,
            title: InkWell(
              onTap: () {
                Get.offNamed("/home");
              },
              child: Image.asset(
                'assets/altea_logo.png',
                width: MediaQuery.of(context).size.width / 3,
              ),
            ),
            actions: [
              InkWell(
                  onTap: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  child: Icon(
                    Icons.menu,
                    color: kButtonColor,
                    size: screenWidth * 0.08,
                  ))
            ],
          ),
          drawer: MobileWebHamburgerMenu(),
          body: ListView(
            children: [
              Container(
                  width: screenWidth,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: kBackground,
                    boxShadow: [
                      BoxShadow(
                        color: kLightGray,
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 35,
                      ),
                      Text(
                        "FAQ",
                        style: kPoppinsMedium500.copyWith(fontSize: 17, color: kBlackColor),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      FutureBuilder<Map<String, dynamic>>(
                          future: controller.getFAQWEb(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final faqListResult = snapshot.data;

                              final resultList = faqListResult!["data"] as List;

                              return SizedBox(
                                width: screenWidth,
                                height: screenWidth * 3,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: resultList.length,
                                  itemBuilder: (context, idx) {
                                    return FAQCardWebMobileWeb(
                                        text: resultList[idx]['answer'].toString(), title: resultList[idx]['question'].toString(), idx: idx);
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          })
                    ],
                  )),
            ],
          ),
        );
      }
    });
  }
}

class FAQCardWebMobileWeb extends StatefulWidget {
  final String text;
  final String title;
  final int idx;

  const FAQCardWebMobileWeb({required this.text, required this.title, required this.idx});
  @override
  _FAQCardWebMobileWebState createState() => _FAQCardWebMobileWebState();
}

class _FAQCardWebMobileWebState extends State<FAQCardWebMobileWeb> {
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
                width: MediaQuery.of(context).size.width * 0.5,
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

class MyProfileMobileWebChangeProfileDataSection extends GetView<MyProfileController> {
  const MyProfileMobileWebChangeProfileDataSection({Key? key}) : super(key: key);

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return ResponsiveBuilder(
      builder: (_, sizingInformation) {
        if (sizingInformation.isDesktop || sizingInformation.isTablet) {
          controller.selectedMyProfileMenu.value = "";
          // controller.currentpage.value = 1;

          return const DesktopWebMyProfileView();
        } else {
          return Scaffold(
            backgroundColor: kBackground,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kBackground,
              centerTitle: false,
              leadingWidth: 0,
              title: InkWell(
                onTap: () {
                  Get.offNamed("/home");
                },
                child: Image.asset(
                  'assets/altea_logo.png',
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: kButtonColor,
                      size: screenWidth * 0.08,
                    ))
              ],
            ),
            drawer: MobileWebHamburgerMenu(),
            body: Column(
              children: [
                SizedBox(
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Text(
                          "Ubah Personal Data",
                          style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 17),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Text(
                          "Personal Data tidak dapat diubah. Perubahan data hanya dapat diajukan dengan menghubungi customer service AlteaCare.",
                          style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 13),
                        ),
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Text(
                          "Email:",
                          style: kPoppinsRegular400.copyWith(color: kTextHintColor.withOpacity(0.5), fontSize: 12),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Text(
                          "Hotline WA:",
                          style: kPoppinsRegular400.copyWith(color: kTextHintColor.withOpacity(0.5), fontSize: 12),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: TextButton.icon(
                            onPressed: null,
                            icon: Icon(
                              Icons.call,
                              color: kButtonColor,
                              size: 18,
                            ),
                            label: Text("+62 813 1573 9235", style: kPoppinsMedium500.copyWith(fontSize: 13, color: kTextHintColor))),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
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
          );
        }
      },
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
          flex: 2,
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

class MyProfileMobileWebPopUpLogOutAccount extends GetView<MyProfileController> {
  MyProfileMobileWebPopUpLogOutAccount({
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
        // width: 400,
        height: 300,
        padding: EdgeInsets.symmetric(horizontal: (screnWidth >= 360) ? 20 : 10, vertical: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            18,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 30,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomFlatButton(
                  width: screnWidth * 0.3,
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
                  width: screnWidth * 0.3,
                  text: "Keluar",
                  onPressed: () async {
                    final result = await controller.userLogout();

                    if (result["status"] == true) {
                      await AppSharedPreferences.deleteAccessToken();
                      homeController.accessTokens.value = "";

                      Get.offNamedUntil(Routes.HOME, ModalRoute.withName(Routes.HOME));
                    } else {
                      Get.dialog(
                        CustomSimpleDialog(
                          icon: SizedBox(
                            width: screnWidth * 0.1,
                            child: Image.asset("assets/failed_icon.png"),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          title: 'Login Gagal',
                          buttonTxt: 'Mengerti',
                          subtitle: result["message"].toString(),
                        ),
                      );
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
