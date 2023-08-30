import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/back_button.dart';
import 'package:raven_verification/doc/camera_view.dart';
import 'package:raven_verification/textstyle.dart';
import 'package:flutter/material.dart';

class VerPreparation extends StatefulWidget {
  const VerPreparation({super.key});

  @override
  State<VerPreparation> createState() => _VerPreparationState();
}

class _VerPreparationState extends State<VerPreparation> {
  final bvnController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CameraView()));
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                    backgroundColor: MaterialStateProperty.all(
                        VerificationPlugin.getBaseColor())),
                child: Text(
                  "Let’s go!",
                  style: subtitle.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              )),
          const SizedBox(height: 34)
        ]),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 24),
              const AppBackButton(),
              const SizedBox(height: 34),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Let’s get you verified",
                    textAlign: TextAlign.center,
                    style: headling1.copyWith(
                      fontSize: 20,
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Please ensure you have the following requirements below to continue",
                    style: subtitle),
              ),
              const SizedBox(height: 34),
              const Item(
                title: "Prepare your valid issued Government ID",
              ),
              const SizedBox(height: 24),
              const Item(
                title: "Check if device is uncovered and working",
              ),
              const SizedBox(height: 24),
              const Item(
                title: "Take a clear photo of your ID with a good lighting",
              ),
            ])),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String title;
  const Item({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: VerificationPlugin.getBaseColor(),
                  shape: BoxShape.circle),
              height: 20,
              width: 20,
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 12,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
                child: Text(title,
                    style: subtitle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color(0xff333333)))),
            const SizedBox(
              width: 12,
            ),
          ],
        ));
  }
}
