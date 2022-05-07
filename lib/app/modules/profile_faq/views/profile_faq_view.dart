// Flutter imports:
// Project imports:
import 'package:altea/app/modules/profile_faq/views/mobile_app_view/profile_f_a_q_mobile_view.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

import '../controllers/profile_faq_controller.dart';

class ProfileFaqView extends GetView<ProfileFaqController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return Container();
    } else {
      return ProfileFAQMobileView();
    }
  }
}
