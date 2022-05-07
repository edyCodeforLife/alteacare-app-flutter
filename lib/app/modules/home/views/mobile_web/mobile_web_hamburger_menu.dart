// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/call_screen/controllers/call_screen_controller.dart';
import 'package:altea/app/modules/choose_payment/controllers/choose_payment_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/login/views/login_view_mobile_web.dart';
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:altea/app/routes/app_pages.dart';

class MobileWebHamburgerMenu extends GetView<HomeController> {
  static final List<Map<String, String>> menuList = [
    {"title": "Beranda", "image": "assets/path.png", "path": "/home"},
    {"title": "Dokter Spesialis", "image": "assets/spesialis.png", "path": "/doctor"},
    {"title": "Konsultasi Saya", "image": "assets/icon.png", "path": "/my-consultation"},
    {"title": "Notifikasi", "image": "assets/group-2.png", "path": "/notifications"},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(color: kLightBlue),
          child: Column(
            children: [
              const SizedBox(
                height: kToolbarHeight,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: kButtonColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.accessTokens.isEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: Row(
                                children: [
                                  Image.asset('assets/account-info.png'),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      // Get.to(() => LoginViewMobileWeb());

                                      Get.toNamed('/login');
                                    },
                                    child: Text(
                                      'Sign In',
                                      style: kSubHeaderStyle.copyWith(fontWeight: FontWeight.w500, color: kDarkBlue),
                                    ),
                                  )
                                ],
                              ),
                            )
                          else
                            InkWell(
                              onTap: () {
                                Get.back();
                                if (Get.currentRoute == Routes.MY_PROFILE) {
                                  // print("masih di my profile");
                                } else {
                                  Get.toNamed(Routes.MY_PROFILE);
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: Obx(() => Row(
                                      children: [
                                        if (controller.userData.value.data != null)
                                          controller.userData.value.data!.userDetails!.avatar != null
                                              ? SizedBox(
                                                  width: screenWidth * 0.15,
                                                  height: screenWidth * 0.15,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(100),
                                                    child: Image.network(
                                                      addCDNforLoadImage(
                                                        controller.userData.value.data!.userDetails!.avatar["formats"]["thumbnail"].toString(),
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : Image.asset('assets/account-info.png')
                                        else
                                          Image.asset('assets/account-info.png'),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          '${controller.userProfile.value.firstName} ${controller.userProfile.value.lastName}',
                                          style: kSubHeaderStyle.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: kDarkBlue,
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: (MediaQuery.of(context).size.width >= 360)
                                ? MediaQuery.of(context).size.width * 0.5
                                : MediaQuery.of(context).size.width * 0.6,
                            child: ListView(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    // Get.back();
                                    if (Get.currentRoute == "/home") {
                                    } else {
                                      Get.toNamed("/home");
                                    }
                                    Get.delete<SpesialisKonsultasiController>();
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/path.png",
                                        width: 45,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Beranda",
                                        style: kButtonTextStyle.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF949698),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    // Get.back();
                                    if (Get.currentRoute == "/doctor") {
                                    } else {
                                      Get.toNamed("/doctor");
                                    }
                                    Get.delete<SpesialisKonsultasiController>();
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/spesialis.png",
                                        width: 45,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Dokter Spesialis",
                                        style: kButtonTextStyle.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF949698),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    // Get.back();
                                    if (Get.currentRoute == "/my-consultation") {
                                    } else {
                                      if (controller.accessTokens.isEmpty) {
                                        Get.toNamed("/login");
                                        Get.delete<SpesialisKonsultasiController>();
                                      } else {
                                        Get.toNamed("/my-consultation");
                                        Get.delete<SpesialisKonsultasiController>();
                                      }
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/icon.png",
                                        width: 45,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Konsultasi Saya",
                                        style: kButtonTextStyle.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF949698),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                if (controller.accessTokens.isEmpty)
                                  Container()
                                else
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      // Get.back();
                                      if (Get.currentRoute == "/notifications") {
                                      } else {
                                        Get.toNamed("/notifications");
                                      }
                                      Get.delete<SpesialisKonsultasiController>();
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/group-2.png",
                                          width: 45,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Notifikasi",
                                          style: kButtonTextStyle.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF949698),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Image.asset('assets/mask.png')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
