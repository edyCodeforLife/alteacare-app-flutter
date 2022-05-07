// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/helper.dart' as helper;
import 'package:altea/app/core/utils/hexColor_toColor.dart';
import 'package:altea/app/core/utils/settings.dart' as setting;
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/my_consultation_detail/controllers/my_consultation_detail_controller.dart';
import 'package:altea/app/modules/my_consultation_detail/views/my_consultation_detail_reminder_dialog_demo.dart';

class MWConsultationDetailHeader extends StatelessWidget {
  final MyConsultationDetailController _controller = Get.find<MyConsultationDetailController>();
  final screenWidth = Get.width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //header yg ada order id & status
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    Text(
                      "Order ID : ",
                      style: kPoppinsMedium500.copyWith(fontSize: 12, color: kTextHintColor),
                    ),
                    Text(
                      "${_controller.data["order_code"]}",
                      style: kPoppinsSemibold600.copyWith(fontSize: 12),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: HexColor("${_controller.data["status_detail"]["bg_color"]}"),
                ),
                child: Center(
                  child: Text(
                    _controller.data["status_detail"]["label"].toString(),
                    // _controller.dataMyConsultationDetail.value
                    //     .statusDetail!.label!,
                    style: kPoppinsSemibold600.copyWith(color: HexColor("${_controller.data["status_detail"]["text_color"]}"), fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          height: 1,
          width: screenWidth,
          color: Colors.grey[200],
        ),
        //dokterrrrrrrrrrrr
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenWidth * 0.2,
                width: screenWidth * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(
                        addCDNforLoadImage(
                          _controller.data["doctor"]["photo"]["formats"]["thumbnail"].toString(),
                        ),
                      ),
                      fit: BoxFit.cover,
                    )),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: screenWidth * 0.69,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _controller.data["doctor"]["name"].toString(),
                      style: kPoppinsSemibold600.copyWith(
                        color: kBlackColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      // "Sp. ${dataDetail.doctor!.specialist!.name!}",
                      "Sp. ${_controller.data["doctor"]["specialist"]["name"]}",
                      style: kPoppinsSemibold600.copyWith(
                        color: kDarkBlue,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: screenWidth * 0.7,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 13,
                            width: 13,
                            child: Image.asset(
                              "assets/calendar_icon.png",
                              color: kTextHintColor,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            // DateFormat("EEEE, dd/MM/yyyy", "id")
                            //     .format(dataDetail.schedule!.date!),
                            DateFormat("EEEE, dd/MM/yyyy", "id").format(DateTime.parse(_controller.data["schedule"]["date"].toString())),
                            style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 13,
                            width: 13,
                            child: Image.asset("assets/time_icon.png", color: kTextHintColor),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            // "${dataDetail.schedule!.timeStart} - ${dataDetail.schedule!.timeEnd}",
                            "${_controller.data["schedule"]["time_start"]} - ${_controller.data["schedule"]["time_end"]}",
                            style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        // Text("${_controller.data['schedule']['date']} ${_controller.data['schedule']['time_start']}"),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          height: 1,
          width: screenWidth,
          color: Colors.grey[200],
        ), // ! check consultation status
        if ([setting.canceledBySystem, setting.canceled].contains(_controller.data["status"]))
          Container()
        else
          InkWell(
            onTap: () {
              Get.dialog(
                MyConsultationDetailReminderDialogDemo(
                  data: {
                    "foto_dokter": _controller.data["doctor"]["photo"]["formats"]["thumbnail"].toString(),
                    "name": _controller.data["doctor"]["name"],
                    "spesialis": _controller.data["doctor"]["specialist"]["name"],
                    "date": _controller.data["schedule"]["date"].toString(),
                    "time_start": _controller.data["schedule"]["time_start"],
                    "time_end": _controller.data["schedule"]["time_end"],
                    "sisa_waktu": helper.printDuration(helper.getTimeStringDifferenceFromNowInDuration(
                        "${_controller.data['schedule']['date']} ${_controller.data['schedule']['time_start']}")),
                  },
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: kLightBlue,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: kDarkBlue),
                  Text(
                    "  Add to Calendar",
                    style: kPoppinsMedium500.copyWith(
                      color: kDarkBlue,
                    ),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
