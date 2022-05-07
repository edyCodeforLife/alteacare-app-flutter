// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../data/model/search_doctor.dart';
import '../../../../routes/app_pages.dart';
import '../../../search_spesialis/controllers/search_specialist_controller.dart';
import '../../../spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';

Widget buildSearchDoctorTextField(double screenWidth) {
  return buildSearchBarMaterial(screenWidth);
}

Widget buildSearchBarMaterial(double screenWidth) {
  final spesialisController = Get.put(SpesialisKonsultasiController());
  final searchSpecialistController = Get.put(SearchSpecialistController());

  return TypeAheadField<Doctor?>(
      hideOnLoading: true,
      textFieldConfiguration: TextFieldConfiguration(
        style: kPoppinsRegular400.copyWith(
          color: hinTextColor,
          fontSize: (screenWidth < 550) ? 11 : 16,
        ),
        decoration: InputDecoration(
          prefix: const SizedBox(
            width: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide(
              color: searchBarBorderColor.withOpacity(0.7),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide(
              color: searchBarBorderColor.withOpacity(0.1),
            ),
          ),
          // focusedBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(26),
          //     borderSide: BorderSide(color: kButtonColor)),
          hintText: "Tulis keluhan atau nama dokter",
          hintStyle: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: (screenWidth < 550) ? 11 : 16),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.search,
              size: 22,
            ),
          ),
          isDense: true,
        ),
      ),
      suggestionsBoxVerticalOffset: 0,
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        elevation: 2,
        color: kBackground,
      ),
      suggestionsCallback: (pattern) async {
        final result = await searchSpecialistController.searchDoctor(pattern);

        return result.data!.doctor!.map((e) => e);
      },
      noItemsFoundBuilder: (context) {
        return SizedBox(
          height: 80,
          child: Center(
            child: Text(
              "Tidak menemukan dokter",
              style: kPoppinsMedium500.copyWith(color: hinTextColor),
            ),
          ),
        );
      },
      itemBuilder: (_, Doctor? suggestion) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: SizedBox(
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  suggestion!.photo == null
                      ? "http://cdn.onlinewebfonts.com/svg/img_148071.png"
                      : addCDNforLoadImage(suggestion.photo!.formats!.thumbnail!),
                ),
              ),
            ),
            title: Text(
              suggestion.name ?? "No data name",
              style: kPoppinsMedium500.copyWith(color: hinTextColor),
            ),
            subtitle: Text(
              suggestion.specialization!.name ?? "No Data",
              style: kPoppinsSemibold600.copyWith(
                color: kMidnightBlue,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
      onSuggestionSelected: (Doctor? suggestion) async {
        spesialisController.checkDoctorNoSchedule(doctorId: suggestion!.doctorId!);
        spesialisController.doctorInfo.value = suggestion;
        Get.toNamed("${Routes.SPESIALIS_KONSULTASI}?doctorId=${suggestion.doctorId}");
      });
}

class SearchSpecialistMWSearchBar extends StatefulWidget {
  final _SearchSpecialistMWSearchBarState state = _SearchSpecialistMWSearchBarState();
  double get screenWidth => state.screenWidth;
  FocusNode get searchBarFocus => state.searchBarFocus;
  void closeSearchBar() {
    state.searchBarFocus.unfocus();
  }

  @override
  _SearchSpecialistMWSearchBarState createState() => state;
}

class _SearchSpecialistMWSearchBarState extends State<SearchSpecialistMWSearchBar> {
  final SpesialisKonsultasiController spesialisController = Get.put(SpesialisKonsultasiController());
  final SearchSpecialistController searchSpecialistController = Get.put(SearchSpecialistController());
  final screenWidth = Get.width;
  FocusNode searchBarFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TypeAheadField<Doctor?>(
      hideOnLoading: true,
      textFieldConfiguration: TextFieldConfiguration(
        style: kPoppinsRegular400.copyWith(
          color: hinTextColor,
          fontSize: (screenWidth < 550) ? 11 : 16,
        ),
        decoration: InputDecoration(
          prefix: const SizedBox(
            width: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide(
              color: searchBarBorderColor.withOpacity(0.7),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide(
              color: searchBarBorderColor.withOpacity(0.1),
            ),
          ),
          // focusedBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(26),
          //     borderSide: BorderSide(color: kButtonColor)),
          hintText: "Tulis keluhan atau nama dokter",
          hintStyle: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: (screenWidth < 550) ? 11 : 16),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.search,
              size: 22,
            ),
          ),
          isDense: true,
        ),
      ),
      suggestionsBoxVerticalOffset: 0,
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        elevation: 2,
        color: kBackground,
      ),
      suggestionsCallback: (pattern) async {
        final result = await searchSpecialistController.searchDoctor(pattern);

        return result.data!.doctor!.map((e) => e);
      },
      noItemsFoundBuilder: (context) {
        return SizedBox(
          height: 80,
          child: Center(
            child: Text(
              "Tidak menemukan dokter",
              style: kPoppinsMedium500.copyWith(color: hinTextColor),
            ),
          ),
        );
      },
      itemBuilder: (_, Doctor? suggestion) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: SizedBox(
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  suggestion!.photo == null
                      ? "http://cdn.onlinewebfonts.com/svg/img_148071.png"
                      : addCDNforLoadImage(suggestion.photo!.formats!.thumbnail!),
                ),
              ),
            ),
            title: Text(
              suggestion.name ?? "No data name",
              style: kPoppinsMedium500.copyWith(color: hinTextColor),
            ),
            subtitle: Text(
              suggestion.specialization!.name ?? "No Data",
              style: kPoppinsSemibold600.copyWith(
                color: kMidnightBlue,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
      onSuggestionSelected: (Doctor? suggestion) async {
        spesialisController.checkDoctorNoSchedule(doctorId: suggestion!.doctorId!);
        spesialisController.doctorInfo.value = suggestion;
        Get.toNamed("${Routes.SPESIALIS_KONSULTASI}?doctorId=${suggestion.doctorId}");
      },
    );
  }
}
