import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/profile-tnc/controllers/profile_tnc_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

class TncMobileView extends GetView<ProfileTncController> {
  String tncText =
      '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget varius facilisisasdd fermentum id eget dui consectetur purus tristique. Lectus ut vitae praesentss augue. Nibh morbi at magnis adipiscing. Morbi aliquam suspendisse vitae at at arcu. Sed elementum at in fusce habitant duis. Facilisi sit egestas at nisl pretium, turpis viverra. Ullamcorper blandit a quisque a platea et purus ullamcorper
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget varius facilisisasdd fermentum id eget dui consectetur purus tristique. Lectus ut vitae praesentss augue. Nibh morbi at magnis adipiscing. Morbi aliquam suspendisse vitae at at arcu. Sed elementum at in fusce habitant duis. Facilisi sit egestas at nisl pretium, turpis viverra. Ullamcorper blandit a quisque a platea et purus ullamcorper
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget varius facilisisasdd fermentum id eget dui consectetur purus tristique. Lectus ut vitae praesentss augue. Nibh morbi at magnis adipiscing. Morbi aliquam suspendisse vitae at at arcu. Sed elementum at in fusce habitant duis. Facilisi sit egestas at nisl pretium, turpis viverra. Ullamcorper blandit a quisque a platea et purus ullamcorper
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget varius facilisisasdd fermentum id eget dui consectetur purus tristique. Lectus ut vitae praesentss augue. Nibh morbi at magnis adipiscing. Morbi aliquam suspendisse vitae at at arcu. Sed elementum at in fusce habitant duis. Facilisi sit egestas at nisl pretium, turpis viverra. Ullamcorper blandit a quisque a platea et purus ullamcorper
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget varius facilisisasdd fermentum id eget dui consectetur purus tristique. Lectus ut vitae praesentss augue. Nibh morbi at magnis adipiscing. Morbi aliquam suspendisse vitae at at arcu. Sed elementum at in fusce habitant duis. Facilisi sit egestas at nisl pretium, turpis viverra. Ullamcorper blandit a quisque a platea et purus ullamcorper

  ''';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 2,
        title: Text(
          'Syarat & Ketentuan',
          style: kAppBarTitleStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 32),
          child: FutureBuilder(
              future: controller.getTNC(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: HtmlWidget(
                      (snapshot.data! as Map<String, dynamic>)['data'][0]['text'].toString(),
                      textStyle: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.7)),
                    ),
                  );
                } else {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
