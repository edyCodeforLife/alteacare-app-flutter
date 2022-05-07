// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/doctor_category_specialist.dart';
import 'package:altea/app/modules/doctor/controllers/doctor_controller.dart';
import 'package:altea/app/core/utils/settings.dart' as settings;

class DoctorFilterPanel extends StatefulWidget {
  final String selectedCategory;
  final String searchQuery;
  final PanelController pc;
  final Function(bool, String, String) trigger;
  final Function clearCategory;

  DoctorFilterPanel(
      {required this.selectedCategory, required this.searchQuery, required this.clearCategory, required this.pc, required this.trigger});
  @override
  _DoctorFilterPanelState createState() => _DoctorFilterPanelState();
}

class _DoctorFilterPanelState extends State<DoctorFilterPanel> {
  List<Datum> spesialisList = [Datum(name: "Tampilkan Semua")];
  DoctorController controller = Get.find<DoctorController>();

  List hospitalList = [
    {"name": "Tampilkan Semua"}
  ];

  bool spesialisExpanded = false;
  bool hospitalExpanded = false;

  int selectedHospital = 0;
  int selectedSpesialis = 0;
  int selectedDate = 0;
  int selectedPrice = 0;
  int selectedSort = 0;

  List<String> params = [
    "", "", "", ""
    // notes : urutannya : SPECIALIZATION , HOSPITAL, DATES(NOT YET, SKIPPED), PRICE, SORT
  ];

  List<Map<String, dynamic>> sort = [
    {
      "text": "Tampilkan Semua",
      "params": "",
    },
    {
      "text": "Harga Tertinggi",
      "params": "&_sort=price:desc",
    },
    {
      "text": "Harga Terendah",
      "params": "&_sort=price:asc",
    },
    {
      "text": "Pengalaman Terlama",
      "params": "&_sort=experience:asc",
    },
    {
      "text": "Pengalaman Terbaru",
      "params": "&_sort=experience:desc",
    }
  ];

  List<Map<String, dynamic>> sortedList = [];

  List<Map<String, dynamic>> price = [
    {"text": "Tampilkan Semua", "params": "&price_lte=10000000&price_gte=0"},
    {"text": "50rb - 150rb", "params": "&price_lte=150000&price_gte=50000"},
    {"text": "150rb - 300rb", "params": "&price_lte=300000&price_gte=150000"},
    {"text": "300rb - 500rb", "params": "&price_lte=500000&price_gte=300000"}
  ];

  bool initCategory = false;
  bool initHospital = false;
  String searchUrl = '';

  List<DateTime> dates = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
    DateTime.now().add(Duration(days: 2)),
    DateTime.now().add(Duration(days: 3)),
    DateTime.now().add(Duration(days: 4)),
    DateTime.now().add(Duration(days: 5)),
    DateTime.now().add(Duration(days: 6))
  ];

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

  bool choosen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller.onInit();
    // print('hospital 1 => ${controller.allHospital.value}');
    // controller.allHospital.value.forEach((element) {
    //   hospitalList.add(element);
    // });
    // print('hospitallsss => $hospitalList');
  }

  @override
  Widget build(BuildContext context) {
    // print('tes hari => ${dates[3].weekday}');
    // print('id dari panel => ${widget.selectedCategory}');
    return Scaffold(
      backgroundColor: kBackground,
      body: Container(
        margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.4),
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(color: kBlackColor.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 11, vertical: 16),
                child: Text(
                  'Filter',
                  style: kPoppinsSemibold600.copyWith(fontSize: 18, color: kBlackColor, decoration: TextDecoration.none),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Spesialis',
                  style: kPoppinsMedium500.copyWith(fontSize: 14, color: kBlackColor, decoration: TextDecoration.none),
                ),
              ),
              FutureBuilder<DoctorSpecialistCategory>(
                future: controller.getDoctorsOthersCategory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (!initCategory) {
                      snapshot.data!.data!.forEach((element) {
                        spesialisList.add(element);
                      });

                      initCategory = true;
                    }

                    if (!choosen) {
                      selectedSpesialis = spesialisList.indexWhere((element) => element.specializationId == widget.selectedCategory);
                      params[0] = "&specialis.id_in=${spesialisList[selectedSpesialis].specializationId}";
                    }
                  }
                  if (spesialisList.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: spesialisList
                              .sublist(
                                  0,
                                  spesialisExpanded
                                      ? spesialisList.length
                                      : spesialisList.length > 5
                                          ? 5
                                          : spesialisList.length)
                              .map((e) => InkWell(
                                    onTap: () {
                                      choosen = true;
                                      setState(() {
                                        selectedSpesialis = spesialisList.indexOf(e);
                                      });
                                      if (selectedSpesialis == 0) {
                                        // print('spesialis 0 ');
                                        params[0] = "";
                                      } else {
                                        params[0] = "&specialis.id_in=${spesialisList[selectedSpesialis].specializationId}";
                                      }
                                      // print("params 0 => ${params[0]}");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: kBackground,
                                          borderRadius: BorderRadius.circular(32),
                                          border: Border.all(color: spesialisList.indexOf(e) == selectedSpesialis ? kDarkBlue : kLightGray)),
                                      child: Text(
                                        e.name!,
                                        style: kPoppinsRegular400.copyWith(
                                            fontSize: 11,
                                            fontWeight: spesialisList.indexOf(e) == selectedSpesialis ? FontWeight.w600 : FontWeight.w400,
                                            color: spesialisList.indexOf(e) == selectedSpesialis ? kDarkBlue : kBlackColor,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        Container(
                          color: kLightGray.withOpacity(0.5),
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 8, bottom: 4),
                          height: 2,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              spesialisExpanded = !spesialisExpanded;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  spesialisExpanded ? 'Show Less' : 'Show More',
                                  style: kPoppinsMedium500.copyWith(color: kBlackColor.withOpacity(0.7), fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  spesialisExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return const SizedBox(
                      width: double.infinity,
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              ),
              Container(
                padding: EdgeInsets.all(11),
                child: Text(
                  'Rumah Sakit',
                  style: kPoppinsMedium500.copyWith(fontSize: 14, color: kBlackColor, decoration: TextDecoration.none),
                ),
              ),
              FutureBuilder(
                  future: controller.getHospitals(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // print('hospitals snapshot => ${snapshot.data!.data}');
                      if (!initHospital) {
                        ((snapshot.data as Map)['data'] as List).forEach((element) {
                          hospitalList.add(element);
                        });

                        initHospital = true;
                      }

                      // if (!choosen) {
                      //   selectedSpesialis = spesialisList.indexWhere(
                      //       (element) =>
                      //           element.specializationId ==
                      //           widget.selectedCategory);
                      //   params[0] =
                      //       "&specialis.id_in=${spesialisList[selectedSpesialis].specializationId}";
                      // }
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: hospitalList
                              .sublist(
                                  0,
                                  hospitalExpanded
                                      ? hospitalList.length
                                      : hospitalList.length > 2
                                          ? 3
                                          : 1)
                              .map((e) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedHospital = hospitalList.indexOf(e);
                                      });
                                      if (selectedHospital == 0) {
                                        // print('hospital 0 ');
                                        params[1] = "";
                                      } else {
                                        params[1] = "&hospital.id_in=${hospitalList[selectedHospital]['hospital_id']}";
                                      }
                                      // print("params 1 => ${params[0]}");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      margin: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: kBackground,
                                          borderRadius: BorderRadius.circular(32),
                                          border: Border.all(color: hospitalList.indexOf(e) == selectedHospital ? kDarkBlue : kLightGray)),
                                      child: Text(
                                        e['name'].toString(),
                                        style: kPoppinsRegular400.copyWith(
                                            fontSize: 11,
                                            fontWeight: hospitalList.indexOf(e) == selectedHospital ? FontWeight.w600 : FontWeight.w400,
                                            color: hospitalList.indexOf(e) == selectedHospital ? kDarkBlue : kBlackColor,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        Container(
                          color: kLightGray.withOpacity(0.5),
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 4, top: 8),
                          height: 2,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              hospitalExpanded = !hospitalExpanded;
                            });
                            // print('hspital expanded => $hospitalExpanded');
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  hospitalExpanded ? 'Show Less' : 'Show More',
                                  style: kPoppinsMedium500.copyWith(color: kBlackColor.withOpacity(0.7), fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  hospitalExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }),
              Container(
                padding: EdgeInsets.all(11),
                child: Text(
                  'Harga',
                  style: kPoppinsMedium500.copyWith(fontSize: 14, color: kBlackColor, decoration: TextDecoration.none),
                ),
              ),
              Wrap(
                children: price.map((e) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedPrice = price.indexOf(e);
                      });
                      if (selectedPrice == 0) {
                        // print('price 0 ');
                        params[2] = "";
                      } else {
                        params[2] = e['params'].toString();
                      }
                      // print("params 2 => ${params[2]}");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: kBackground,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: price.indexOf(e) == selectedPrice ? kDarkBlue : kLightGray)),
                      child: Text(
                        e['text'].toString(),
                        style: kPoppinsRegular400.copyWith(
                            fontSize: 11,
                            fontWeight: price.indexOf(e) == selectedPrice ? FontWeight.w600 : FontWeight.w400,
                            color: price.indexOf(e) == selectedPrice ? kDarkBlue : kBlackColor,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 19,
              ),
              Container(
                padding: EdgeInsets.all(11),
                child: Text(
                  'Urutkan',
                  style: kPoppinsMedium500.copyWith(fontSize: 14, color: kBlackColor, decoration: TextDecoration.none),
                ),
              ),
              Wrap(
                children: sort.map((e) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedSort = sort.indexOf(e);
                      });
                      if (selectedSort == 0) {
                        // print('sort 0 ');
                        params[3] = "";
                      } else {
                        params[3] = e['params'].toString();
                      }
                      // print("params 3 => ${params[3]}");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: kBackground,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: sort.indexOf(e) == selectedSort ? kDarkBlue : kLightGray)),
                      child: Text(
                        e['text'].toString(),
                        style: kPoppinsRegular400.copyWith(
                            fontSize: 11,
                            fontWeight: sort.indexOf(e) == selectedSort ? FontWeight.w600 : FontWeight.w400,
                            color: sort.indexOf(e) == selectedSort ? kDarkBlue : kBlackColor,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 16,
              ),
              CustomFlatButton(
                  width: double.infinity,
                  text: 'Terapkan',
                  height: MediaQuery.of(context).size.height * 0.055,
                  onPressed: () {
                    // print('params akhir => $params');
                    String url = '${settings.alteaURL}/data/doctors?' + params[0] + params[1] + params[2] + params[3];

                    if (widget.searchQuery != '') {
                      searchUrl = url + '&_q=${widget.searchQuery}';
                    } else {
                      searchUrl = url;
                    }

                    if (params[0] == '') {
                      widget.clearCategory;
                    }

                    widget.trigger(true, searchUrl, spesialisList[selectedSpesialis].specializationId ?? '');
                    widget.pc.close();
                  },
                  color: kButtonColor),
              SizedBox(
                height: (GetPlatform.isIOS) ? 70 : 32,
              )
            ],
          ),
        ),
      ),
    );
  }
}
