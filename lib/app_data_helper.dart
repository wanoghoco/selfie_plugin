import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:raven_verification/bvn/enter_bvn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raven_verification/doc/doc_intro_screen.dart';
import 'package:raven_verification/nin/nin_intro_screen.dart';

enum VerificationType { bvnVerification, docVerification, ninverification }

class VerificationPlugin {
  String? clientNumber;
  final Color baseColor;
  final VerificationType type;
  final String? metaDataGetterUrl;
  final Function(dynamic) onSucess;
  final String bearerToken;
  final String? initToken;
  final Function(dynamic) onFailure;
  static VerificationPlugin? _instance;
  String? metaData;

  VerificationPlugin._(
      {required this.clientNumber,
      required this.onFailure,
      this.initToken,
      this.metaDataGetterUrl,
      this.type = VerificationType.bvnVerification,
      required this.bearerToken,
      this.metaData,
      required this.baseColor,
      required this.onSucess});

  static VerificationPlugin getInstance(
          {required String bearer,
          String? clientNumber,
          String? metaData,
          String? initToken,
          VerificationType type = VerificationType.bvnVerification,
          required Color baseColor,
          String? metaDataGetterUrl,
          required Function(dynamic) success,
          required Function(dynamic) failiure}) =>
      VerificationPlugin._(
          type: type,
          onFailure: failiure,
          metaData: metaData,
          initToken: initToken,
          metaDataGetterUrl: metaDataGetterUrl,
          onSucess: success,
          baseColor: baseColor,
          clientNumber: clientNumber,
          bearerToken: bearer);

  static Future<void> startPlugin(
      BuildContext context, VerificationPlugin instance) async {
    _instance = instance;
    await Navigator.push(
      context,
      PageRouteBuilder(
        settings: const RouteSettings(name: "bvn_service"),
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) =>
            (instance.type == VerificationType.bvnVerification)
                ? const EnterBVNScreen()
                : (instance.type == VerificationType.ninverification)
                    ? const NInIntroScreen()
                    : const DocIntroScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );

    return;
  }

  static String? getClientNumber() {
    return _instance!.clientNumber;
  }

  static void setClientNumber(String number) {
    _instance?.clientNumber = number;
  }

  static void setMetaData(String metaData) {
    _instance?.metaData = metaData;
  }

  static String? getmetaDataGetterUrl() {
    return _instance?.metaDataGetterUrl;
  }

  static Map getMetaData() {
    try {
      var data = jsonDecode(_instance?.metaData ?? "");
      return data;
    } catch (ex) {
      return {};
    }
  }

  static String? getIniToken() {
    return _instance?.initToken;
  }

  static Color getBaseColor() {
    return _instance!.baseColor;
  }

  static String getBearer() {
    return _instance!.bearerToken;
  }

  static VerificationType getVerificationType() {
    return _instance!.type;
  }

  static Future<void> closePlugin(BuildContext context, bool success,
      {dynamic payload}) async {
    if (success) {
      Navigator.of(context).popUntil(ModalRoute.withName("bvn_service"));
      Navigator.pop(context);
      _instance!.onSucess(payload);
      return;
    }
    Navigator.of(context).popUntil(ModalRoute.withName("bvn_service"));
    Navigator.pop(context);
    _instance!.onFailure(payload);
    return;
  }
}

String loadAsset(String asset) {
  return "packages/raven_verification/asset/$asset";
}

Future<File> compressImage({required File file}) async {
  Directory tempDir = await getTemporaryDirectory();
  String dir = "${tempDir.absolute.path}/bvn_photo.jpeg";
  var result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    dir,
    quality: 60,
  );

  return result!;
}

showAlert(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: VerificationPlugin.getBaseColor(),
      textColor: Colors.white,
      fontSize: 16.0);
}
