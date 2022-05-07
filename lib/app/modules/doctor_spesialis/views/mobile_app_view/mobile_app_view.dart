// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/doctor_category_specialist.dart';
import 'package:altea/app/data/model/doctors.dart';
import 'package:altea/app/modules/doctor/controllers/doctor_controller.dart';
import 'package:altea/app/modules/doctor_spesialis/views/mobile_app_view/doctor_filter_panel.dart';
import 'package:altea/app/routes/app_pages.dart';

class DoctorSpesialisByCategoryMobileApp extends StatefulWidget {
  final String selectedId;

  DoctorSpesialisByCategoryMobileApp({required this.selectedId});

  @override
  _DoctorSpesialisByCategoryMobileAppState createState() => _DoctorSpesialisByCategoryMobileAppState();
}

class _DoctorSpesialisByCategoryMobileAppState extends State<DoctorSpesialisByCategoryMobileApp> {
  DoctorController doctorController = Get.find<DoctorController>();
  PanelController pc = PanelController();

  List<Datum> categoryList = [Datum(name: "Filter")];
  String id = '';
  bool init = false;
  bool isSearching = false;
  String searchQuery = '';
  String urlFilter = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.selectedId;
  }

  bool isFiltered = false;

  void clearCategory() {
    setState(() {
      id = '';
    });
  }

  void triggerFilter(bool value, String url, String sid) {
    setState(() {
      urlFilter = url;
      isFiltered = value;
      id = sid;
    });
    // print('urlFilter => $urlFilter');
  }

  @override
  Widget build(BuildContext context) {
    // print('selectedId => ${widget.selectedId}');
    return SlidingUpPanel(
      panelSnapping: true,
      minHeight: 0,
      borderRadius: const BorderRadius.only(topLeft: const Radius.circular(24), topRight: const Radius.circular(24)),
      controller: pc,
      isDraggable: true,
      panel: DoctorFilterPanel(
        clearCategory: () => setState(() => id = ''),
        pc: pc,
        selectedCategory: id,
        searchQuery: searchQuery,
        trigger: triggerFilter,
      ),
      maxHeight: MediaQuery.of(context).size.height,
      snapPoint: 0.7,
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 2,
          title: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Transform(
              transform: Matrix4.translationValues(-30.0, 0.0, 0.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                // width: MediaQuery.of(context).size.width,
                // margin: EdgeInsets.only(top: 4),
                // child: TypeAheadFormField(
                //   hideOnLoading: true,
                //   textFieldConfiguration: TextFieldConfiguration(
                //     style: kVerifText1.copyWith(color: kBlackColor),
                //     decoration: InputDecoration(
                //       hintText: 'Search...',
                //       contentPadding: EdgeInsets.only(top: 4),
                //       prefixIcon: Icon(
                //         Icons.search,
                //         color: kButtonColor,
                //       ),
                //       isDense: true,
                //       fillColor: kBackground,
                //       filled: true,
                //       border: OutlineInputBorder(borderSide: BorderSide(color: kWhiteGray, width: 2), borderRadius: BorderRadius.circular(24)),
                //       enabledBorder:
                //           OutlineInputBorder(borderSide: BorderSide(color: kWhiteGray, width: 2), borderRadius: BorderRadius.circular(24)),
                //     ),
                //   ),
                //   suggestionsBoxDecoration:
                //       SuggestionsBoxDecoration(borderRadius: BorderRadius.all(Radius.circular(26)), elevation: 2, color: kBackground),
                //   suggestionsCallback: (val) async {
                //     // if (val.isNotEmpty) {
                //     //   print('value is not empty => $val');
                //     //
                //     //   searchQuery = val;
                //     //   isSearching = true;
                //     //   isFiltered = isFiltered;
                //     //   if (!urlFilter.contains('&_q=')) {
                //     //     urlFilter = '$urlFilter${'&_q=$val'}';
                //     //   } else {
                //     //     List<String> url = urlFilter.split('&_q=');
                //     //     urlFilter = '${url[0]}&_q=$val';
                //     //   }
                //     // } else {
                //     //   print('value is empty => $val');
                //     //
                //     //   searchQuery = val;
                //     //   isSearching = false;
                //     //   isFiltered = isFiltered;
                //     //   urlFilter = urlFilter;
                //     // }
                //     return await doctorController.getDoctorsByQuery(query: val) as List;
                //   },
                //   onSuggestionSelected: (val) {
                //     print('val selected =>$val');
                //     Get.toNamed(Routes.SPESIALIS_KONSULTASI, arguments: val);
                //   },
                //   itemBuilder: (context, suggestion) {
                //     // return Container(
                //     //   width: 10,
                //     //   height: 10,
                //     //   color: Colors.red,
                //     // );
                //     return Container(
                //       width: MediaQuery.of(context).size.width * 0.4,
                //       decoration: BoxDecoration(
                //         color: kBackground,
                //       ),
                //       // borderRadius: BorderRadius.circular(16)),
                //       child: Padding(
                //         padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                //         child: Row(
                //           children: [
                //             Container(
                //               // padding: const EdgeInsets.all(8),
                //               margin: EdgeInsets.all(4),
                //               decoration: BoxDecoration(
                //                 // color: kBackground,
                //                 borderRadius: BorderRadius.circular(16),
                //               ),
                //               child: ClipRRect(
                //                 borderRadius: BorderRadius.circular(16),
                //                 child: ExtendedImage.network(
                //                   (suggestion as dynamic)['photo '] == null
                //                       ? "http://cdn.onlinewebfonts.com/svg/img_148071.png"
                //                       : addCDNforLoadImage(
                //                           (suggestion as dynamic)['photo']['formats']['thumbnail'].toString(),
                //                         ),
                //                   cache: true,
                //                   fit: BoxFit.cover,
                //                   width: MediaQuery.of(context).size.width * 0.15,
                //                   height: MediaQuery.of(context).size.width * 0.15,
                //                   borderRadius: BorderRadius.circular(16),
                //                   loadStateChanged: (ExtendedImageState state) {
                //                     if (state.extendedImageLoadState == LoadState.failed) {
                //                       return Icon(
                //                         Icons.image_not_supported_rounded,
                //                         color: kLightGray,
                //                       );
                //                     }
                //                   },
                //                 ),
                //               ),
                //             ),
                //             SizedBox(
                //               width: 16,
                //             ),
                //             Container(
                //                 width: MediaQuery.of(context).size.width * 0.3,
                //                 child: Text(
                //                   '${(suggestion as dynamic)['name']}',
                //                   softWrap: true,
                //                 )),
                //           ],
                //         ),
                //       ),
                //     );
                //
                //     // return Container(
                //     //   margin: const EdgeInsets.all(4),
                //     //   child: ListTile(
                //     //     leading: Container(
                //     //       padding: const EdgeInsets.all(8),
                //     //       decoration: BoxDecoration(
                //     //         color: kBackground,
                //     //         borderRadius: BorderRadius.circular(16),
                //     //       ),
                //     //       child: ClipRRect(
                //     //         borderRadius: BorderRadius.circular(16),
                //     //         child: ExtendedImage.network(
                //     //           suggestion!['photo']['formats']
                //     //                   ['thumbnail']
                //     //               .toString(),
                //     //           cache: true,
                //     //           fit: BoxFit.contain,
                //     //           width: MediaQuery.of(context).size.width *
                //     //               0.15,
                //     //           height:
                //     //               MediaQuery.of(context).size.width *
                //     //                   0.15,
                //     //           borderRadius: BorderRadius.circular(16),
                //     //           loadStateChanged:
                //     //               (ExtendedImageState state) {
                //     //             if (state.extendedImageLoadState ==
                //     //                 LoadState.failed) {
                //     //               return Icon(
                //     //                 Icons.error_outline,
                //     //                 color: kRedError,
                //     //               );
                //     //             }
                //     //           },
                //     //         ),
                //     //       ),
                //     //     ),
                //     //   ),
                //     // );
                //   },
                // ),
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
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: kWhiteGray, width: 2), borderRadius: BorderRadius.circular(24)),
                  ),
                  onChanged: (val) {
                    // print('value => $val');
                    if (val.isNotEmpty) {
                      // print('value is not empty => $val');
                      setState(() {
                        searchQuery = val;
                        isSearching = true;
                        isFiltered = isFiltered;
                        if (!urlFilter.contains('&_q=')) {
                          urlFilter = '$urlFilter${'&_q=$val'}';
                        } else {
                          List<String> url = urlFilter.split('&_q=');
                          urlFilter = '${url[0]}&_q=$val';
                        }
                      });
                    } else {
                      // print('value is empty => $val');
                      setState(() {
                        searchQuery = val;
                        isSearching = false;
                        isFiltered = isFiltered;
                        urlFilter = urlFilter;
                      });
                    }
                    // print('updated url filter => $urlFilter');
                    // print('isfiltered => $isFiltered');
                  },
                ),
              ),
            ),
          ),
          centerTitle: false,
          backgroundColor: kBackground,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kBlackColor,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8, left: 16),
          child: Column(
            children: [
              FutureBuilder<DoctorSpecialistCategory>(
                future: doctorController.getDoctorsOthersCategory(),
                builder: (context, snapshot) {
                  // print('isSearching ? $isSearching');
                  if (snapshot.hasData) {
                    DoctorSpecialistCategory? popularCategories;
                    popularCategories = snapshot.data;
                    if (!init) {
                      popularCategories?.data?.forEach((e) {
                        // print('e => $e');
                        categoryList.add(e);
                      });
                      init = true;
                    }

                    // print('categoryList => $categoryList');
                  }

                  // return Container();
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    padding: const EdgeInsets.all(4),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryList.length,
                      itemBuilder: (context, idx) {
                        return InkWell(
                          onTap: categoryList[idx].specializationId == null
                              ? () {
                                  pc.isPanelClosed ? pc.open() : pc.close();
                                }
                              : () {
                                  setState(() {
                                    id = categoryList[idx].specializationId.toString();
                                    isFiltered = false;
                                  });
                                  // print('id setelah di klik => $id');
                                },
                          child: categoryList[idx].specializationId == null
                              ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: isFiltered ? kDarkBlue : kBackground,
                                      borderRadius: BorderRadius.circular(36),
                                      border: Border.all(color: isFiltered ? kBackground : kLightGray, width: 1)),
                                  child: Row(
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
                                        categoryList[idx].name.toString(),
                                        style: kValidationText.copyWith(fontWeight: FontWeight.w500, color: isFiltered ? kBackground : kBlackColor),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: kBackground,
                                      borderRadius: BorderRadius.circular(36),
                                      border:
                                          Border.all(color: id == categoryList[idx].specializationId.toString() ? kDarkBlue : kLightGray, width: 1)),
                                  child: Center(
                                      child: Text(
                                    categoryList[idx].name.toString(),
                                    style: kValidationText.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: id == categoryList[idx].specializationId.toString() ? kDarkBlue : kBlackColor),
                                  )),
                                ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 2,
              ),
              FutureBuilder<Doctors>(
                future: isFiltered
                    ? doctorController.getDoctorFilteredAndSorted(urlFilter)
                    : isSearching == true
                        ? doctorController.searchDoctor(searchQuery)
                        : doctorController.getDoctorListBySpecializationAndAllHospitalFilter(selectedDoctorFilterId: id),
                builder: (context, snapshot) {
                  List<DatumDoctors> doctorsList = [];
                  if (snapshot.hasData) {
                    // print('data doctor => ${snapshot.data!.data}');
                    if (snapshot.data!.data!.isNotEmpty) {
                      doctorsList = snapshot.data!.data as List<DatumDoctors>;
                      if (isFiltered && urlFilter.contains('sort=price:asc')) {
                        doctorsList.sort((a, b) {
                          return a.price!.raw!.compareTo(b.price!.raw!);
                        });
                      } else if (isFiltered && urlFilter.contains('sort=price:desc')) {
                        doctorsList.sort((b, a) {
                          return a.price!.raw!.compareTo(b.price!.raw!);
                        });
                      } else if (isFiltered && urlFilter.contains('sort=experience:desc')) {
                        doctorsList.sort((a, b) {
                          return int.parse(a.experience!.split(' Tahun Pengalaman')[0])
                              .compareTo(int.parse(b.experience!.split(' Tahun Pengalaman')[0]));
                        });
                      } else if (isFiltered && urlFilter.contains('sort=experience:asc')) {
                        doctorsList.sort((b, a) {
                          return int.parse(a.experience!.split(' Tahun Pengalaman')[0])
                              .compareTo(int.parse(b.experience!.split(' Tahun Pengalaman')[0]));
                        });
                      }

                      return Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        margin: EdgeInsets.only(right: 12),
                        child: ListView.builder(
                          itemCount: doctorsList.length,
                          itemBuilder: (context, idx) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                boxShadow: [kBoxShadow],
                                color: kBackground,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              // padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: kBackground,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: ExtendedImage.network(
                                            doctorsList[idx].photo?.url ?? ' ',
                                            cache: true,
                                            fit: BoxFit.contain,
                                            width: MediaQuery.of(context).size.width * 0.15,
                                            height: MediaQuery.of(context).size.width * 0.15,
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
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.6,
                                            child: Text(
                                              doctorsList[idx].name!,
                                              softWrap: true,
                                              style: kButtonTextStyle.copyWith(color: kBlackColor),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            'Sp. ${doctorsList[idx].specialization!.name!}',
                                            style: kValidationText.copyWith(color: kDarkBlue, fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 2,
                                    color: kWhiteGray,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    margin: EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(color: Color(0xFFEBF7F5), borderRadius: BorderRadius.circular(16)),
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              child: Text(
                                                doctorsList[idx].experience!,
                                                style: kPswValidText.copyWith(fontWeight: FontWeight.w600, color: kButtonColor),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.symmetric(
                                                horizontal: 4,
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      ExtendedImage.network(
                                                        doctorsList[idx].hospital![0].icon == null
                                                            ? ''
                                                            : doctorsList[idx].hospital![0].icon!.formats!.thumbnail!,
                                                        width: MediaQuery.of(context).size.width * 0.07,
                                                        loadStateChanged: (ExtendedImageState state) {
                                                          if (state.extendedImageLoadState == LoadState.failed) {
                                                            return Icon(
                                                              Icons.image_not_supported_rounded,
                                                              color: kLightGray,
                                                              size: 15,
                                                            );
                                                          }
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * 0.3,
                                                        child: Text(
                                                          'RS. ${doctorsList[idx].hospital![0].name!}',
                                                          style: kPswValidText.copyWith(fontWeight: FontWeight.w600, color: kDontHaveAccColor),
                                                          softWrap: true,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.8,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Languages : ',
                                                style: kPoppinsRegular400.copyWith(fontSize: 9, color: kBlackColor.withOpacity(0.4)),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.6,
                                                child: Text(
                                                  doctorsList[idx].overview.toString(),
                                                  style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    color: kWhiteGray,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(16),
                                          child: Text(
                                            'Rp. ${NumberFormat("#,###", "en_US").format(doctorsList[idx].price!.raw)}',
                                            style: kHomeSubHeaderStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 14, color: kButtonColor),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.06,
                                          child: CustomFlatButton(
                                              width: MediaQuery.of(context).size.width / 3,
                                              text: 'Konsultasi',
                                              textStyle: kButtonTextStyle.copyWith(fontSize: 11),
                                              onPressed: () {
                                                Get.toNamed(Routes.SPESIALIS_KONSULTASI, arguments: doctorsList[idx].toJson());
                                              },
                                              color: kButtonColor),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      doctorsList = [];
                      return Container(
                        margin: EdgeInsets.only(top: 16, right: 16),
                        height: MediaQuery.of(context).size.height * 0.5,
                        // padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(boxShadow: [kBoxShadow], borderRadius: BorderRadius.circular(16), color: kBackground),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/no_doctor_icon.png',
                                width: MediaQuery.of(context).size.width / 4,
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Text(
                                'Jadwal Dokter tidak Ditemukan.',
                                style: kVerifText1.copyWith(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    // doctors = snapshot.data?.data as List<DatumDoctors>;
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
