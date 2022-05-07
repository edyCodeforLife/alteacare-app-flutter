// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/alert_screen.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/verify_email/controllers/verify_email_controller.dart';

class VerifyOtpDialog extends StatefulWidget {
  final String email;
  VerifyOtpDialog({required this.email});
  @override
  _VerifOtpDialogState createState() => _VerifOtpDialogState();
}

class _VerifOtpDialogState extends State<VerifyOtpDialog> {
  VerifyEmailController emailController = Get.find<VerifyEmailController>();

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool countdownDone = false;
  bool otpFalse = false;

  CountdownController countdownCtrl = CountdownController();

  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      countdownCtrl.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: Get.width / 2,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Kode verifikasi telah dikirim via email ke ',
                style: kVerifText1.copyWith(fontSize: Get.width * 0.015),
              ),
              // Text(
              //   widget.email,
              //   style: kPoppinsSemibold600.copyWith(fontSize: Get.width * 0.015),
              // ),
              const SizedBox(
                height: 4,
              ),
              Text(
                emailController.email.value,
                style: kVerifText2,
              ),
              const SizedBox(
                height: 16,
              ),
              PinPut(
                onSaved: (val) {
                  // print('value => $val');
                  emailController.otpCode.value = val.toString();
                  // print('otp =>${emailController.otpCode.value}');
                },
                validator: (val) {
                  if (val != null) {
                    if (val.length < 6) {
                      return 'Kode Verifikasi tidak Sesuai';
                    } else if (otpFalse) {
                      return 'Kode OTP yang anda masukkan salah.';
                    }
                  }
                },
                // keyboardType: TextInputType.number,
                fieldsCount: 6,
                eachFieldHeight: Get.height * 0.08,
                eachFieldWidth: Get.width * 0.06,
                textStyle: kPinStyle,
                followingFieldDecoration: BoxDecoration(color: kPinFieldColor, borderRadius: BorderRadius.circular(12)),
                submittedFieldDecoration: BoxDecoration(color: kPinFieldColor, borderRadius: BorderRadius.circular(12)),
                selectedFieldDecoration: BoxDecoration(color: kPinFieldColor, borderRadius: BorderRadius.circular(12)),
                eachFieldMargin: const EdgeInsets.only(
                  right: 15,
                ),
                fieldsAlignment: MainAxisAlignment.center,
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (countdownDone) {
                          countdownDone = false;
                          countdownCtrl.restart();
                          emailController.sendVerificationEmail();
                        }
                      },
                      child: Text(
                        'Kirim Ulang Kode',
                        style: kVerifText1.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                      ),
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
                          seconds =
                              (time - 120).toStringAsFixed(0).length == 2 ? (time - 120).toStringAsFixed(0) : '0${(time - 120).toStringAsFixed(0)}';
                        } else if (time >= 60) {
                          minutes = '01';
                          seconds =
                              (time - 60).toStringAsFixed(0).length == 2 ? (time - 60).toStringAsFixed(0) : '0${(time - 60).toStringAsFixed(0)}';
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
                  height: 50,
                  width: Get.width / 2,
                  text: 'Verifikasi',
                  onPressed: () async {
                    otpFalse = false;
                    var res = _key.currentState?.validate();
                    if (res == true) {
                      _key.currentState?.save();
                      var result = await emailController.verifEmail();
                      if (result['status'] == true) {
                        Get.back();
                        Get.dialog(
                          Dialog(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/success_icon.png',
                                  width: MediaQuery.of(context).size.width / 3,
                                ),
                                const SizedBox(
                                  height: 28,
                                ),
                                Text(
                                  'Verifikasi Berhasil',
                                  style: kDialogTitleStyle,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    'Alamat email Anda telah di verifikasi, click Beranda untuk lanjut',
                                    softWrap: true,
                                    style: kDialogSubTitleStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: 36,
                                ),
                                // CustomFlatButton(
                                //     color: kButtonColor,
                                //     width: MediaQuery.of(context).size.width * 0.7,
                                //     text: 'Sign In',
                                //     onPressed: onPressed,
                                // ),
                              ],
                            ),
                          ),
                        );
                        // Get.to(
                        //     AlertScreen(
                        //     title: 'Verifikasi Berhasil',
                        //     subtitle: 'Alamat email Anda telah di verifikasi, click Beranda untuk lanjut',
                        //     imgPath: 'assets/success_icon.png',
                        //     btnText: 'Beranda',
                        //     onPressed: () => Get.offNamed('/home'),
                        //     ),
                        // );
                      } else {
                        otpFalse = true;
                        _key.currentState?.validate();
                      }
                    }
                  },
                  color: kButtonColor)
            ],
          ),
        ),
      ),
    );
  }
}

class VerifyOtpDialogMobileWeb extends StatefulWidget {
  final String email;
  VerifyOtpDialogMobileWeb({required this.email});
  @override
  _VerifOtpDialogMobilwWebState createState() => _VerifOtpDialogMobilwWebState();
}

class _VerifOtpDialogMobilwWebState extends State<VerifyOtpDialogMobileWeb> {
  VerifyEmailController emailController = Get.find<VerifyEmailController>();

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool countdownDone = false;
  bool otpFalse = false;

  CountdownController countdownCtrl = CountdownController();

  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      countdownCtrl.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Kode verifikasi telah dikirim via email ke :',
                style: kVerifText1.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              // Text(
              //   widget.email,
              //   style: kPoppinsSemibold600.copyWith(fontSize: 12),
              //   textAlign: TextAlign.center,
              // ),
              const SizedBox(
                height: 4,
              ),
              Text(
                emailController.email.value,
                style: kVerifText2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              PinPut(
                onSaved: (val) {
                  // print('value => $val');
                  emailController.otpCode.value = val.toString();
                  // print('otp =>${emailController.otpCode.value}');
                },
                validator: (val) {
                  if (val != null) {
                    if (val.length < 6) {
                      return 'Kode Verifikasi tidak Sesuai';
                    } else if (otpFalse) {
                      return 'Kode OTP yang anda masukkan salah.';
                    }
                  }
                },
                // keyboardType: TextInputType.number,
                fieldsCount: 6,
                eachFieldHeight: Get.height * 0.08,
                eachFieldWidth: Get.width * 0.08,
                textStyle: kPinStyle,
                followingFieldDecoration: BoxDecoration(color: kPinFieldColor, borderRadius: BorderRadius.circular(12)),
                submittedFieldDecoration: BoxDecoration(color: kPinFieldColor, borderRadius: BorderRadius.circular(12)),
                selectedFieldDecoration: BoxDecoration(color: kPinFieldColor, borderRadius: BorderRadius.circular(12)),
                eachFieldMargin: const EdgeInsets.only(
                  right: 5,
                ),
                fieldsAlignment: MainAxisAlignment.center,
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (countdownDone) {
                          countdownDone = false;
                          countdownCtrl.restart();
                          emailController.sendVerificationEmail();
                        }
                      },
                      child: Text(
                        'Kirim Ulang Kode',
                        style: kVerifText1.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                      ),
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
                          seconds =
                              (time - 120).toStringAsFixed(0).length == 2 ? (time - 120).toStringAsFixed(0) : '0${(time - 120).toStringAsFixed(0)}';
                        } else if (time >= 60) {
                          minutes = '01';
                          seconds =
                              (time - 60).toStringAsFixed(0).length == 2 ? (time - 60).toStringAsFixed(0) : '0${(time - 60).toStringAsFixed(0)}';
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
                  height: 50,
                  width: Get.width / 2,
                  text: 'Verifikasi',
                  onPressed: () async {
                    otpFalse = false;
                    var res = _key.currentState?.validate();
                    if (res == true) {
                      _key.currentState?.save();
                      var result = await emailController.verifEmail();
                      if (result['status'] == true) {
                        Get.to(AlertScreen(
                            title: 'Verifikasi Berhasil',
                            subtitle: 'Alamat email Anda telah di verifikasi, click Beranda untuk lanjut',
                            imgPath: 'assets/success_icon.png',
                            btnText: 'Beranda',
                            onPressed: () => Get.offNamed('/home')));
                      } else {
                        otpFalse = true;
                        _key.currentState?.validate();
                      }
                    }
                  },
                  color: kButtonColor)
            ],
          ),
        ),
      ),
    );
  }
}
