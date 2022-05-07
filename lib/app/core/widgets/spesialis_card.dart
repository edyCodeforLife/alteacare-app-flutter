import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SpesialisCard extends StatelessWidget {
  final bool isShadow;
  final double width;
  final double height;
  final String text;
  final String img;
  final double imgWidth;
  final void Function() onTap;
  final String id;
  final Color backgroundClr;

  SpesialisCard(
      {required this.imgWidth,
      required this.id,
      this.backgroundClr = kBackground,
      required this.onTap,
      this.isShadow = false,
      required this.width,
      required this.height,
      required this.text,
      required this.img});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        // MediaQuery.of(context).size.width / 4,
        height: height,
        // MediaQuery.of(context).size.width / 5,
        decoration: BoxDecoration(
          boxShadow: isShadow ? [kBoxShadow] : [],
          borderRadius: BorderRadius.circular(16),
          color: backgroundClr,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        // padding: const EdgeInsets.all(4),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExtendedImage.network(
                img,
                width: imgWidth,
                cache: true,
                loadStateChanged: (state) {
                  if (state.extendedImageLoadState == LoadState.failed) {
                    return Icon(
                      Icons.image_not_supported_rounded,
                      color: kLightGray,
                    );
                  }
                },
              ),
              // Image.network(
              //   img,
              //   // e['assetImage'].toString(),
              //   width: imgWidth,
              //   // MediaQuery.of(context).size.width / 10,
              // ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: width * 0.8,
                child: AutoSizeText(
                  text,
                  softWrap: true,
                  // e['title'].toString(),
                  style: kSpesialisMenuStyle,
                  textAlign: TextAlign.center,
                  minFontSize: 5,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
