import 'package:flutter_svg/flutter_svg.dart';
import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/back_button.dart';
import 'package:raven_verification/doc/ver_preparation.dart';
import 'package:raven_verification/textstyle.dart';
import 'package:flutter/material.dart';

class SelectDocType extends StatefulWidget {
  const SelectDocType({super.key});

  @override
  State<SelectDocType> createState() => _SelectDocTypeState();
}

class _SelectDocTypeState extends State<SelectDocType> {
  final bvnController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 24),
              const AppBackButton(),
              const SizedBox(height: 34),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Select a document to verify",
                    textAlign: TextAlign.center,
                    style: headling1.copyWith(
                      fontSize: 20,
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(height: 8),
              SvgPicture.asset(
                loadAsset("test.svg"),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Select which of the documents you would like to verify",
                    style: subtitle),
              ),
              const SizedBox(height: 34),
              const Item(
                title: "National identification number (NIN)",
              ),
              const SizedBox(height: 24),
              const Item(
                title: "Voters card",
              ),
              const SizedBox(height: 24),
              const Item(
                title: "International passport",
              ),
              const SizedBox(height: 24),
              const Item(
                title: "Driver’s license",
              ),
            ])),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const VerPreparation()));
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xffEEEEEE)),
          ),
          child: Row(
            children: [
              Image.asset(
                loadAsset("doc_icon.png"),
                color: VerificationPlugin.getBaseColor(),
                width: 28,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                  child: Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: headling1.copyWith(
                          fontSize: 16, color: const Color(0xff333333)))),
              const SizedBox(
                width: 12,
              ),
              const Icon(Icons.arrow_forward_ios, size: 12)
            ],
          )),
    );
  }
}
