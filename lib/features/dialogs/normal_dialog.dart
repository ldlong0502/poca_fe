
import 'package:flutter/material.dart';

import '../../configs/constants.dart';
import '../../utils/resizable.dart';

class NormalDialog extends StatelessWidget {
  const NormalDialog({super.key, required this.onYes, required this.onCancel, required this.title, required this.content});
  final Function() onYes;
  final Function() onCancel;
  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      title: Center(
        child: Column(
          children: [
            Text(title, style: TextStyle(
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
            Row(
              children: [
                Expanded(
                  child: TextButton(onPressed: onCancel,
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(const BorderSide(color: primaryColor))
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Cancel' , style: TextStyle(fontWeight: FontWeight.w600),)
                        ],
                      )),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: TextButton(onPressed: onYes,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all( primaryColor)
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Yes' , style: TextStyle(fontWeight: FontWeight.w600 ,color: Colors.white),)
                        ],
                      )),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}