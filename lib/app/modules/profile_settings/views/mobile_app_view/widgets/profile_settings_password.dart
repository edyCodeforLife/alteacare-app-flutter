import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/core/widgets/validation_card.dart';
import 'package:altea/app/modules/profile_settings/controllers/profile_settings_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSettingsPassword extends StatefulWidget {
  @override
  _ProfileSettingsPasswordState createState() => _ProfileSettingsPasswordState();
}

class _ProfileSettingsPasswordState extends State<ProfileSettingsPassword> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  ProfileSettingsController controller = Get.find<ProfileSettingsController>();

  bool minCharacter = false;

  bool capsCharacter = false;

  bool smallCharacter = false;

  bool numCharacter = false;

  bool passwordDone = false;

  bool correct = false;
  String oldPass = '';
  String password = '';
  String confirmPass = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Ubah Password',
          style: kAppBarTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: kBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(25),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    onChanged: (val) {},
                    hintText: 'Masukkan Password Lama',
                    keyboardType: TextInputType.visiblePassword,
                    onSaved: (val) {
                      oldPass = val!;
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
                  SizedBox(
                    height: 16,
                  ),
                  CustomTextField(
                    onChanged: (val) {
                      setState(() {
                        correct = false;
                      });
                      password = val.toString();
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
                      }
                    },
                    hintText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    onSaved: (val) {
                      password = val!;
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
                      correct = false;
                      // print('$val');
                      if (val != null) {
                        confirmPass = val;
                      }
                      // print('confirmPass => $confirmPass');
                      if (val.toString() == password) {
                        setState(() {
                          correct = true;
                        });
                      } else {
                        setState(() {
                          correct = false;
                        });
                      }
                      _key.currentState?.validate();
                    },
                    hintText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    onSaved: (val) {
                      // if (val != null) controller.retryPassword.value = val;
                      confirmPass = val!;
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
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: correct
                          ? Text(
                              'Password Sesuai',
                              style: kPswValidText,
                            )
                          : Container()),
                  SizedBox(
                    height: 24,
                  ),
                  CustomFlatButton(
                      width: double.infinity,
                      text: 'Konfirmasi',
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          _key.currentState!.save();
                          var res = await controller.checkPassword({
                            "password": oldPass,
                          });

                          if (res['status'] as bool) {
                            var result = await controller.changePassword({"password": password, "password_confirmation": confirmPass});

                            if (result['status'] as bool) {
                              Get.back();
                              Get.back();
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => CustomSimpleDialog(
                                    icon: ImageIcon(
                                      AssetImage('assets/group-5.png'),
                                      size: 150,
                                      color: kRedError,
                                    ),
                                    onPressed: () => Get.back(),
                                    title: 'Gagal',
                                    buttonTxt: 'Kembali',
                                    subtitle: res['message'].toString()));
                          }
                        }
                      },
                      color: kButtonColor)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
