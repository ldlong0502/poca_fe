import 'package:flutter/material.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_provider.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/providers/user/user_provider.dart';

class ApiLogin {
  ApiLogin._privateConstructor();

  static final ApiLogin _instance = ApiLogin._privateConstructor();

  static ApiLogin get instance => _instance;

  Future<bool> login(String username, String password) async {
    var response = await ApiProvider().post('/auth/login', data:  {
      'username': username,
      'password': password,
    });
    if(response == null) return false;
    if(response.statusCode == 200) {
      debugPrint(response.toString());
      await PreferenceProvider.setString('access_token', response.data['accessToken']);
      await PreferenceProvider.setString('refresh_token', response.data['refreshToken']);
      await PreferenceProvider.saveJsonToPrefs(response.data['data'] , 'user');

      return true;
    } else {
      return false;
    }
  }
}