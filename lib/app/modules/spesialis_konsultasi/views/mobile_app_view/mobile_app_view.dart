// Flutter imports:
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/doctor_schedules.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';

class MobileAppViewSpesialisKonsultasiPage extends StatefulWidget {
  @override
  _MobileAppViewSpesialisKonsultasiPageState createState() => _MobileAppViewSpesialisKonsultasiPageState();
}

class _MobileAppViewSpesialisKonsultasiPageState extends State<MobileAppViewSpesialisKonsultasiPage> with SingleTickerProviderStateMixin {
  bool profileExpanded = false;
  SpesialisKonsultasiController controller = Get.find<SpesialisKonsultasiController>();

  List<DateTime> dates = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 1)),
    DateTime.now().add(const Duration(days: 2)),
    DateTime.now().add(const Duration(days: 3)),
    DateTime.now().add(const Duration(days: 4)),
    DateTime.now().add(const Duration(days: 5)),
    DateTime.now().add(const Duration(days: 6)),
  ];

  String selDate = '';

  late TabController tabController;
  String selectedMethod = 'VIDEO_CALL';

  String getDay(int day) {
    switch (day) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      default:
        return 'Minggu';
    }
  }

  String selectedTime = '';
  int selectedTab = 0;
  List<List<DataDoctorSchedule>> schedules = [];
  bool dateChoosen = false;
  late Map<String, dynamic> arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments != null) {
      arguments = Get.arguments as Map<String, dynamic>;
    } else {
      arguments = controller.selectedDoctorData.value;
    }
    tabController = TabController(length: 6, vsync: this);
    List filteredDate = dates.where((element) => element.weekday != 7).toList();

    selDate = filteredDate[0].toString().split(' ')[0];
    // getDoctorSchedule(arguments);
  }

  bool scheduleExpanded = false;

  Future getDoctorSchedule(arguments) async {
    // print('argsss =>$arguments');
    List<List<DataDoctorSchedule>> temp = [];
    setState(() {
      tabController.index = 0;
      schedules = [];
    });

    await Future.forEach<DateTime>(dates.where((element) => element.weekday != 7).toList(), (element) async {
      // print('for eachhh');
      String day = '';
      String month = '';

      if (element.day.toString().length == 1) {
        day = '0${element.day}';
      } else {
        day = element.day.toString();
      }

      if (element.month.toString().length == 1) {
        month = '0${element.month}';
      } else {
        month = element.month.toString();
      }

      String date = '${element.year}-$month-$day';
      // print('ini date =>$date');

      DoctorSchedules schedule = await controller.getDoctorSchedule(doctorId: arguments['doctor_id'].toString(), date: date);

      temp.add(schedule.data!);
    });

    setState(() {
      schedules = temp;
    });

    // print('schedule final => $schedules');
    selectedTime = schedules[0][0].code!;
    controller.selectedDoctorTime.value = schedules[0][0];
  }

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      // print('arguments => ${ModalRoute.of(context)!.settings.arguments}');
      arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      // print('aaaaaaaaaaaaaaaaa${dates[0].year}-${dates[0].month}-${dates[0].day}');
      controller.selectedDoctorData.value = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    } else {
      arguments = controller.selectedDoctorData;
    }
    return Scaffold(
      backgroundColor: kWhiteGray,
      body: SlidingUpPanel(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        maxHeight: MediaQuery.of(context).size.height * 0.75,
        minHeight: MediaQuery.of(context).size.height * 0.75,
        panel: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          // padding: EdgeInsets.all(4),
                          child: Text(
                            arguments['name'].toString(),
                            style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 18),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text(
                            (arguments['specialization'] == null)
                                ? (arguments['specialist'] != null)
                                    ? 'Sp. ${arguments['specialist']['name']}'
                                    : "?"
                                : 'Sp. ${arguments['specialization']['name']}',
                            style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 14),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(color: Color(0xFFEBF7F5), borderRadius: BorderRadius.circular(16)),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                child: Text(
                                  arguments['experience'].toString(),
                                  style: kPswValidText.copyWith(fontWeight: FontWeight.w600, color: kButtonColor),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    ExtendedImage.network(
                                        arguments['hospital'][0]['icon'] == null
                                            ? ''
                                            : arguments['hospital'][0]['icon']['formats']['thumbnail'].toString(),
                                        width: MediaQuery.of(context).size.width * 0.07, loadStateChanged: (ExtendedImageState state) {
                                      if (state.extendedImageLoadState == LoadState.failed) {
                                        return Icon(
                                          Icons.image_not_supported_rounded,
                                          color: kLightGray,
                                        );
                                      }
                                    }),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      'RS. ${arguments['hospital'][0]['name']}',
                                      style: kPswValidText.copyWith(fontWeight: FontWeight.w600, color: kDontHaveAccColor),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Profil Dokter : ',
                          style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kBlackColor),
                        ),
                        SizedBox(height: 7),
                        Container(
                            child: HtmlWidget(
                          (arguments['about'] ?? '-').toString(),
                          textStyle: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                        )),
                        SizedBox(
                          height: 28,
                        ),
                        Text(
                          'Consult By',
                          style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kBlackColor),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => setState(() => selectedMethod = 'VIDEO_CALL'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                width: MediaQuery.of(context).size.width / 3.5,
                                decoration: BoxDecoration(
                                  border: Border.all(color: selectedMethod == 'VIDEO_CALL' ? kButtonColor : kLightGray),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.videocam_sharp,
                                      color: selectedMethod == 'VIDEO_CALL' ? kButtonColor : kLightGray,
                                      size: MediaQuery.of(context).size.width / 17,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'Video Call',
                                      style: kPoppinsSemibold600.copyWith(
                                          fontSize: 10, color: selectedMethod == 'VIDEO_CALL' ? kButtonColor : kLightGray),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   width: 8,
                            // ),
                            // InkWell(
                            //   onTap: () =>
                            //       setState(() => selectedMethod = 'PHONE_CALL'),
                            //   child: Container(
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 8, vertical: 4),
                            //     width: MediaQuery.of(context).size.width / 3.5,
                            //     decoration: BoxDecoration(
                            //       border: Border.all(
                            //           color: selectedMethod == 'PHONE_CALL'
                            //               ? kButtonColor
                            //               : kLightGray),
                            //       borderRadius: BorderRadius.circular(32),
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Icon(
                            //           Icons.phone,
                            //           color: selectedMethod == 'PHONE_CALL'
                            //               ? kButtonColor
                            //               : kLightGray,
                            //           size:
                            //               MediaQuery.of(context).size.width / 17,
                            //         ),
                            //         SizedBox(
                            //           width: 8,
                            //         ),
                            //         Text(
                            //           'Phone Call',
                            //           style: kPoppinsSemibold600.copyWith(
                            //               fontSize: 10,
                            //               color: selectedMethod == 'PHONE_CALL'
                            //                   ? kButtonColor
                            //                   : kLightGray),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pilih Jadwal yang tersedia',
                              style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kBlackColor),
                            ),
                            Text(
                              'Menampilkan jadwal 7 hari kedepan',
                              style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.5)),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // if (schedules.length == 6)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TabBar(
                                isScrollable: true,
                                onTap: (idx) {
                                  controller.needUpdated.value = true;
                                  // int index = tabController.previousIndex;

                                  List filteredDate = dates.where((element) => element.weekday != 7).toList();

                                  // print('tanggalnya => ${filteredDate[idx].toString().split(' ')[0]}');
                                  setState(() {
                                    selDate = filteredDate[idx].toString().split(' ')[0];
                                  });

                                  // setState(() {
                                  //   if (schedules[idx].isNotEmpty) {
                                  //     tabController.index = idx;
                                  //   } else {
                                  //     if (idx != 0) {
                                  //       tabController.index = index;
                                  //     } else {
                                  //       tabController.index = idx;
                                  //     }
                                  //   }
                                  // });

                                  // print('index => ${tabController.index}');
                                },
                                controller: tabController,
                                tabs: dates
                                    .where((element) => element.weekday != 7)
                                    .toList()
                                    .map((e) => Container(
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                          child: Text(
                                            e.day == DateTime.now().day && e.month == DateTime.now().month && e.year == DateTime.now().year
                                                ? 'Hari ini'
                                                : getDay(e.weekday),
                                            maxLines: 1,
                                            style: kPoppinsMedium500.copyWith(
                                                color: tabController.index == dates.where((element) => element.weekday != 7).toList().indexOf(e)
                                                    ? kDarkBlue
                                                    : kBlackColor.withOpacity(0.5),
                                                fontWeight: tabController.index == dates.where((element) => element.weekday != 7).toList().indexOf(e)
                                                    ? FontWeight.w600
                                                    : FontWeight.w500,
                                                fontSize: 11),
                                          ),
                                        ))
                                    .toList()),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder(
                              future: controller.getDoctorSchedule(doctorId: arguments['doctor_id'].toString(), date: selDate),
                              builder: (context, snapshot) {
                                if (!controller.scheduleLoad.value && snapshot.hasData) {
                                  // print('snapshot data schedule => ${(snapshot.data as DoctorSchedules).data}');
                                  DoctorSchedules docSchedule = snapshot.data as DoctorSchedules;
                                  if (docSchedule.data == null) {
                                    return Center(
                                        child: InkWell(
                                      onTap: () async {
                                        setState(() {});
                                      },
                                      child: Text("Silakan klik di sini untuk mengulang"),
                                    ));
                                  } else if (docSchedule.data!.isEmpty) {
                                    return Container(
                                      padding: EdgeInsets.all(32),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/no_doctor_icon.png',
                                            width: MediaQuery.of(context).size.width / 5,
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'Belum Ada Jadwal Konsultasi',
                                            style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          children: docSchedule.data!
                                              .sublist(
                                                  0,
                                                  scheduleExpanded
                                                      ? docSchedule.data!.length
                                                      : docSchedule.data!.length > 12
                                                          ? 12
                                                          : (docSchedule.data!.length / 3).ceil())
                                              .map((e) {
                                            // print('schedulessssss =>${e.date}');
                                            return InkWell(
                                              onTap: () {
                                                // print('sel time => $selectedTime current => ${e.code}');
                                                if (selectedTime == e.code) {
                                                  setState(() {
                                                    selectedTime = '';
                                                  });
                                                } else {
                                                  setState(() {
                                                    selectedTime = e.code!;
                                                  });
                                                  controller.selectedDoctorTime.value = e;
                                                }
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                width: MediaQuery.of(context).size.width / 3.5,
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16),
                                                    border: Border.all(color: selectedTime == e.code ? kButtonColor : kBlackColor.withOpacity(0.3)),
                                                    color: kBackground),
                                                child: Center(
                                                  child: Text(
                                                    '${e.startTime} - ${e.endTime}',
                                                    style: kPoppinsMedium500.copyWith(
                                                        color: selectedTime == e.code ? kButtonColor : kBlackColor,
                                                        fontWeight: selectedTime == e.code ? FontWeight.w600 : FontWeight.w500,
                                                        fontSize: 11),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 4),
                                          width: double.infinity,
                                          height: 2,
                                          color: kWhiteGray,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () => setState(() => scheduleExpanded = !scheduleExpanded),
                                          child: scheduleExpanded
                                              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  Text('Show Less'),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Icon(Icons.keyboard_arrow_up, size: 20)
                                                ])
                                              : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  Text('Show More'),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Icon(Icons.keyboard_arrow_down, size: 20)
                                                ]),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    );
                                  }
                                } else {
                                  return Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                }
                              },
                            )
                            //       if (schedules[tabController.index]
                            //               .isEmpty &&
                            //           tabController.index == 0 &&
                            //           dateChoosen == false)
                            //         Container(
                            //           padding: EdgeInsets.all(32),
                            //           width: double.infinity,
                            //           child: Column(
                            //             children: [
                            //               Image.asset(
                            //                 'assets/no_doctor_icon.png',
                            //                 width: MediaQuery.of(context)
                            //                         .size
                            //                         .width /
                            //                     5,
                            //               ),
                            //               SizedBox(
                            //                 height: 16,
                            //               ),
                            //               Text(
                            //                 'Belum Ada Jadwal Konsultasi',
                            //                 style:
                            //                     kPoppinsSemibold600.copyWith(
                            //                         color: kDarkBlue,
                            //                         fontSize: 12),
                            //               )
                            //             ],
                            //           ),
                            //         )
                            //       else
                            //         Container(
                            //           width:
                            //               MediaQuery.of(context).size.width,
                            //           // padding: EdgeInsets.all(16),
                            //           child:
                            //           Column(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Wrap(
                            //                 children: schedules[
                            //                         tabController.index]
                            //                     .sublist(
                            //                         0,
                            //                         scheduleExpanded
                            //                             ? schedules[
                            //                                     tabController
                            //                                         .index]
                            //                                 .length
                            //                             : schedules[tabController
                            //                                             .index]
                            //                                         .length >
                            //                                     12
                            //                                 ? 12
                            //                                 : (schedules[tabController
                            //                                                 .index]
                            //                                             .length /
                            //                                         3)
                            //                                     .ceil())
                            //                     .map((e) {
                            //                   print(
                            //                       'schedulessssss =>${e.date}');
                            //                   return InkWell(
                            //                     onTap: () {
                            //                       print(
                            //                           'sel time => $selectedTime current => ${e.code}');
                            //                       if (selectedTime ==
                            //                           e.code) {
                            //                         setState(() {
                            //                           selectedTime = '';
                            //                         });
                            //                       } else {
                            //                         setState(() {
                            //                           selectedTime = e.code!;
                            //                         });
                            //                         controller
                            //                             .selectedDoctorTime
                            //                             .value = e;
                            //                       }
                            //                     },
                            //                     child: Container(
                            //                       margin: EdgeInsets.all(4),
                            //                       width:
                            //                           MediaQuery.of(context)
                            //                                   .size
                            //                                   .width /
                            //                               3.5,
                            //                       padding: EdgeInsets.all(8),
                            //                       decoration: BoxDecoration(
                            //                           borderRadius:
                            //                               BorderRadius
                            //                                   .circular(16),
                            //                           border: Border.all(
                            //                               color: selectedTime ==
                            //                                       e.code
                            //                                   ? kButtonColor
                            //                                   : kBlackColor
                            //                                       .withOpacity(
                            //                                           0.3)),
                            //                           color: kBackground),
                            //                       child: Center(
                            //                         child: Text(
                            //                           '${e.startTime} - ${e.endTime}',
                            //                           style: kPoppinsMedium500.copyWith(
                            //                               color: selectedTime ==
                            //                                       e.code
                            //                                   ? kButtonColor
                            //                                   : kBlackColor,
                            //                               fontWeight:
                            //                                   selectedTime ==
                            //                                           e.code
                            //                                       ? FontWeight
                            //                                           .w600
                            //                                       : FontWeight
                            //                                           .w500,
                            //                               fontSize: 11),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   );
                            //                 }).toList(),
                            //               ),
                            //               SizedBox(
                            //                 height: 10,
                            //               ),
                            //               Container(
                            //                 margin: EdgeInsets.symmetric(
                            //                     vertical: 4),
                            //                 width: double.infinity,
                            //                 height: 2,
                            //                 color: kWhiteGray,
                            //               ),
                            //               SizedBox(
                            //                 height: 10,
                            //               ),
                            //               InkWell(
                            //                 onTap: () => setState(() =>
                            //                     scheduleExpanded =
                            //                         !scheduleExpanded),
                            //                 child: scheduleExpanded
                            //                     ? Row(
                            //                         mainAxisAlignment:
                            //                             MainAxisAlignment
                            //                                 .center,
                            //                         children: [
                            //                             Text('Show Less'),
                            //                             SizedBox(
                            //                               width: 4,
                            //                             ),
                            //                             Icon(
                            //                                 Icons
                            //                                     .keyboard_arrow_up,
                            //                                 size: 20)
                            //                           ])
                            //                     : Row(
                            //                         mainAxisAlignment:
                            //                             MainAxisAlignment
                            //                                 .center,
                            //                         children: [
                            //                             Text('Show More'),
                            //                             SizedBox(
                            //                               width: 4,
                            //                             ),
                            //                             Icon(
                            //                                 Icons
                            //                                     .keyboard_arrow_down,
                            //                                 size: 20)
                            //                           ]),
                            //               ),
                            //               SizedBox(
                            //                 height: 16,
                            //               ),
                            //             ],
                            //           ),
                            //         )
                            //     ],
                            //   )
                            // else
                            //   const SizedBox(
                            //       width: double.infinity,
                            //       child: Center(
                            //           child: CupertinoActivityIndicator())),
                            ,
                            SizedBox(
                              height: 12,
                            ),
                            ExpansionTile(
                              tilePadding: EdgeInsets.zero,
                              title: Text(
                                "Terms & Conditions",
                                style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kBlackColor),
                              ),
                              children: [
                                Obx(
                                  () => (controller.tncBlock == null)
                                      ? Center(
                                          child: InkWell(
                                            onTap: () {
                                              controller.getTNCBlock();
                                            },
                                            child: Text(
                                              "Klik di sini untuk mengulang",
                                              style: kPoppinsMedium500.copyWith(fontSize: 11, height: 1.6, color: kBlackColor.withOpacity(0.5)),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: HtmlWidget(
                                            controller.tncBlock!.text,
                                            textStyle: kPoppinsMedium500.copyWith(
                                              fontSize: 11,
                                              color: kBlackColor,
                                            ),
                                          ),
                                        ),
                                )
                              ],
                            ),
                            // Text(
                            //   'Terms & Conditions : ',
                            //   style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kBlackColor),
                            // ),
                            SizedBox(height: 12),
                            // SizedBox(
                            //     width: double.infinity,
                            //     child: Obx(
                            //       () => (controller.tncBlock == null)
                            //           ? Center(
                            //               child: InkWell(
                            //                 onTap: () {
                            //                   controller.getTNCBlock();
                            //                 },
                            //                 child: Text(
                            //                   "Klik di sini untuk mengulang",
                            //                   style: kPoppinsMedium500.copyWith(fontSize: 11, height: 1.6, color: kBlackColor.withOpacity(0.5)),
                            //                 ),
                            //               ),
                            //             )
                            //           : HtmlWidget(
                            //               controller.tncBlock!.text,
                            //               textStyle: kPoppinsMedium500.copyWith(
                            //                 fontSize: 8,
                            //                 color: kBlackColor,
                            //               ),
                            //             ),
                            //     )),
                            SizedBox(height: 8),
                            // Container(
                            //   width: double.infinity,
                            //   child: Text(
                            //     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                            //     style: kPoppinsMedium500.copyWith(fontSize: 11, height: 1.6, color: kBlackColor.withOpacity(0.5)),
                            //   ),
                            // ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                          ],
                        ),
                      ])),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    boxShadow: [kBoxShadow],
                    color: kBackground,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(36), topLeft: Radius.circular(36))),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            'Biaya Konsultasi',
                            style: kPoppinsMedium500.copyWith(
                              fontSize: 11,
                              color: kBlackColor,
                            ),
                            minFontSize: 7,
                          ),
                        ),
                        Text(
                          arguments['price']['formatted'].toString(),
                          style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 19),
                        )
                      ],
                    ),
                    Container(
                      // margin: EdgeInsets.only(bottom: 8),

                      child: CustomFlatButton(
                          width: MediaQuery.of(context).size.width / 3,
                          text: 'Lanjut',
                          // height: MediaQuery.of(context).size.height * 0.2,
                          // height: MediaQuery.of(context).size.height * 0.05,
                          onPressed: () async {
                            if (selectedMethod != '' && selectedTime != '') {
                              controller.selectedDoctor.value = arguments['doctor_id'].toString();
                              controller.doctorAvatar.value =
                                  arguments['photo'] == null ? ' ' : arguments['photo']['formats']['thumbnail'].toString();
                              controller.doctorName.value = arguments['name'].toString();
                              controller.doctorSpecialist.value = arguments['specialization']['name'].toString();
                              controller.consultBy.value = selectedMethod;
                              controller.doctorPrice.value = arguments['price']['formatted'].toString();
                              // print(controller.doctorAvatar.value);
                              // print(controller.doctorName.value);
                              // print(controller.doctorPrice.value);
                              // print(controller.doctorSpecialist.value);

                              Get.toNamed('/patient-type');
                            }
                          },
                          color: selectedMethod != '' && selectedTime != '' ? kButtonColor : kLightGray),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: ExtendedImage.network(
                  arguments['photo'] == null ? ' ' : arguments['photo']['formats']['thumbnail'].toString(),
                  fit: BoxFit.contain,
                  cache: true,
                  borderRadius: BorderRadius.circular(16),
                  loadStateChanged: (ExtendedImageState state) {
                    if (state.extendedImageLoadState == LoadState.failed) {
                      return Icon(
                        Icons.image_not_supported_rounded,
                        color: kLightGray,
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.1,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: kBlackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
