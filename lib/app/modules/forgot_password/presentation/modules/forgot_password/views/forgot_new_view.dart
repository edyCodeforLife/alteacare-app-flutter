// Flutter imports:
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
import 'package:altea/app/core/widgets/validation_card.dart';
import 'package:altea/app/data/model/forgot_password_change_model.dart';
import 'package:altea/app/modules/forgot_password/presentation/modules/forgot_password/controllers/forgot_password_controller.dart';
import 'package:altea/app/modules/login/controllers/login_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';

class ForgotNewView extends StatefulWidget {
  @override
  _ForgotNewViewState createState() => _ForgotNewViewState();
}

class _ForgotNewViewState extends State<ForgotNewView> {
  final GlobalKey<FormState> _verifKey = GlobalKey<FormState>();
  final ForgotPasswordController controller = Get.find<ForgotPasswordController>();

  bool minCharacter = false;
  bool capsCharacter = false;
  bool smallCharacter = false;
  bool numCharacter = false;
  String password = '';

  bool passwordDone = false;
  bool correct = false;
  String confirmPass = '';

  // static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        // Get.offNamedUntil(
        //   "/home",
        //   ModalRoute.withName("/home"),
        // );
        Future.delayed(Duration.zero, () {
          Get.offNamedUntil("/home", (route) => false);
        });
        Get.put(LoginController());
        Get.toNamed("/login");
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            if (sizingInformation.isMobile) {
              return SafeArea(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
                  child: Form(
                    key: _verifKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter New Password',
                          style: kHeaderStyle,
                        ),
                        CustomTextField(
                          onChanged: (val) {
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
                          hintText: 'Masukkan Password',
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
                        if (password == '')
                          Container()
                        else
                          Column(
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
                        CustomTextField(
                          correctPass: correct,
                          onChanged: (val) {
                            // print('$val');
                            if (val.toString() == password) {
                              setState(() {
                                correct = true;
                              });
                            } else {
                              correct = false;
                            }
                          },
                          hintText: 'Masukkan Password Kembali',
                          keyboardType: TextInputType.visiblePassword,
                          onSaved: (val) {
                            if (val != null) {
                              controller.confirmPassword.value = val;
                            }
                          },
                          validator: (val) {
                            // print('val => $val');
                            if (val == '' || !correct) {
                              setState(() {
                                correct = false;
                              });
                              return 'Password tidak sesuai';
                            } else {
                              return null;
                            }
                          },
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: correct
                                ? Text(
                                    'Password Sesuai',
                                    style: kPswValidText,
                                  )
                                : Container()),
                        const SizedBox(
                          height: 12,
                        ),
                        CustomFlatButton(
                            width: double.infinity,
                            text: 'Verifikasi',
                            onPressed: () async {
                              var res = _verifKey.currentState?.validate();
                              // print('res => $res');

                              if (res == true) {
                                _verifKey.currentState?.save();
                                final ForgotPasswordChange result = await controller.forgotPasswordChangeAccount(
                                    password: controller.password.value, passwordConfirmation: controller.confirmPassword.value);
                                if (result.status == true) {
                                  return showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => WillPopScope(child: CustomSimpleDialog(
                                      icon: SizedBox(
                                        width: screenWidth * 0.2,
                                        child: Image.asset("assets/success_icon.png"),
                                      ),
                                      onPressed: () {
                                        // Navigator.of(context).popUntil((route) => route.isFirst);
                                        Get.offNamedUntil(
                                          "/login",
                                          ModalRoute.withName("/login"),
                                        );
                                        // Get.offNamedUntil(
                                        //   "/home",
                                        //   ModalRoute.withName("/home"),
                                        // );
                                        // Get.put(LoginController());
                                        // Get.toNamed("/login");
                                      },
                                      title: 'Reset Password Berhasil',
                                      buttonTxt: 'Sign In',
                                      subtitle: 'Sign In kembali dan masukkan password yang baru',
                                    ), onWillPop: () async {
                                      Get.offNamedUntil(
                                        "/login",
                                        ModalRoute.withName("/login"),
                                      );
                                      return false;
                                    }),
                                  );
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
                                'Enter New Password',
                                style: kHeaderStyle,
                              ),
                              CustomTextField(
                                onChanged: (val) {
                                  if (val != '') {
                                    setState(() {
                                      password = val.toString();
                                    });
                                  }
                                  if (val != null) {
                                    if (val.contains(RegExp(r'[A-Z]'))) {
                                      setState(() {
                                        capsCharacter = true;
                                      });
                                    } else {
                                      setState(() {
                                        capsCharacter = false;
                                      });
                                    }
                                    if (val.contains(RegExp(r'[a-z]'))) {
                                      setState(() {
                                        smallCharacter = true;
                                      });
                                    } else {
                                      setState(() {
                                        smallCharacter = false;
                                      });
                                    }
                                    if (val.contains(RegExp(r'[0-9]'))) {
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

                                    if (val == confirmPass) {
                                      // print("MASUK CONFIRMPASS SAMA");
                                      _verifKey.currentState?.validate();
                                      setState(() {
                                        correct = true;
                                      });
                                    } else {
                                      // print("MASUK CONFIRMPASS TIDAK SAMA");
                                      // print("${_verifKey.currentState?.validate()}");
                                      setState(() {
                                        correct = false;
                                      });
                                      _verifKey.currentState?.validate();
                                      // setState(() {
                                      //   correct = true;
                                      // });
                                    }
                                  }
                                },
                                hintText: 'Masukkan Password',
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
                              if (password == '')
                                Container()
                              else
                                Column(
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
                              CustomTextField(
                                correctPass: correct,
                                onChanged: (val) {
                                  // print('$val');
                                  if (val != null) {
                                    setState(() {
                                      confirmPass = val;
                                    });
                                  }
                                  // print('$val');
                                  if (confirmPass == password) {
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
                                hintText: 'Masukkan Password Kembali',
                                keyboardType: TextInputType.visiblePassword,
                                onSaved: (val) {
                                  if (val != null) {
                                    controller.confirmPassword.value = val;
                                  }
                                },
                                // validator: (val) {},
                                validator: (val) {
                                  // print("MASUK KE VALIDATOR RETYPE PASSWORD");
                                  // print('val => $val');
                                  // print('status -> $correct');
                                  if (val!.isEmpty) {
                                    setState(() {
                                      correct = false;
                                    });
                                    return 'Confirm Password tidak boleh kosong';
                                  } else if (!correct) {
                                    // print("CONFRIM PASS -> $confirmPass");
                                    // print("MASUK VAL TIDAK SAMA DENGAN CONFIRM PASS");
                                    setState(() {
                                      correct = false;
                                    });
                                    return 'Password tidak sesuai';
                                  }
                                  // else {
                                  //   // return 'Password sesuai';

                                  //   // return null;
                                  // }
                                },
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
                                height: 12,
                              ),
                              CustomFlatButton(
                                width: double.infinity,
                                text: 'Buat Kata Sandi',
                                onPressed: () async {
                                  var res = _verifKey.currentState!.validate();

                                  if (res == true) {
                                    _verifKey.currentState?.save();
                                    final ForgotPasswordChange result = await controller.forgotPasswordChangeAccount(
                                        password: controller.password.value, passwordConfirmation: controller.confirmPassword.value);
                                    if (result.status == true) {
                                      return showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => CustomSimpleDialog(
                                            icon: SizedBox(
                                              width: screenWidth * 0.1,
                                              child: Image.asset("assets/success_icon.png"),
                                            ),
                                            onPressed: () {
                                              Get.back();
                                              // Get.offNamed('/login');
                                              Get.put(LoginController());

                                              Get.offAndToNamed(
                                                "/home",
                                              );
                                              Get.toNamed("/login");
                                            },
                                            title: 'Reset Password Berhasil',
                                            buttonTxt: 'Sign In',
                                            subtitle: 'Sign In kembali dan masukkan password yang baru'),
                                      );
                                    } else {
                                      return showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) => CustomSimpleDialog(
                                            icon: SizedBox(
                                              width: screenWidth * 0.1,
                                              child: Image.asset("assets/failed_icon.png"),
                                            ),
                                            onPressed: () {
                                              // Get.offNamed('/login');
                                              Get.back();
                                            },
                                            title: 'Reset Password Gagal',
                                            buttonTxt: 'Saya mengerti',
                                            subtitle: result.message!),
                                      );
                                    }
                                  }
                                },
                                color: kButtonColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
