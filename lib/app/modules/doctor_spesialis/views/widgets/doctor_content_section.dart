// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/doctors.dart';
import 'package:altea/app/data/model/search_doctor.dart' as search_doctor;
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:altea/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

Widget buildContentListDoctor(double screenHeight, double screenWidth, DatumDoctors dataDoctor, BuildContext context) {
  final spesialisController = Get.find<SpesialisKonsultasiController>();

  return ResponsiveBuilder(builder: (context, sizingInformation) {
    if (sizingInformation.isMobile) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(12), boxShadow: [
            BoxShadow(
              color: fullBlack.withAlpha(15),
              offset: const Offset(
                0.0,
                3.0,
              ),
              blurRadius: 12.0,
            ),
          ]),
          child: Column(
            children: [
              Row(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth * 0.15,
                        height: screenWidth * 0.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                                image: dataDoctor.photo != null
                                    ? NetworkImage(dataDoctor.photo!.formats!.thumbnail!)
                                    : const NetworkImage(
                                        "http://cdn.onlinewebfonts.com/svg/img_148071.png",
                                      ),
                                fit: BoxFit.cover)),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.6,
                            child: Text(
                              dataDoctor.name!,
                              style: kSubHeaderStyle.copyWith(color: kBlackColor, fontSize: screenWidth * 0.03),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: screenWidth * 0.002,
                          ),
                          Text(
                            "Sp. ${dataDoctor.specialization!.name!}",
                            style: kSubHeaderStyle.copyWith(color: kDarkBlue, fontSize: screenWidth * 0.02),
                          ),
                          SizedBox(
                            height: screenWidth * 0.005,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: Color(0xffEBF7F5),
                thickness: 1,
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: screenWidth * 0.05,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffEBF7F5),
                    ),
                    child: Text(
                      dataDoctor.experience!,
                      style: kSubHeaderStyle.copyWith(color: kButtonColor, fontSize: screenWidth * 0.02),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    height: 18,
                    child: Row(
                      children: [
                        Image.network(dataDoctor.hospital![0].icon == null
                            ? "http://cdn.onlinewebfonts.com/svg/img_148071.png"
                            : dataDoctor.hospital![0].icon!.formats!.thumbnail!),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(dataDoctor.hospital![0].name ?? "No data",
                            style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenWidth * 0.01,
              ),
              const Divider(
                color: Color(0xffEBF7F5),
                thickness: 1,
              ),
              SizedBox(height: screenWidth * 0.01),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Languages: ",
                    style: kSubHeaderStyle.copyWith(color: kBlackColor.withOpacity(0.4), fontSize: screenWidth * 0.02),
                  ),
                  Text(
                    dataDoctor.overview ?? "No Data",
                    style: kSubHeaderStyle.copyWith(color: kBlackColor, fontSize: screenWidth * 0.025),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
              SizedBox(
                  height: screenWidth * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dataDoctor.price!.formatted!,
                        style: kSubHeaderStyle.copyWith(color: kButtonColor, fontSize: screenWidth * 0.04),
                      ),
                      CustomFlatButton(
                          width: screenWidth * 0.3,
                          text: "Konsultasi",
                          onPressed: () async {
                            // doctor
                            final search_doctor.Formats formatsDoctor = search_doctor.Formats(
                              large: dataDoctor.photo == null ? null : dataDoctor.photo!.formats!.large,
                              medium: dataDoctor.photo == null ? null : dataDoctor.photo!.formats!.medium,
                              small: dataDoctor.photo == null ? null : dataDoctor.photo!.formats!.small,
                              thumbnail: dataDoctor.photo == null ? null : dataDoctor.photo!.formats!.thumbnail,
                            );

                            final search_doctor.IconPhotoDoctor photoDoctor = search_doctor.IconPhotoDoctor(
                              formats: formatsDoctor,
                              sizeFormatted: dataDoctor.photo == null ? null : dataDoctor.photo!.sizeFormatted,
                              url: dataDoctor.photo == null ? null : dataDoctor.photo!.url,
                            );

                            // // hospital
                            final search_doctor.Formats formatIconHospi = search_doctor.Formats(
                                large: dataDoctor.hospital![0].icon == null ? null : dataDoctor.hospital![0].icon!.formats!.large,
                                medium: dataDoctor.hospital![0].icon == null ? null : dataDoctor.hospital![0].icon!.formats!.medium,
                                small: dataDoctor.hospital![0].icon == null ? null : dataDoctor.hospital![0].icon!.formats!.small,
                                thumbnail: dataDoctor.hospital![0].icon == null ? null : dataDoctor.hospital![0].icon!.formats!.thumbnail);

                            final search_doctor.Formats formatIconImageHospi = search_doctor.Formats(
                                large: dataDoctor.hospital![0].image == null ? null : dataDoctor.hospital![0].image!.formats!.large,
                                medium: dataDoctor.hospital![0].image == null ? null : dataDoctor.hospital![0].image!.formats!.medium,
                                small: dataDoctor.hospital![0].image == null ? null : dataDoctor.hospital![0].image!.formats!.small,
                                thumbnail: dataDoctor.hospital![0].image == null ? null : dataDoctor.hospital![0].image!.formats!.thumbnail);

                            final search_doctor.IconPhotoDoctor iconHospital = search_doctor.IconPhotoDoctor(
                                formats: formatIconHospi,
                                sizeFormatted: dataDoctor.hospital![0].icon == null ? null : dataDoctor.hospital![0].icon!.sizeFormatted,
                                url: dataDoctor.hospital![0].icon == null ? null : dataDoctor.hospital![0].icon!.url);

                            final search_doctor.IconPhotoDoctor iconImageHospital = search_doctor.IconPhotoDoctor(
                                formats: formatIconImageHospi,
                                sizeFormatted: dataDoctor.hospital![0].image == null ? null : dataDoctor.hospital![0].image!.sizeFormatted,
                                url: dataDoctor.hospital![0].image == null ? null : dataDoctor.hospital![0].image!.url);

                            final List<search_doctor.HospitalSearchDoctor> hospitalDoctor = [
                              search_doctor.HospitalSearchDoctor(
                                  id: dataDoctor.hospital![0].id, name: dataDoctor.hospital![0].name, icon: iconHospital, image: iconImageHospital)
                            ];
                            final search_doctor.DoctorSpecialization specialization = search_doctor.DoctorSpecialization(
                              id: dataDoctor.specialization!.id,
                              name: dataDoctor.specialization!.name,
                            );

                            final search_doctor.PriceSearchDoctor priceDoctor =
                                search_doctor.PriceSearchDoctor(formatted: dataDoctor.price!.formatted, raw: dataDoctor.price!.raw!.toInt());

                            final search_doctor.Doctor doctor = search_doctor.Doctor(
                                about: dataDoctor.about,
                                aboutPreview: dataDoctor.aboutPreview,
                                doctorId: dataDoctor.doctorId,
                                experience: dataDoctor.experience,
                                hospital: hospitalDoctor,
                                isPopular: dataDoctor.isPopular,
                                name: dataDoctor.name,
                                overview: dataDoctor.overview,
                                photo: photoDoctor,
                                price: priceDoctor,
                                sip: dataDoctor.sip,
                                slug: dataDoctor.slug,
                                specialization: specialization);

                            spesialisController.doctorInfo.value = doctor;
                            // print(spesialisController.doctorInfo.value);

                            // spesialisController.checkDoctorNoSchedule(doctorId: dataDoctor.doctorId!);

                            Get.toNamed("${Routes.SPESIALIS_KONSULTASI}?doctorId=${dataDoctor.doctorId}");
                            // spesialisController.isLoading.value = false;
                          },
                          color: kButtonColor),
                    ],
                  )),
            ],
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(12), boxShadow: [
          BoxShadow(
            color: kLightGray,
            offset: const Offset(
              0.0,
              3.0,
            ),
            blurRadius: 12.0,
          ),
        ]),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.1,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(12),
                      //     image: DecorationImage(
                      //         image: )),
                      child: dataDoctor.photo != null
                          ? Image.network(addCDNforLoadImage(dataDoctor.photo!.formats!.thumbnail!), fit: BoxFit.cover)
                          : Image.asset("assets/account-info@3x.png", fit: BoxFit.cover),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            width: screenWidth * 0.2,
                            child: Text(
                              dataDoctor.name!,
                              style: kPoppinsSemibold600.copyWith(
                                color: kBlackColor.withOpacity(0.8),
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "Sp. ${dataDoctor.specialization!.name!}",
                            style: kSubHeaderStyle.copyWith(color: kDarkBlue, fontSize: 15),
                          ),
                          SizedBox(
                            height: screenWidth * 0.005,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: kButtonColor.withOpacity(0.1),
                                ),
                                child: Text(
                                  dataDoctor.experience!,
                                  style: kSubHeaderStyle.copyWith(color: kButtonColor, fontSize: 11),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                height: 18,
                                // width: 300,
                                child: Row(
                                  children: [
                                    Image.network(dataDoctor.hospital![0].icon == null
                                        ? "http://cdn.onlinewebfonts.com/svg/img_148071.png"
                                        : addCDNforLoadImage(dataDoctor.hospital![0].icon!.formats!.thumbnail!)),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(dataDoctor.hospital![0].name ?? "No data",
                                        style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor), overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenWidth * 0.005,
                          ),
                          SizedBox(
                            width: screenWidth * 0.3,
                            child: Row(
                              children: [
                                Text(
                                  "Languages: ",
                                  style: kSubHeaderStyle.copyWith(color: kBlackColor.withOpacity(0.4), fontSize: 12),
                                ),
                                Text(
                                  dataDoctor.overview ?? "No Data",
                                  style: kSubHeaderStyle.copyWith(color: kBlackColor, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            Container(
              color: kBlackColor.withOpacity(0.2),
              height: screenWidth * 0.1,
              width: 1,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 8,
                ),
                Column(
                  children: [
                    Text(
                      dataDoctor.price!.formatted!,
                      style: kSubHeaderStyle.copyWith(color: kButtonColor, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomFlatButton(
                        width: 150,
                        text: "Konsultasi",
                        onPressed: () async {
                          // doctor
                          final search_doctor.Formats formatsDoctor = search_doctor.Formats(
                            large: dataDoctor.photo == null ? null : dataDoctor.photo!.formats!.large,
                            medium: dataDoctor.photo == null ? null : dataDoctor.photo!.formats!.medium,
                            small: dataDoctor.photo == null ? null : dataDoctor.photo!.formats!.small,
                            thumbnail: dataDoctor.photo == null ? null : dataDoctor.photo!.formats!.thumbnail,
                          );

                          final search_doctor.IconPhotoDoctor photoDoctor = search_doctor.IconPhotoDoctor(
                            formats: formatsDoctor,
                            sizeFormatted: dataDoctor.photo == null ? null : dataDoctor.photo!.sizeFormatted,
                            url: dataDoctor.photo == null ? null : dataDoctor.photo!.url,
                          );

                          // // hospital
                          final search_doctor.Formats formatIconHospi = search_doctor.Formats(
                              large: dataDoctor.hospital![0].icon == null ? null : dataDoctor.hospital![0].icon!.formats!.large,
                              medium: dataDoctor.hospital![0].icon == null ? null : dataDoctor.hospital![0].icon!.formats!.medium,
                              small: dataDoctor.hospital![0].icon == null ? null : dataDoctor.hospital![0].icon!.formats!.small,
                              thumbnail: dataDoctor.hospital![0].icon == null ? null : dataDoctor.hospital![0].icon!.formats!.thumbnail);

                          final search_doctor.Formats formatIconImageHospi = search_doctor.Formats(
                              large: dataDoctor.hospital![0].image == null ? null : dataDoctor.hospital![0].image!.formats!.large,
                              medium: dataDoctor.hospital![0].image == null ? null : dataDoctor.hospital![0].image!.formats!.medium,
                              small: dataDoctor.hospital![0].image == null ? null : dataDoctor.hospital![0].image!.formats!.small,
                              thumbnail: dataDoctor.hospital![0].image == null ? null : dataDoctor.hospital![0].image!.formats!.thumbnail);

                          final search_doctor.IconPhotoDoctor iconHospital = search_doctor.IconPhotoDoctor(
                              formats: formatIconHospi,
                              sizeFormatted: dataDoctor.hospital![0].icon == null ? null : dataDoctor.hospital![0].icon!.sizeFormatted,
                              url: dataDoctor.hospital![0].icon == null ? null : dataDoctor.hospital![0].icon!.url);

                          final search_doctor.IconPhotoDoctor iconImageHospital = search_doctor.IconPhotoDoctor(
                              formats: formatIconImageHospi,
                              sizeFormatted: dataDoctor.hospital![0].image == null ? null : dataDoctor.hospital![0].image!.sizeFormatted,
                              url: dataDoctor.hospital![0].image == null ? null : dataDoctor.hospital![0].image!.url);

                          final List<search_doctor.HospitalSearchDoctor> hospitalDoctor = [
                            search_doctor.HospitalSearchDoctor(
                                id: dataDoctor.hospital![0].id, name: dataDoctor.hospital![0].name, icon: iconHospital, image: iconImageHospital)
                          ];
                          final search_doctor.DoctorSpecialization specialization = search_doctor.DoctorSpecialization(
                            id: dataDoctor.specialization!.id,
                            name: dataDoctor.specialization!.name,
                          );

                          final search_doctor.PriceSearchDoctor priceDoctor =
                              search_doctor.PriceSearchDoctor(formatted: dataDoctor.price!.formatted, raw: dataDoctor.price!.raw!.toInt());

                          final search_doctor.Doctor doctor = search_doctor.Doctor(
                              about: dataDoctor.about,
                              aboutPreview: dataDoctor.aboutPreview,
                              doctorId: dataDoctor.doctorId,
                              experience: dataDoctor.experience,
                              hospital: hospitalDoctor,
                              isPopular: dataDoctor.isPopular,
                              name: dataDoctor.name,
                              overview: dataDoctor.overview,
                              photo: photoDoctor,
                              price: priceDoctor,
                              sip: dataDoctor.sip,
                              slug: dataDoctor.slug,
                              specialization: specialization);

                          spesialisController.doctorInfo.value = doctor;
                          // !! SUDAH HANDLE NULL YAA 8/19/21
                          // print(spesialisController.doctorInfo.value);

                          // await spesialisController.checkDoctorNoSchedule(doctorId: dataDoctor.doctorId!);
                          Get.toNamed("${Routes.SPESIALIS_KONSULTASI}?doctorId=${dataDoctor.doctorId}");
                        },
                        color: kButtonColor),
                  ],
                )
              ],
            )),
          ],
        ),
      );
    }
  });
}
