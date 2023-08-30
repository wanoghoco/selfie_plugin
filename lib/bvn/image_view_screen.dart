// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/progress_loader.dart';
import 'package:raven_verification/bvn/verification_screen.dart';
import 'package:raven_verification/bvn/verification_succesful.dart';
import 'package:raven_verification/server/server.dart';
import 'package:raven_verification/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageViewScreen extends StatefulWidget {
  final String imagePath;
  const ImageViewScreen({super.key, required this.imagePath});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      onVerify();
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                        backgroundColor: MaterialStateProperty.all(
                            VerificationPlugin.getBaseColor())),
                    child: Text(
                      "Use this selfie",
                      style: subtitle.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  )),
              const SizedBox(height: 24),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const VerificationScreen()));
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                        backgroundColor: MaterialStateProperty.all(
                            VerificationPlugin.getBaseColor())),
                    child: Text(
                      "Re-take selfie",
                      style: subtitle.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  )),
              const SizedBox(height: 34)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              const SizedBox(height: 34),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Take a clear selfie",
                    style: headling1.copyWith(
                      fontSize: 20,
                      color: VerificationPlugin.getBaseColor(),
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Ensure that your entire face is clearly visible within the provided frame.",
                    style: subtitle.copyWith(
                        fontSize: 14, color: const Color(0xff8B8B8B))),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                  height: size.height * 0.4,
                  width: double.infinity,
                  child: Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.contain,
                  )),
              const SizedBox(
                height: 24,
              ),
              Text("Is this clear enough?",
                  style: bodyText.copyWith(color: Colors.black)),
              const SizedBox(
                height: 4,
              ),
              Text(
                  "Make sure your face is clear enough and the photo is not blurry",
                  textAlign: TextAlign.center,
                  style: subtitle.copyWith(color: const Color(0xff8B8B8B))),
              const SizedBox(
                height: 16,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  onVerify() async {
    showProgressContainer(context);

    Map<String, dynamic> form = {
      "token": VerificationPlugin.getBVN(),
      "type": "bvn"
    };
    String filePath = (await compressImage(file: File(widget.imagePath))).path;
    var response = await Server(key: "").uploadFile(filePath, form);
    Navigator.pop(context);
    try {
      Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: VerificationPlugin.getBaseColor(),
          textColor: Colors.white,
          fontSize: 16.0);
      if (response['status'] == "success") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const VerificationSuccessful()));
        return;
      }
    } catch (ex) {}
  }
}
