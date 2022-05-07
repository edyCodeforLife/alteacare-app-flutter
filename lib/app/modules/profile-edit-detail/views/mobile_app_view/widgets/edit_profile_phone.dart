import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/modules/profile-edit-detail/controllers/profile_edit_detail_controller.dart';
import 'package:altea/app/modules/profile-edit-detail/views/mobile_app_view/widgets/edit_profile_email_o_t_p.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfilePhone extends GetView<ProfileEditDetailController> {
  GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  String phoneNum = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Form(
        key: _phoneKey,
        child: Column(
          children: [
            CustomTextField(
                validator: (val) {
                  if (val == '') {
                    return 'Nomor Handphone belum terisi';
                  } else {
                    return null;
                  }
                },
                onSaved: (val) {
                  // print('save nih');
                  if (val != null) {
                    phoneNum = val;
                    // print('phoneNum => $phoneNum');
                    controller.phone.value = val;
                  }
                },
                onChanged: (val) {},
                hintText: 'Masukkan No. Handphone Baru',
                keyboardType: TextInputType.number),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: CustomFlatButton(
                  width: double.infinity,
                  text: 'Konfirmasi',
                  onPressed: () async {
                    if (_phoneKey.currentState!.validate()) {
                      _phoneKey.currentState!.save();
                      var res = await controller.changePhoneNum(phoneNum);

                      if (res['status'] as bool) {
                        Get.to(EditProfileEmailOTP(
                          type: "phone",
                        ));
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
                                title: 'Gagal',
                                buttonTxt: 'Kembali',
                                subtitle: res['message'].toString()));
                      }
                    }
                  },
                  color: kButtonColor),
            )
          ],
        ),
      ),
    );
  }
}
