// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/helper.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/patient_data_model.dart';

class PatientDataCard extends StatefulWidget {
  final Patient patientData;
  final int idx;
  final int? selected;
  final void Function() onTap;

  PatientDataCard({
    required this.patientData,
    this.selected,
    required this.idx,
    required this.onTap,
  });

  @override
  _PatientDataCardState createState() => _PatientDataCardState();
}

class _PatientDataCardState extends State<PatientDataCard> {
  bool isExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        padding: EdgeInsets.only(top: 20, bottom: 16, left: 16, right: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [kBoxShadow],
            color: widget.selected == widget.idx ? kLightBlue : kBackground,
            border: Border.all(width: 2, color: widget.selected == widget.idx ? kDarkBlue : kBackground)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.patientData.firstName} ${widget.patientData.lastName}',
                      style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kBlackColor),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      '${widget.patientData.age == null ? 0 : widget.patientData.age!.year} Tahun',
                      style: kPoppinsRegular400.copyWith(color: kBlackColor.withOpacity(0.7), fontSize: 11),
                    )
                  ],
                ),
                IconButton(
                    icon: Icon(isExpanded ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined),
                    onPressed: () => setState(() => isExpanded = !isExpanded))
              ],
            ),
            if (isExpanded)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: kWhiteGray,
                    margin: EdgeInsets.only(top: 8, bottom: 10, right: 12),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Jenis Kelamin     :', style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.5))),
                            SizedBox(
                              width: 4,
                            ),
                            Text(widget.patientData.gender == 'MALE' ? 'Laki - Laki' : 'Perempuan',
                                style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor)),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text('Tempat Lahir      :', style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.5))),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                                '${widget.patientData.birthPlace == null ? " " : widget.patientData.birthPlace}, ${widget.patientData.birthCountry == null ? " " : widget.patientData.birthCountry?.name}',
                                style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor)),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text('Tanggal Lahir     :', style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.5))),
                            SizedBox(
                              width: 4,
                            ),
                            Text(getDateWithMonthAbv2(widget.patientData.birthDate.toString()),
                                style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor)),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('No. KTP                  :', style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.5))),
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(widget.patientData.cardId.toString(), style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Alamat                  :', style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.5))),
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                  "${widget.patientData.street == null ? "" : "Jl. ${widget.patientData.street!}"}, ${widget.patientData.rtRw == null ? " " : "RT/RW + ${widget.patientData.rtRw!}"},  ${widget.patientData.subDistrict == null ? " " : "Kel. ${widget.patientData.subDistrict!.name}"}, ${widget.patientData.district == null ? "" : " Kec.${widget.patientData.district!.name}"} ${widget.patientData.city == null ? "" : widget.patientData.city!.name} ${widget.patientData.province == null ? " " : widget.patientData.province!.name} ${widget.patientData.subDistrict == null ? " " : widget.patientData.subDistrict!.postalCode}",
                                  style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor)),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Text('Jenis Kelamin     :',
                        //         style: kPoppinsRegular400.copyWith(
                        //             fontSize: 10,
                        //             color: kBlackColor.withOpacity(0.5))),
                        //     SizedBox(
                        //       width: 4,
                        //     ),
                        //     Container(
                        //       width: MediaQuery.of(context).size.width * 0.6,
                        //       child: Text(widget.patientData.addressId,
                        //           style: kPoppinsRegular400.copyWith(
                        //               fontSize: 10, color: kBlackColor)),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Container()
          ],
        ),
      ),
    );
  }
}
