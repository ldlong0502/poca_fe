import 'package:flutter/material.dart';

import '../../../configs/constants.dart';
import '../../../utils/resizable.dart';
import '../custom_dialog.dart';

class AndroidAlertDialog extends CustomDialog {
  const AndroidAlertDialog(this.title, this.content);
  final String title;
  final String content;
  @override
  String getTitle() => title;

  @override
  Widget create(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      title: Center(
        child: Column(
          children: [
            Text(getTitle(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Resizable.font(context, 20),
                  color: textColor,
                  fontWeight: FontWeight.w700
              ),),
            const SizedBox(height: 20,),
            Text(content,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Resizable.font(context, 14),
                  color: secondaryColor,
                  fontWeight: FontWeight.w600
              ),),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 20),
          vertical: Resizable.padding(context, 20)
      ).copyWith(top: 0),
      actions: [
        Column(
          children: [
            Divider(
              color: Colors.grey.shade400,
              thickness: 1,
            ),
            TextButton(onPressed: () {
              Navigator.pop(context);
            },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Close' , style: TextStyle(fontWeight: FontWeight.w600 , color: Colors.black , fontSize: 20),)
                  ],
                )),
          ],
        )
      ],
    );
  }
}