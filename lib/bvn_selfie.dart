import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class BvnServiceProvider {
  final BvnServiceProviderController controller;
  static const _methodChannel = MethodChannel('bvn_selfie');
  BvnServiceProvider({required this.controller}) {
    _methodChannel.setMethodCallHandler((call) async {
      if (call.method == "showTextureView") {
        controller.onTextureCreated(call.arguments['textureId']);
        return;
      }
      if (call.method == "onError") {
        controller.onError(call.arguments['error']);
        return;
      }
      if (call.method == "image_capture") {
        controller.onImageCapture(call.arguments['imagePath']);
        return;
      }
      if (call.method == "onProgresChanged") {
        controller.onProgressChange(call.arguments['progress']);
        return;
      }
      if (call.method == "Facial_Gesture") {
        controller.gesturetEvent(call.arguments['type'] == 0
            ? DetectionType.NoFaceDetected
            : DetectionType.FaceDetected);
        return;
      }
      if (call.method == "action_gesture") {
        int actionType = call.arguments['action_type'];
        controller.actionRecongnition(actionType == 1
            ? RecongnitionType.SMILE_AND_BLINK
            : actionType == 2
                ? RecongnitionType.FROWN_ONLY
                : actionType == 3
                    ? RecongnitionType.CLOSE_AND_OPEN_SLOWLY
                    : actionType == 4
                        ? RecongnitionType.HEAD_ROTATE
                        : RecongnitionType.SMILE_AND_OPEN_ONLY);
        return;
      }
    });
  }

  Future<String?> startBvnService() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final result = await _methodChannel.invokeMethod<String>('start_camera');
      return result;
    }
    return null;
  }

  Future<String?> takePhoto() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final result = await _methodChannel.invokeMethod<String>('take_photo');
      return result;
    }
    return null;
  }

  Future<void> destroyer() async {
    await _methodChannel.invokeMethod("destroyer");
  }
}

class BvnServiceProviderController {
  final Function(String) onError;
  final Function(int) onTextureCreated;
  final Function(DetectionType) gesturetEvent;
  final Function(RecongnitionType) actionRecongnition;
  final Function(String) onImageCapture;
  final Function(int) onProgressChange;
  final Function(BvnServiceProvider) onInit;
  BvnServiceProviderController(
      {required this.onTextureCreated,
      required this.onError,
      required this.gesturetEvent,
      required this.onProgressChange,
      required this.onInit,
      required this.onImageCapture,
      required this.actionRecongnition});
}

enum DetectionType { NoFaceDetected, FaceDetected }

enum RecongnitionType {
  SMILE_AND_BLINK,
  FROWN_ONLY,
  CLOSE_AND_OPEN_SLOWLY,
  HEAD_ROTATE,
  SMILE_AND_OPEN_ONLY
}
