// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/hexColor_toColor.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/my_consultation.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/my_consultation_detail/controllers/my_consultation_detail_controller.dart';
import '../../../../../routes/app_pages.dart';

class DoctorCardMyConsultation extends StatelessWidget {
  final MyConsultationDetailController myConsultationDetailController = Get.find<MyConsultationDetailController>();
  final homeController = Get.find<HomeController>();
  final double screenWidth;
  final DatumMyConsultation data;
  DoctorCardMyConsultation({required this.screenWidth, required this.data});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          height: 200,
          width: screenWidth,
          decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(22), boxShadow: [
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Order ID: ",
                            style: kPoppinsRegular400.copyWith(color: kTextHintColor, fontSize: 13, letterSpacing: 0.5),
                          ),
                          TextSpan(
                            text: data.orderCode,
                            style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: HexColor(data.statusDetail!.bgColor!),
                      ),
                      child: Center(
                        child: Text(
                          data.statusDetail!.label!,
                          style: kPoppinsSemibold600.copyWith(color: HexColor(data.statusDetail!.textColor!), fontSize: 12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: searchBarBorderColor.withOpacity(0.7),
              ),
              // Divider(
              //   height: 1,
              //   color: searchBarBorderColor.withOpacity(0.7),
              // ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 115,
                        width: 115,
                        child: data.doctor!.photo!.formats!.thumbnail != null
                            ? Image.network(addCDNforLoadImage(data.doctor!.photo!.formats!.thumbnail!), fit: BoxFit.cover)
                            : Image.asset("assets/account-info@3x.png", fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          data.doctor!.name ?? "No data",
                          style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        Text(
                          data.doctor!.specialist!.name ?? "No data",
                          style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: Image.asset("calendar_icon.png", color: kTextHintColor),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              DateFormat("EEEE, dd/MM/yyyy", "id").format(DateTime.parse(data.schedule!.date!.toString())),
                              style: kPoppinsRegular400.copyWith(color: kBlackColor, fontSize: 12),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: Image.asset(
                                "time_icon.png",
                                color: kTextHintColor,
                              ),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              "${data.schedule!.timeStart} - ${data.schedule!.timeEnd}",
                              style: kPoppinsRegular400.copyWith(color: kBlackColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: Container(
                            height: 37,
                            width: 37,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: kTextHintColor),
                            child: InkWell(
                              onTap: () {
                                myConsultationDetailController.orderId.value = data.id.toString();

                                if (homeController.menus.isNotEmpty) {
                                  homeController.menus.value = <String>[];
                                  homeController.menus.add("Konsultasi Saya");
                                } else {
                                  homeController.menus.add("Konsultasi Saya");
                                }

                                homeController.menus.add("Order ID: ${data.orderCode}");

                                Get.toNamed(Routes.MY_CONSULTATION_DETAIL);
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: kBackground,
                                  size: 14,
                                ),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
