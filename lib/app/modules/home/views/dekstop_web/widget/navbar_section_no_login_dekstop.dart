// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/data/model/sign_in_model.dart';
import 'package:altea/app/modules/doctor/controllers/doctor_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/login/controllers/login_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:altea/app/routes/app_pages.dart';

class NavBarSectionWidget extends GetView<HomeController> {
  const NavBarSectionWidget({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final doctorController = Get.find<DoctorController>();

    ScreenSize.recalculate(context);

    return Container(
      color: kBackground,
      width: screenWidth,
      child: Column(
        children: [
          SizedBox(
            height: 0.5.hb,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.wb),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(width: 10.wb),
                InkWell(
                  onTap: () {
                    Get.offNamed("/home");
                    if (controller.menus.length > 1) {
                      controller.menus.removeRange(1, controller.menus.length);
                    }
                    // print("menus-> ${controller.menus.length}");
                    controller.isSelectedTabBeranda.value = true;
                    controller.isSelectedTabDokter.value = false;
                    controller.isSelectedTabKonsultasi.value = false;
                  },
                  child: SizedBox(
                      width: 10.wb,
                      height: 10.hb,
                      child: Image.asset(
                        "assets/altea_logo.png",
                      )),
                ),
                const Spacer(),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        controller.isSelectedTabBeranda.value = true;
                        controller.isSelectedTabDokter.value = false;
                        controller.isSelectedTabKonsultasi.value = false;

                        if (controller.menus.length > 1) {
                          controller.menus.removeRange(1, controller.menus.length - 1);
                        }

                        Get.offNamed(
                          Routes.HOME,
                        );
                      },
                      child: Obx(() => Text(
                            "Beranda",
                            style: controller.isSelectedTabBeranda.value
                                ? kPoppinsSemibold600.copyWith(
                                    fontSize: 1.wb, color: controller.isSelectedTabBeranda.value ? kSubHeaderColor : kSubHeaderColor.withOpacity(0.5))
                                : kPoppinsRegular400.copyWith(
                                    fontSize: 1.wb,
                                    color: controller.isSelectedTabBeranda.value ? kSubHeaderColor : kSubHeaderColor.withOpacity(0.5)),
                          )),
                    ),
                    SizedBox(
                      width: 2.wb,
                    ),
                    InkWell(
                      onTap: () {
                        controller.isSelectedTabBeranda.value = false;
                        controller.isSelectedTabDokter.value = true;
                        controller.isSelectedTabKonsultasi.value = false;

                        if (controller.menus.length > 1) {
                          controller.menus.removeAt(1);
                        }

                        Get.toNamed(
                          Routes.DOCTOR,
                        );
                      },
                      child: Row(
                        children: [
                          Obx(() => Text(
                                "Dokter Spesialis",
                                style: controller.isSelectedTabDokter.value
                                    ? kPoppinsSemibold600.copyWith(
                                        fontSize: 1.wb,
                                        color: controller.isSelectedTabDokter.value ? kSubHeaderColor : kSubHeaderColor.withOpacity(0.5))
                                    : kPoppinsRegular400.copyWith(
                                        fontSize: 1.wb,
                                        color: controller.isSelectedTabDokter.value ? kSubHeaderColor : kSubHeaderColor.withOpacity(0.5)),
                              )),
                          // Icon(
                          //   Icons.keyboard_arrow_down_rounded,
                          //   color: kSubHeaderColor,
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 2.wb,
                    ),
                    InkWell(
                      onTap: () {
                        Get.dialog(
                          const LoginCheckDialog(),
                        );
                      },
                      child: Text(
                        "Konsultasi Saya",
                        style: controller.isSelectedTabKonsultasi.value
                            ? kPoppinsSemibold600.copyWith(
                                fontSize: 1.wb, color: controller.isSelectedTabKonsultasi.value ? kSubHeaderColor : kSubHeaderColor.withOpacity(0.5))
                            : kPoppinsRegular400.copyWith(
                                fontSize: 1.wb, color: controller.isSelectedTabKonsultasi.value ? kSubHeaderColor : kSubHeaderColor.withOpacity(0.5)),
                      ),
                    ),
                    SizedBox(
                      width: 2.wb,
                    ),
                    CustomFlatButton(
                        borderColor: kButtonColor,
                        width: 10.wb,
                        text: 'Sign In',
                        onPressed: () {
                          Get.toNamed("/login");
                        },
                        color: kBackground),
                    // Container(
                    //   color: Colors.red,
                    //   width: 10.wb,
                    //   height: 1.hb,
                    // ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginCheckDialog extends StatelessWidget {
  const LoginCheckDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final GlobalKey<FormState> loginKey = GlobalKey<FormState>();

    final loginController = Get.put(LoginController());
    final homeController = Get.find<HomeController>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: SizedBox(
        height: screenWidth * 0.4,
        width: screenWidth * 0.3,
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign In',
                          style: kHeaderStyle,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Lakukan proses sign in untuk booking konsultasi',
                          style: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: loginKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomTextField(
                            onChanged: (val) {},
                            hintText: 'Email',
                            keyboardType: TextInputType.text,
                            onSaved: (val) {
                              loginController.email.value = val.toString();
                            },
                            validator: (val) {
                              if (val == '') {
                                return 'Email tidak boleh kosong';
                              } else {
                                return null;
                              }
                            },
                          ),
                          CustomTextField(
                            onChanged: (val) {},
                            hintText: 'Password',
                            keyboardType: TextInputType.visiblePassword,
                            onSaved: (val) {
                              loginController.password.value = val.toString();
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
                          TextButton(
                            onPressed: () => Get.toNamed('/forgot'),
                            child: Text(
                              'Forgot Password',
                              style: kForgotTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: CustomFlatButton(
                        width: screenWidth * 0.8,
                        text: 'Sign In',
                        onPressed: () async {
                          final res = loginKey.currentState?.validate();
                          if (res == true) {
                            loginKey.currentState!.save();
                          }
                          final SignIn result =
                              await loginController.signInToUserAccount(email: loginController.email.value, password: loginController.password.value);
                          if (result.status == true) {
                            await AppSharedPreferences.setAccessToken(result.data!.accessToken!);

                            final String accessToken = AppSharedPreferences.getAccessToken();
                            if (accessToken.isNotEmpty) {
                              homeController.accessTokens.value = accessToken;

                              // print("access token -> ${homeController.accessTokens}");
                              Get.back();
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
                                    title: 'Login Gagal',
                                    buttonTxt: 'Mengerti',
                                    subtitle: result.message!));
                          }
                        },
                        color: kButtonColor),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            // width: double.infinity,
                            height: 1,
                            color: Colors.black38,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: 'Belum punya akun? ', style: kDontHaveAccStyle),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: kDontHaveAccStyle.copyWith(color: kDarkBlue, fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed('/register'),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // width: double.infinity,
                            height: 1,
                            color: Colors.black38,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
