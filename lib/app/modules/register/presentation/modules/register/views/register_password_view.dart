// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/core/widgets/validation_card.dart';
import 'package:altea/app/modules/register/presentation/modules/register/controllers/register_controller.dart';

class RegisterPasswordView extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  RegisterPasswordView({required this.formKey});

  @override
  _RegisterPasswordViewState createState() => _RegisterPasswordViewState();
}

class _RegisterPasswordViewState extends State<RegisterPasswordView> {
  bool minCharacter = false;

  bool capsCharacter = false;

  bool smallCharacter = false;

  bool numCharacter = false;

  bool passwordDone = false;

  bool correct = false;
  String password = '';
  String confirmPass = '';
  RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      if (sizingInformation.isMobile) {
        return Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                onChanged: (val) {
                  setState(() {
                    correct = false;
                  });

                  if (val != '') {
                    password = val.toString();
                  }
                  if (val != null && val != "") {
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
                      setState(() {
                        passwordDone = true;
                      });
                    } else {
                      setState(() {
                        passwordDone = false;
                      });
                    }
                    if (val.toString() == confirmPass) {
                      setState(() {
                        correct = true;
                      });
                    } else {
                      setState(() {
                        correct = false;
                      });
                    }
                    widget.formKey.currentState?.validate();
                    controller.password.value = password;
                  }
                },
                hintText: 'Password',
                keyboardType: TextInputType.visiblePassword,
                onSaved: (val) {
                  if (val != null) controller.password.value = val;
                },
                validator: (val) {
                  // print('val => $val');
                  if (val == '') {
                    return 'Password tidak boleh kosong';
                  } else if (!passwordDone) {
                    return '';
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
                  if (val != null) {
                    confirmPass = val;
                  }
                  // print('$val');
                  if (val.toString() == password) {
                    setState(() {
                      correct = true;
                    });
                    widget.formKey.currentState?.validate();
                  } else {
                    setState(() {
                      correct = false;
                    });
                    widget.formKey.currentState?.validate();
                  }
                  controller.retryPassword.value = val!;
                },
                hintText: 'Password',
                keyboardType: TextInputType.visiblePassword,
                onSaved: (val) {
                  // print("register password -> $val");

                  if (val != null) controller.retryPassword.value = val;
                },
                validator: (val) {
                  // print('val => $val');
                  if (val == '' || !correct) {
                    return 'Password tidak sesuai';
                  } else {
                    return null;
                  }
                },
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: correct
                      ? Text(
                          'Password Sesuai',
                          style: kPswValidText,
                        )
                      : Container())
            ],
          ),
        );
      } else {
        return Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                onChanged: (val) {
                  setState(() {
                    correct = false;
                  });
                  controller.password.value = password;

                  if (val != '') {
                    password = val.toString();
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
                      setState(() {
                        passwordDone = true;
                      });
                    } else {
                      setState(() {
                        passwordDone = false;
                      });
                    }
                    if (val.toString() == confirmPass) {
                      setState(() {
                        correct = true;
                      });
                    } else {
                      setState(() {
                        correct = false;
                      });
                    }
                    widget.formKey.currentState?.validate();
                  }
                },
                hintText: 'Password',
                keyboardType: TextInputType.visiblePassword,
                onSaved: (val) {
                  if (val != null) controller.password.value = val;
                },
                validator: (val) {
                  // print('val => $val');
                  if (val == '') {
                    return 'Password tidak boleh kosong';
                  } else if (!passwordDone) {
                    return '';
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
              const SizedBox(
                height: 8,
              ),
              CustomTextField(
                correctPass: correct,
                onChanged: (val) {
                  if (val != null) {
                    confirmPass = val;
                  }
                  // print('$val');
                  if (val.toString() == password) {
                    setState(() {
                      correct = true;
                    });
                    widget.formKey.currentState?.validate();
                  } else {
                    setState(() {
                      correct = false;
                    });
                    widget.formKey.currentState?.validate();
                  }
                  controller.retryPassword.value = val!;
                },
                hintText: 'Password',
                keyboardType: TextInputType.visiblePassword,
                onSaved: (val) {
                  if (val != null) controller.retryPassword.value = val;
                  // print("retry password -> $val");
                },
                validator: (val) {
                  // print('val => $val');
                  if (val == '' || !correct) {
                    return 'Password tidak sesuai';
                  } else {
                    return null;
                  }
                },
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: correct
                      ? Text(
                          'Password Sesuai',
                          style: kPswValidText,
                        )
                      : Container())
            ],
          ),
        );
      }
    });
  }
}
