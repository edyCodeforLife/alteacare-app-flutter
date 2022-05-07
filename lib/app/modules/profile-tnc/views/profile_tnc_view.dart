// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/profile_tnc_controller.dart';
import 'mobile_app_view/tnc_mobile_view.dart';

class ProfileTncView extends GetView<ProfileTncController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return Container();
    } else {
      return TncMobileView();
    }
  }
}
