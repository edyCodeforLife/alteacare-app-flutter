import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/profile_settings/controllers/profile_settings_controller.dart';
import 'package:altea/app/modules/profile_settings/views/mobile_app_view/widgets/profile_settings_language.dart';
import 'package:altea/app/modules/profile_settings/views/mobile_app_view/widgets/profile_settings_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSettingsMobileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Pengaturan',
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
      body: Container(
        margin: EdgeInsets.all(32),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bahasa',
                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor.withOpacity(0.5)),
                ),
                InkWell(
                  onTap: () {
                    Get.to(ProfileSettingsLanguage());
                  },
                  child: Text(
                    'Ubah',
                    style: kPoppinsSemibold600.copyWith(fontSize: 11, color: kDarkBlue),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Text(
                'Bahasa Indonesia',
                style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
              ),
              decoration: BoxDecoration(color: kWhiteGray, borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(
              height: 22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Password',
                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor.withOpacity(0.5)),
                ),
                InkWell(
                  onTap: () {
                    Get.lazyPut(() => ProfileSettingsController());
                    Get.to(()=> ProfileSettingsPassword());
                  },
                  child: Text(
                    'Ubah',
                    style: kPoppinsSemibold600.copyWith(fontSize: 11, color: kDarkBlue),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Text(
                "\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022",
                style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
              ),
              decoration: BoxDecoration(color: kWhiteGray, borderRadius: BorderRadius.circular(8)),
            )
          ],
        ),
      ),
    );
  }
}
