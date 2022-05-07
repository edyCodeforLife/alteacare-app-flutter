// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';

class CustomDropdownField extends StatefulWidget {
  final List<DropdownMenuItem<dynamic>> items;
  final value;
  final void Function(dynamic) onChanged;
  final void Function()? onTapped;
  final String? Function(dynamic) validator;
  final String hintText;
  final String? Function(dynamic) onSaved;
  final double? borderRadius;
  final Widget? icon;
  CustomDropdownField({
    required this.items,
    required this.onSaved,
    required this.validator,
    required this.onChanged,
    required this.hintText,
    required this.value,
    this.borderRadius,
    this.icon,
    this.onTapped,
  });
  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  // FocusNode dropDownFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: DropdownButtonFormField(
          onTap: () {
            try {
              FocusManager.instance.primaryFocus?.unfocus();
            } catch (e) {
              // print("unfocus failed $e");
            }
          },
          onSaved: widget.onSaved,
          validator: widget.validator,
          style: kTextInputStyle,
          value: widget.value,
          items: widget.items,
          icon: widget.icon,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              errorStyle: kErrorTextStyle,
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 32), borderSide: BorderSide(color: kRedError, width: 1.0)),
              hintText: widget.hintText,
              hintStyle: kTextHintStyle.copyWith(fontSize: 12),
              fillColor: kTextFieldColor,
              filled: true,
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(widget.borderRadius ?? 32), borderSide: BorderSide.none)),
        ));
  }
}
