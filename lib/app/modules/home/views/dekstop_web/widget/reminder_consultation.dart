// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';

class ReminderConsultationDialog extends StatefulWidget {
  const ReminderConsultationDialog({Key? key}) : super(key: key);

  @override
  _ReminderConsultationDialogState createState() => _ReminderConsultationDialogState();
}

class _ReminderConsultationDialogState extends State<ReminderConsultationDialog> {
  CountdownController countdownCtrl = CountdownController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ! remove later
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      countdownCtrl.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final homeController = Get.find<HomeController>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          // height: screenWidth * 0.38,
          width: screenWidth * 0.3,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: kButtonColor.withOpacity(0.1)),
                padding: const EdgeInsets.symmetric(vertical: 25),
                width: screenWidth,
                child: Center(
                  child: Text(
                    "Reminder Jadwal Konsultasi",
                    style: kPoppinsRegular400.copyWith(
                      color: fullBlack,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 23),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 105,
                            width: 105,
                            child: Image.asset("assets/account-info@3x.png"),
                          ),
                        ),
                        const SizedBox(
                          width: 13,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr. Vinda Octavio",
                              style: kPoppinsSemibold600.copyWith(fontSize: 16, color: kBlackColor),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Sp. Anak - Endokrinologi ",
                              style: kPoppinsSemibold600.copyWith(fontSize: 16, color: kDarkBlue),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Image.asset(
                                    "assets/calendar_icon.png",
                                    color: kTextHintColor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  // DateFormat("EEEE, dd/MM/yyyy", "id").format(
                                  //     DateTime.parse(controller.data["schedule"]
                                  //             ["date"]
                                  //         .toString())),
                                  "Monday, 22/03/2021",
                                  style: kPoppinsRegular400.copyWith(fontSize: 12, color: kTextHintColor),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Image.asset("assets/time_icon.png", color: kTextHintColor),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  // "${dataDetail.schedule!.timeStart} - ${dataDetail.schedule!.timeEnd}",
                                  // "${controller.data["schedule"]["time_start"]} - ${controller.data["schedule"]["time_end"]}",
                                  "08.15 - 08.30",
                                  style: kPoppinsRegular400.copyWith(fontSize: 12, color: kTextHintColor),
                                ),
                                const SizedBox(
                                  width: 48,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Divider(
                color: kLightGray,
              ),
              const SizedBox(
                height: 54,
              ),
              Text(
                "Konsultasi akan dimulai dalam",
                style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kBlackColor),
              ),
              const SizedBox(
                height: 14,
              ),
              Countdown(
                seconds: 60,
                controller: countdownCtrl,
                interval: Duration(seconds: 1),
                build: (context, time) {
                  // print(time);
                  // countdownCtrl.start();
                  String minutes = '0';
                  String seconds = '0';

                  // ! temp, need to show the hour also
                  if (time >= 120) {
                    minutes = '02';
                    seconds = (time - 120).toStringAsFixed(0).length == 2 ? (time - 120).toStringAsFixed(0) : '0${(time - 120).toStringAsFixed(0)}';
                  } else if (time >= 60) {
                    minutes = '01';
                    seconds = (time - 60).toStringAsFixed(0).length == 2 ? (time - 60).toStringAsFixed(0) : '0${(time - 60).toStringAsFixed(0)}';
                  } else {
                    minutes = '00';
                    seconds = time.toStringAsFixed(0).length == 2 ? time.toStringAsFixed(0) : '0${time.toStringAsFixed(0)}';
                  }
                  // print('$minutes : $seconds');

                  return Text(
                    '$minutes : $seconds',
                    style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 28),
                  );
                },
                onFinished: () {},
              ),
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Text(
                  "*Konsultasi akan tetap dianggap berjalan walaupun patient tidak terhubung dalam ruang konsultasi atau melewati batas waktu tunggu dokter.",
                  style: kPoppinsRegular400.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 58,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: CustomFlatButton(
                    width: screenWidth,
                    text: "Saya Mengerti",
                    onPressed: () {
                      Get.back();
                    },
                    color: kButtonColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
