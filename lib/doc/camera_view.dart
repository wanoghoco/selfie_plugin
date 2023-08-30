import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/back_button.dart';
import 'package:raven_verification/doc/upload_photo.dart';
import 'package:raven_verification/textstyle.dart';

/// Camera example home widget.
class CameraView extends StatefulWidget {
  /// Default Constructor
  const CameraView({super.key});

  @override
  State<CameraView> createState() {
    return _CameraViewState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
}

class _CameraViewState extends State<CameraView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;

  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  bool confirm = false;
  bool flashState = true;
  final List<XFile> docPhotos = [];
  bool isBusy = false;
  bool flashSet = false;
  // Counting pointers (number of user fingers on screen)

  @override
  void initState() {
    super.initState();
    _initCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    int cameraIndex = 0;
    for (var i = 0; i < cameras.length; i++) {
      if (cameras[i].lensDirection == CameraLensDirection.back) {
        cameraIndex = i;
        break;
      }
    }
    final CameraController cameraController = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    controller!.initialize();
    cameraController.addListener(() {
      if (!flashSet) {
        controller!.setFlashMode(FlashMode.off);
        flashSet = true;
      }
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        Fluttertoast.showToast(
            msg: 'Camera error ${cameraController.value.errorDescription}');
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: AppBackButton(
                  textColor: Colors.white,
                )),
            const SizedBox(height: 20),
            if (!confirm) ...[
              Text(
                  docPhotos.isEmpty
                      ? "Take front photo of your ID"
                      : "Take back photo of ID",
                  style: subtitle.copyWith(color: Colors.white, fontSize: 16)),
            ] else ...[
              Center(
                child: Text("Proceed to use this photo ?",
                    style:
                        subtitle.copyWith(color: Colors.white, fontSize: 16)),
              ),
            ],
            const SizedBox(height: 20),
            Expanded(child: confirm ? _photoPreview() : _cameraPreviewWidget()),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: confirm
                    ? [
                        InkWell(
                            onTap: () {
                              docPhotos.removeAt(docPhotos.length - 1);
                              reset();
                              confirm = false;
                              setState(() {});
                            },
                            child: SizedBox(
                                height: 38,
                                width: 38,
                                child: Image.asset(
                                  loadAsset("cancel.png"),
                                  color: Colors.white,
                                  height: 38,
                                  width: 38,
                                ))),
                        const Expanded(
                          child: SizedBox(
                            height: 64,
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              if (docPhotos.length > 1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const UploadPhoto()));
                                return;
                              }
                              reset();
                              confirm = false;
                              setState(() {});
                            },
                            child: const SizedBox(
                                height: 38,
                                width: 38,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 36,
                                ))),
                      ]
                    : [
                        GestureDetector(
                          onTap: () {
                            _toggleFlashlight();
                          },
                          child: Image.asset(
                            loadAsset(isCameraFlashOn()
                                ? "flash_on.png"
                                : "flash.png"),
                            height: 38,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (isBusy) {
                                return;
                              }
                              isBusy = true;
                              var file = await controller!.takePicture();
                              flashState = false;
                              if (controller!.value.flashMode ==
                                  FlashMode.torch) {
                                flashState = true;
                              }
                              controller!.setFlashMode(FlashMode.off);
                              docPhotos.add(file);
                              isBusy = false;
                              confirm = true;
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            child: Image.asset(
                              loadAsset("shutter.png"),
                              height: 64,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: "rotation not supported");
                          },
                          child: Image.asset(
                            loadAsset("rotate.png"),
                            color: Colors.grey,
                            height: 38,
                          ),
                        ),
                      ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void reset() {
    if (flashState) {
      controller!.setFlashMode(FlashMode.torch);
    }
  }

  void _toggleFlashlight() async {
    if (controller == null) {
      return;
    }
    try {
      await controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
      if (controller!.value.flashMode == FlashMode.off) {
        await controller!.setFlashMode(FlashMode.torch);
      } else {
        await controller!.setFlashMode(FlashMode.off);
      }
      setState(() {});
    } catch (e) {
      print('Error toggling flashlight: $e');
    }
  }

  bool isCameraFlashOn() {
    if (controller == null) {
      return false;
    }
    if (controller!.value.flashMode == FlashMode.torch) {
      return true;
    }
    return false;
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized) {
      return const SizedBox();
    } else {
      return Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: CameraPreview(
              controller!,
            ),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0) +
                const EdgeInsets.symmetric(horizontal: 24),
            child: Image.asset(loadAsset("doc_preview.png")),
          ))
        ],
      );
    }
  }

  Widget _photoPreview() {
    if (controller == null || !controller!.value.isInitialized) {
      return const SizedBox();
    } else {
      return SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Image.file(
          File(docPhotos[docPhotos.length - 1].path),
          height: double.infinity,
          width: double.infinity,
        ),
      );
    }
  }
}
