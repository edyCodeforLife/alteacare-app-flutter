// import 'package:altea/app/core/utils/colors.dart';
// import 'package:altea/app/core/utils/styles.dart';
// import 'package:altea/app/modules/my_consultation_detail/controllers/my_consultation_detail_controller.dart';
// import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgets/mw_cd_biaya.dart';
// import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgets/mw_cd_data_pasien.dart';
// import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgets/mw_cd_dokumen_medis.dart';
// import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgets/mw_cd_memo_altea.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../demo_data.dart' as ddd;

// class MWConsultationDetailContent02 extends StatelessWidget{
//   final MyConsultationDetailController _controller = Get.find<MyConsultationDetailController>();
//   final screenWidth = Get.width;


//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: _controller.tabMenuMyConsultationDetail.length,
//       child: ListView(
//         physics: const NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         children: [
//           Container(
//             width: screenWidth,
//             decoration: BoxDecoration(
//                 border: Border(
//                     bottom: BorderSide(
//                       width: 1.5,
//                       color: kLightGray,
//                     ))),
//             child: TabBar(
//               labelColor: kDarkBlue,
//               labelPadding: EdgeInsets.zero,
//               unselectedLabelColor: kLightGray,
//               indicatorColor: kDarkBlue,
//               isScrollable: true,
//               labelStyle: kPoppinsMedium500.copyWith(fontSize: 11),
//               tabs: List.generate(
//                 _controller.tabMenuMyConsultationDetail.length,
//                     (index) => Tab(

//                   child: Container(
//                     alignment: Alignment.center,
//                     width: 100,
//                     padding: const EdgeInsets.symmetric(horizontal: 5),
//                     child: Text(_controller.tabMenuMyConsultationDetail[index]),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: Get.height * 1.2,
//             child: TabBarView(
//               physics: const NeverScrollableScrollPhysics(),
//               children: [
//                 MWCDDataPasien(data: _controller.data,),
//                 MWCDMemoAltea(
//                   dataMedicalResume: _controller.data["medical_resume"] == null ? ddd.memoAltea  : _controller.data["medical_resume"] as Map<String, dynamic>,
//                   noteFromAlteaMADashbobard: _controller.data['notes'] == null ? "" : _controller.data['notes'].toString(),
//                   noteFromAlteaCreatedAt: _controller.data['notes_at'] == null ? "" : _controller.data['notes-at'].toString() ,
//                   noteFromAlteaSender: _controller.data['notes_by'] == null ? {} : _controller.data['notes_by'] as Map<String, dynamic>,
//                 ),
//                 MWCDDokumenMedis(dataMedicalDocs: (_controller.data["medical_document"] == null || (_controller.data["medical_document"] as List).isEmpty ) ? [] : _controller.data["medical_document"] as List,),
//                 MWCDBiaya(dataBiaya: _controller.data["transaction"] == null ? null : _controller.data,),
//               ],
//             ),
//           )
//         ],
//       )
//     );
//   }
// }