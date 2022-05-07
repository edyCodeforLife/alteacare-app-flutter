import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSettingsLanguage extends StatefulWidget {
  @override
  _ProfileSettingsLanguageState createState() => _ProfileSettingsLanguageState();
}

class _ProfileSettingsLanguageState extends State<ProfileSettingsLanguage> {
  String selectedLanguage = 'Bahasa';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Ubah Bahasa',
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
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            InkWell(
              onTap: () => setState(() => selectedLanguage = 'Bahasa'),
              child: Container(
                decoration: BoxDecoration(
                    color: kWhiteGray,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: selectedLanguage == 'Bahasa' ? kDarkBlue : kWhiteGray, width: 1)),
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(16),
                child: Text(
                  'Bahasa',
                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                ),
              ),
            ),
            InkWell(
              onTap: () => setState(() => selectedLanguage = 'English'),
              child: Container(
                decoration: BoxDecoration(
                    color: kWhiteGray,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: selectedLanguage == 'English' ? kDarkBlue : kWhiteGray, width: 1)),
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(16),
                child: Text(
                  'English',
                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                ),
              ),
            ),
            CustomFlatButton(
                width: double.infinity,
                text: 'Konfirmasi',
                onPressed: () {
                  Get.back();
                },
                color: kButtonColor)
          ],
        ),
      ),
    );
  }
}
