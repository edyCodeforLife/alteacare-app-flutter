import 'dart:io';

import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EditProfilePersonal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      // color: Colors.blue,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            child: Text(
              'Personal Data tidak dapat diubah. Perubahan data hanya dapat diajukan dengan menghubungi customer service AlteaCare.',
              style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor.withOpacity(0.5)),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            'Email : ',
            style: kForgotTextStyle.copyWith(fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'cs@alteacare.com',
              );

              launch(emailLaunchUri.toString());
            },
            child: Row(
              children: [
                Icon(
                  Icons.mail,
                  color: kButtonColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'cs@alteacare.com',
                  style: kConfirmTextStyle.copyWith(color: kBlackColor),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Hotline WA : ',
            style: kForgotTextStyle.copyWith(fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              String url = Platform.isIOS ? "whatsapp://wa.me/081315739235/" : "whatsapp://send?phone=081315739235";

              if (await canLaunch(url)) {
                launch(url);
              } else {
                final Uri phoneUri = Uri(
                  scheme: 'tel',
                  path: '081315739235',
                );

                launch(phoneUri.toString());
              }
            },
            child: Row(
              children: [
                Icon(
                  Icons.phone,
                  color: kButtonColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '+62 813 1573 9235',
                  style: kConfirmTextStyle.copyWith(color: kBlackColor),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              String url = Platform.isIOS ? "whatsapp://wa.me/081315739245/" : "whatsapp://send?phone=081315739245";
              if (await canLaunch(url)) {
                launch(url);
              } else {
                final Uri phoneUri = Uri(
                  scheme: 'tel',
                  path: '081315739245',
                );

                launch(phoneUri.toString());
              }
            },
            child: Row(
              children: [
                Icon(
                  Icons.phone,
                  color: kButtonColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '+62 813 1573 9245',
                  style: kConfirmTextStyle.copyWith(color: kBlackColor),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
