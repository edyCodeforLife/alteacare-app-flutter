// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';

class MobileWebMedicalDataContainer extends StatelessWidget {
  MobileWebMedicalDataContainer({
    required this.bannerTitle,
    this.medicalDocuments,
    this.newDocument,
  });
  final String bannerTitle;
  final Map<String, dynamic>? newDocument;
  final List<Map<String, dynamic>>? medicalDocuments;
  final double screenWidth = Get.width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 14,
          ),
          width: screenWidth,
          color: bannerUploadFileColor,
          child: Text(
            bannerTitle,
            style: kPoppinsMedium500.copyWith(
              fontSize: 10,
              color: bannerUploadTextColor,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (newDocument != null)
          InkWell(
            onTap: () async {
              if (await canLaunch(newDocument!['url'].toString())) {
                launch(newDocument!['url'].toString());
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Row(
                children: [
                  Container(
                    width: 49,
                    height: 49,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kDarkBlue.withOpacity(0.1),
                    ),
                    child: SizedBox(
                      width: 15,
                      child: Image.asset(
                        "assets/no_file_upload_icon.png",
                        color: kDarkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        newDocument!["original_name"].toString(),
                        style: kPoppinsMedium500.copyWith(
                          color: fullBlack.withOpacity(0.8),
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        newDocument!["size"].toString(),
                        style: kPoppinsMedium500.copyWith(
                          color: fullBlack.withOpacity(0.5),
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        newDocument!["date"].toString(),
                        style: kPoppinsRegular400.copyWith(
                          color: fullBlack.withOpacity(0.3),
                          fontSize: 8,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        else
          Column(
            children: List.generate(
                medicalDocuments!.length,
                (index) => InkWell(
                      onTap: () async {
                        if (await canLaunch(medicalDocuments![index]['url'].toString())) {
                          launch(medicalDocuments![index]['url'].toString());
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 25,
                          bottom: (index == medicalDocuments!.length - 1) ? 0 : 14,
                        ),
                        margin: const EdgeInsets.only(bottom: 21),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: (index == medicalDocuments!.length - 1)
                                ? BorderSide.none
                                : BorderSide(
                                    color: grayLight.withOpacity(0.3),
                                  ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 49,
                              height: 49,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kDarkBlue.withOpacity(0.1),
                              ),
                              child: SizedBox(
                                width: 15,
                                child: Image.asset(
                                  "assets/no_file_upload_icon.png",
                                  color: kDarkBlue,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  medicalDocuments![index]["original_name"].toString(),
                                  style: kPoppinsMedium500.copyWith(
                                    color: fullBlack.withOpacity(0.8),
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  medicalDocuments![index]["size"].toString(),
                                  style: kPoppinsMedium500.copyWith(
                                    color: fullBlack.withOpacity(0.5),
                                    fontSize: 9,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  medicalDocuments![index]["date"].toString(),
                                  style: kPoppinsRegular400.copyWith(
                                    color: fullBlack.withOpacity(0.3),
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
          ),
        const SizedBox(
          height: 18,
        )
      ],
    );
  }
}
