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

class VerifOtpView extends StatefulWidget {
  @override
  _VerifOtpViewState createState() => _VerifOtpViewState();
}

class _VerifOtpViewState extends State<VerifOtpView> {
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
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: Text(
            'Verifikasi Email',
            style: kAppBarTitleStyle,
          ),
          centerTitle: true,
          backgroundColor: kBackground,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kBlackColor,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 27, vertical: 50),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kode verifikasi telah dikirim via email ke',
                  style: kVerifText1,
                ),
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
                    width: double.infinity,
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
        ));
  }
}
