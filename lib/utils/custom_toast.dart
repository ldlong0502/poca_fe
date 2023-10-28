import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uni_wave/utils/resizable.dart';

import '../configs/constants.dart';

class CustomToast {
  static void showBottomToast(BuildContext context, String text) {
    final fToast = FToast()..init(context);
    Widget toast = Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.size(context, 20),
            vertical: Resizable.size(context, 5)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: whiteColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.asset(
                'assets/icons/ic_logo.png',
                height: Resizable.size(context, 30),
              ),
            ),
            const SizedBox(width: 5,),
            Flexible(
              child: AutoSizeText(
                text,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 1),
    );
  }
}