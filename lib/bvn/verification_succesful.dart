import 'package:raven_verification/app_data_helper.dart';
import 'package:flutter/material.dart';

class VerificationSuccessful extends StatefulWidget {
  const VerificationSuccessful({super.key});

  @override
  State<VerificationSuccessful> createState() => _VerificationSuccessfulState();
}

class _VerificationSuccessfulState extends State<VerificationSuccessful> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                    SizedBox(height: size.height * 0.04),
                    const SizedBox(height: 24),
                    const Text("🥳Verification Successsful",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      "Your BVN verifiction was successful.. Thank You",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.04),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          loadAsset("success.png"),
                          color: VerificationPlugin.getBaseColor(),
                          height: 160,
                        ),
                        Positioned(
                          right: 0,
                          bottom: -16,
                          child: Image.asset(
                            loadAsset("check.png"),
                            height: 44,
                            width: 44,
                            color: VerificationPlugin.getBaseColor(),
                          ),
                        ),
                      ],
                    )
                  ]),
            )),
      ),
    );
  }
}
