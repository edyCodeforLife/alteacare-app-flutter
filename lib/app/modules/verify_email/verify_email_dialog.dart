import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:altea/app/modules/verif_otp/views/verify_otp_dialog.dart';
import 'package:altea/app/modules/verify_email/controllers/verify_email_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailDialog extends GetView<VerifyEmailController> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 27, vertical: 50),
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              'Masukkan alamat email yang terdaftar di AlteaCare',
              softWrap: true,
              style: kVerifText2.copyWith(fontWeight: FontWeight.w400, color: const Color(0xFF606D77)),
            ),
          ),
          const SizedBox(
            height: 27,
          ),
          Form(
            key: _key,
            child: CustomTextField(
                onChanged: (val) {},
                validator: (val) {
                  if (val != null) {
                    if (val.isEmpty) {
                      return 'Email tidak bisa kosong';
                    } else if (!val.contains('@') || !val.contains('.')) {
                      return 'Email tidak sesuai';
                    }
                  }
                },
                onSaved: (val) {
                  controller.email.value = val.toString();
                },
                hintText: 'Alamat Email',
                keyboardType: TextInputType.emailAddress),
          ),
          const SizedBox(
            height: 23,
          ),
          CustomFlatButton(
              width: MediaQuery.of(context).size.width,
              text: 'Lanjutkan',
              onPressed: () async {
                var res = _key.currentState?.validate();
                if (res == true) {
                  _key.currentState?.save();
                  var result = await controller.sendVerificationEmail();
                  // print('hasil => $result');

                  if (result['status'] == true) {
                    Get.back();
                    Get.dialog(VerifyOtpDialog(
                      email: "",
                    ));
                    // Get.toNamed('/verify/otp');
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => CustomSimpleDialog(
                            icon: const ImageIcon(
                              AssetImage('assets/group-5.png'),
                              size: 200,
                              color: kRedError,
                            ),
                            onPressed: () => Get.back(),
                            title: 'Verifikasi Gagal',
                            buttonTxt: 'Kembali',
                            subtitle: result['message'].toString()));
                  }
                }
              },
              color: kButtonColor)
        ],
      ),
    ));
  }
}
