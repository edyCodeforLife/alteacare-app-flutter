// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';

class MWCDDataPasien extends StatelessWidget {
  final Map<String, dynamic> data;
  final screenWidth = Get.width;
  late final String alamat;
  MWCDDataPasien({
    required this.data,
  }) {
    if (data["patient"]["address_raw"] != null && (data["patient"]["address_raw"] as List).isNotEmpty) {
      alamat =
          "${data["patient"]["address_raw"][0]["street"]}, Blok RT/RW${data["patient"]["address_raw"][0]["rt_rw"]}, Kel. ${data["patient"]["address_raw"][0]["sub_district"]["name"]}, Kec.${data["patient"]["address_raw"][0]["district"]["name"]} ${data["patient"]["address_raw"][0]["city"]["name"]} ${data["patient"]["address_raw"][0]["province"]["name"]} ${data["patient"]["address_raw"][0]["sub_district"]["postal_code"]}";
    } else {
      alamat = "Alamat belum lengkap. Silakan lengkapi alamat Anda";
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (data["patient"]["avatar"] == null)
                const SizedBox(
                  height: 62,
                  width: 62,
                )
              else
                SizedBox(
                  height: 62,
                  width: 62,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.network(
                      addCDNforLoadImage(
                        data["patient"]["avatar"].toString(),
                      ),
                    ),
                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // dataDetail.patient!.name!,
                    data["patient"]["name"].toString(),
                    style: kPoppinsSemibold600.copyWith(
                      color: kBlackColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    // "{${dataDetail.patient!.age!.year} Tahun}",
                    "${data["patient"]["age"]["year"]} Tahun",
                    style: kPoppinsSemibold600.copyWith(
                      color: kDarkBlue,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Container(
            height: 1,
            width: screenWidth,
            color: kLightGray,
          ),
          const SizedBox(
            height: 13,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Jenis Kelamin",
                  style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                ),
              ),
              Expanded(
                flex: 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ":",
                      style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        data["patient"]["gender"].toString() == "MALE" ? "Laki-laki" : "Perempuan",
                        style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Tanggal Lahir",
                  style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                ),
              ),
              Expanded(
                flex: 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ":",
                      style: kPoppinsRegular400.copyWith(fontSize: 10, color: kLightGray),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        DateFormat("dd/MM/yyyy").format(
                          DateTime.parse(data["patient"]["birthdate"].toString()),
                        ),
                        style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Alamat",
                  style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                ),
              ),
              Expanded(
                flex: 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ":",
                      style: kPoppinsRegular400.copyWith(fontSize: 10, color: kLightGray),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        alamat,
                        style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
            decoration: BoxDecoration(
              color: bannerUploadFileColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(text: "Upload file (opsional) ", style: kPoppinsMedium500.copyWith(color: blackGreyish, fontSize: 13)),
                      TextSpan(text: "Max 10MB", style: kPoppinsRegular400.copyWith(color: kRedError, fontSize: 13)),
                    ])),
                    Text("pemeriksaan penunjang", style: kPoppinsRegular400.copyWith(color: grayDarker, fontSize: 10))
                  ],
                ),
                TextButton.icon(
                    onPressed: () {},
                    icon: SizedBox(
                      width: 18,
                      height: 20,
                      child: Image.asset("assets/file.png"),
                    ),
                    label: Text(
                      "Unggah File",
                      style: kPoppinsMedium500.copyWith(color: kButtonColor, fontSize: 12),
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),

          // FILE List Section
          Container(
            width: screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 38,
                ),
                SizedBox(
                  width: 38,
                  height: 51,
                  child: Image.asset("assets/no_file_upload_icon.png"),
                ),
                const SizedBox(
                  height: 27,
                ),
                Text(
                  "Belum ada file yang diunggah",
                  style: kPoppinsMedium500.copyWith(fontSize: 14, color: grayLight),
                ),
                const SizedBox(
                  height: 131,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
