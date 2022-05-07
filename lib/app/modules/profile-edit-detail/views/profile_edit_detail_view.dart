// Flutter imports:
// Project imports:
import 'package:altea/app/modules/profile-edit-detail/views/mobile_app_view/mobile_profile_edit_detail_view.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

import '../controllers/profile_edit_detail_controller.dart';

class ProfileEditDetailView extends GetView<ProfileEditDetailController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return Container();
    } else {
      return MobileProfileEditDetailView();
    }
  }
}
