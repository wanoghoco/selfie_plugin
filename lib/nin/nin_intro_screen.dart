import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/back_button.dart';
import 'package:raven_verification/doc/select_doc_type.dart';
import 'package:raven_verification/nin/enter_nin.dart';
import 'package:raven_verification/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:raven_verification/widget/verification_button.dart';

class NInIntroScreen extends StatefulWidget {
  const NInIntroScreen({super.key});

  @override
  State<NInIntroScreen> createState() => _NInIntroScreenState();
}

class _NInIntroScreenState extends State<NInIntroScreen> {
  final bvnController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 34),
            Text("Verify your National Identification Number (NIN)",
                style: headling1.copyWith(
                  fontSize: 20,
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 24),
            const Item(
              asset: "info.png",
              subTitle:
                  "We cross-reference the provided NIN with government databases to ensure data accuracy and authenticity.",
              title: "How we verify you",
            ),
            const SizedBox(height: 24),
            const Item(
              asset: "icon_secure.png",
              title: "Fast and secure",
              subTitle:
                  "You don’t have to wait long to get verified, in less than few second your details would be verified.",
            ),
            const SizedBox(height: 38),
            SizedBox(
                height: 50,
                width: double.infinity,
                child: VerificationButton(
                    onPressed: () async {
                      if (VerificationPlugin.getVerificationType() ==
                          VerificationType.ninverification) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EnterNinScreen()));
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectDocType()));
                    },
                    buttonText: "Verify Now")),
            const SizedBox(height: 28)
          ]),
        ),
        body: Stack(
          children: [
            Image.asset(loadAsset("nin_bg.png")),
            const SafeArea(
                child: Column(
              children: [
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: AppBackButton(),
                )
              ],
            ))
          ],
        ));
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
