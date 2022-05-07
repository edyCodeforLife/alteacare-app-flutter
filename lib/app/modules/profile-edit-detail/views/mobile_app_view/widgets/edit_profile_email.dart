import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/modules/profile-edit-detail/controllers/profile_edit_detail_controller.dart';
import 'package:altea/app/modules/profile-edit-detail/views/mobile_app_view/widgets/edit_profile_email_o_t_p.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileEmail extends StatelessWidget {
  ProfileEditDetailController controller = Get.put(ProfileEditDetailController());
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Form(
        key: _key,
        child: Column(
          children: [
            CustomTextField(
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
                hintText: 'Masukkan Alamat Email Baru',
                keyboardType: TextInputType.emailAddress),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: CustomFlatButton(
                  width: double.infinity,
                  text: 'Konfirmasi',
                  onPressed: () async {
                    var res = _key.currentState?.validate();
                    if (res == true) {
                      _key.currentState?.save();
                      var result = await controller.sendVerificationEmail();
                      // print('hasil send email => $result');

                      if (result['status'] == true) {
                        Get.to(EditProfileEmailOTP(
                          type: "email",
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
                                subtitle: result['message'].toString()));
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
