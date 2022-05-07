// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/styles.dart';

class TransactionDataWidgetMyConsultation extends StatelessWidget {
  const TransactionDataWidgetMyConsultation({
    Key? key,
    required this.dataTitle,
    required this.dataDescription,
  }) : super(key: key);
  final String dataTitle;
  final String dataDescription;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            dataTitle,
            style: kPoppinsRegular400.copyWith(fontSize: 14, color: kLightGray),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  dataDescription,
                  style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor),
                  softWrap: true,
                ),
              ),
              const Spacer()
            ],
          ),
        )
      ],
    );
  }
}
