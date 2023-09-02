// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/back_button.dart';
import 'package:raven_verification/bvn/preview_screen.dart';
import 'package:raven_verification/bvn/verification_screen.dart';
import 'package:raven_verification/progress_loader.dart';
import 'package:raven_verification/server/server.dart';
import 'package:raven_verification/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:raven_verification/widget/verification_button.dart';
import 'package:raven_verification/widget/verification_textfield.dart';

class EnterBVNScreen extends StatefulWidget {
  const EnterBVNScreen({super.key});

  @override
  State<EnterBVNScreen> createState() => _EnterBVNScreenState();
}

class _EnterBVNScreenState extends State<EnterBVNScreen> {
  _EnterBVNScreenState() {
    bvnController.text = VerificationPlugin.getClientNumber() ?? "";
  }

  final bvnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            VerificationButton(
              onPressed: () async {
                if ((VerificationPlugin.getClientNumber() == null ||
                        VerificationPlugin.getClientNumber().toString().length <
                            10) &&
                    bvnController.text.length < 10) {
                  showAlert("Please enter your BVN");

                  return;
                }
                if ((VerificationPlugin.getClientNumber() == null ||
                    VerificationPlugin.getClientNumber().toString().length <
                        10)) {
                  VerificationPlugin.setClientNumber(bvnController.text);
                }
                setState(() {});
                if (VerificationPlugin.getmetaDataGetterUrl() != null) {
                  showProgressContainer(context);
                  var response = await Server(
                          key: VerificationPlugin.getmetaDataGetterUrl() ?? "",
                          isFull: true)
                      .getRequest();
                  Navigator.pop(context);
                  if (response == "failed") {
                    showAlert("something went wrong... please try again");

                    return;
                  }

                  if (response['status'] != "success") {
                    showAlert(response['message']);
                    return;
                  }
                  response = response;
                  VerificationPlugin.setMetaData(
                      jsonEncode(response['data'] ?? ""));
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VerificationScreen(
                              onCapture: (context, imagePath) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PreviewScreen(
                                              imagePath: imagePath,
                                            )));
                              },
                            )));
              },
              buttonText: "Continue to Verify",
            ),
            const SizedBox(height: 34)
          ]),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const AppBackButton(),
                    const SizedBox(height: 24),
                    Text("Enter your BVN ",
                        style: headling1.copyWith(
                          fontSize: 20,
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 12),
                    Text(
                        "We need your BVN so you can get verified on Raven bank",
                        style: subtitle.copyWith(
                            height: 1.5,
                            color: const Color(0xff646464),
                            fontSize: 14.5)),
                    const SizedBox(
                      height: 28,
                    ),
                    VerificationTextField(
                      labelText: "Enter BVN",
                      controller: bvnController,
                      hintText: "01234567899",
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.info_outline,
                            size: 20, color: Color(0xffEA872D)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                              text: TextSpan(
                                  text: "Dial ",
                                  children: const [
                                    TextSpan(
                                        text: " *565*0# ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffEA872D),
                                            fontSize: 13)),
                                    TextSpan(
                                        text:
                                            "to get your BVN Number, must be with the registered phone number.")
                                  ],
                                  style: subtitle.copyWith(fontSize: 13))),
                        )
                      ],
                    )
                  ])),
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String asset;
  final String title;
  const Item({super.key, required this.asset, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Image.asset(
                loadAsset(asset),
                color: VerificationPlugin.getBaseColor(),
                height: 54,
                width: 54,
              ),
              Image.asset(
                loadAsset("no.png"),
                height: 54,
                width: 54,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(title,
              style: subtitle.copyWith(
                  color: VerificationPlugin.getBaseColor(), fontSize: 13))
        ],
      ),
    );
  }
}
