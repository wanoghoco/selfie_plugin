import 'dart:io';

import 'package:bvn_selfie/main_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class BVNPlugin {
  final String clientBVN;
  final Color baseColor;
  final Function(dynamic) onSucess;
  final String bearerToken;
  final Function(dynamic) onFailure;
  static BVNPlugin? _instance;

  BVNPlugin._(
      {required this.clientBVN,
      required this.onFailure,
      required this.bearerToken,
      required this.baseColor,
      required this.onSucess});

  static BVNPlugin getInstance(
          {required String bearer,
          required String clientBvn,
          required Color baseColor,
          required Function(dynamic) success,
          required Function(dynamic) failiure}) =>
      BVNPlugin._(
          onFailure: failiure,
          onSucess: success,
          baseColor: baseColor,
          clientBVN: clientBvn,
          bearerToken: bearer);

  static Future<void> startPlugin(
      BuildContext context, BVNPlugin bvnInstance) async {
    _instance = bvnInstance;
    await Navigator.push(
      context,
      PageRouteBuilder(
        settings: const RouteSettings(name: "bvn_service"),
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => const MainIntro(),
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

  static String getBVN() {
    return _instance!.clientBVN;
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
  return "packages/bvn_selfie/asset/$asset";
}

Future<XFile> compressImage({required File file}) async {
  Directory tempDir = await getTemporaryDirectory();
  String dir = "${tempDir.absolute.path}/bvn_photo.jpeg";
  var result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    dir,
    quality: 60,
  );

  return result!;
}
