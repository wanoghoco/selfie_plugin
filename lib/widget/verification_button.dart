import 'package:flutter/material.dart';
import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/textstyle.dart';

class VerificationButton extends StatelessWidget {
  final String buttonText;
  final Function() onPressed;
  const VerificationButton(
      {super.key, required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => onPressed(),
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
              backgroundColor:
                  MaterialStateProperty.all(VerificationPlugin.getBaseColor())),
          child: Text(
            buttonText,
            style: subtitle.copyWith(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));
  }
}
