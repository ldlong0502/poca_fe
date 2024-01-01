
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:poca/features/blocs/login_cubit.dart';
import 'package:poca/utils/helper_utils.dart';

import '../providers/api/api_auth.dart';

class NFCServices {
  NFCServices._privateConstructor();

  static final NFCServices _instance = NFCServices._privateConstructor();

  static NFCServices get instance => _instance;

  void readFromNFC(BuildContext context , LoginCubit loginCubit) async {
    final cubit = context.read<LoadingCubit>();
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      return;
    }
    try {
      var tag = await FlutterNfcKit.poll(
          timeout: const Duration(seconds: 10),
          iosMultipleTagMessage: "Multiple tags found!",
          iosAlertMessage: "Scan your tag");
      if (tag.ndefAvailable!) {
        for (var record in await FlutterNfcKit.readNDEFRecords(cached: false)) {
          if (record is ndef.UriRecord) {
            debugPrint('+>>>>>>>>${record.content}');
            cubit.update(1);
            await Future.delayed(const Duration(seconds: 1));
          }
          else if (record is ndef.TextRecord) {
            cubit.update(1);
            await Future.delayed(const Duration(seconds: 2));
            var text = record.text;
            if(text == null) return;
            var key = HelperUtils().decrypt(text);
            var username = key.split(':')[0];
            var password = key.split(':')[1];
            loginCubit.update(LoginStatus.loading);
            var res = await ApiAuthentication.instance.login(
               username, password);
            if (res) {
              loginCubit.update(LoginStatus.success);
            } else {
              loginCubit.update(LoginStatus.failed);
            }
          }
        }
      }
    }
    catch (e){
      debugPrint(e.toString());
      cubit.update(2);
    }
  }

  void writeToNFC( int type, String text , BuildContext context) async {
    //type: 0 text, 1: url
    final cubit = context.read<LoadingCubit>();
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      return;
    }
    try {
      var tag = await FlutterNfcKit.poll(
          timeout: const Duration(seconds: 5),
          iosMultipleTagMessage: "Multiple tags found!",
          iosAlertMessage: "Scan your tag");
      if (tag.ndefAvailable!) {
        if (tag.ndefWritable!) {
          if (type == 0) {
            debugPrint(text);

            await FlutterNfcKit.writeNDEFRecords([
              ndef.TextRecord(text: text ?? '', language: 'en')
            ]);
          }
          else if (type == 1) {
            await FlutterNfcKit.writeNDEFRecords([
              ndef.UriRecord.fromString('0$text')
            ]);
          }
          cubit.update(1);
        }
      }
      await FlutterNfcKit.finish();
    }
    catch (e) {
      debugPrint(e.toString());
      cubit.update(2);
    }
  }
}

class LoadingCubit extends Cubit<int> {
  LoadingCubit() : super(0);

  update(int value) {
    emit(value);
  }
}
