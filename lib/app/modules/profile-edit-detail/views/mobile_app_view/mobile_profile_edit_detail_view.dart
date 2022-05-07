import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/profile-edit-detail/views/mobile_app_view/widgets/edit_profile_address.dart';
import 'package:altea/app/modules/profile-edit-detail/views/mobile_app_view/widgets/edit_profile_email.dart';
import 'package:altea/app/modules/profile-edit-detail/views/mobile_app_view/widgets/edit_profile_personal.dart';
import 'package:altea/app/modules/profile-edit-detail/views/mobile_app_view/widgets/edit_profile_phone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileProfileEditDetailView extends StatelessWidget {
  String buildAppBarTitle(BuildContext context) {
    String args = ModalRoute.of(context)!.settings.arguments.toString();
    switch (args) {
      case 'personal':
        return 'Ubah Personal Data';
      case 'phone':
        return 'Ubah No. Handphone';
      case 'email':
        return 'Ubah Alamat Email';
      default:
        return 'Ubah Alamat Pengiriman';
    }
  }

  Widget buildBody(BuildContext context) {
    String args = ModalRoute.of(context)!.settings.arguments.toString();
    switch (args) {
      case 'personal':
        return EditProfilePersonal();
      case 'phone':
        return EditProfilePhone();
      case 'email':
        return EditProfileEmail();
      default:
        return EditProfileAddress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 2,
        title: Text(
          buildAppBarTitle(context),
          style: kAppBarTitleStyle,
        ),
      ),
      body: buildBody(context),
    );
  }
}
