import 'package:raven_verification/app_data_helper.dart';
import 'package:flutter/material.dart';
import 'package:raven_verification/textstyle.dart';

class VerificationSuccessful extends StatefulWidget {
  final String type;
  const VerificationSuccessful({super.key, this.type = "BVN"});

  @override
  State<VerificationSuccessful> createState() => _VerificationSuccessfulState();
}

class _VerificationSuccessfulState extends State<VerificationSuccessful> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  VerificationPlugin.closePlugin(context, true);
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                    backgroundColor: MaterialStateProperty.all(
                        VerificationPlugin.getBaseColor())),
                child: const Text("Done"),
              )),
          const SizedBox(height: 24)
        ]),
        body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.06),
                      const SizedBox(height: 24),
                      Text("🥳Verification Sumitted",
                          style: subtitle.copyWith(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        "You will be notified once your ${widget.type} verification process is completed.",
                        textAlign: TextAlign.center,
                        style: subtitle.copyWith(),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Image.asset(
                        loadAsset("success_image.png"),
                        width: size.width,
                      ),
                    ]),
              )),
        ),
      ),
    );
  }
}
