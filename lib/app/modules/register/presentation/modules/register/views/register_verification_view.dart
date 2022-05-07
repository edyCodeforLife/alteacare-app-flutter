// Flutter imports:
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/register/presentation/modules/register/controllers/register_controller.dart';

class RegisterVerificationView extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const RegisterVerificationView({required this.formKey});

  @override
  _RegisterVerificationViewState createState() => _RegisterVerificationViewState();
}

class _RegisterVerificationViewState extends State<RegisterVerificationView> {
  RegisterController controller = Get.put(RegisterController());

  CountdownController countdownCtrl = CountdownController();
  CountdownController countdownCtrl2 = CountdownController();

  bool countdownDone = false;
  bool countdownDone2 = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      countdownCtrl.start();
      // countdownCtrl2
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => (controller.verificationMethod == "phone")
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kode verifikasi telah dikirim via SMS ke',
                            style: kVerifText1,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            controller.phoneNum.value,
                            style: kVerifText2,
                          ),
                        ],
                      )
                    : (controller.verificationMethod == "email")
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                            ],
                          )
                        : const SizedBox()),
                const SizedBox(
                  height: 16,
                ),
                PinPut(
                  onSaved: (val) {
                    // print('value => $val');
                    controller.otpCode.value = val.toString();
                    // print('otp =>${controller.accessToken.value}');
                  },
                  validator: (val) {
                    if (val != null) {
                      if (val.length < 6) {
                        return 'Kode Verifikasi tidak Sesuai';
                      }
                    }
                  },
                  keyboardType: TextInputType.number,
                  fieldsCount: 6,
                  // eachFieldHeight: Get.height * 0.08,
                  // eachFieldWidth: Get.width * 0.13,
                  textStyle: kPinStyle,
                  followingFieldDecoration: BoxDecoration(color: kPinFieldColor, borderRadius: BorderRadius.circular(12)),
                  submittedFieldDecoration: BoxDecoration(color: kPinFieldColor, borderRadius: BorderRadius.circular(12)),
                  selectedFieldDecoration: BoxDecoration(color: kPinFieldColor, borderRadius: BorderRadius.circular(12)),
                ),
                const SizedBox(
                  height: 50,
                ),
                Obx(
                  () => (controller.verificationMethod == "phone")
                      ? Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    if (countdownDone) {
                                      countdownDone = false;
                                      countdownCtrl.restart();
                                      controller.sendPhoneVerification();
                                    }
                                  },
                                  child: Text(
                                    'Kirim Ulang Kode ke ${controller.phoneNum.value}',
                                    style: kVerifText1.copyWith(fontWeight: FontWeight.w400),
                                  )),
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
                        )
                      : Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    if (countdownDone2) {
                                      countdownDone2 = false;
                                      countdownCtrl2.restart();
                                      controller.sendEmailVerification();
                                    } else {
                                      print("countdown done??");
                                    }
                                  },
                                  child: Text(
                                    'Kirim Kode lain ke ${controller.email.value}',
                                    style: kVerifText1.copyWith(fontWeight: FontWeight.w400),
                                  )),
                              Countdown(
                                seconds: 60,
                                controller: countdownCtrl2,
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
                                  setState(() => countdownDone2 = true);
                                },
                              ),
                            ],
                          ),
                        ),
                ),
                Obx(
                  () => (controller.verificationMethod == "phone")
                      ? Center(
                          child: CustomFlatButton(
                            onPressed: () {
                              controller.sendEmailVerification();

                              countdownDone2 = false;
                              countdownCtrl2.restart();
                            },
                            width: double.infinity,
                            color: Colors.white,
                            text: "Kirim ke Email",
                          ),
                        )
                      : Center(
                          child: CustomFlatButton(
                            onPressed: () {
                              controller.sendPhoneVerification();

                              countdownDone = false;
                              countdownCtrl.restart();
                            },
                            width: double.infinity,
                            color: Colors.white,
                            text: "Kirim ke Nomor Handphone",
                          ),
                        ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          );
        } else {
          return Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Kode verifikasi telah dikirim via SMS ke',
                //   style: kVerifText1,
                // ),
                // SizedBox(
                //   height: 4,
                // ),
                // Text(
                //   controller.phoneNum.value,
                //   style: kVerifText2,
                // ),
                Obx(
                  () => (controller.verificationMethod == "phone")
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kode verifikasi telah dikirim via SMS ke',
                              style: kVerifText1,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              controller.phoneNum.value,
                              style: kVerifText2,
                            ),
                          ],
                        )
                      : (controller.verificationMethod == "email")
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                              ],
                            )
                          : const SizedBox(),
                ),
                SizedBox(
                  height: 16,
                ),
                PinPut(
                  onSaved: (val) {
                    // print('value => $val');
                    controller.otpCode.value = val.toString();
                    // print('otp =>${controller.otpCode.value}');
                  },
                  validator: (val) {
                    if (val != null) {
                      if (val.length < 6) {
                        return 'Kode Verifikasi tidak Sesuai';
                      }
                    }
                  },
                  keyboardType: TextInputType.number,
                  fieldsCount: 6,
                  eachFieldPadding: const EdgeInsets.all(16),
                  // eachFieldHeight: MediaQuery.of(context).size.height * 0.07,
                  // eachFieldWidth: MediaQuery.of(context).size.width * 0.13,
                  textStyle: kPinStyle,
                  followingFieldDecoration: BoxDecoration(color: kPinFieldColor, borderRadius: BorderRadius.circular(12)),
                  submittedFieldDecoration: BoxDecoration(color: kPinFieldColor, borderRadius: BorderRadius.circular(12)),
                  selectedFieldDecoration: BoxDecoration(color: kPinFieldColor, borderRadius: BorderRadius.circular(12)),
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => (controller.verificationMethod == "phone")
                            ? Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          if (countdownDone) {
                                            countdownDone = false;
                                            countdownCtrl.restart();
                                            controller.sendPhoneVerification();
                                          }
                                        },
                                        child: Text(
                                          'Kirim Ulang Kode ke ${controller.phoneNum.value}',
                                          style: kVerifText1.copyWith(fontWeight: FontWeight.w400),
                                        )),
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
                              )
                            : Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          if (countdownDone2) {
                                            countdownDone2 = false;
                                            countdownCtrl2.restart();
                                            controller.sendEmailVerification();
                                          } else {
                                            print("countdown done??");
                                          }
                                        },
                                        child: Text(
                                          'Kirim Kode lain ke ${controller.email.value}',
                                          style: kVerifText1.copyWith(fontWeight: FontWeight.w400),
                                        )),
                                    Countdown(
                                      seconds: 60,
                                      controller: countdownCtrl2,
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
                                        setState(() => countdownDone2 = true);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      // TextButton(
                      //     onPressed: () {
                      //       if (countdownDone) {
                      //         countdownDone = false;
                      //         countdownCtrl.restart();
                      //         controller.sendPhoneVerification();
                      //       }
                      //     },
                      //     child: Text(
                      //       'Kirim Ulang Kode',
                      //       style: kVerifText1.copyWith(fontWeight: FontWeight.w400),
                      //     )),
                      // Countdown(
                      //   seconds: 60,
                      //   controller: countdownCtrl,
                      //   interval: Duration(seconds: 1),
                      //   build: (context, time) {
                      //     // print(time);
                      //     // countdownCtrl.start();
                      //     String minutes = '0';
                      //     String seconds = '0';
                      //     if (time >= 120) {
                      //       minutes = '02';
                      //       seconds =
                      //           (time - 120).toStringAsFixed(0).length == 2 ? (time - 120).toStringAsFixed(0) : '0${(time - 120).toStringAsFixed(0)}';
                      //     } else if (time >= 60) {
                      //       minutes = '01';
                      //       seconds =
                      //           (time - 60).toStringAsFixed(0).length == 2 ? (time - 60).toStringAsFixed(0) : '0${(time - 60).toStringAsFixed(0)}';
                      //     } else {
                      //       minutes = '00';
                      //       seconds = time.toStringAsFixed(0).length == 2 ? time.toStringAsFixed(0) : '0${time.toStringAsFixed(0)}';
                      //     }
                      //     // print('$minutes : $seconds');

                      //     return Text(
                      //       '$minutes : $seconds',
                      //       style: kVerifText2.copyWith(color: kRedError),
                      //     );
                      //   },
                      //   onFinished: () {
                      //     // print('countdown done!');
                      //     setState(() => countdownDone = true);
                      //   },
                      // ),
                    ],
                  ),
                ),
                Obx(
                  () => (controller.verificationMethod == "phone")
                      ? Center(
                          child: CustomFlatButton(
                            onPressed: () {
                              controller.sendEmailVerification();

                              countdownDone2 = false;
                              countdownCtrl2.restart();
                            },
                            width: double.infinity,
                            color: Colors.white,
                            text: "Kirim ke Email",
                          ),
                        )
                      : Center(
                          child: CustomFlatButton(
                            onPressed: () {
                              controller.sendPhoneVerification();

                              countdownDone = false;
                              countdownCtrl.restart();
                            },
                            width: double.infinity,
                            color: Colors.white,
                            text: "Kirim ke Nomor Handphone",
                          ),
                        ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
