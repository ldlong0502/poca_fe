
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:poca/features/blocs/login_cubit.dart';
import 'package:poca/utils/helper_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/api/api_auth.dart';

class FCMServices {
  FCMServices._privateConstructor();

  static final FCMServices _instance = FCMServices._privateConstructor();

  static FCMServices get instance => _instance;

  void sendNotification( String title, String body, String clickMessage , String token) async {
    try {
      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] =
      'key=AAAAxCT30J0:APA91bHPCq2Mi6mi-Hwuit3v2MBc9EkUesFLh7gHru2ZLxC4pr_bjQmAVDYpy_TI_MRDRouaYnVU4J6mxeZWqVRakcXbzbVAm-ZZswe6kx7c0onBX2mOIW-rmDLYjGloI4P3YV3hC_CY'; // Replace with your FCM server key

      Map<String, dynamic> notification = {
        'title': title,
        'body': body,
      };

      Map<String, dynamic> message = {
        'notification': notification,
        "data": {
          "click_action": clickMessage,
          "sound": "default",
        },
        'to': token,
      };

      Response response = await dio.post(
        'https://fcm.googleapis.com/fcm/send',
        data: message,
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

}
