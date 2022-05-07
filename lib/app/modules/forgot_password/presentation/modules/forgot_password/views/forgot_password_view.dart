// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/data/model/forgot_password_model.dart';
import 'package:altea/app/modules/forgot_password/presentation/modules/forgot_password/controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  final GlobalKey<FormState> _forgotKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: kBackground,
        body: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            if (sizingInformation.isMobile) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Forgot Password',
                          style: kHeaderStyle,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Form(
                          key: _forgotKey,
                          child: CustomTextField(
                              onChanged: (val) {},
                              validator: (val) {
                                if (val != null) {
                                  if (controller.isEmailRegistered.value == false) {
                                    // return 'No. Handphone Tidak Terdaftar';
                                    return 'Email Tidak Terdaftar';
                                  } else if (val.isEmpty) {
                                    return 'Alamat email tidak boleh kosong';
                                  } else {
                                    return null;
                                  }
                                }
                              },
                              onSaved: (val) {
                                if (val != null) {
                                  controller.email.value = val;
                                }
                              },
                              hintText: 'Alamat Email',
                              keyboardType: TextInputType.emailAddress),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        CustomFlatButton(
                            width: double.infinity,
                            text: 'Reset Password',
                            onPressed: () async {
                              controller.isEmailRegistered.value = true;
                              var res = _forgotKey.currentState!.validate();
                              // print("value email -> ${controller.email.value}");

                              if (res == true) {
                                _forgotKey.currentState!.save();
                                // print("value email -> ${controller.email.value}");

                                final ForgotPassword result = await controller.forgotPasswordAccount(email: controller.email.value);

                                if (result.status == true) {
                                  Get.toNamed('/forgot/verification');
                                } else {
                                  // print("error not found");
                                  controller.isEmailRegistered.value = result.status!;
                                  _forgotKey.currentState!.validate();
                                }
                              }
                            },
                            color: kButtonColor),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: 'Sudah Punya Akun? ', style: kDontHaveAccStyle),
                                TextSpan(
                                  text: 'Sign In',
                                  style: kDontHaveAccStyle.copyWith(color: kDarkBlue, fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()..onTap = () => Get.offNamed('/login'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Forgot Password',
                              style: kHeaderStyle,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Masukkan Alamat Email yang terdaftar di AlteaCare',
                              style: kHeaderStyle,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Form(
                              key: _forgotKey,
                              child: CustomTextField(
                                  onChanged: (val) {},
                                  validator: (val) {
                                    if (val != null) {
                                      if (controller.isEmailRegistered.value == false) {
                                        // return 'No. Handphone Tidak Terdaftar';
                                        return 'Email Tidak Terdaftar';
                                      } else if (val.isEmpty) {
                                        return 'Alamat email tidak boleh kosong';
                                      } else {
                                        return null;
                                      }
                                    }
                                  },
                                  onSaved: (val) {
                                    if (val != null) {
                                      // print("value on saved -> ");
                                      controller.email.value = val;
                                    }
                                  },
                                  hintText: 'Alamat email',
                                  keyboardType: TextInputType.emailAddress),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            CustomFlatButton(
                                width: double.infinity,
                                text: 'Reset Password',
                                onPressed: () async {
                                  controller.isEmailRegistered.value = true;
                                  var res = _forgotKey.currentState!.validate();
                                  // print("value email -> ${controller.email.value}");

                                  if (res == true) {
                                    _forgotKey.currentState!.save();
                                    // print("value email -> ${controller.email.value}");

                                    final ForgotPassword result = await controller.forgotPasswordAccount(email: controller.email.value);

                                    if (result.status == true) {
                                      Get.toNamed('/forgot/verification');
                                    } else {
                                      // print("error not found");
                                      controller.isEmailRegistered.value = result.status!;
                                      _forgotKey.currentState!.validate();
                                    }
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
                                          TextSpan(text: 'Ingat Kata Sandi? ', style: kDontHaveAccStyle),
                                          TextSpan(
                                            text: 'Sign In',
                                            style: kDontHaveAccStyle.copyWith(color: kDarkBlue, fontWeight: FontWeight.w600),
                                            recognizer: TapGestureRecognizer()..onTap = () => Get.offNamed('/login'),
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
                            ),
                            // Center(
                            //   child: RichText(
                            //     text: TextSpan(
                            //       children: [
                            //         TextSpan(
                            //             text: 'Sudah Punya Akun? ',
                            //             style: kDontHaveAccStyle),
                            //         TextSpan(
                            //           text: 'Sign In',
                            //           style: kDontHaveAccStyle.copyWith(
                            //               color: kDarkBlue,
                            //               fontWeight: FontWeight.w600),
                            //           recognizer: TapGestureRecognizer()
                            //             ..onTap = () => Get.offNamed('/login'),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              );
            }
          },
        ));
  }
}
