import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/back_button.dart';
import 'package:raven_verification/bvn/enter_bvn.dart';
import 'package:raven_verification/textstyle.dart';
import 'package:flutter/material.dart';

class BvnIntroScreen extends StatefulWidget {
  const BvnIntroScreen({super.key});

  @override
  State<BvnIntroScreen> createState() => _BvnIntroScreenState();
}

class _BvnIntroScreenState extends State<BvnIntroScreen> {
  final bvnController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Item(
            asset: "info.png",
            subTitle:
                "We use information you provide and data about your device. to learn more , see the privacy statement",
            title: "How we verify you",
          ),
          const SizedBox(height: 24),
          const Item(
            asset: "icon_secure.png",
            title: "Fast and secure",
            subTitle: "By selecting “continue” you agree to the privacy policy",
          ),
          SizedBox(height: size.height * 0.09),
          SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EnterBVNScreen()));
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                    backgroundColor: MaterialStateProperty.all(
                        VerificationPlugin.getBaseColor())),
                child: Text(
                  "Continue to Verify",
                  style: subtitle.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              )),
          const SizedBox(height: 34)
        ]),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 24),
              const AppBackButton(),
              const SizedBox(height: 24),
              Text("Verify your bank verification number (BVN)",
                  textAlign: TextAlign.center,
                  style: headling1.copyWith(
                    fontSize: 18,
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 34),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  loadAsset("verify_img.png"),
                  //olor: VerificationPlugin.getBaseColor(),
                  height: 180,
                ),
              ),
            ])),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String asset;
  final String title;
  final String subTitle;
  const Item(
      {super.key,
      required this.asset,
      required this.title,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 34,
          width: 34,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VerificationPlugin.getBaseColor().withOpacity(0.1)),
          child: Image.asset(
            loadAsset(asset),
            color: VerificationPlugin.getBaseColor(),
            height: 54,
            width: 54,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 4),
            Text(title,
                style: headling1.copyWith(
                    color: const Color(0xff333333), fontSize: 16)),
            const SizedBox(height: 4),
            Text(subTitle,
                style: subtitle.copyWith(
                    color: const Color(0xff646464), fontSize: 13))
          ]),
        )
      ],
    );
  }
}
