import 'package:flutter/cupertino.dart';

import '../custom_dialog.dart';

class IosAlertDialog extends CustomDialog {
  const IosAlertDialog(this.title, this.content);
  final String title;
  final String content;
  @override
  String getTitle() => title;

  @override
  Widget create(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(getTitle()),
      content: Text(content),
      actions: <Widget>[
        CupertinoButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Close'),
        ),
      ],
    );
  }
}