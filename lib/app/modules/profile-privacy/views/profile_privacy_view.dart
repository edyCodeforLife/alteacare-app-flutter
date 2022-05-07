// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/profile_privacy_controller.dart';
import 'mobile_app_view/profile_privacy_mobile_view.dart';

class ProfilePrivacyView extends GetView<ProfilePrivacyController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return Container();
    } else {
      return ProfilePrivacyMobileView();
    }
  }
}
