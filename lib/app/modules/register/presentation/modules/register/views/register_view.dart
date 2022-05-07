import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/styles.dart';
import '../../../../../../core/widgets/alert_screen.dart';
import '../../../../../../core/widgets/custom_flat_button.dart';
import '../../../../../../data/model/register_model.dart';
import '../../../../../../routes/app_pages.dart';
import '../controllers/register_controller.dart';
import 'custom_simple_dialog.dart';
import 'register_contact_data_view.dart';
import 'register_password_view.dart';
import 'register_personal_data_view.dart';
import 'register_tn_c_view.dart';
import 'register_verification_view.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  int currentStep = 0;
  int completedStep = 0;

  bool confirmed = false;

  List<String> stepperText = ['Kontak Data', 'Personal Data', 'Kata Sandi', 'T&C', 'Verifikasi'];

  // WEB STEPPER
  String textStepper1 = "1";
  String textStepper2 = "2";
  String textStepper3 = "3";
  String textStepper4 = "4";
  String textStepper5 = "5";

  bool isChooseStep1 = true;
  bool isChooseStep2 = false;
  bool isChooseStep3 = false;
  bool isChooseStep4 = false;
  bool isChooseStep5 = false;

  RegisterController controller = Get.put(RegisterController());
  ScrollController stepCtrl = ScrollController();
  bool approved = false;

  Widget registerBody(int i) {
    switch (i) {
      case 1:
        return RegisterPersonalDataView(
          formKey: registerKey,
        );
      case 2:
        return RegisterPasswordView(
          formKey: registerKey,
        );
      case 3:
        return RegisterTnCView(
          approved: approved,
          changeApproval: (val) {
            if (val != null) {
              setState(() {
                approved = val;
              });
            }
          },
        );
      case 4:
        return RegisterVerificationView(
          formKey: registerKey,
        );
      default:
        return RegisterContactDataView(
          formKey: registerKey,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Get.dialog(
          CustomSimpleDualButtonDialog(
            icon: const SizedBox(),
            onPressed1: () {
              Get.back();
              Get.back();
            },
            onPressed2: () {
              Get.back();
            },
            title: "Keluar dari registrasi?",
            buttonTxt1: "Ya",
            buttonTxt2: "Tidak",
            subtitle: "Anda akan diminta untuk memasukkan data anda lagi",
          ),
        );
        return false;
      },
      child: Scaffold(
          appBar: GetPlatform.isWeb
              ? null
              : AppBar(
                  elevation: 0,
                  backgroundColor: kBackground,
                  title: Text(
                    'Sign Up',
                    style: kAppBarTitleStyle,
                  ),
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: kBlackColor,
                      size: 20,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
          backgroundColor: kBackground,
          body: ResponsiveBuilder(
            builder: (context, sizingInformation) {
              if (GetPlatform.isWeb) {
                // !! INI BUAT WEB
                if (sizingInformation.isMobile) {
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sign Up',
                              style: kHeaderStyle,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: Get.width * 1.5,
                              height: Get.height * 0.1,
                              // padding: EdgeInsets.all(16),
                              // color: Colors.pink,
                              child: SingleChildScrollView(
                                controller: stepCtrl,
                                // physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(16),
                                      width: Get.width * 1.3,
                                      height: 3,
                                      color: kButtonColor,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      width: Get.width * 1.3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: stepperText.asMap().entries.map((e) {
                                          return Column(
                                            children: [
                                              Container(
                                                width: Get.width * 0.25,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: Get.width * 0.05,
                                                      height: Get.width * 0.05,
                                                      decoration: BoxDecoration(
                                                          color: currentStep >= e.key ? kButtonColor : kLightGray,
                                                          borderRadius: BorderRadius.circular(24)),
                                                      child: Center(
                                                          child: currentStep > e.key
                                                              ? Icon(
                                                                  Icons.done,
                                                                  color: kBackground,
                                                                  size: Get.width * 0.03,
                                                                )
                                                              : Text(
                                                                  (e.key + 1).toString(),
                                                                  style: kStepperTextStyle,
                                                                )),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      stepperText[e.key],
                                                      style: kStepperSubStyle(currentStep >= e.key ? kButtonColor : kLightGray),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            registerBody(currentStep),
                            SizedBox(
                              height: screenWidth * 0.05,
                            ),
                            CustomFlatButton(
                                width: double.infinity,
                                text: currentStep == 3
                                    ? 'Saya Setuju'
                                    : currentStep == 4
                                        ? 'Verifikasi'
                                        : 'Lanjutkan',
                                onPressed: () async {
                                  if (currentStep == 1) {
                                    var res = registerKey.currentState?.validate();
                                    if (res == true) {
                                      registerKey.currentState?.save();
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              backgroundColor: Colors.white,
                                              child: Container(
                                                padding: const EdgeInsets.all(16),
                                                width: MediaQuery.of(context).size.width * 0.4,
                                                height: MediaQuery.of(context).size.height * 0.5,
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Konfirmasi Data',
                                                      style: kSubHeaderStyle,
                                                    ),
                                                    Text(
                                                      'Pastikan data yang di isi sudah benar. Hubungi customer service AlteaCare untuk perubahan data.',
                                                      style: kVerifText1,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    buildConfirmationRow('Nama', '${controller.firstName.value} ${controller.lastName.value}'),
                                                    buildConfirmationRow('Jenis Kelamin', controller.gender.value),
                                                    buildConfirmationRow(
                                                        'Tempat Lahir', '${controller.birthTown.value}, ${controller.countryName.value}'),
                                                    buildConfirmationRow('Tanggal Lahir', controller.birthDate.value),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    CustomFlatButton(
                                                        width: double.infinity,
                                                        text: 'Konfirmasi',
                                                        onPressed: () {
                                                          Get.back();
                                                          controller.dataSaved.value = true;
                                                          registerKey.currentState?.save();
                                                          setState(() {
                                                            currentStep += 1;
                                                            isChooseStep3 = true;
                                                            // isChooseStep2 = true;
                                                          });
                                                        },
                                                        color: kButtonColor),
                                                    CustomFlatButton(
                                                        width: double.infinity,
                                                        text: 'Cancel',
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        borderColor: kButtonColor,
                                                        color: kBackground)
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  } else if (currentStep == 0) {
                                    controller.isPhoneUsable.value = true;
                                    controller.isEmailUsable.value = true;
                                    // isPhoneUsable = ga bisa di pake;
                                    var res = registerKey.currentState?.validate();
                                    // validasi ada isinya apa ngga;
                                    if (res == true) {
                                      controller.dataSaved.value = false;
                                      registerKey.currentState?.save();
                                      var check = await controller.checkPhoneAndEmail();
                                      print(check);

                                      // print('check phone email => $check');

                                      if (check['status'] == true) {
                                        controller.isPhoneUsable.value = check['data']['is_phone_available'] as bool;
                                        controller.isEmailUsable.value = check['data']['is_email_available'] as bool;
                                        var valid = registerKey.currentState?.validate();
                                        // isPhoneUsable = ga bisa di pake;
                                        // 085694146369
                                        // 085694148389 < yang belum di pakai
                                        if (valid == true) {
                                          controller.dataSaved.value = true;
                                          registerKey.currentState!.save();
                                          setState(() {
                                            currentStep += 1;
                                            // isChooseStep3 = true;
                                            isChooseStep2 = true;
                                          });
                                        }
                                      } else {
                                        controller.isPhoneUsable.value = false;
                                        registerKey.currentState?.validate();
                                      }
                                    }
                                  } else if (currentStep == 2) {
                                    print(controller.password.value.toString());
                                    setState(() {
                                      currentStep += 1;
                                      isChooseStep3 = true;
                                    });
                                  } else if (currentStep == 3) {
                                    if (approved) {
                                      Register result = await controller.registerAccount(context: context);
                                      // print('hasil register =>${result.data?.accessToken}');
                                      if (result.status!) {
                                        if (result.data?.accessToken != null) {
                                          controller.accessToken.value = result.data!.accessToken!;
                                          final verifResult = await controller.sendPhoneVerification();

                                          if (verifResult['status'] == true) {
                                            setState(() {
                                              currentStep += 1;
                                              isChooseStep4 = true;
                                            });
                                          }
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
                                                title: 'Register Gagal',
                                                buttonTxt: 'Mengerti',
                                                subtitle: result.message!));
                                      }
                                    }
                                  } else if (currentStep == 4) {
                                    var res = registerKey.currentState?.validate();
                                    if (res == true) {
                                      registerKey.currentState?.save();
                                      // print('controller => ${controller.otpCode.value}');
                                      var result = (controller.verificationMethod == "phone")
                                          ? await controller.verifyPhone()
                                          : await controller.verifyEmail();
                                      if (result['status'] == true) {
                                        setState(() {
                                          currentStep += 1;
                                          isChooseStep4 = true;
                                        });

                                        Get.to(AlertScreen(
                                            title: 'Akun Berhasil Dibuat',
                                            subtitle: 'Akun anda berhasil dibuat. Silahkan sign in.',
                                            imgPath: 'assets/success_icon.png',
                                            btnText: 'Sign In',
                                            onPressed: () => Get.toNamed('/login')));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) => CustomSimpleDialog(
                                                icon: const ImageIcon(
                                                    AssetImage(
                                                      'assets/group-5.png',
                                                    ),
                                                    color: kRedError,
                                                    size: 150),
                                                onPressed: () => Get.back(),
                                                title: "Kode OTP Salah",
                                                buttonTxt: "Tutup",
                                                subtitle: "Kode OTP Salah, harap periksa lagi SMS yang anda terima"));
                                      }
                                    }
                                  } else {
                                    var res = registerKey.currentState?.validate();

                                    // if (res == true) {
                                    //   registerKey.currentState?.save();
                                    //   setState(() {
                                    //     currentStep += 1;
                                    //   });
                                    //   if (currentStep == 1) {
                                    //     setState(() {
                                    //       isChooseStep2 = true;
                                    //     });
                                    //   } else if (currentStep == 2) {
                                    //     setState(() {
                                    //       isChooseStep3 = true;
                                    //     });
                                    //   } else if (currentStep == 3) {
                                    //     setState(() {
                                    //       isChooseStep4 = true;
                                    //     });
                                    //   } else {
                                    //     setState(() {
                                    //       isChooseStep5 = true;
                                    //     });
                                    //   }
                                    //   if (confirmed) {}
                                    // }
                                  }
                                },
                                color: currentStep == 3
                                    ? approved
                                        ? kButtonColor
                                        : kLightGray
                                    : kButtonColor),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Sudah Punya Akun? ', style: kDontHaveAccStyle),
                                    TextSpan(
                                      text: 'Sign In',
                                      style: kDontHaveAccStyle.copyWith(color: kDarkBlue, fontWeight: FontWeight.w600),
                                      recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
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
                  // NOTE: DESKTOP WEB
                  return Row(
                    children: [
                      Expanded(
                          child: Image.asset(
                        "assets/doctor_img.jpg",
                        fit: BoxFit.cover,
                      )),
                      Expanded(
                          child: SafeArea(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign Up',
                                    style: kHeaderStyle,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // ? STEPPER SECTION
                                  Container(
                                    width: screenWidth * 1.5,
                                    height: screenWidth * 0.05,
                                    // padding: EdgeInsets.all(16),
                                    // color: Colors.pink,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        StepperFirstWidget(
                                          screenWidth: screenWidth,
                                          text: textStepper1,
                                          subtitleText: "Kontak Data",
                                          isChooseStep: isChooseStep1,
                                          currentStep: currentStep,
                                        ),
                                        StepperMiddleWidget(
                                          screenWidth: screenWidth,
                                          text: textStepper2,
                                          subtitleText: "Personal Data",
                                          isChooseStep: isChooseStep2,
                                          currentStep: currentStep,
                                        ),
                                        StepperMiddleWidget(
                                          screenWidth: screenWidth,
                                          text: textStepper3,
                                          subtitleText: "Kata Sandi",
                                          isChooseStep: isChooseStep3,
                                          currentStep: currentStep,
                                        ),
                                        StepperMiddleWidget(
                                          screenWidth: screenWidth,
                                          text: textStepper4,
                                          subtitleText: "T&C",
                                          isChooseStep: isChooseStep4,
                                          currentStep: currentStep,
                                        ),
                                        StepperLastWidget(
                                          screenWidth: screenWidth,
                                          text: textStepper5,
                                          subtitleText: "Verifikasi",
                                          isChooseStep: isChooseStep5,
                                          currentStep: currentStep,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // ? REGISTER FORM SECTION
                                  registerBody(currentStep),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  CustomFlatButton(
                                      width: double.infinity,
                                      text: currentStep == 3
                                          ? 'Saya Setuju'
                                          : currentStep == 4
                                              ? 'Verifikasi'
                                              : 'Lanjutkan',
                                      onPressed: () async {
                                        // print('currentStep awal => $currentStep');
                                        if (currentStep == 1) {
                                          var res = registerKey.currentState?.validate();
                                          if (res == true) {
                                            registerKey.currentState?.save();
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
                                                    ),
                                                    content: Container(
                                                      padding: const EdgeInsets.all(16),
                                                      width: MediaQuery.of(context).size.width * 0.3,
                                                      height: MediaQuery.of(context).size.height * 0.55,
                                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            'Konfirmasi Data',
                                                            style: kSubHeaderStyle,
                                                          ),
                                                          Text(
                                                            'Pastikan data yang di isi sudah benar. Hubungi customer service AlteaCare untuk perubahan data.',
                                                            style: kVerifText1,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          buildConfirmationRow('Nama', '${controller.firstName.value} ${controller.lastName.value}'),
                                                          buildConfirmationRow('Jenis Kelamin', controller.gender.value),
                                                          buildConfirmationRow(
                                                              'Tempat Lahir', '${controller.birthTown.value}, ${controller.countryName.value}'),
                                                          buildConfirmationRow('Tanggal Lahir', controller.birthDate.value),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          CustomFlatButton(
                                                              width: double.infinity,
                                                              text: 'Konfirmasi',
                                                              onPressed: () {
                                                                Get.back();
                                                                controller.dataSaved.value = true;
                                                                registerKey.currentState?.save();
                                                                setState(() {
                                                                  currentStep += 1;
                                                                  isChooseStep3 = true;
                                                                  // isChooseStep2 = true;
                                                                });
                                                              },
                                                              color: kButtonColor),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          CustomFlatButton(
                                                              width: double.infinity,
                                                              text: 'Cancel',
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              borderColor: kButtonColor,
                                                              color: kBackground)
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          }
                                        } else if (currentStep == 0) {
                                          controller.isPhoneUsable.value = true;
                                          controller.isEmailUsable.value = true;
                                          var res = registerKey.currentState?.validate();
                                          if (res == true) {
                                            controller.dataSaved.value = false;
                                            registerKey.currentState?.save();
                                            var check = await controller.checkPhoneAndEmail();
                                            print('check phone email => $check');

                                            if (check['status'] == true) {
                                              controller.isPhoneUsable.value = check['data']['is_phone_available'] as bool;
                                              controller.isEmailUsable.value = check['data']['is_email_available'] as bool;
                                              var valid = registerKey.currentState?.validate();
                                              if (valid == true) {
                                                controller.dataSaved.value = true;
                                                registerKey.currentState!.save();
                                                setState(() {
                                                  currentStep += 1;
                                                  // isChooseStep3 = true;
                                                  isChooseStep2 = true;
                                                });
                                              }
                                            } else {
                                              controller.isPhoneUsable.value = false;
                                              registerKey.currentState?.validate();
                                            }
                                          }
                                        } else if (currentStep == 2) {
                                          final res = registerKey.currentState?.validate();
                                          if (res == true) {
                                            registerKey.currentState?.save();
                                            setState(() {
                                              currentStep += 1;
                                              isChooseStep3 = true;
                                            });
                                          }
                                        } else if (currentStep == 3) {
                                          if (approved) {
                                            Register result = await controller.registerAccount(context: context);
                                            // print('hasil register =>${result.data?.accessToken}');
                                            if (result.status!) {
                                              if (result.data?.accessToken != null) {
                                                controller.accessToken.value = result.data!.accessToken!;
                                                final verifResult = await controller.sendPhoneVerification();

                                                if (verifResult['status'] == true) {
                                                  setState(() {
                                                    currentStep += 1;
                                                    isChooseStep4 = true;
                                                  });
                                                }
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
                                                      title: 'Register Gagal',
                                                      buttonTxt: 'Mengerti',
                                                      subtitle: result.message!));
                                            }
                                          }
                                        } else if (currentStep == 4) {
                                          var res = registerKey.currentState?.validate();
                                          if (res == true) {
                                            registerKey.currentState?.save();
                                            // print('controller => ${controller.otpCode.value}');
                                            var result = (controller.verificationMethod == "phone")
                                                ? await controller.verifyPhone()
                                                : await controller.verifyEmail();
                                            if (result['status'] == true) {
                                              setState(() {
                                                currentStep += 1;
                                                isChooseStep4 = true;
                                              });

                                              // Get.dialog(Container(
                                              //   width: screenWidth * 0.3,
                                              //   height: screenWidth * 0.35,
                                              //   decoration: BoxDecoration(
                                              //     borderRadius:
                                              //         BorderRadius.circular(22),
                                              //     color: kBackground,
                                              //   ),
                                              //   child: AlertScreen(
                                              // title: 'Akun Berhasil Dibuat',
                                              //       subtitle:
                                              // 'Akun anda berhasil dibuat. Silahkan sign in.',
                                              //       imgPath:
                                              // 'assets/success_icon.png',
                                              //       btnText: 'Sign In',
                                              //       onPressed: () =>
                                              //           Get.toNamed('/login')),
                                              // ));
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => CustomSimpleDialog(
                                                      icon: ImageIcon(
                                                          AssetImage(
                                                            'assets/success_icon.png',
                                                          ),
                                                          color: kGreenColor,
                                                          size: 150),
                                                      onPressed: () => Get.offNamed(Routes.LOGIN),
                                                      title: "Akun Berhasil Dibuat",
                                                      buttonTxt: "Sign In",
                                                      subtitle: "Akun anda berhasil dibuat. Silahkan sign in."));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => CustomSimpleDialog(
                                                      icon: const ImageIcon(
                                                          AssetImage(
                                                            'assets/group-5.png',
                                                          ),
                                                          color: kRedError,
                                                          size: 150),
                                                      onPressed: () => Get.back(),
                                                      title: "Kode OTP Salah",
                                                      buttonTxt: "Tutup",
                                                      subtitle: "Kode OTP Salah, harap periksa lagi SMS yang anda terima"));
                                            }
                                          }
                                        } else {
                                          var res = registerKey.currentState?.validate();

                                          // if (res == true) {
                                          //   registerKey.currentState?.save();
                                          //   setState(() {
                                          //     currentStep += 1;
                                          //   });
                                          //   if (currentStep == 1) {
                                          //     setState(() {
                                          //       isChooseStep2 = true;
                                          //     });
                                          //   } else if (currentStep == 2) {
                                          //     setState(() {
                                          //       isChooseStep3 = true;
                                          //     });
                                          //   } else if (currentStep == 3) {
                                          //     setState(() {
                                          //       isChooseStep4 = true;
                                          //     });
                                          //   } else {
                                          //     setState(() {
                                          //       isChooseStep5 = true;
                                          //     });
                                          //   }
                                          //   if (confirmed) {}
                                          // }
                                        }

                                        // print('currentStep akhir => $currentStep');
                                      },
                                      color: currentStep == 3
                                          ? approved
                                              ? kButtonColor
                                              : kLightGray
                                          : kButtonColor)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                    ],
                  );
                }
              } else {
                // ? NOTE: MOBILE APP
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      // height: MediaQuery.of(context).size.height * 0.8,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Get.width * 1.5,
                                height: Get.height * 0.1,
                                // padding: EdgeInsets.all(16),
                                // color: Colors.pink,
                                child: SingleChildScrollView(
                                  controller: stepCtrl,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(16),
                                        width: Get.width * 1.3,
                                        height: 3,
                                        color: kButtonColor,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        width: Get.width * 1.3,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: stepperText.asMap().entries.map((e) {
                                            return InkWell(
                                              onTap: () {
                                                if (completedStep >= e.key) {
                                                  setState(() {
                                                    currentStep = e.key;
                                                  });
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: Get.width * 0.25,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: Get.width * 0.05,
                                                          height: Get.width * 0.05,
                                                          decoration: BoxDecoration(
                                                              color: currentStep >= e.key ? kButtonColor : kLightGray,
                                                              borderRadius: BorderRadius.circular(24)),
                                                          child: Center(
                                                              child: currentStep > e.key
                                                                  ? Icon(
                                                                      Icons.done,
                                                                      color: kBackground,
                                                                      size: Get.width * 0.03,
                                                                    )
                                                                  : Text(
                                                                      (e.key + 1).toString(),
                                                                      style: kStepperTextStyle,
                                                                    )),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          stepperText[e.key],
                                                          style: kStepperSubStyle(currentStep >= e.key ? kButtonColor : kLightGray),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              registerBody(currentStep),
                            ],
                          ),
                          Column(
                            children: [
                              CustomFlatButton(
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  width: double.infinity,
                                  text: currentStep == 3
                                      ? 'Saya Setuju'
                                      : currentStep == 4
                                          ? 'Verifikasi'
                                          : 'Lanjutkan',
                                  onPressed: () async {
                                    if (currentStep == 1) {
                                      var res = registerKey.currentState?.validate();
                                      if (res == true) {
                                        registerKey.currentState?.save();
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                backgroundColor: Colors.white,
                                                child: Container(
                                                  padding: const EdgeInsets.all(16),
                                                  width: MediaQuery.of(context).size.width * 0.4,
                                                  height: MediaQuery.of(context).size.height * 0.7,
                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'Konfirmasi Data',
                                                        style: kSubHeaderStyle,
                                                      ),
                                                      Text(
                                                        'Pastikan data yang di isi sudah benar. Hubungi customer service AlteaCare untuk perubahan data.',
                                                        style: kVerifText1,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      buildConfirmationRow('Email', controller.email.value),
                                                      buildConfirmationRow('Nomor Handphone', controller.phoneNum.value),
                                                      buildConfirmationRow('Nama', '${controller.firstName.value} ${controller.lastName.value}'),
                                                      buildConfirmationRow('Jenis Kelamin', controller.gender.value),
                                                      buildConfirmationRow(
                                                          'Tempat Lahir', '${controller.birthTown.value}, ${controller.countryName.value}'),
                                                      buildConfirmationRow('Tanggal Lahir', controller.birthDate.value),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      CustomFlatButton(
                                                          width: double.infinity,
                                                          text: 'Konfirmasi',
                                                          onPressed: () {
                                                            Get.back();
                                                            controller.dataSaved.value = true;
                                                            registerKey.currentState?.save();
                                                            setState(() {
                                                              currentStep += 1;
                                                              completedStep += 1;
                                                              isChooseStep2 = true;
                                                            });
                                                          },
                                                          color: kButtonColor),
                                                      CustomFlatButton(
                                                          width: double.infinity,
                                                          text: 'Cancel',
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          borderColor: kButtonColor,
                                                          color: kBackground)
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      }
                                    } else if (currentStep == 0) {
                                      controller.isPhoneUsable.value = true;
                                      controller.isEmailUsable.value = true;
                                      var res = registerKey.currentState?.validate();
                                      if (res == true) {
                                        controller.dataSaved.value = false;
                                        registerKey.currentState?.save();
                                        var check = await controller.checkPhoneAndEmail();
                                        // print('check phone email => $check');

                                        if (check['status'] == true) {
                                          controller.isPhoneUsable.value = check['data']['is_phone_available'] as bool;
                                          controller.isEmailUsable.value = check['data']['is_email_available'] as bool;
                                          var valid = registerKey.currentState?.validate();
                                          if (valid == true) {
                                            controller.dataSaved.value = true;
                                            registerKey.currentState!.save();
                                            setState(() {
                                              currentStep += 1;
                                              completedStep += 1;
                                              isChooseStep2 = true;
                                            });
                                          }
                                        } else {
                                          controller.isPhoneUsable.value = false;
                                          registerKey.currentState?.validate();
                                        }
                                      }
                                    } else if (currentStep == 2) {
                                      var res = registerKey.currentState?.validate();
                                      if (res == true) {
                                        registerKey.currentState?.save();
                                        setState(() {
                                          currentStep += 1;
                                          completedStep += 1;
                                          isChooseStep3 = true;
                                        });
                                      }
                                    } else if (currentStep == 3) {
                                      if (approved) {
                                        Register result = await controller.registerAccount(context: context);
                                        // print('hasil register =>${result.data?.accessToken}');
                                        if (result.status!) {
                                          if (result.data?.accessToken != null) {
                                            controller.accessToken.value = result.data?.accessToken as String;
                                            var verifResult = await controller.sendPhoneVerification();

                                            if (verifResult['status'] == true) {
                                              setState(() {
                                                currentStep += 1;
                                                completedStep += 1;
                                                isChooseStep4 = true;
                                              });
                                            }
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
                                                  title: 'Register Gagal',
                                                  buttonTxt: 'Mengerti',
                                                  subtitle: result.message!));
                                        }
                                      }
                                    } else if (currentStep == 4) {
                                      var res = registerKey.currentState?.validate();
                                      if (res == true) {
                                        registerKey.currentState?.save();
                                        // print('controller => ${controller.otpCode.value}');
                                        var result = (controller.verificationMethod == "phone")
                                            ? await controller.verifyPhone()
                                            : await controller.verifyEmail();
                                        if (result['status'] == true) {
                                          setState(() {
                                            currentStep += 1;
                                            completedStep += 1;
                                            isChooseStep4 = true;
                                          });

                                          Get.to(AlertScreen(
                                              title: 'Akun Berhasil Dibuat',
                                              subtitle: 'Akun anda berhasil dibuat. Silahkan sign in.',
                                              imgPath: 'assets/success_icon.png',
                                              btnText: 'Beranda',
                                              onPressed: () => Get.toNamed('/login')));
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) => CustomSimpleDialog(
                                                  icon: const ImageIcon(
                                                      AssetImage(
                                                        'assets/group-5.png',
                                                      ),
                                                      color: kRedError,
                                                      size: 150),
                                                  onPressed: () => Get.back(),
                                                  title: "Kode OTP Salah",
                                                  buttonTxt: "Tutup",
                                                  subtitle: "Kode OTP Salah, harap periksa lagi SMS yang anda terima"));
                                        }
                                      }
                                    } else {
                                      var res = registerKey.currentState?.validate();

                                      // if (res == true) {
                                      //   registerKey.currentState?.save();
                                      //   setState(() {
                                      //     currentStep += 1;
                                      //   });
                                      //   if (currentStep == 1) {
                                      //     setState(() {
                                      //       isChooseStep2 = true;
                                      //     });
                                      //   } else if (currentStep == 2) {
                                      //     setState(() {
                                      //       isChooseStep3 = true;
                                      //     });
                                      //   } else if (currentStep == 3) {
                                      //     setState(() {
                                      //       isChooseStep4 = true;
                                      //     });
                                      //   } else {
                                      //     setState(() {
                                      //       isChooseStep5 = true;
                                      //     });
                                      //   }
                                      // }
                                    }
                                  },
                                  color: currentStep == 3
                                      ? approved
                                          ? kButtonColor
                                          : kLightGray
                                      : kButtonColor),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: 'Sudah Punya Akun? ', style: kDontHaveAccStyle),
                                      TextSpan(
                                        text: 'Sign In',
                                        style: kDontHaveAccStyle.copyWith(color: kDarkBlue, fontWeight: FontWeight.w600),
                                        recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          )),
    );
  }

  Row buildConfirmationRow(String title, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kConfirmTitleStyle,
        ),
        Text(content, style: kConfirmTextStyle),
      ],
    );
  }
}

class StepperLastWidget extends StatelessWidget {
  const StepperLastWidget({
    Key? key,
    required this.screenWidth,
    required this.text,
    required this.subtitleText,
    required this.currentStep,
    this.isChooseStep = false,
    this.width,
    this.height,
  }) : super(key: key);

  final double screenWidth;
  final String text;
  final String subtitleText;
  final int currentStep;

  final bool isChooseStep;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (currentStep >= int.parse(text)) ...[
          SizedBox(
            height: 10.5,
          ),
        ],
        Row(
          children: [
            Container(
              height: height ?? screenWidth * 0.003,
              width: width ?? screenWidth * 0.02,
              color: isChooseStep ? kButtonColor : kLightGray,
            ),
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: isChooseStep ? kButtonColor : kLightGray),
              child: Padding(
                padding: EdgeInsets.all(currentStep >= int.parse(text) ? 2.0 : 8.0),
                child: currentStep >= int.parse(text)
                    ? Icon(
                        Icons.done,
                        color: kBackground,
                        size: 21,
                      )
                    : Text(
                        text,
                        style: kStepperSubStyle(kBackground, fontSize: 21),
                      ),
              ),
            ),
            Container(
              height: height ?? screenWidth * 0.003,
              width: width ?? screenWidth * 0.02,
              color: kBackground,
            ),
          ],
        ),
        if (currentStep >= int.parse(text)) ...[
          SizedBox(
            height: 10,
          ),
        ],
        Text(
          subtitleText,
          style: kStepperSubStyle(isChooseStep ? kButtonColor : kLightGray),
        )
      ],
    );
  }
}

class StepperMiddleWidget extends StatelessWidget {
  const StepperMiddleWidget({
    Key? key,
    required this.screenWidth,
    required this.text,
    required this.subtitleText,
    required this.currentStep,
    this.isChooseStep = false,
    this.width,
    this.height,
  }) : super(key: key);

  final double screenWidth;
  final String text;
  final String subtitleText;
  final int currentStep;
  final bool isChooseStep;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (currentStep >= int.parse(text)) ...[
          SizedBox(
            height: 10.5,
          ),
        ],
        Row(
          children: [
            Container(
              height: height ?? screenWidth * 0.003,
              width: width ?? screenWidth * 0.02,
              color: isChooseStep ? kButtonColor : kLightGray,
            ),
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: isChooseStep ? kButtonColor : kLightGray),
              child: Padding(
                padding: EdgeInsets.all(currentStep >= int.parse(text) ? 3.0 : 8.0),
                child: currentStep >= int.parse(text)
                    ? Icon(
                        Icons.done,
                        color: kBackground,
                        size: 21,
                      )
                    : Text(
                        text,
                        style: kStepperSubStyle(kBackground, fontSize: 21),
                      ),
              ),
            ),
            Container(
              height: height ?? screenWidth * 0.003,
              width: width ?? screenWidth * 0.02,
              color: isChooseStep ? kButtonColor : kLightGray,
            ),
          ],
        ),
        if (currentStep >= int.parse(text)) ...[
          SizedBox(
            height: 10,
          ),
        ],
        Text(
          subtitleText,
          style: kStepperSubStyle(
            isChooseStep ? kButtonColor : kLightGray,
          ),
        )
      ],
    );
  }
}

class StepperFirstWidget extends StatelessWidget {
  const StepperFirstWidget({
    Key? key,
    this.isChooseStep = false,
    required this.text,
    required this.subtitleText,
    required this.currentStep,
    required this.screenWidth,
    this.width,
    this.height,
  }) : super(key: key);

  final bool isChooseStep;
  final String text;
  final String subtitleText;
  final int currentStep;
  final double screenWidth;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    // print("current step -> $currentStep");
    return Column(
      children: [
        if (currentStep >= int.parse(text)) ...[
          const SizedBox(
            height: 10.5,
          ),
        ],
        Row(
          children: [
            Container(
              height: height ?? screenWidth * 0.003,
              width: width ?? screenWidth * 0.02,
              color: kBackground,
            ),
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: isChooseStep ? kButtonColor : kLightGray),
              child: Padding(
                padding: EdgeInsets.all(currentStep >= int.parse(text) ? 3.0 : 8.0),
                child: currentStep >= int.parse(text)
                    ? const Icon(
                        Icons.done,
                        color: kBackground,
                        size: 21,
                      )
                    : Text(
                        text,
                        style: kStepperSubStyle(kBackground, fontSize: 21),
                      ),
              ),
            ),
            Container(
              height: height ?? screenWidth * 0.003,
              width: width ?? screenWidth * 0.02,
              color: isChooseStep ? kButtonColor : kLightGray,
            ),
          ],
        ),
        if (currentStep >= int.parse(text)) ...[
          SizedBox(
            height: 10,
          ),
        ],
        Text(
          subtitleText,
          style: kStepperSubStyle(
            isChooseStep ? kButtonColor : kLightGray,
          ),
        )
      ],
    );
  }
}

//  Container(
//                                         margin: const EdgeInsets.all(16),
//                                         width: Get.width * 1.3,
//                                         height: 3,
//                                         color: kButtonColor,
//                                       ),
//                                       Container(
//                                         margin: const EdgeInsets.symmetric(
//                                             horizontal: 16, vertical: 8),
//                                         width: Get.width * 1.3,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: stepperText
//                                               .asMap()
//                                               .entries
//                                               .map((e) {
//                                             return Column(
//                                               children: [
//                                                 Container(
//                                                   width: Get.width * 0.25,
//                                                   child: Column(
//                                                     children: [
//                                                       Container(
//                                                         width: Get.width * 0.05,
//                                                         height:
//                                                             Get.width * 0.05,
//                                                         decoration: BoxDecoration(
//                                                             color: currentStep >=
//                                                                     e.key
//                                                                 ? kButtonColor
//                                                                 : kLightGray,
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         24)),
//                                                         child: Center(
//                                                             child: currentStep >
//                                                                     e.key
//                                                                 ? Icon(
//                                                                     Icons.done,
//                                                                     color:
//                                                                         kBackground,
//                                                                     size:
//                                                                         Get.width *
//                                                                             0.03,
//                                                                   )
//                                                                 : Text(
//                                                                     (e.key + 1)
//                                                                         .toString(),
//                                                                     style:
//                                                                         kStepperTextStyle,
//                                                                   )),
//                                                       ),
//                                                       const SizedBox(
//                                                         height: 8,
//                                                       ),
//                                                       Text(
//                                                         stepperText[e.key],
//                                                         style: kStepperSubStyle(
//                                                             currentStep >= e.key
//                                                                 ? kButtonColor
//                                                                 : kLightGray),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             );
//                                           }).toList(),
//                                         ),
//                                       )
