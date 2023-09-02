import 'package:flutter/material.dart';
import 'package:raven_verification/textstyle.dart';

class VerificationTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isRequired;
  final String? labelText;
  final String? hintText;
  final TextStyle? hintStyle;
  const VerificationTextField(
      {super.key,
      required this.controller,
      this.labelText,
      this.hintStyle,
      this.hintText,
      this.isRequired = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (labelText != null) ...[
          Row(
            children: [
              Text(labelText!,
                  style: subtitle.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff333333),
                      fontSize: 14)),
              if (isRequired) ...[
                Text(" *",
                    style: subtitle.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                        fontSize: 14)),
              ]
            ],
          ),
          const SizedBox(
            height: 4,
          ),
        ],
        TextField(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            keyboardType: TextInputType.number,
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: hintStyle ?? subtitle.copyWith(color: Colors.grey),
                fillColor: const Color(0xFFF4F4F4),
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFF4F4F4), width: 0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFF4F4F4), width: 0)),
                border: InputBorder.none)),
      ],
    );
  }
}
