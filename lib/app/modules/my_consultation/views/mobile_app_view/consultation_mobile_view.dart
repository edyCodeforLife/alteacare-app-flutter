import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/helper.dart' as helper;
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/my_consultation/controllers/my_consultation_controller.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ConsultationMobileView extends StatefulWidget {
  @override
  _ConsultationMobileViewState createState() => _ConsultationMobileViewState();
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    // print('hexxx => $hexColor');
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class _ConsultationMobileViewState extends State<ConsultationMobileView> with SingleTickerProviderStateMixin {
  List<String> tabs = ['Berjalan', 'Riwayat', 'Dibatalkan', 'Percakapan'];

  late TabController tabController;
  MyConsultationController controller = Get.put(MyConsultationController());
  Map<String, dynamic> filter = {
    "date_start": "",
    "date_end": "",
    "doctor_id": "",
    "user_id": "",
    "consultation_method": "",
    "hospital_id": "",
    "specialist_id": "",
    "status": [],
    "page": "0"
  };

  List<String> orderId = [];

  bool start = true;
  int count = 1;
  int totalPage = 99;
  List snap = [];
  List<String> orderIds = [];

  bool isFiltered = false;

  bool isScrolling = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
        if (scrollController.position.atEdge && scrollController.position.pixels != 0) {
          // isScrolling = true;
          if (!start) {
            // print('at the bottom----------------------------------------------');

            // print('count => $count totalPage => $totalPage');
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                filter['page'] = count.toString();
              });
            });
            count += 1;
            // print('filterrr => $filter');
            // } else {
            //   print("total page > count");
          }

          start = false;
        }
      });
    });
  }

  String searchQuery = '';
  PanelController _pc = PanelController();

  ScrollController scrollController = ScrollController();

  // Color chooseColor(String status) {
  //   switch (status) {
  //     case 'NEW':
  //       return Color(0XFF43BEAE).withOpacity(0.2);
  //     case 'PROCESS_GP':
  //       return Color(0XFF43BEAE).withOpacity(0.2);
  //     case 'WAITING_FOR_PAYMENT':
  //       return Color(0XFFE5B800).withOpacity(0.2);
  //     case 'PAID':
  //       return Color(0XFF128EBF).withOpacity(0.2);
  //     case 'ON_GOING':
  //       return Color(0XFF128EBF).withOpacity(0.2);
  //     case 'WAITING_FOR_MEDICAL_RESUME':
  //       return Color(0XFFF0990D).withOpacity(0.2);
  //     case 'COMPLETED':
  //       return Color(0XFF43BEAE).withOpacity(0.2);
  //     case "CANCELED_BY_SYSTEM":
  //       return Color(0XFFFF0505).withOpacity(0.2);
  //     case "CANCELED_BY_GP":
  //       return Color(0XFFFF0505).withOpacity(0.2);
  //     case "CANCELED_BY_USER":
  //       return Color(0XFFFF0505).withOpacity(0.2);
  //     case "PAYMENT_EXPIRED":
  //       return Color(0XFFFF0505).withOpacity(0.2);
  //     case "PAYMENT_FAILED":
  //       return Color(0XFFFF0505).withOpacity(0.2);
  //     case "REFUNDED":
  //       return Color(0XFFFF0505).withOpacity(0.2);
  //     default:
  //       return Color(0XFF128EBF).withOpacity(0.2);
  //   }
  // }
  //
  // String chooseText(String status) {
  //   switch (status) {
  //     case 'NEW':
  //       return 'Baru';
  //     case 'PROCESS_GP':
  //       return 'Diproses';
  //     case 'WAITING_FOR_PAYMENT':
  //       return 'Menunggu Pembayaran';
  //     case 'PAID':
  //       return 'Temui Dokter';
  //     case 'MEET_SPECIALIST':
  //       return 'Temui Dokter';
  //     case 'ON_GOING':
  //       return 'Sedang Berlangsung';
  //     case 'WAITING_FOR_MEDICAL_RESUME':
  //       return 'Memo Altea di Proses';
  //     case 'COMPLETED':
  //       return 'Selesai';
  //     case "CANCELED_BY_SYSTEM":
  //       return 'Dibatalkan';
  //     case "CANCELED_BY_GP":
  //       return 'Dibatalkan';
  //     case "CANCELED_BY_USER":
  //       return 'Dibatalkan';
  //     case "PAYMENT_EXPIRED":
  //       return 'Masa Pembayaran Berakhir';
  //     case "PAYMENT_FAILED":
  //       return 'Pembayaran Gagal';
  //     case "REFUNDED":
  //       return 'Pengembalian Dana';
  //     default:
  //       return ' ';
  //   }
  // }

  String endPoint(int idx) {
    switch (idx) {
      case 0:
        // return 'appointment/on-going';
        return 'appointment/v1/consultation/ongoing';

      case 1:
        // return 'appointment/history';
        return 'appointment/v1/consultation/history';

      case 2:
        // return 'appointment/cancel';
        return 'appointment/v1/consultation/canceled';

      default:
        return 'appointment';
    }
  }

  // String selectedStatus = '';
  List<String> selectedStatus = [];
  int statusIndex(int idx) {
    switch (idx) {
      case 0:
        // ini on-going
        return 0;
      case 1:
        //ini canceled
        return 2;
      case 2:
        // ini history
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.6,
      controller: _pc,
      panel: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                  child: Text(
                    'Filter',
                    style: kPoppinsSemibold600.copyWith(fontSize: 18, color: kBlackColor, decoration: TextDecoration.none),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Status Konsultasi',
                    style: kPoppinsMedium500.copyWith(fontSize: 14, color: kBlackColor, decoration: TextDecoration.none),
                  ),
                ),
                FutureBuilder(
                  future: controller.getStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List snap =
                          ((snapshot.data as Map<String, dynamic>)['data'] == null) ? [] : (snapshot.data as Map<String, dynamic>)['data'] as List;

                      // print('snap dataaaa => ${snap[statusIndex(tabController.index)]}');
                      return (snap.isEmpty)
                          ? const SizedBox()
                          : Wrap(
                              children: (snap[statusIndex(tabController.index)]['child'] as List)
                                  .map((e) => InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (selectedStatus.contains(e['code'])) {
                                              selectedStatus.remove(e['code']);
                                            } else {
                                              selectedStatus.add(e['code'].toString());
                                            }
                                            count = 1;
                                            totalPage = 99;
                                            orderIds = [];
                                          });
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
                                              border: Border.all(color: selectedStatus.contains(e['code']) ? kDarkBlue : kLightGray)),
                                          child: Text(
                                            e['detail']['label'].toString(),
                                            style: kPoppinsRegular400.copyWith(
                                                fontSize: 11,
                                                fontWeight: selectedStatus.contains(e['code']) ? FontWeight.w600 : FontWeight.w400,
                                                color: selectedStatus.contains(e['code']) ? kDarkBlue : kBlackColor,
                                                decoration: TextDecoration.none),
                                          ),
                                        ),
                                      ))
                                  .toList());
                    } else {
                      return CupertinoActivityIndicator();
                    }
                  },
                ),
              ],
            ),
            CustomFlatButton(
                width: double.infinity,
                text: 'Konfirmasi',
                onPressed: () {
                  _pc.close();
                  setState(() {
                    snap = [];
                    isScrolling = false;
                    count = 1;
                    filter['page'] = 1;
                    filter['status'] = selectedStatus;

                    count = 1;
                    totalPage = 99;
                    orderId = [];
                  });
                  // print(filter['status']);
                },
                color: kButtonColor)
          ],
        ),
      ),
      body: Container(
        // height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              onTap: (idx) {
                setState(() {
                  snap = [];
                });
                // print('snap => $snap');
                setState(() {
                  tabController.index = idx;
                  isScrolling = false;
                  count = 1;
                  filter['page'] = 1;
                  filter['status'] = [];
                  selectedStatus = [];
                  start = true;
                  count = 1;
                  totalPage = 99;
                  orderId = [];
                });
              },
              controller: tabController,
              unselectedLabelColor: kLightGray,
              labelColor: kDarkBlue,
              tabs: [
                for (int index = 0; index < tabs.length; index++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16),
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.65,
                    margin: EdgeInsets.only(left: 16, top: 8, bottom: 4, right: 4),
                    child: TextField(
                      style: kVerifText1.copyWith(color: kBlackColor),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        contentPadding: EdgeInsets.only(top: 4),
                        prefixIcon: Icon(
                          Icons.search,
                          color: kButtonColor,
                        ),
                        isDense: true,
                        fillColor: kBackground,
                        filled: true,
                        border: OutlineInputBorder(borderSide: BorderSide(color: kWhiteGray, width: 2), borderRadius: BorderRadius.circular(24)),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: kWhiteGray, width: 2), borderRadius: BorderRadius.circular(24)),
                      ),
                      onChanged: (val) {
                        setState(() {
                          // snap = [];
                          // count = 0;
                          // filter['page'] = 0;
                          searchQuery = val;
                          // snap = snap
                          //     .where((data) => data['doctor']['name']
                          //         .toString()
                          //         .toLowerCase()
                          //         .contains(searchQuery.toLowerCase()))
                          //     .toList();
                        });
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (_pc.isPanelClosed) {
                        _pc.open();
                      } else {
                        _pc.close();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration:
                          BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(36), border: Border.all(color: kLightGray, width: 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.tune,
                            size: 18,
                            color: isFiltered ? kBackground : kBlackColor,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Filter',
                            style: kValidationText.copyWith(fontWeight: FontWeight.w500, color: isFiltered ? kBackground : kBlackColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.65,
              child: FutureBuilder(
                future: controller.getConsultation(endPoint(tabController.index), filter),
                builder: (context, snapshot) {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      // if (!isScrolling) {
                      // snap = [];
                      // }
                      // print('snapshotData => ${snapshot.data}');
                      // print('snap dari future builder=> $snap');

                      if ((snapshot.data as Map<String, dynamic>)['data'] != null) {
                        if ((snapshot.data as Map<String, dynamic>).containsKey("meta")) {
                          totalPage = ((snapshot.data as Map<String, dynamic>)['meta']['total_page'] is int)
                              ? (snapshot.data as Map<String, dynamic>)['meta']['total_page'] as int
                              : 0;
                        }
                        if (searchQuery.removeAllWhitespace != '') {
                          // print('search queryyy => $searchQuery');
                          if ((snapshot.data as Map<String, dynamic>)['meta']['page'] == 1) {
                            snap = [];
                            orderId = [];
                          }

                          List data = ((snapshot.data as Map<String, dynamic>)['data'] as List)
                              .where((data) => data['doctor']['name'].toString().toLowerCase().contains(searchQuery.toLowerCase()))
                              .toList();

                          // print('udah di where => $data');

                          // print('ini snapppp di future builder => $snap');
                          // print('SAMA GA? 001? ${snap == data} count : $count');

                          data.forEach((e) {
                            if (!orderId.contains(e['id'].toString())) {
                              orderId.add(e['id'].toString());
                              snap.add(e);
                            }
                            // print('mau di add 001');
                            // if (!orderIds.contains(e['id'].toString())) {

                            // orderIds.add(e['id'].toString());
                            // } else {
                            //   print(
                            //       "sudah ada $e, count : $count , orderIds : $orderIds");
                            // }
                          });
                          // print('dah di add 001');
                          // print('dataa => $data');

                          // print('snappp 1 => $snap');
                          snap.sort((a, b) {
                            DateTime adate = DateTime.parse(a['schedule']['date'].toString());
                            DateTime bdate = DateTime.parse(b['schedule']['date'].toString());
                            return bdate.compareTo(adate);
                          });
                        } else {
                          var data = (snapshot.data as Map<String, dynamic>)['data'] as List;

                          // print(
                          //     'SAMA GA? 002 ? ${snap == data} count : $count');
                          // snap.add(data);
                          data.forEach((e) {
                            // print('mau di add 002');
                            // if (!orderIds.contains(e['id'].toString())) {
                            if (!orderId.contains(e['id'].toString())) {
                              orderId.add(e['id'].toString());
                              snap.add(e);
                            }
                            // orderIds.add(e['id'].toString());
                            // }
                          });
                          // print('dah di add 2');
                          // print('snappp 1 => $snap');
                          snap.sort((a, b) {
                            DateTime adate = DateTime.parse(a['schedule']['date'].toString());
                            DateTime bdate = DateTime.parse(b['schedule']['date'].toString());
                            return bdate.compareTo(adate);
                          });
                        }
                      }
                      // print('ini data sebelom di build => $data');
                      // print('ini snapp => $snap | ini count => $count');
                      if (snap == null || snap.isEmpty) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(16), boxShadow: [kBoxShadow]),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/no_doctor_icon.png',
                                width: MediaQuery.of(context).size.width / 5,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                'Belum ada Konsultasi',
                                style: kPoppinsMedium500.copyWith(fontSize: 13, color: kDarkBlue),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  'Buat janji konsultasi dengan dokter spesialis AlteaCare',
                                  textAlign: TextAlign.center,
                                  style: kPoppinsRegular400.copyWith(fontSize: 10, color: kLightGray),
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: (snap != null ? snap : []).length,
                          shrinkWrap: true,
                          itemBuilder: (context, idx) {
                            Map<String, dynamic> data = snap[idx] as Map<String, dynamic>;

                            // if (scrollController.position.atEdge &&
                            //     scrollController.position.pixels != 0) {
                            //   print('max scroll extent!');
                            //   count += 1;
                            //   print('ini count => $count');
                            // }
                            // // print('each => ${snap['data'][idx]}');

                            return InkWell(
                              onTap: () {
                                // if (tabController.index == 0 || tabController.index == 2) {
                                Get.toNamed('/my-consultation-detail', arguments: data['id']);
                                // }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                                decoration: BoxDecoration(color: kBackground, boxShadow: [kBoxShadow], borderRadius: BorderRadius.circular(16)),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'OrderID:',
                                              style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.3)),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            // Text(data['id'].toString()),
                                            Text(
                                              data['order_code'].toString(),
                                              style: kPoppinsSemibold600.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.8)),
                                            )
                                          ],
                                        ),
                                        Container(
                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: HexColor(data['status_detail']['bg_color'].toString()).withOpacity(0.5),
                                            ),
                                            child: Text(
                                              data['status_detail']['label'].toString(),
                                              style: kPoppinsSemibold600.copyWith(
                                                fontSize: 9,
                                                color: HexColor(data['status_detail']['text_color'].toString()),
                                              ),
                                            ))
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      height: 1,
                                      color: kLightGray,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            ExtendedImage.network(
                                              data['doctor']['photo'] == null
                                                  ? ""
                                                  : data['doctor']['photo']['formats']['thumbnail'] == null
                                                      ? ' '
                                                      : data['doctor']['photo']['formats']['thumbnail'] as String,
                                              cache: true,
                                              fit: BoxFit.contain,
                                              width: MediaQuery.of(context).size.width * 0.15,
                                              height: MediaQuery.of(context).size.width * 0.2,
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
                                            SizedBox(
                                              width: 16,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.5,
                                                  child: Container(
                                                    child: Text(
                                                      data['doctor']['name'].toString(),
                                                      softWrap: true,
                                                      style: kPoppinsSemibold600.copyWith(fontSize: 14, color: kBlackColor),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  'Sp. ${data['doctor']['specialist']['name']}',
                                                  style: kPoppinsSemibold600.copyWith(fontSize: 10, color: kDarkBlue),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundColor: tabController.index == 0 || tabController.index == 2 ? kButtonColor : kLightGray,
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: kBackground,
                                            size: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 1,
                                      color: kLightGray,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.date_range,
                                            color: kLightGray,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            helper.getDateWithMonthAbv(data['schedule']['date'].toString()),
                                            style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                          ),
                                          SizedBox(
                                            width: 24,
                                          ),
                                          Icon(
                                            Icons.schedule,
                                            color: kLightGray,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            '${data['schedule']['time_start']} - ${data['schedule']['time_end']}',
                                            style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      // print('snapshots ga ada data => ${snapshot.data}');
                      return Container();
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
