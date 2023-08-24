import 'package:bvn_selfie/textstyle.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final Color? textColor;
  const AppBackButton({super.key, this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.1)),
                child: Icon(Icons.arrow_back, size: 14, color: textColor)),
            const SizedBox(
              width: 8,
            ),
            Text("Back",
                style: bodyText.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor ?? Colors.black,
                    fontSize: 14))
          ],
        ));
  }
}
