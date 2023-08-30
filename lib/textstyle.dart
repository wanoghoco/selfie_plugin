import 'package:raven_verification/app_data_helper.dart';
import 'package:flutter/material.dart';

class RavenPayText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? align;
  final String? fontFamily;
  final TextOverflow? overflow;
  final int? maxLine;

  RavenPayText.heading(this.text,
      {super.key,
      Color? color,
      double? fontSize,
      this.align,
      this.maxLine,
      this.overflow,
      this.fontFamily})
      : style = headling1.copyWith(fontSize: fontSize, color: color);

  RavenPayText.bodyText(this.text,
      {super.key,
      Color? color,
      double? fontSize,
      this.align,
      this.maxLine,
      this.overflow,
      this.fontFamily})
      : style = bodyText.copyWith(fontSize: fontSize, color: color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      style: style,
      textAlign: align,
      overflow: overflow,
    );
  }
}

TextStyle headling1 = TextStyle(
    fontSize: 24,
    fontFamily: "br_bold",
    color: VerificationPlugin.getBaseColor(),
    package: "raven_verification");
TextStyle headling2 = TextStyle(
    fontSize: 16,
    fontFamily: "br_bold",
    color: VerificationPlugin.getBaseColor(),
    package: "raven_verification");
TextStyle bodyText = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w900,
  color: Color(0xff333333),
  package: "raven_verification",
  fontFamily: "br_regular",
);
TextStyle subtitle = const TextStyle(
  fontSize: 14,
  color: Color(0xff333333),
  fontFamily: "br_regular",
  package: "raven_verification",
);
TextStyle subtitle2 = const TextStyle(
    fontFamily: "br_regular",
    fontWeight: FontWeight.w200,
    color: Color(0xff333333),
    package: "raven_verification",
    fontSize: 12);

TextStyle caption = const TextStyle(
    fontFamily: "br_light",
    fontWeight: FontWeight.w500,
    color: Color(0xff333333),
    package: "raven_verification",
    fontSize: 12);
