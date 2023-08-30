import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/back_button.dart';
import 'package:raven_verification/bvn/bvn_selfie.dart';
import 'package:raven_verification/textstyle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BvnSelfieView extends StatefulWidget {
  final Function(String) onImageCapture;
  final Function(String) onError;
  final Function(BvnServiceProvider) onInit;
  final bool allowTakePhoto;

  const BvnSelfieView(
      {super.key,
      required this.onImageCapture,
      required this.onError,
      required this.allowTakePhoto,
      required this.onInit});

  @override
  State<BvnSelfieView> createState() => _BvnSelfieViewState();
}

class _BvnSelfieViewState extends State<BvnSelfieView>
    with SingleTickerProviderStateMixin {
  bool enabled = false;
  late AnimationController _animationController;
  String? actionText;
  late BvnServiceProvider instance;
  double count = 0;
  double before = 0;

  Color surfaceColor = Colors.red;
  int? textureId;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) {
        enabled = true;
        if (mounted) {
          setState(() {});
        }
      }
    });
    instance = BvnServiceProvider(
        controller: BvnServiceProviderController(
      onProgressChange: (progress) {
        before = count;
        count = progress * 0.25;
        setState(() {});
      },
      onTextureCreated: (textureID) {
        textureId = textureID;
        if (mounted) {
          setState(() {});
        }
      },
      gesturetEvent: (DetectionType type) {
        if (type == DetectionType.NoFaceDetected) {
          surfaceColor = Colors.red;
          if (mounted) {
            setState(() {});
          }
          return;
        }
        if (type == DetectionType.FaceDetected) {
          surfaceColor = Colors.transparent;
          if (mounted) {
            setState(() {});
          }
          return;
        }
      },
      actionRecongnition: (RecongnitionType recongnitionType) {
        if (recongnitionType == RecongnitionType.SMILE_AND_BLINK) {
          actionText = "SMILE AND BLINK";
          if (mounted) {
            setState(() {});
          }
          return;
        }
        if (recongnitionType == RecongnitionType.FROWN_ONLY) {
          actionText = "FROWN FACE";
          setState(() {});
          return;
        }
        if (recongnitionType == RecongnitionType.CLOSE_AND_OPEN_SLOWLY) {
          actionText = "CLOSE AND OPEN EYE SLOWLY";
          if (mounted) {
            setState(() {});
          }
          return;
        }
        if (recongnitionType == RecongnitionType.HEAD_ROTATE) {
          actionText = "ROTATE HEAD SLOWLY";
          setState(() {});
          return;
        }
        if (recongnitionType == RecongnitionType.SMILE_AND_OPEN_ONLY) {
          if (mounted) {
            actionText = "☺️ SMILE ☺️";
          }
          setState(() {});
        }
      },
      onImageCapture: widget.onImageCapture,
      onError: widget.onError,
      onInit: widget.onInit,
    ));

    instance.startBvnService();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    widget.onInit(instance);
    super.initState();
  }

  String loadAsset(String asset) {
    return "packages/bvn_selfie/asset/$asset";
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    Size size = MediaQuery.of(context).size;
    if (textureId == null && TargetPlatform.android == defaultTargetPlatform) {
      return const SizedBox();
    } else {
      return SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
            ),
            Positioned(
              top: size.height * 0.03,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: size.width * 0.82,
                    width: size.width * 0.82,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: textureId != null
                            ? surfaceColor
                            : Colors.transparent),
                  ),
                  Image.asset(
                    loadAsset("frame_cover.png"),
                    color: surfaceColor == Colors.transparent
                        ? VerificationPlugin.getBaseColor()
                        : surfaceColor,
                    width: size.width * 0.85,
                  ),
                  Container(
                      height: size.width * 0.76,
                      width: size.width * 0.76,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: textureId != null
                              ? Colors.transparent
                              : Colors.transparent),
                      child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: before, end: count),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, _) =>
                              CircularProgressIndicator(
                                strokeWidth: 24,
                                color: surfaceColor != Colors.transparent
                                    ? Colors.transparent
                                    : VerificationPlugin.getBaseColor(),
                                value: value,
                              ))),
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.8,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: SizedBox(
                          height: size.width * 0.74,
                          width: size.width * 0.74,
                          child: AspectRatio(
                              aspectRatio: size.width / (size.width * 1.9),
                              child: defaultTargetPlatform ==
                                      TargetPlatform.android
                                  ? Texture(textureId: textureId!)
                                  : UiKitView(
                                      viewType: "bvnview_cam",
                                      creationParams: creationParams,
                                      creationParamsCodec:
                                          const StandardMessageCodec(),
                                    )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                top: size.height * 0.03,
                left: 20,
                child: const AppBackButton(textColor: Color(0xffEEEEEE))),
            Positioned(
              top: size.height * 0.14,
              child: Text(
                (actionText ?? "PLACE YOUR FACE PROPERLY").toUpperCase(),
                style: bodyText.copyWith(
                    fontSize: 18,
                    color: const Color(0xffEEEEEE),
                    fontWeight: FontWeight.w900),
              ),
            ),
            if (widget.allowTakePhoto &&
                enabled &&
                TargetPlatform.android == defaultTargetPlatform) ...[
              Positioned(
                  bottom: size.height * 0.1,
                  child: GestureDetector(
                    onTap: () {
                      instance.takePhoto();
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          loadAsset("shutter.png"),
                          height: 54,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text("You Can Take Shot Now...",
                            style: TextStyle(
                              color: Color(0xffEEEEEE),
                            ))
                      ],
                    ),
                  )),
            ],
            Positioned(
                top: size.height * 0.75,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xffEDE8FB).withOpacity(0.1)),
                      color: const Color(0xffFAFAFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Item(
                        asset: "no_glass.png",
                        title: "No Glass",
                      ),
                      Item(
                        asset: "no_mask.png",
                        title: "No Face Mask",
                      ),
                      Item(
                        asset: "no_hat.png",
                        title: "No Hat",
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    textureId = null;
    _animationController.dispose();
    super.dispose();
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
            alignment: Alignment.center,
            children: [
              Image.asset(
                loadAsset(asset),
                color: VerificationPlugin.getBaseColor(),
                height: 40,
                width: 40,
              ),
              Image.asset(
                loadAsset("no.png"),
                height: 44,
                width: 44,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(title,
              style: subtitle.copyWith(color: Colors.white, fontSize: 12))
        ],
      ),
    );
  }
}
