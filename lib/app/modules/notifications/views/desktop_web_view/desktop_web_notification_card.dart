// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/notification_model.dart';
import 'package:altea/app/modules/notifications/views/mobile_web_view/widgets/hightlight_text.dart';

class DesktopWebNotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final double screenWidth;
  const DesktopWebNotificationCard({required this.notification, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(color: kLightGray.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: (notification.type.toLowerCase().contains('success'))
                  ? Image.asset(
                      "assets/success_icon.png",
                      color: kYellowColor,
                      height: 30,
                      width: 30,
                    )
                  : (notification.type.toLowerCase().contains('cancel'))
                      ? Image.asset(
                          "assets/failed_icon.png",
                          color: kRedError,
                          height: 30,
                          width: 30,
                        )
                      : Image.asset(
                          "assets/no_file_upload_icon.png",
                          color: kDarkBlue,
                          height: 30,
                          width: 30,
                        ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            // width: (screenWidth * 0.4) - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // "Hari ini 09.30",
                  notification.createdAt,
                  style: kPoppinsRegular400.copyWith(color: Colors.black, fontSize: 8),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  notification.title,
                  style: kPoppinsMedium500.copyWith(color: fullBlack, fontSize: 12),
                ),
                Text(
                  notification.subTitle,
                  style: kPoppinsMedium500.copyWith(color: fullBlack, fontSize: 10),
                ),
                const SizedBox(
                  height: 4,
                ),
                HightlightText(
                  text: notification.message,
                  highlight: notification.orderId ?? "",
                  style: kPoppinsRegular400.copyWith(color: kTextHintColor, fontSize: 10),
                  highlightStyle: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 10),
                )
                // Text(
                //   notification.message,
                //   style: kPoppinsRegular400.copyWith(
                //       color: kTextHintColor, fontSize: 10),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
