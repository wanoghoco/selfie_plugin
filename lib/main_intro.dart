import 'package:bvn_selfie/app_data_helper.dart';
import 'package:bvn_selfie/back_button.dart';
import 'package:bvn_selfie/textstyle.dart';
import 'package:bvn_selfie/verification_screen.dart';
import 'package:flutter/material.dart';

class MainIntro extends StatefulWidget {
  const MainIntro({super.key});

  @override
  State<MainIntro> createState() => _MainIntroState();
}

class _MainIntroState extends State<MainIntro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VerificationScreen()));
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                  backgroundColor:
                      MaterialStateProperty.all(BVNPlugin.getBaseColor())),
              child: Text(
                "Verify Now",
                style: subtitle.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            )),
        const SizedBox(height: 24)
      ]),
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 12),
              const AppBackButton(),
              const SizedBox(height: 24),
              Text("Take a clear selfie.",
                  style: headling1.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 8),
              Text("We need your BVN so you can get verified on Raven bank",
                  style: subtitle.copyWith(color: const Color(0xff8B8B8B))),
              const SizedBox(
                height: 24,
              ),
              Text("Tips",
                  style: subtitle.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDE8FB)),
                    color: const Color(0xffFAFAFF),
                    borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Item(
                      asset: "no_glass.png",
                      title: "No glass",
                    ),
                    Item(
                      asset: "no_mask.png",
                      title: "No face mask",
                    ),
                    Item(
                      asset: "no_hat.png",
                      title: "No hat",
                    ),
                  ],
                ),
              )
            ])),
      ),
    );
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
            children: [
              Image.asset(
                loadAsset(asset),
                color: BVNPlugin.getBaseColor(),
                height: 54,
                width: 54,
              ),
              Image.asset(
                loadAsset("no.png"),
                height: 54,
                width: 54,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(title,
              style: subtitle.copyWith(
                  color: BVNPlugin.getBaseColor(), fontSize: 13))
        ],
      ),
    );
  }
}
