import "package:bvn_selfie/app_data_helper.dart";
import "package:flutter/material.dart";

void showProgressContainer(BuildContext context,
    {String message = "Please Wait..."}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          SendCheapProgressContainer(message: message));
}

class SendCheapProgressContainer extends StatelessWidget {
  final String message;

  const SendCheapProgressContainer({Key? key, required this.message})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.grey[300],
          child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 12),
              child: Wrap(
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 10),
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(BVNPlugin.getBaseColor()),
                    ),
                    const SizedBox(width: 15),
                    Text(message,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: "mon_r")),
                  ])),
        ));
  }
}
