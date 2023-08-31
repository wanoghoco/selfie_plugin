// ignore_for_file: use_build_context_synchronously

import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/platform_view/selfie_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raven_verification/platform_view/selfie_view.dart';

class VerificationScreen extends StatefulWidget {
  final Function(BuildContext, String) onCapture;
  const VerificationScreen({super.key, required this.onCapture});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late SelfieServiceProvider provider;
  @override
  Widget build(BuildContext appContext) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SelfieView(
            allowTakePhoto: false,
            onImageCapture: (imagePath) async {
              provider.destroyer();
              widget.onCapture(context, imagePath);
            },
            onError: (String errorLog) {
              Fluttertoast.showToast(
                  msg: errorLog,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: VerificationPlugin.getBaseColor(),
                  textColor: Colors.black,
                  fontSize: 16.0);
            },
            onInit: (SelfieServiceProvider provider) {
              this.provider = provider;
            },
          )),
    );
  }
}
