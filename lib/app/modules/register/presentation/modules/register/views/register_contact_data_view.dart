// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/modules/register/presentation/modules/register/controllers/register_controller.dart';

class RegisterContactDataView extends GetView<RegisterController> {
  final GlobalKey<FormState> formKey;
  const RegisterContactDataView({required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            onChanged: (val) {},
            validator: (val) {
              if (val == '') {
                return 'Nomor Handphone belum terisi';
              } else if (!controller.isPhoneUsable.value) {
                return 'Nomor Handphone sudah terdaftar';
              }
            },
            onSaved: (val) {
              // print('save nih');
              if (val != null) {
                controller.phoneNum.value = val;
              }
            },
            hintText: 'Nomor Handphone',
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(14)],
          ),
          CustomTextField(
              onChanged: (val) {},
              validator: (val) {
                if (val == '') {
                  return 'Alamat Email belum terisi';
                } else if (!controller.isEmailUsable.value) {
                  return 'Alamat Email sudah terdaftar';
                } else {
                  if (val != null) {
                    // print('masukkk');
                    if (!val.contains('@') || !val.contains('.')) {
                      // print('masuk sini');
                      return 'Alamat Email tidak sesuai';
                    } else {
                      return null;
                    }
                  }
                }
              },
              onSaved: (val) {
                // print('save nih');
                if (val != null) {
                  controller.email.value = val;
                }
              },
              hintText: 'Alamat Email',
              keyboardType: TextInputType.emailAddress),
        ],
      ),
    );
  }
}
