// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:altea/app/data/model/my_profile.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/styles.dart';
import '../../../core/widgets/custom_flat_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../data/model/sign_in_model.dart';
import '../../register/presentation/modules/register/views/custom_simple_dialog.dart';
import '../controllers/login_controller.dart';

class LoginViewMobileWeb extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final homeController = Get.find<HomeController>();
  // final GlobalKey<FormState> homeController.loginKey = GlobalKey<FormState>(
  //   debugLabel: "login key di login view mobile web",
  // );
  // final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackground,
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          if (GetPlatform.isWeb) {
            if (sizingInformation.isMobile) {
              return SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Text(
                          'Sign In',
                          style: kHeaderStyle,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Form(
                          key: homeController.loginKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomTextField(
                                onChanged: (val) {},
                                hintText: 'Email',
                                keyboardType: TextInputType.text,
                                onSaved: (val) {
                                  controller.email.value = val.toString();
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
                                  controller.password.value = val.toString();
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
                      Center(
                        child: CustomFlatButton(
                            width: screenWidth * 0.8,
                            text: 'Sign In',
                            onPressed: () async {
                              final res = homeController.loginKey.currentState?.validate();
                              if (res == true) {
                                homeController.loginKey.currentState!.save();
                              }
                              final SignIn result =
                                  await controller.signInToUserAccount(email: controller.email.value, password: controller.password.value);
                              if (result.status == true) {
                                await AppSharedPreferences.setAccessToken(result.data!.accessToken!);

                                final String accessToken = AppSharedPreferences.getAccessToken();
                                if (accessToken.isNotEmpty) {
                                  homeController.accessTokens.value = accessToken;
                                  // print("access token -> ${homeController.accessTokens}");
                                  final MyProfile profile = await homeController.getProfile();

                                  if (profile.status!) {
                                    homeController.userProfile.value = profile.data!;
                                  }

                                  if (profile.data!.userDetails!.avatar != null) {
                                    homeController.avatarUrl.value = profile.data!.userDetails!.avatar["formats"]["thumbnail"].toString();
                                  }
                                  Get.back();
                                  // Get.offAllNamed("/home");
                                  // Get.offNamed('/home');
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
                              flex: 1,
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
                              flex: 1,
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
              );
            } else {
              return Row(
                children: [
                  Expanded(
                      child: Image.asset(
                    "assets/doctor_img.jpg",
                    fit: BoxFit.cover,
                  )),
                  Expanded(
                      child: SafeArea(
                    child: Center(
                      child: Container(
                        width: screenWidth * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                'Sign In',
                                style: kHeaderStyle,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Form(
                                key: homeController.loginKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CustomTextField(
                                      onChanged: (val) {},
                                      hintText: 'Email',
                                      keyboardType: TextInputType.text,
                                      onSaved: (val) {
                                        if (val != null) {
                                          controller.email.value = val;
                                        }
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
                                        if (val != null) {
                                          controller.password.value = val;
                                        }
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
                            CustomFlatButton(
                                width: screenWidth * 0.3,
                                text: 'Sign In',
                                onPressed: () async {
                                  final res = homeController.loginKey.currentState?.validate();

                                  if (res == true) {
                                    homeController.loginKey.currentState!.save();
                                  }
                                  final SignIn result =
                                      await controller.signInToUserAccount(email: controller.email.value, password: controller.password.value);
                                  if (result.status == true) {
                                    await AppSharedPreferences.setAccessToken(result.data!.accessToken!);

                                    final String accessToken = await AppSharedPreferences.getAccessToken();
                                    if (accessToken.isNotEmpty) {
                                      homeController.accessTokens.value = accessToken;

                                      final MyProfile profile = await homeController.getProfile();

                                      if (profile.data!.userDetails!.avatar != null) {
                                        homeController.avatarUrl.value = profile.data!.userDetails!.avatar["formats"]["thumbnail"].toString();
                                      }
                                      Get.offNamed('/home');
                                    }
                                  } else {
                                    return showDialog(
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
                                          subtitle: result.message!),
                                    );
                                  }
                                },
                                color: kButtonColor),
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
                    ),
                  ))
                ],
              );
            }
          } else {
            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/altea_logo.png',
                          width: MediaQuery.of(context).size.width / 1.8,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Form(
                          key: homeController.loginKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomTextField(
                                onChanged: (val) {},
                                hintText: 'Email',
                                keyboardType: TextInputType.text,
                                onSaved: (val) {
                                  controller.email.value = val.toString();
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
                                  controller.password.value = val.toString();
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
                      CustomFlatButton(
                          width: double.infinity,
                          text: 'Sign In',
                          onPressed: () async {
                            final res = homeController.loginKey.currentState?.validate();

                            if (res == true) {
                              homeController.loginKey.currentState!.save();
                            }
                            final SignIn result =
                                await controller.signInToUserAccount(email: controller.email.value, password: controller.password.value);
                            if (result.status == true) {
                              await AppSharedPreferences.setAccessToken(result.data!.accessToken!);

                              final String accessToken = await AppSharedPreferences.getAccessToken();
                              if (accessToken.isNotEmpty) {
                                homeController.accessTokens.value = accessToken;
                                // print("access token -> ${homeController.accessTokens}");
                                Get.toNamed('/home');
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
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: Container(
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
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: 'Butuh Bantuan? ', style: kDontHaveAccStyle),
                                TextSpan(
                                  text: 'Hubungi Call Center Altea Care',
                                  style: kDontHaveAccStyle.copyWith(color: kDarkBlue, fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showModalBottomSheet(
                                        context: context,
                                        // barrierColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        builder: (context) => Container(
                                          color: const Color.fromRGBO(255, 255, 255, 0.1),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(16),
                                            decoration: const BoxDecoration(
                                                color: kBackground,
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  height: 10,
                                                  decoration:
                                                      BoxDecoration(color: kSubHeaderColor.withOpacity(0.3), borderRadius: BorderRadius.circular(50)),
                                                ),
                                                Container(
                                                  // color: Colors.blue,
                                                  width: double.infinity,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 50,
                                                      ),
                                                      Text(
                                                        'Altea Call Center',
                                                        style: kPoppins17,
                                                      ),
                                                      const SizedBox(
                                                        height: 40,
                                                      ),
                                                      Text(
                                                        'Email : ',
                                                        style: kForgotTextStyle.copyWith(fontWeight: FontWeight.w400),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          final Uri emailLaunchUri = Uri(
                                                            scheme: 'mailto',
                                                            path: 'cs@alteacare.com',
                                                          );

                                                          launch(emailLaunchUri.toString());
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.mail,
                                                              color: kButtonColor,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              'cs@alteacare.com',
                                                              style: kConfirmTextStyle.copyWith(color: kBlackColor),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                      Text(
                                                        'Hotline WA : ',
                                                        style: kForgotTextStyle.copyWith(fontWeight: FontWeight.w400),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          String url = Platform.isIOS
                                                              ? "whatsapp://wa.me/081315739235/"
                                                              : "whatsapp://send?phone=081315739235";

                                                          if (await canLaunch(url)) {
                                                            launch(url);
                                                          } else {
                                                            final Uri phoneUri = Uri(
                                                              scheme: 'tel',
                                                              path: '081315739235',
                                                            );

                                                            launch(phoneUri.toString());
                                                          }
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.phone,
                                                              color: kButtonColor,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              '+62 813 1573 9235',
                                                              style: kConfirmTextStyle.copyWith(color: kBlackColor),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          String url = Platform.isIOS
                                                              ? "whatsapp://wa.me/081315739245/"
                                                              : "whatsapp://send?phone=081315739245";
                                                          if (await canLaunch(url)) {
                                                            launch(url);
                                                          } else {
                                                            final Uri phoneUri = Uri(
                                                              scheme: 'tel',
                                                              path: '081315739245',
                                                            );

                                                            launch(phoneUri.toString());
                                                          }
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.phone,
                                                              color: kButtonColor,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              '+62 813 1573 9245',
                                                              style: kConfirmTextStyle.copyWith(color: kBlackColor),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          // color: Colors.white,
                                        ),
                                      );
                                    },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
