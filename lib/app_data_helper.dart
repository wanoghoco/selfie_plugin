import 'dart:io';

import 'package:raven_verification/bvn/enter_bvn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raven_verification/doc/doc_intro_screen.dart';

enum VerificationType { bvnVerification, docVerification }

class VerificationPlugin {
  String? clientBVN;
  final Color baseColor;
  final VerificationType type;
  final Function(dynamic) onSucess;
  final String bearerToken;
  final Function(dynamic) onFailure;
  static VerificationPlugin? _instance;

  VerificationPlugin._(
      {required this.clientBVN,
      required this.onFailure,
      this.type = VerificationType.bvnVerification,
      required this.bearerToken,
      required this.baseColor,
      required this.onSucess});

  static VerificationPlugin getInstance(
          {required String bearer,
          String? clientBvn,
          VerificationType type = VerificationType.bvnVerification,
          required Color baseColor,
          required Function(dynamic) success,
          required Function(dynamic) failiure}) =>
      VerificationPlugin._(
          type: type,
          onFailure: failiure,
          onSucess: success,
          baseColor: baseColor,
          clientBVN: clientBvn,
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

  static String? getBVN() {
    return _instance!.clientBVN;
  }

  static void setBVN(String bvn) {
    _instance?.clientBVN = bvn;
  }

  static Color getBaseColor() {
    return _instance!.baseColor;
  }

  static String getBearer() {
    return _instance!.bearerToken;
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
