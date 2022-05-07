// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetDoctorTab extends StatefulWidget {
  Map<String, dynamic> data;

  MeetDoctorTab({required this.data});
  @override
  _MeetDoctorTabState createState() => _MeetDoctorTabState();
}

class _MeetDoctorTabState extends State<MeetDoctorTab> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  List<String> tabs = ['Data Pasien', 'Memo Altea', 'Dokumen Medis', 'Biaya'];
  List<Map<String, dynamic>> docs = [
    {
      "type": "Dokumen Baru",
      "data": [
        {"file_name": "file_radiologi.pdf", "file_size": "345kb", "time": "Hari ini, 2:30 PM"},
        {"file_name": "file_radiologi.pdf", "file_size": "345kb", "time": "Hari ini, 2:30 PM"}
      ]
    },
    {
      "type": "Dokumen Altea Care",
      "data": [
        {"file_name": "file_radiologi.pdf", "file_size": "345kb", "time": "Kemarin, 3:30 PM"},
        {"file_name": "file_radiologi.pdf", "file_size": "345kb", "time": "Kemarin, 5:30 PM"}
      ]
    },
    {
      "type": "Unggahan Saya",
      "data": [
        {"file_name": "file_radiologi.pdf", "file_size": "345kb", "time": "Hari ini, 1:30 PM"},
        {"file_name": "file_radiologi.pdf", "file_size": "345kb", "time": "Hari ini, 11:30 AM"}
      ]
    }
  ];
  List<Map<String, dynamic>> memos = [
    {
      "title": "Keluhan",
      "summary":
          "Sakit kepala kiri sejak 3 hari, berdenyut disertai muntah sejak 1 hari ini. Sakit kepala dirasakan memberat saat beraktivitas, berkurang saat istirahat. Tidak ada trauma kepala. Tidak ada kelemahan anggota gerak, nyeri ulu hati sejak 2 hari, riwayat terlambat makan, badan lemas."
    },
    {"title": "Diagnosis", "summary": "Migrain, Dispepsia"},
    {
      "title": "Resep Obat",
      "summary": '''- Analsik 500mg, 15 tablet 3x1 tablet setelah makan
   (bila sakit kepala). 
- Omeprazole 20mg, 10 tablet 2x1 tablet sebelum
   makan. 
- Sucralfat Susp, 100ml, 4x1 sendok makan sebelum
   makan.
- Becom-c, 10 tablet, 1x1 tablet setelah makan (pagi)'''
    },
    {
      "title": "Rekomendasi Dokter",
      "summary": '''- Pola makan secara teratur
- Hindari makanan pedas, minum kopi, soda, alcohol
- Istirahata teratur'''
    },
    {
      "title": "Catatan Lain",
      "summary": '''- Bila sakit kepala tidak berkurang / bertambah berat 
   lakukan CT Scan di Mitra Keluarga kelapa gading 23 
   Desember 2020
- Bila Nyeri ulu hati tidak berkurang disarankan untuk 
   melakukan endoscopy di mitra keluarga
   kelapa gading tanggal 4 Januari 2021 '''
    },
  ];
  final oCcy = NumberFormat("#,##0", "en_US");
  @override
  Widget build(BuildContext context) {
    // print('medical resume => ${widget.data['medical_resume']}');
    // print('medical doc => ${widget.data['medical_document']}');
    return Container(
      // height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              List<String> date = widget.data['schedule']['date'].toString().split('-');
              // print('hour => ${(widget.data['schedule']['time_start'] as String).split(':')[0]}');
              final Event event = Event(
                title: 'Altea Care - Dr. ${widget.data['doctor']['name']}',
                description: 'Konsultasi Altea Care dengan Dr. ${widget.data['doctor']['name']} / Sp. ${widget.data['doctor']['specialist']['name']}',
                location: 'Event location',
                startDate: DateTime.utc(
                  int.parse(date[0]),
                  int.parse(date[1]),
                  int.parse(date[2]),
                  int.parse((widget.data['schedule']['time_start'] as String).split(':')[0]) - 7,
                  int.parse((widget.data['schedule']['time_start'] as String).split(':')[1]),
                ),
                endDate: DateTime.utc(
                    int.parse(date[0]),
                    int.parse(date[1]),
                    int.parse(date[2]),
                    int.parse((widget.data['schedule']['time_end'] as String).split(':')[0]) - 7,
                    int.parse((widget.data['schedule']['time_end'] as String).split(':')[1])),
                // iosParams: IOSParams(
                //   reminder: Duration(/* Ex. hours:1 */), // on iOS, you can set alarm notification after your event.
                // ),
                // androidParams: AndroidParams(
                //   emailInvites: [], // on Android, you can add invite emails to your event.
                // ),
              );
              Add2Calendar.addEvent2Cal(event);
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: kLightBlue, borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                '+ Add to Calendar',
                style: kPoppinsSemibold600.copyWith(fontSize: 10, color: kDarkBlue),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TabBar(
            onTap: (idx) {
              setState(() {
                if (idx == 1) {
                  // if (memos.isNotEmpty) {
                  if (widget.data['medical_resume'] != null) {
                    tabController.index = idx;
                  } else {
                    tabController.index = tabController.previousIndex;
                  }
                } else if (idx == 2) {
                  // if (docs.isNotEmpty) {
                  if ((widget.data['medical_document'] as List).isNotEmpty) {
                    tabController.index = idx;
                  } else {
                    tabController.index = tabController.previousIndex;
                  }
                } else {
                  tabController.index = idx;
                }
              });
            },
            controller: tabController,
            tabs: [
              for (int index = 0; index < tabs.length; index++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
                  child: Text(
                    tabs[index],
                    style: tabController.index == index
                        ? kPoppinsMedium500.copyWith(color: kDarkBlue, fontSize: 10)
                        : kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 10),
                    maxLines: 1,
                  ),
                )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            // height: MediaQuery.of(context).size.height * 0.38,
            // color: Colors.pink,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: tabController,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data['patient']['name'].toString(),
                        style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${widget.data['patient']['age']['year']} Tahun',
                        style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 1,
                        color: kLightGray,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Text('Jenis Kelamin     :', style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.5))),
                          SizedBox(
                            width: 4,
                          ),
                          Text(widget.data['patient']['gender'] == 'MALE' ? 'Laki - Laki' : 'Perempuan',
                              style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor)),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text('Tanggal Lahir     :', style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.5))),
                          SizedBox(
                            width: 4,
                          ),
                          Text(widget.data['patient']['birthdate'].toString(), style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor)),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alamat                  :', style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.5))),
                          SizedBox(
                            width: 4,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                                "${widget.data['patient']['address_raw'][0]['street'] == null ? "" : widget.data['patient']['address_raw'][0]['street']}, Blok RT/RW${widget.data['patient']['address_raw'][0]['rt_rw'] == null ? " " : widget.data['patient']['address_raw'][0]['rt_rw']}, Kel. ${widget.data['patient']['address_raw'][0]['sub_district'] == null ? " " : widget.data['patient']['address_raw'][0]['sub_district']['name']}, Kec.${widget.data['patient']['address_raw'][0]['district'] == null ? "" : widget.data['patient']['address_raw'][0]['district']['name']} ${widget.data['patient']['address_raw'][0]['city'] == null ? "" : widget.data['patient']['address_raw'][0]['city']['name']} ${widget.data['patient']['address_raw'][0]['province'] == null ? " " : widget.data['patient']['address_raw'][0]['province']['name']} ${widget.data['patient']['address_raw'][0]['sub_district'] == null ? " " : widget.data['patient']['address_raw'][0]['sub_district']['postal_code']}",
                                style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //MEMO
                if (widget.data['medical_resume'] == null)
                  Container()
                else
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      // height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView(
                        children: [
                          Text(
                            'Keluhan',
                            style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kBlackColor),
                          ),
                          Text(
                            widget.data['medical_resume']['symptom'].toString(),
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.7)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Diagnosis',
                            style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kBlackColor),
                          ),
                          Text(
                            widget.data['medical_resume']['diagnosis'].toString(),
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.7)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Resep Obat',
                            style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kBlackColor),
                          ),
                          Text(
                            widget.data['medical_resume']['drug_resume'].toString(),
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.7)),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomFlatButton(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    text: 'Info Pemesanan Obat',
                                    onPressed: () => Get.toNamed('/pharmacy-information'),
                                    color: kButtonColor),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Rekomendasi Dokter',
                            style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kBlackColor),
                          ),
                          Text(
                            widget.data['medical_resume']['consultation'].toString(),
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.7)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Catatan Lain',
                            style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kBlackColor),
                          ),
                          Text(
                            widget.data['medical_resume']['notes'].toString(),
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.7)),
                          ),
                          const SizedBox(
                            height: 80,
                          )
                        ],
                      )
                      // ListView.builder(
                      //   itemCount: memos.length,
                      //   itemBuilder: (context, idx) {
                      //     return Container(
                      //       margin: EdgeInsets.symmetric(vertical: 4),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             memos[idx]['title'].toString(),
                      //             style: kPoppinsSemibold600.copyWith(
                      //                 fontSize: 13, color: kBlackColor),
                      //           ),
                      //           SizedBox(
                      //             height: 4,
                      //           ),
                      //           Text(
                      //             memos[idx]['summary'].toString(),
                      //             style: kPoppinsRegular400.copyWith(
                      //                 fontSize: 11,
                      //                 color: kBlackColor.withOpacity(0.7)),
                      //           ),
                      //           SizedBox(
                      //             height: 4,
                      //           ),
                      //           if (idx == 3)
                      //             CustomFlatButton(
                      //                 width:
                      //                     MediaQuery.of(context).size.width * 0.5,
                      //                 text: 'Info Pemesanan Obat',
                      //                 onPressed: () =>
                      //                     Get.toNamed('/pharmacy-information'),
                      //                 color: kButtonColor)
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                      ),
                //DOKUMEN MEDIS
                if ((widget.data['medical_document'] as List).isEmpty)
                  Container()
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          List medicalDocs = (widget.data['medical_document'] as List).where((element) => element['upload_by_user'] == 0).toList();
                          List uploadedDocs = (widget.data['medical_document'] as List).where((element) => element['upload_by_user'] == 1).toList();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dokumen AlteaCare',
                                style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.7)),
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: medicalDocs.length,
                                itemBuilder: (context, idx) {
                                  return InkWell(
                                    onTap: () async {
                                      // print(medicalDocs[idx].toString());
                                      if (await canLaunch(medicalDocs[idx]['url'])) {
                                        launch(medicalDocs[idx]['url']);
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Image.asset('assets/memo.png'),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                medicalDocs[idx]['original_name'].toString(),
                                                style: kPoppinsSemibold600.copyWith(fontSize: 11, color: kBlackColor),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                medicalDocs[idx]['size'].toString(),
                                                style: kPoppinsMedium500.copyWith(fontSize: 9, color: kBlackColor.withOpacity(0.5)),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                medicalDocs[idx]['date'].toString(),
                                                style: kPoppinsRegular400.copyWith(fontSize: 8, color: kBlackColor.withOpacity(0.5)),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (uploadedDocs.isNotEmpty)
                                Column(
                                  children: [
                                    Text(
                                      'Unggahan Saya',
                                      style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.7)),
                                    ),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: uploadedDocs.length,
                                      itemBuilder: (context, idx) {
                                        return InkWell(
                                          onTap: () async {
                                            if (await canLaunch(uploadedDocs[idx]['url'])) {
                                              launch(uploadedDocs[idx]['url']);
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Image.asset('assets/memo.png'),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      uploadedDocs[idx]['original_name'].toString(),
                                                      style: kPoppinsSemibold600.copyWith(fontSize: 11, color: kBlackColor),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      uploadedDocs[idx]['size'].toString(),
                                                      style: kPoppinsMedium500.copyWith(fontSize: 9, color: kBlackColor.withOpacity(0.5)),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      uploadedDocs[idx]['date'].toString(),
                                                      style: kPoppinsRegular400.copyWith(fontSize: 8, color: kBlackColor.withOpacity(0.5)),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                              else
                                Container()
                            ],
                          );
                        }),
                  ),

                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Metode Pembayaran',
                            style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                          ),
                          Image.network(
                            widget.data['transaction']['detail']['icon'].toString(),
                            width: MediaQuery.of(context).size.width * 0.2,
                          )
                        ],
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: (widget.data['fees'] as List).length,
                        itemBuilder: (context, idx) {
                          Map<String, dynamic> fee = (widget.data['fees'] as List)[idx] as Map<String, dynamic>;
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  fee['label'].toString(),
                                  style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor.withOpacity(0.6)),
                                ),
                                Text(
                                  'Rp. ${oCcy.format(fee['amount'])}',
                                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor.withOpacity(0.8)),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 1,
                        color: kBlackColor,
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: kPoppinsSemibold600.copyWith(fontSize: 14, color: kButtonColor),
                            ),
                            Text(
                              'Rp. ${oCcy.format(widget.data['total_price'])}',
                              style: kPoppinsSemibold600.copyWith(fontSize: 18, color: kButtonColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
