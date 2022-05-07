// Flutter imports:
// Project imports:
import 'package:altea/app/modules/profile_contact/views/mobile_app_view/profile_contact_mobile_view.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

import '../controllers/profile_contact_controller.dart';

class ProfileContactView extends GetView<ProfileContactController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return Container();
    } else {
      return ProfileContactMobileView();
    }
  }
}
