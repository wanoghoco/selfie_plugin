// ignore_for_file: use_build_context_synchronously

import 'package:bvn_selfie/app_data_helper.dart';
import 'package:bvn_selfie/bvn_selfie.dart';
import 'package:bvn_selfie/bvn_selfie_view.dart';
import 'package:bvn_selfie/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late BvnServiceProvider provider;
  @override
  Widget build(BuildContext appContext) {
    return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: BvnSelfieView(
          allowTakePhoto: false,
          onImageCapture: (imagePath) async {
            provider.destroyer();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageViewScreen(
                          imagePath: imagePath,
                        )));
          },
          onError: (String errorLog) {
            Fluttertoast.showToast(
                msg: errorLog,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: BVNPlugin.getBaseColor(),
                textColor: Colors.white,
                fontSize: 16.0);
          },
          onInit: (BvnServiceProvider provider) {
            this.provider = provider;
          },
        ));
  }
}
