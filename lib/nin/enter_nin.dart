// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/back_button.dart';
import 'package:raven_verification/bvn/verification_screen.dart';
import 'package:raven_verification/bvn/verification_succesful.dart';
import 'package:raven_verification/nin/preview_nin.dart';
import 'package:raven_verification/progress_loader.dart';
import 'package:raven_verification/server/server.dart';
import 'package:raven_verification/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:raven_verification/widget/verification_textfield.dart';

class EnterNinScreen extends StatefulWidget {
  const EnterNinScreen({super.key});

  @override
  State<EnterNinScreen> createState() => _EnterNinScreenState();
}

class _EnterNinScreenState extends State<EnterNinScreen> {
  final ninController = TextEditingController();
  var apiResponse = {};
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {});
                  if ((VerificationPlugin.getClientNumber() == null ||
                          VerificationPlugin.getClientNumber()
                                  .toString()
                                  .length <
                              10) &&
                      ninController.text.length < 10) {
                    showAlert("Please enter your NIN");

                    return;
                  }
                  if ((VerificationPlugin.getClientNumber() == null ||
                      VerificationPlugin.getClientNumber().toString().length <
                          10)) {
                    VerificationPlugin.setClientNumber(ninController.text);
                  }

                  if (VerificationPlugin.getmetaDataGetterUrl() != null) {
                    showProgressContainer(context);
                    var response = await Server(
                            key:
                                VerificationPlugin.getmetaDataGetterUrl() ?? "",
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
                    apiResponse = response;
                    VerificationPlugin.setMetaData(
                        jsonEncode(response['data'] ?? ""));
                  }

                  if ((apiResponse['data']['bvn'] ?? "") == "") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerificationScreen(
                                  onCapture: (context, imagePath) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PreviewNinScreen(
                                                  imagePath: imagePath,
                                                )));
                                  },
                                )));
                    return;
                  }
                  verifyNIN();
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                    backgroundColor: MaterialStateProperty.all(
                        VerificationPlugin.getBaseColor())),
                child: Text(
                  "Proceed to verify",
                  style: subtitle.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              )),
          const SizedBox(height: 34)
        ]),
        body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const AppBackButton(),
                    const SizedBox(height: 24),
                    Text("Enter your NIN ",
                        style: headling1.copyWith(
                          fontSize: 20,
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 12),
                    Text(
                        "We need your NIN so you can get verified on Raven bank",
                        style: subtitle.copyWith(
                            height: 1.5,
                            color: const Color(0xff646464),
                            fontSize: 14.5)),
                    const SizedBox(
                      height: 24,
                    ),
                    if (VerificationPlugin.getClientNumber() == null ||
                        VerificationPlugin.getClientNumber().toString().length <
                            10) ...[
                      VerificationTextField(
                        controller: ninController,
                        labelText: "Enter NIN",
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
                                          text: " *346# ",
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
                    ],
                  ])),
        ),
      ),
    );
  }

  verifyNIN() async {
    showProgressContainer(context);
    var response = await Server(key: "/nin/initiate_nin_with_bvn_verification")
        .postRequest({
      "bvn": apiResponse['data']['bvn'],
      "nin": VerificationPlugin.getClientNumber(),
      "meta_data": VerificationPlugin.getMetaData()
    });
    Navigator.pop(context);
    if (response.toString() == "failed") {
      showAlert("something went wrong");
      return;
    }
    if (response['status'] == "success") {
      showAlert(response['message']);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const VerificationSuccessful(
                    type: "NIN",
                  )));
      return;
    }
    showAlert(response['message']);
  }
}
