import 'dart:io';

import 'package:poca/design_patterns/factory_method/alert_dialogs/android_alert_dialog.dart';
import 'package:poca/design_patterns/factory_method/alert_dialogs/ios_alert_dialog.dart';
import 'package:poca/design_patterns/factory_method/custom_dialog.dart';

class ClientAlertDialog {
  ClientAlertDialog(this.title, this.content) {
    if(Platform.isAndroid) {
      customDialog = AndroidAlertDialog(title, content);
    }
    else {
      customDialog = IosAlertDialog(title, content);
    }
  }
  late CustomDialog customDialog;
  final String title;
  final String content;

  CustomDialog get getDialog => customDialog;
}