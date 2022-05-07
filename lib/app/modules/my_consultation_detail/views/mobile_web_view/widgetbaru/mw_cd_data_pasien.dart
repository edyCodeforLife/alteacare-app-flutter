// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/my_consultation_detail/models/my_consultation_detail_model.dart';

class MWCDDataPasien extends StatelessWidget {
  final Patient patient;
  final screenWidth = Get.width;
  late final String alamat;
  MWCDDataPasien({
    required this.patient,
  }) {
    if (patient != null) {
      if (patient.addressRaw.isNotEmpty) {
        alamat =
            "${patient.addressRaw[0].street}, Blok RT/RW${patient.addressRaw[0].rtRw}, Kel. ${patient.addressRaw[0].subDistrict.name}, Kec.${patient.addressRaw[0].district.name} ${patient.addressRaw[0].city.name} ${patient.addressRaw[0].province.name} ${patient.addressRaw[0].subDistrict.postalCode}";
      } else {
        alamat = "Alamat belum lengkap. Silakan lengkapi alamat Anda";
      }
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
              if (patient.avatar == null || patient.avatar.toString() == "null")
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
                        patient.avatar.toString(),
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
                    patient.name,
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
                    "${patient.age.year} Tahun",
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
                        patient.gender == "MALE" ? "Laki-laki" : "Perempuan",
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
                          DateTime.parse(patient.birthdate.toString()),
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

          // Container(
          //   margin: const EdgeInsets.symmetric(vertical: 20),
          //   padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          //   decoration: BoxDecoration(
          //     color: bannerUploadFileColor,
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text.rich(TextSpan(children: [
          //             TextSpan(text: "Upload file (opsional) ", style: kPoppinsMedium500.copyWith(color: blackGreyish, fontSize: 13)),
          //             TextSpan(text: "Max 10MB", style: kPoppinsRegular400.copyWith(color: kRedError, fontSize: 13)),
          //           ])),
          //           Text("pemeriksaan penunjang", style: kPoppinsRegular400.copyWith(color: grayDarker, fontSize: 10))
          //         ],
          //       ),
          //       TextButton.icon(
          //           onPressed: () {},
          //           icon: SizedBox(
          //             width: 18,
          //             height: 20,
          //             child: Image.asset("assets/file.png"),
          //           ),
          //           label: Text(
          //             "Unggah File",
          //             style: kPoppinsMedium500.copyWith(color: kButtonColor, fontSize: 12),
          //           ))
          //     ],
          //   ),
          // ),
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
