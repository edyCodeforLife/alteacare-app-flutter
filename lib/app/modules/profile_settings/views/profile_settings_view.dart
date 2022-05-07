// Flutter imports:
// Project imports:
import 'package:altea/app/modules/profile_settings/views/mobile_app_view/profile_settings_mobile_view.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

import '../controllers/profile_settings_controller.dart';

class ProfileSettingsView extends GetView<ProfileSettingsController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return Container();
    } else {
      return ProfileSettingsMobileView();
    }
  }
}
