

import 'package:poca/models/user_model.dart';
import 'dart:convert';
import '../providers/preference_provider.dart';

class HelperUtils {

  static Future<UserModel?> checkLogin()  async {
    var user = await PreferenceProvider.instance.getJsonFromPrefs("user");
    if(user != null) return UserModel.fromJson(user);
    return null;
  }


  String encrypt(String plaintext) {
    return base64.encode(utf8.encode(plaintext));
  }

  String decrypt(String ciphertext) {
    return utf8.decode(base64.decode(ciphertext));
  }

}