// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/register/presentation/modules/register/controllers/register_controller.dart';

class RegisterTnCView extends GetView<RegisterController> {
  final bool approved;
  final void Function(bool?) changeApproval;
  const RegisterTnCView({required this.approved, required this.changeApproval});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      if (sizingInformation.isMobile) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Syarat &  Ketentuan',
                style: kSubHeaderStyle,
              ),
              Container(
                height: screenHeight * 0.3,
                width: screenHeight * 0.9,
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: FutureBuilder<Map<String, dynamic>>(
                      future: controller.getTnCData(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          final result = snapshot.data;
                          return SingleChildScrollView(
                            child: HtmlWidget(
                              result!["data"][0]["text"].toString(),
                              customStylesBuilder: (_) {
                                return {'color': "0xFF606D77", 'font-size': '11px'};
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: approved,
                    onChanged: changeApproval,
                    activeColor: kButtonColor,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: screenWidth * 0.65,
                    child: Text(
                      'Dengan ini saya menyetujui Syarat dan Ketentuan yang ditetapkan oleh AlteaCare. ',
                      style: kTNCapproveStyle,
                      softWrap: true,
                    ),
                  )
                ],
              )
            ],
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Syarat &  Ketentuan',
                style: kSubHeaderStyle,
              ),
              Container(
                height: screenHeight * 0.3,
                width: screenHeight * 0.9,
                padding: const EdgeInsets.all(8),
                child: FutureBuilder<Map<String, dynamic>>(
                    future: controller.getTnCData(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        final result = snapshot.data;
                        return SingleChildScrollView(
                          child: HtmlWidget(
                            result!["data"][0]["text"].toString(),
                            customStylesBuilder: (_) {
                              return {'color': "0xFF606D77", 'font-size': '11px'};
                            },
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
              Row(
                children: [
                  Checkbox(
                    value: approved,
                    onChanged: changeApproval,
                    activeColor: kButtonColor,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: screenWidth * 0.3,
                    child: Text(
                      'Dengan ini saya menyetujui Syarat dan Ketentuan yang ditetapkan oleh AlteaCare. ',
                      style: kTNCapproveStyle,
                      softWrap: true,
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }
    });
  }
}
