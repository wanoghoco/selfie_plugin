import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/back_button.dart';
import 'package:raven_verification/textstyle.dart';
import 'package:flutter/material.dart';

class UploadPhoto extends StatefulWidget {
  const UploadPhoto({super.key});

  @override
  State<UploadPhoto> createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  final bvnController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  VerificationPlugin.closePlugin(context, false);
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                    backgroundColor: MaterialStateProperty.all(
                        VerificationPlugin.getBaseColor())),
                child: Text(
                  "Let’s go!",
                  style: subtitle.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              )),
          const SizedBox(height: 34)
        ]),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      width: size.width,
                    ),
                    const AppBackButton(),
                    const SizedBox(height: 34),
                    Align(
                      child: Text("Your identity is being verified",
                          textAlign: TextAlign.center,
                          style: headling1.copyWith(
                            fontSize: 20,
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(loadAsset("doc_icon.png"),
                                  color: VerificationPlugin.getBaseColor()),
                              const SizedBox(
                                height: 16,
                              ),
                              Text("Document uploading",
                                  style: headling1.copyWith(
                                      fontSize: 18, color: Colors.black)),
                              const SizedBox(height: 24),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: LinearProgressIndicator(
                                  backgroundColor:
                                      VerificationPlugin.getBaseColor()
                                          .withOpacity(0.2),
                                  color: VerificationPlugin.getBaseColor(),
                                ),
                              )
                            ]),
                      ),
                    )
                  ]),
            )),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String title;
  const Item({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: VerificationPlugin.getBaseColor(),
                  shape: BoxShape.circle),
              height: 20,
              width: 20,
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 12,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
                child: Text(title,
                    style: subtitle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color(0xff333333)))),
            const SizedBox(
              width: 12,
            ),
          ],
        ));
  }
}
