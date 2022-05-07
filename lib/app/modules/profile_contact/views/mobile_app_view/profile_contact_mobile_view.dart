import 'dart:io';

import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_dropdown_field.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/profile_contact/controllers/profile_contact_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileContactMobileView extends GetView<ProfileContactController> {
  List<String> contactReason = ['Pilih Kategori Pesan'];
  HomeController homeController = Get.find<HomeController>();
  String? selectedReason;
  String message = '';
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // print('user => ${homeController.userData.value.data!.firstName}');
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text(
          'Kontak Altea Care',
          style: kAppBarTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: kBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 32, horizontal: 25),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: controller.getQuestionType(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CustomDropdownField(
                            items: (snapshot.data! as Map<String, dynamic>)['status'] as bool
                                ? ((snapshot.data! as Map<String, dynamic>)['data'] as List)
                                    .map((e) => DropdownMenuItem(
                                          child: Text(e['name'].toString()),
                                          value: e['id'],
                                        ))
                                    .toList()
                                : [],
                            onSaved: (val) {
                              selectedReason = val.toString();
                            },
                            validator: (val) {
                              if (val == null) {
                                return 'Harap Pilih salah satu jenis';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              selectedReason = val.toString();
                            },
                            hintText: 'Pilih Kategori Pesan',
                            value: selectedReason);
                      } else {
                        return Container();
                      }
                    }),
                SizedBox(
                  height: 8,
                ),
                CustomTextField(
                    onChanged: (val) {},
                    validator: (val) {
                      if (val != null) {
                        if (val == '') {
                          return 'Pesan harus diisi';
                        } else {
                          return null;
                        }
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) {
                      message = val.toString();
                    },
                    hintText: 'Masukkan Pesan Anda',
                    keyboardType: TextInputType.multiline),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: CustomFlatButton(
                      width: double.infinity,
                      text: 'Kirim Pesan',
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          _key.currentState!.save();
                          // print('type => $selectedReason message => $message');

                          try {
                            var res = await controller.postQuestion({
                              "message_type": selectedReason,
                              "message": message,
                              "name": '${homeController.userData.value.data?.firstName} ${homeController.userData.value.data?.lastName}',
                              "phone": homeController.userData.value.data!.phone,
                              "email": homeController.userData.value.data!.email,
                              "user_id": homeController.userData.value.data!.id,
                            });

                            if (res['status'] as bool) {
                              showDialog(
                                  context: context,
                                  builder: (context) => CustomSimpleDialog(
                                      icon: ImageIcon(
                                        AssetImage(
                                          'assets/success_icon.png',
                                        ),
                                        size: 150,
                                        color: kGreenColor,
                                      ),
                                      onPressed: () {
                                        Get.offNamed('/home');
                                      },
                                      title: 'Pesan Terkirim',
                                      buttonTxt: 'Kembali',
                                      subtitle: 'Kami akan menghubungi anda!'));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => CustomSimpleDialog(
                                      icon: ImageIcon(
                                        AssetImage('assets/group-5.png'),
                                        size: 150,
                                        color: kRedError,
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      },
                                      title: 'Gagal mengirim pesan',
                                      buttonTxt: 'Kembali',
                                      subtitle: res['message'].toString()));
                            }
                          } catch (e) {
                            showDialog(
                                context: context,
                                builder: (context) => CustomSimpleDialog(
                                    icon: ImageIcon(
                                      AssetImage('assets/group-5.png'),
                                      size: 150,
                                      color: kRedError,
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    title: 'Gagal mengirim pesan',
                                    buttonTxt: 'Kembali',
                                    subtitle: e.toString()));
                          }
                        }
                      },
                      color: kButtonColor),
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
                    String url = Platform.isIOS ? "whatsapp://wa.me/081315739235/" : "whatsapp://send?phone=081315739235";

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
                    String url = Platform.isIOS ? "whatsapp://wa.me/081315739245/" : "whatsapp://send?phone=081315739245";
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
          ),
        ),
      ),
    );
  }
}
