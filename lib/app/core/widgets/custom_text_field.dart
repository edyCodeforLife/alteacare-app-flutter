// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/register/presentation/modules/register/controllers/register_controller.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final void Function(String?) onSaved;
  final String? Function(String?) validator;
  final String? Function(String?) onChanged;
  final void Function(String?)? onSubmitted;
  final bool correctPass;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> inputFormatters;
  final bool? smallBorderRadius;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;

  const CustomTextField({
    required this.onChanged,
    this.onSubmitted,
    required this.validator,
    required this.onSaved,
    required this.hintText,
    required this.keyboardType,
    this.hintStyle,
    this.smallBorderRadius = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters = const [],
    this.correctPass = false,
    this.focusNode,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hideText = false;
  TextEditingController controller = TextEditingController();
  MaskedTextController maskController = MaskedTextController(mask: '000/000');

  final RegisterController _registerController = Get.put(RegisterController());

  // @override
  // void initState() {

  //   super.initState();
  //   // setState(() {
  //   // hideText = widget.keyboardType == TextInputType.visiblePassword;
  //   // });

  //   print("hideText -> $hideText");
  // }

  bool isTempHide = false;

  @override
  Widget build(BuildContext context) {
    ScreenSize.recalculate(context);

    if (isTempHide) {
      setState(() {
        hideText = !isTempHide;
      });
    } else {
      hideText = widget.keyboardType == TextInputType.visiblePassword;
      // print("hideText -> $hideText");
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: GetPlatform.isWeb
            ? GetPlatform.isDesktop
                ? 0
                : 5
            : 5,
      ),
      child: TextFormField(
        // focusNode: FocusNode(canRequestFocus: false),
        onTap: widget.keyboardType == TextInputType.datetime
            ? () async {
                // print('date picker');
                var res = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());

                var dates = res?.toString().split(' ')[0].split('-');

                if (dates?[0] != null && dates?[1] != null && dates?[2] != null) {
                  controller.text = '${dates?[0]}-${dates?[1]}-${dates?[2]}';
                }
              }
            : null,
        textCapitalization: widget.textCapitalization,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        onChanged: (val) {
          widget.onChanged(val);
          // FocusScope.of(context).unfocus();
        },
        controller: widget.hintText == 'RT/RW (001/002)' ? maskController : controller,
        validator: widget.validator,
        focusNode: widget.focusNode,
        onSaved: (val) {
          widget.onSaved(val);
          if (_registerController.dataSaved.value) {
            widget.hintText == 'RT/RW (001/002)' ? maskController.clear() : controller.clear();
          }
        },
        style: kTextInputStyle,
        obscureText: hideText,
        readOnly: widget.keyboardType == TextInputType.datetime,
        minLines: widget.keyboardType == TextInputType.multiline ? 6 : 1,
        maxLines: widget.keyboardType == TextInputType.multiline ? null : 1,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            errorStyle: kErrorTextStyle,
            errorBorder: OutlineInputBorder(
                borderRadius: widget.smallBorderRadius! ? BorderRadius.circular(10) : BorderRadius.circular(24),
                borderSide: const BorderSide(color: kRedError, width: 1.0)),
            hintText: widget.hintText,
            hintStyle: kTextHintStyle.copyWith(
                fontSize: GetPlatform.isWeb
                    ? GetPlatform.isDesktop
                        ? 1.wb
                        : 12
                    : 12),
            fillColor: kTextFieldColor,
            filled: true,
            focusedBorder: OutlineInputBorder(
                borderRadius: widget.smallBorderRadius! ? BorderRadius.circular(10) : BorderRadius.circular(32),
                borderSide: widget.correctPass ? BorderSide(color: kGreenColor, width: 2) : BorderSide.none),
            border: OutlineInputBorder(
                borderRadius: widget.smallBorderRadius! ? BorderRadius.circular(10) : BorderRadius.circular(32),
                borderSide: widget.correctPass ? BorderSide(color: kGreenColor, width: 2) : BorderSide.none),
            suffixIcon: widget.keyboardType == TextInputType.visiblePassword
                ? IconButton(
                    color: Colors.black54,
                    icon: hideText ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        // hideText = !hideText;
                        isTempHide = !isTempHide;
                      });
                    })
                : widget.keyboardType == TextInputType.datetime
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.date_range,
                          color: kButtonColor,
                        ),
                      )
                    : null),
      ),
    );
  }
}
