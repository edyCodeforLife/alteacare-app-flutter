import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/profile_faq/controllers/profile_faq_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

class ProfileFAQMobileView extends StatefulWidget {
  @override
  _ProfileFAQMobileViewState createState() => _ProfileFAQMobileViewState();
}

class _ProfileFAQMobileViewState extends State<ProfileFAQMobileView> {
  ProfileFaqController controller = Get.put(ProfileFaqController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          title: Text(
            'FAQ',
            style: kAppBarTitleStyle,
          ),
          centerTitle: true,
          backgroundColor: kBackground,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: kBlackColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(24),
          child: FutureBuilder(
              future: controller.getFAQ(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List faqList = (snapshot.data! as Map<String, dynamic>)['data'] as List;
                  // print('faq => $faqList');
                  return ListView.builder(
                    itemCount: faqList.length,
                    itemBuilder: (context, idx) {
                      return FAQCard(text: faqList[idx]['answer'].toString(), title: faqList[idx]['question'].toString(), idx: idx);
                    },
                  );
                } else {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              }),
        ));
  }
}

class FAQCard extends StatefulWidget {
  String text;
  String title;
  int idx;

  FAQCard({required this.text, required this.title, required this.idx});
  @override
  _FAQCardState createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kWhiteGray, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  widget.title,
                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_rounded,
                  color: kBlackColor,
                ),
              ),
            ],
          ),
          if (isExpanded)
            Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: kBlackColor.withOpacity(0.2),
                ),
                SizedBox(
                  height: 8,
                ),
                HtmlWidget(
                  widget.text,
                  textStyle: kPoppinsRegular400.copyWith(color: kBlackColor.withOpacity(0.5), fontSize: 9),
                )
              ],
            )
          else
            Container()
        ],
      ),
    );
  }
}
