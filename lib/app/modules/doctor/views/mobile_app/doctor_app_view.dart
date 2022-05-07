import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/spesialis_card.dart';
import 'package:altea/app/data/model/doctor_category_specialist.dart';
import 'package:altea/app/modules/doctor/controllers/doctor_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorAppView extends GetView<DoctorController> {
  final DoctorController controller = Get.put(DoctorController());
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Paling Dicari',
                style: kHomeSubHeaderStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder<DoctorSpecialistCategory>(
                future: controller.getDoctorsPopularCategory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // print('data category populer => ${snapshot.data}');
                    DoctorSpecialistCategory? popularCategories;
                    popularCategories = snapshot.data;
                    // return Container();
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      // height: MediaQuery.of(context).size.width / 3.2 * 2,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: popularCategories?.data?.length,
                        itemBuilder: (context, idx) {
                          return SpesialisCard(
                              backgroundClr: kWhiteGray,
                              imgWidth: MediaQuery.of(context).size.width / 9,
                              id: popularCategories?.data?[idx].specializationId ?? ' ',
                              onTap: () {
                                Get.toNamed('/doctor/doctor-spesialis', arguments: popularCategories?.data?[idx].specializationId);
                              },
                              width: MediaQuery.of(context).size.width / 3.2,
                              height: MediaQuery.of(context).size.width / 3.2,
                              text: popularCategories?.data?[idx].name ?? ' ',
                              img: popularCategories?.data?[idx].icon?.formats?.thumbnail ?? ' ');
                        },
                      ),
                    );
                  } else {
                    return CupertinoActivityIndicator();
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Spesialis Lainnya',
                style: kHomeSubHeaderStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder<DoctorSpecialistCategory>(
                future: controller.getDoctorsOthersCategory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // print('data category populer => ${snapshot.data}');
                    DoctorSpecialistCategory? popularCategories;
                    popularCategories = snapshot.data;
                    int? count = popularCategories?.data?.length;
                    // return Container();
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height:
                          count != null ? ((count / 3) + 1) * (MediaQuery.of(context).size.width / 3.35) : MediaQuery.of(context).size.height * 0.4,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: popularCategories?.data?.length,
                        itemBuilder: (context, idx) {
                          return SpesialisCard(
                              backgroundClr: kWhiteGray,
                              imgWidth: MediaQuery.of(context).size.width / 9,
                              id: popularCategories?.data?[idx].specializationId ?? ' ',
                              onTap: () {
                                Get.toNamed('/doctor/doctor-spesialis', arguments: popularCategories?.data?[idx].specializationId);
                              },
                              width: MediaQuery.of(context).size.width / 3.5,
                              height: MediaQuery.of(context).size.width / 3,
                              text: popularCategories?.data?[idx].name ?? ' ',
                              img: popularCategories?.data?[idx].icon?.formats?.thumbnail ?? ' ');
                        },
                      ),
                    );
                  } else {
                    return CupertinoActivityIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
