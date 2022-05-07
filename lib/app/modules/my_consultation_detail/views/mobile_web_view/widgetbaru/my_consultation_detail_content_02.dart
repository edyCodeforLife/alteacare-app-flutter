// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/my_consultation_detail/controllers/my_consultation_detail_controller.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgetbaru/mw_cd_data_pasien.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgetbaru/mw_cd_memo_altea.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgets/mw_cd_biaya.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgets/mw_cd_dokumen_medis.dart';
import '../demo_data.dart' as ddd;

class MWConsultationDetailContent02 extends StatelessWidget {
  final MyConsultationDetailController _controller = Get.find<MyConsultationDetailController>();
  final screenWidth = Get.width;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: _controller.tabMenuMyConsultationDetail.length,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
              width: screenWidth,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                width: 1.5,
                color: kLightGray,
              ))),
              child: TabBar(
                labelColor: kDarkBlue,
                labelPadding: EdgeInsets.zero,
                unselectedLabelColor: kLightGray,
                indicatorColor: kDarkBlue,
                isScrollable: true,
                labelStyle: kPoppinsMedium500.copyWith(fontSize: 11),
                tabs: List.generate(
                  _controller.tabMenuMyConsultationDetail.length,
                  (index) => Tab(
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(_controller.tabMenuMyConsultationDetail[index]),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 1.2,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MWCDDataPasien(
                    patient: _controller.myConsultationDetail!.patient!,
                  ),
                  MWCDMemoAltea(
                    dataMedicalResume:
                        _controller.myConsultationDetail!.medicalResume == null ? null : _controller.myConsultationDetail!.medicalResume,
                    noteFromAlteaMADashbobard:
                        _controller.myConsultationDetail!.notes == null ? "" : _controller.myConsultationDetail!.notes.toString(),
                    noteFromAlteaCreatedAt:
                        _controller.myConsultationDetail!.notesAt == null ? "" : _controller.myConsultationDetail!.notesAt.toString(),
                    noteFromAlteaSender:
                        _controller.myConsultationDetail!.notesBy == null ? "" : _controller.myConsultationDetail!.notesBy.toString(),
                  ),
                  MWCDDokumenMedis(
                    dataMedicalDocs: (_controller.myConsultationDetail!.medicalDocument == null ||
                            (_controller.myConsultationDetail!.medicalDocument as List).isEmpty)
                        ? []
                        : _controller.myConsultationDetail!.medicalDocument,
                  ),
                  MWCDBiaya(
                    transaction: _controller.myConsultationDetail!.transaction == null ? null : _controller.myConsultationDetail!.transaction!,
                    fees: _controller.myConsultationDetail!.fees,
                    totalPrice: _controller.myConsultationDetail!.totalPrice,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
