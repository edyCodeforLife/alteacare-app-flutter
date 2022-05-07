import 'package:altea/app/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle kHeaderStyle = GoogleFonts.poppins(color: kHeaderColor, fontSize: 22, fontWeight: FontWeight.w500);

TextStyle kTextHintStyle = GoogleFonts.poppins(color: kTextHintColor, fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 2);
TextStyle kTextInputStyle = kTextHintStyle.copyWith(color: const Color(0XFF606D77), letterSpacing: 2);
TextStyle kForgotTextStyle = GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 12, color: kForgotTextColor);

TextStyle kButtonTextStyle = GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14);

TextStyle kButtonTextStyle2 = GoogleFonts.poppins(color: kButtonColor, fontWeight: FontWeight.w600, fontSize: 14);
TextStyle kDontHaveAccStyle = kForgotTextStyle.copyWith(fontWeight: FontWeight.w400, color: kDontHaveAccColor);

TextStyle kErrorTextStyle = GoogleFonts.poppins(color: kRedError, fontSize: 8, fontWeight: FontWeight.w400);
TextStyle kStepperTextStyle = GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600);
TextStyle kStepperSubStyle(Color color, {double? fontSize}) => kStepperTextStyle.copyWith(fontSize: fontSize ?? 9, color: color);

TextStyle kValidationText = GoogleFonts.poppins(color: Color(0XFF606D77), fontSize: 10, fontWeight: FontWeight.w400);

TextStyle kPswValidText = GoogleFonts.poppins(
  color: kGreenColor,
  fontSize: 8,
  fontWeight: FontWeight.w400,
);

TextStyle kSubHeaderStyle = GoogleFonts.poppins(color: kSubHeaderColor, fontSize: 15, fontWeight: FontWeight.w600);

TextStyle kTNCapproveStyle = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 10, color: const Color(0xFF2B2E30));

TextStyle kTncTextStyle = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 10, color: const Color(0xFF828688));

TextStyle kSubHeaderStyleBold = GoogleFonts.poppins(color: kBlackColor, fontSize: 16, fontWeight: FontWeight.w700);
TextStyle kVerifText1 = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 11, color: const Color(0xFF606D77));

TextStyle kVerifText2 = GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12, color: const Color(0xFF454849));
TextStyle kPinStyle = GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 21, color: const Color(0xFF606D77));

TextStyle kConfirmTextStyle = GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13, color: const Color(0xFF66696B));

TextStyle kConfirmTitleStyle = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 13, color: const Color(0xFF878D93));

TextStyle kDialogTitleStyle = GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w600, color: const Color(0xFF42494E));

TextStyle kDialogSubTitleStyle = GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF42494E));
TextStyle kfloatingMenuStyle = GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF535556));

TextStyle kHomeSubHeaderStyle = GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF4F4D4D));

TextStyle kHomeSmallText = GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w600, color: const Color(0xFF3E8CB9));

TextStyle kSpesialisMenuStyle = GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w500, color: const Color(0xFF535556));

TextStyle kAppBarTitleStyle = GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xFF292B2C));

BoxShadow kBoxShadow = BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 4);
TextStyle kPoppins17 = GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: const Color(0xFF42494E));

TextStyle kPoppinsRegular400 = GoogleFonts.poppins().copyWith(fontWeight: FontWeight.w400);
TextStyle kPoppinsMedium500 = GoogleFonts.poppins().copyWith(fontWeight: FontWeight.w500);
TextStyle kPoppinsSemibold600 = GoogleFonts.poppins().copyWith(fontWeight: FontWeight.w600);
