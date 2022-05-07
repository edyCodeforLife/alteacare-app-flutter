// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/forgot_password_otp_model.dart';
import 'package:altea/app/modules/forgot_password/presentation/modules/forgot_password/controllers/forgot_password_controller.dart';

class ForgotVerificationView extends StatefulWidget {
  @override
  _ForgotVerificationViewState createState() => _ForgotVerificationViewState();
}

class _ForgotVerificationViewState extends State<ForgotVerificationView> {
  ForgotPasswordController controller = Get.find<ForgotPasswordController>();
  static final GlobalKey<FormState> _verifKey = GlobalKey<FormState>();
  CountdownController countdownCtrl = CountdownController();

  bool countdownDone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      countdownCtrl.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ResponsiveBuilder(builder: (context, sizingInformation) {
      if (sizingInformation.isMobile) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
              child: Form(
                key: _verifKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verifikasi Email',
                      style: kHeaderStyle,
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    Text(
                      'Kode verifikasi telah dikirim via Email ke',
                      style: kVerifText1,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      controller.email.value,
                      style: kVerifText2,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    PinPut(
                      onSaved: (val) {
                        if (val != null) {
                          controller.otp.value = val;
                        }
                      },
                      validator: (val) {
                        if (val != null) {
                          if (controller.isOtpCorrect.value == false) {
                            return 'Kode Verifikasi tidak Sesuai';
                          } else if (val.length < 6) {
                            return 'Kode Verifikasi Kurang';
                          } else {
                            return null;
                          }
                        }
                      },
                      // keyboardType: TextInputType.number,
                      fieldsCount: 6,
                      // eachFieldHeight: Get.height * 0.08,
                      // eachFieldWidth: Get.width * 0.13,
                      textStyle: kPinStyle,
                      followingFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      submittedFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                      selectedFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () async {
                                if (countdownDone) {
                                  await controller.forgotPasswordAccount(email: controller.email.value);
                                  setState(() {
                                    countdownDone = false;
                                  });
                                  countdownCtrl.restart();
                                }
                              },
                              child: Text(
                                'Kirim Ulang Kode',
                                style: kVerifText1.copyWith(fontWeight: FontWeight.w400),
                              )),
                          const SizedBox(
                            width: 8,
                          ),
                          Countdown(
                            seconds: 60,
                            controller: countdownCtrl,
                            interval: Duration(seconds: 1),
                            build: (context, time) {
                              // print(time);
                              // countdownCtrl.start();
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
                              setState(() => countdownDone = true);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomFlatButton(
                        width: double.infinity,
                        text: 'Verifikasi',
                        onPressed: () async {
                          controller.isOtpCorrect.value = true;
                          var res = _verifKey.currentState?.validate();

                          if (res == true) {
                            _verifKey.currentState?.save();

                            final ForgotPasswordOtp result =
                                await controller.forgotPasswordOtp(email: controller.email.value, otp: controller.otp.value);
                            // print(result);
                            if (result.status == true) {
                              controller.tokenChangePassword.value = result.data!.accessToken!;
                              Get.toNamed('/forgot/new');
                            } else {
                              controller.isOtpCorrect.value = false;
                              _verifKey.currentState?.validate();
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
                    )
                  ],
                ),
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
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: kBackground,
                body: SafeArea(
                  child: Center(
                    child: SizedBox(
                      width: screenWidth * 0.3,
                      child: Form(
                        key: _verifKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Verifikasi Email',
                              style: kHeaderStyle,
                            ),
                            const SizedBox(
                              height: 21,
                            ),
                            Text(
                              'Kode verifikasi telah dikirim via Email ke',
                              style: kVerifText1,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              controller.email.value,
                              style: kVerifText2,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            PinPut(
                              validator: (val) {
                                if (val != null) {
                                  if (controller.isOtpCorrect.value == false) {
                                    return 'Kode Verifikasi tidak Sesuai';
                                  } else if (val.length < 6) {
                                    return 'Kode Verifikasi Kurang';
                                  } else {
                                    return null;
                                  }
                                }
                              },
                              onSaved: (val) {
                                if (val != null) {
                                  controller.otp.value = val;
                                }
                              },
                              keyboardType: TextInputType.number,
                              fieldsCount: 6,
                              // eachFieldHeight: Get.height * 0.08,
                              // eachFieldWidth: Get.width * 0.13,
                              textStyle: kPinStyle,
                              followingFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                              submittedFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                              selectedFieldDecoration: BoxDecoration(color: kBlackColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () async {
                                        if (countdownDone) {
                                          await controller.forgotPasswordAccount(email: controller.email.value);
                                          countdownDone = false;
                                          countdownCtrl.restart();
                                        }
                                      },
                                      child: Text(
                                        'Kirim Ulang Kode',
                                        style: kVerifText1.copyWith(fontWeight: FontWeight.w400),
                                      )),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Countdown(
                                    seconds: 60,
                                    controller: countdownCtrl,
                                    interval: Duration(seconds: 1),
                                    build: (context, time) {
                                      // print(time);
                                      // countdownCtrl.start();
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
                                      setState(() => countdownDone = true);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            CustomFlatButton(
                                width: double.infinity,
                                text: 'Verifikasi',
                                onPressed: () async {
                                  controller.isOtpCorrect.value = true;
                                  var res = _verifKey.currentState?.validate();

                                  if (res == true) {
                                    _verifKey.currentState?.save();

                                    final ForgotPasswordOtp result =
                                        await controller.forgotPasswordOtp(email: controller.email.value, otp: controller.otp.value);
                                    // print(result);
                                    if (result.status == true) {
                                      controller.tokenChangePassword.value = result.data!.accessToken!;
                                      countdownCtrl.pause();
                                      Get.offNamed('/forgot/new');
                                    } else {
                                      controller.isOtpCorrect.value = false;
                                      _verifKey.currentState?.validate();
                                    }
                                  }
                                },
                                color: kButtonColor),
                            const SizedBox(
                              height: 24,
                            ),
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
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    });
  }
}
