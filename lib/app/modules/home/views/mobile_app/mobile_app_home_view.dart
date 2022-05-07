import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/helper.dart' as helper;
import 'package:altea/app/core/utils/hexColor_toColor.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/doctor/controllers/doctor_controller.dart';
import 'package:altea/app/modules/home/views/mobile_app/widget/homepage_profile_card.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/build_mobile_spesialis_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_promo.dart';
import 'package:altea/app/routes/app_pages.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class MobileAppHomeView extends GetView<DoctorController> {
  DoctorController controller = Get.find<DoctorController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomepageProfileCard(),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              color: kBackground,
              boxShadow: [kBoxShadow],
            ),
            padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16),
            // margin: EdgeInsets.all(16,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), spreadRadius: 1, blurRadius: 1)],
                            borderRadius: BorderRadius.circular(24)),
                        child: TypeAheadFormField(
                          hideOnLoading: true,
                          textFieldConfiguration: TextFieldConfiguration(
                            style: kVerifText1.copyWith(color: kBlackColor),
                            decoration: InputDecoration(
                                hintText: 'Tulis Keluhan atau Nama Dokter',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: kButtonColor,
                                ),
                                isDense: true,
                                fillColor: kBackground,
                                filled: true,
                                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(24))),
                          ),
                          suggestionsBoxDecoration:
                              SuggestionsBoxDecoration(borderRadius: BorderRadius.all(Radius.circular(26)), elevation: 2, color: kBackground),
                          suggestionsCallback: (val) async {
                            return await controller.getDoctorsByQuery(query: val) as List;
                          },
                          onSuggestionSelected: (val) {
                            // print('val selected =>$val');
                            Get.toNamed(Routes.SPESIALIS_KONSULTASI, arguments: val);
                          },
                          noItemsFoundBuilder: (context) {
                            return Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Tidak ada Dokter yang sesuai',
                                style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor),
                              ),
                            );
                          },
                          itemBuilder: (context, suggestion) {
                            // return Container(
                            //   width: 10,
                            //   height: 10,
                            //   color: Colors.red,
                            // );
                            return Container(
                              decoration: BoxDecoration(
                                color: kBackground,
                              ),
                              // borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      // padding: const EdgeInsets.all(8),
                                      margin: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        // color: kBackground,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: ExtendedImage.network(
                                          (suggestion as dynamic)['photo'] == null
                                              ? "http://cdn.onlinewebfonts.com/svg/img_148071.png"
                                              : addCDNforLoadImage(
                                                  (suggestion as dynamic)['photo']['formats']['thumbnail'].toString(),
                                                ),
                                          cache: true,
                                          fit: BoxFit.cover,
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
                                      width: 16,
                                    ),
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.55,
                                        child: Text(
                                          '${(suggestion as dynamic)!['name']}',
                                          softWrap: true,
                                        )),
                                  ],
                                ),
                              ),
                            );

                            // return Container(
                            //   margin: const EdgeInsets.all(4),
                            //   child: ListTile(
                            //     leading: Container(
                            //       padding: const EdgeInsets.all(8),
                            //       decoration: BoxDecoration(
                            //         color: kBackground,
                            //         borderRadius: BorderRadius.circular(16),
                            //       ),
                            //       child: ClipRRect(
                            //         borderRadius: BorderRadius.circular(16),
                            //         child: ExtendedImage.network(
                            //           suggestion!['photo']['formats']
                            //                   ['thumbnail']
                            //               .toString(),
                            //           cache: true,
                            //           fit: BoxFit.contain,
                            //           width: MediaQuery.of(context).size.width *
                            //               0.15,
                            //           height:
                            //               MediaQuery.of(context).size.width *
                            //                   0.15,
                            //           borderRadius: BorderRadius.circular(16),
                            //           loadStateChanged:
                            //               (ExtendedImageState state) {
                            //             if (state.extendedImageLoadState ==
                            //                 LoadState.failed) {
                            //               return Icon(
                            //                 Icons.error_outline,
                            //                 color: kRedError,
                            //               );
                            //             }
                            //           },
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                        // TextField(
                        //   style: kVerifText1.copyWith(color: kBlackColor),
                        //   decoration: InputDecoration(
                        //       hintText: 'Tulis Keluhan atau Nama Dokter',
                        //       prefixIcon: Icon(
                        //         Icons.search,
                        //         color: kButtonColor,
                        //       ),
                        //       isDense: true,
                        //       fillColor: kBackground,
                        //       filled: true,
                        //       border: OutlineInputBorder(
                        //           borderSide: BorderSide.none,
                        //           borderRadius: BorderRadius.circular(24))),
                        // ),
                      ),
                    ),
                    Container(padding: const EdgeInsets.only(left: 8, top: 16), child: MobilePromo()),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 12,
                      ),
                      child: buildMobileSpesialisMenu(context),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8, top: 24, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Konsultasi Saya',
                            style: kHomeSubHeaderStyle,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          FutureBuilder(
                              future: controller.getOngoingAppointment(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if ((snapshot.data as Map)['data'] == null) {
                                    return Container();
                                  } else if (((snapshot.data as Map)['data'] as List).isEmpty) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 2),
                                      padding: const EdgeInsets.all(30),
                                      decoration: BoxDecoration(boxShadow: [kBoxShadow], borderRadius: BorderRadius.circular(16), color: kBackground),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Image.asset(
                                              'assets/no_doctor_icon.png',
                                              width: MediaQuery.of(context).size.width / 6,
                                            ),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            Text(
                                              'Belum ada jadwal konsultasi',
                                              style: kVerifText1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    final List datas = ((snapshot.data as Map)['data'] as List);
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      height: 210,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: datas.length < 5 ? datas.length : 5,
                                        separatorBuilder: (c, i) {
                                          return const SizedBox(
                                            width: 15,
                                          );
                                        },
                                        itemBuilder: (c, i) {
                                          Map data = datas[i] as Map;
                                          return InkWell(
                                            onTap: () {
                                              Get.toNamed('/my-consultation-detail', arguments: data['id']);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                right: 2,
                                                left: 2,
                                              ),
                                              decoration:
                                                  BoxDecoration(color: kBackground, boxShadow: [kBoxShadow], borderRadius: BorderRadius.circular(16)),
                                              // padding: EdgeInsets.all(16),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    // color: Colors.blue,
                                                    width: MediaQuery.of(context).size.width * 0.7,
                                                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Order ID:',
                                                              style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.3)),
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              data['order_code'].toString(),
                                                              style: kPoppinsSemibold600.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.8)),
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 2,
                                                    color: kWhiteGray,
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            ExtendedImage.network(
                                                              data['doctor']['photo']['formats']['thumbnail'] == null
                                                                  ? ' '
                                                                  : data['doctor']['photo']['formats']['thumbnail'] as String,
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
                                                            const SizedBox(
                                                              width: 16,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                SizedBox(
                                                                  width: MediaQuery.of(context).size.width * 0.4,
                                                                  child: Text(
                                                                    data['doctor']['name'].toString(),
                                                                    softWrap: true,
                                                                    style: kPoppinsSemibold600.copyWith(fontSize: 14, color: kBlackColor),
                                                                  ),
                                                                ),
                                                                const SizedBox(
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
                                                          backgroundColor: kButtonColor,
                                                          child: const Icon(
                                                            Icons.arrow_forward_ios,
                                                            color: kBackground,
                                                            size: 12,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 2,
                                                    color: kWhiteGray,
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                    // padding: EdgeInsets.all(4),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.date_range,
                                                          color: kLightGray,
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          helper.getDateWithMonthAbv(
                                                            data['schedule']['date'].toString(),
                                                          ),
                                                          style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                                        ),
                                                        const SizedBox(
                                                          width: 24,
                                                        ),
                                                        Icon(
                                                          Icons.schedule,
                                                          color: kLightGray,
                                                        ),
                                                        const SizedBox(
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
                                      ),
                                    );
                                  }
                                } else {
                                  return const Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                }
                                // return Container(
                                //   padding: EdgeInsets.all(30),
                                //   decoration: BoxDecoration(boxShadow: [kBoxShadow], borderRadius: BorderRadius.circular(16), color: kBackground),
                                //   child: Center(
                                //     child: Column(
                                //       children: [
                                //         Image.asset(
                                //           'assets/no_doctor_icon.png',
                                //           width: MediaQuery.of(context).size.width / 6,
                                //         ),
                                //         const SizedBox(
                                //           height: 17,
                                //         ),
                                //         Text(
                                //           'Belum ada jadwal konsultasi',
                                //           style: kVerifText1,
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // );
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
