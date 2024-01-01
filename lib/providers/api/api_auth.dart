import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_provider.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/providers/user/user_provider.dart';
import 'package:poca/utils/custom_toast.dart';

import '../../routes/app_routes.dart';

class ApiAuthentication {
  ApiAuthentication._privateConstructor();

  static final ApiAuthentication _instance = ApiAuthentication._privateConstructor();

  static ApiAuthentication get instance => _instance;

  Future<bool> login(String username, String password) async {
    var response = await ApiProvider().post('/auth/login', data:  {
      'username': username,
      'password': password,
    });
    if(response == null) return false;
    if(response.statusCode == 200) {
      debugPrint(response.toString());
      await PreferenceProvider.instance.setString('username', username);
      await PreferenceProvider.instance.setString('password', password);
      await PreferenceProvider.instance.setString('access_token', response.data['accessToken']);
      await PreferenceProvider.instance.setString('refresh_token', response.data['refreshToken']);
      await PreferenceProvider.instance.saveJsonToPrefs(response.data['data'] , 'user');

      return true;
    } else {
      return false;
    }
  }
  Future<bool> signUp(String email, String fullName , String username, String dob, String password) async {

    debugPrint(dob);
    var date  = DateFormat('dd-MM-yyyy').parse(dob);
    var response = await ApiProvider().post('/auth/register', data:  {
      "username": username,
      "email": email,
      "password": password,
      "fullName": fullName,
      "dateOfBirth": DateFormat('yyyy-MM-dd').format(date)
    });
    debugPrint(response.toString());
    if(response == null) return false;
    if(response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logOut(BuildContext context) async {
    await PreferenceProvider.instance.removeJsonToPref('username');
    await PreferenceProvider.instance.removeJsonToPref('password');
    await PreferenceProvider.instance.removeJsonToPref('access_token');
    await PreferenceProvider.instance.removeJsonToPref('refresh_token');
    await PreferenceProvider.instance.removeJsonToPref('user');
    if(context.mounted){
      CustomToast.showBottomToast(context, 'Log out successfully!');
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          AppRoutes.splash, (route) => false,);
    }
    return true;


  }

  Future<bool> changePass(String id, String newPass) async {
    var response = await ApiProvider().post('/auth/change-password/$id', data:  {
      'newPassword': newPass,
    });
    if(response == null) return false;
    if(response.statusCode == 200) {
      debugPrint(response.toString());
      await PreferenceProvider.instance.setString('password', newPass);
      return true;
    } else {
      return false;
    }
  }

  Future<String?> resetPass(String username) async {
    var response = await ApiProvider().post('/password-reset', data:  {
      'username': username,
    });
    if(response == null) return null;
    if(response.statusCode == 200) {
      debugPrint(response.toString());
      return response.data['email'];
    } else {
      return null;
    }
  }
}