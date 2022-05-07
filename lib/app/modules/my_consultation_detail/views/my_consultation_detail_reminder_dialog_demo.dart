import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:altea/app/core/utils/helper.dart' as helper;

class MyConsultationDetailReminderDialogDemo extends StatelessWidget {
  final Map<String, dynamic> data;
  const MyConsultationDetailReminderDialogDemo({required this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              color: Colors.black12,
              child: Text(
                "Reminder Jadwal Konsultasi",
                style: kPoppinsMedium500.copyWith(fontSize: 12),
              ),
            ),
            //info dokter
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(
                            addCDNforLoadImage(
                              data['foto_dokter'].toString(),
                            ),
                          ),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.69,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["name"].toString(),
                            style: kPoppinsSemibold600.copyWith(
                              color: kBlackColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            // "Sp. ${dataDetail.doctor!.specialist!.name!}",
                            "Sp. ${data["spesialis"]}",
                            style: kPoppinsSemibold600.copyWith(
                              color: kDarkBlue,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
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
                                  DateFormat("EEEE, dd/MM/yyyy", "id").format(DateTime.parse(data["date"].toString())),
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
                                  "${data["time_start"]} - ${data["time_end"]}",
                                  style: kPoppinsRegular400.copyWith(fontSize: 10, color: kTextHintColor),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //info dokter end
            //konsultasi dimulai dalam 3..2..
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 15,
              ),
              child: Column(
                children: [
                  Text(
                    "Konsultasi akan dimulai dalam",
                    style: kPoppinsMedium500.copyWith(fontSize: 13),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    data["sisa_waktu"].toString(),
                    style: kPoppinsSemibold600.copyWith(fontSize: 14, color: kDarkBlue),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "*Konsultasi akan tetap dianggap berjalan walaupun patient tidak terhubung dalam ruang konsultasi atau melewati batas waktu tunggu dokter.",
                    style: kPoppinsRegular400.copyWith(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            CustomFlatButton(
                width: MediaQuery.of(context).size.width,
                text: "Saya Mengerti",
                onPressed: () {
                  Navigator.pop(context);
                },
                color: kButtonColor),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
