import 'package:flutter/material.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/playlist.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_provider.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/providers/user/user_provider.dart';
import 'package:poca/utils/helper_utils.dart';

import '../../models/podcast.dart';

class ApiUser {
  ApiUser._privateConstructor();

  static final ApiUser _instance = ApiUser._privateConstructor();

  static ApiUser get instance => _instance;

  Future<bool> updateUser(String idUser, Map<String, dynamic> data) async {
    var response = await ApiProvider().update('/users/$idUser', data: data);
    if (response == null) return false;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteUser(String idUser) async {
    var response = await ApiProvider().delete('/users/$idUser');
    if (response == null) return false;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<UserModel?> getUserById(String idUser) async {
    var response = await ApiProvider().get('/users/$idUser');
    if (response == null) return null;

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    var response = await ApiProvider().get('/users');
    if(response == null) return [];

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      List<UserModel> podcasts =
      (response.data as List).map((e) => UserModel.fromJson(e)).toList();
      return podcasts;
    } else {
      return [];
    }
  }

  Future<bool> updateFCMToken(String fcmToken) async {
    print(fcmToken);
    var user = await HelperUtils.checkLogin();
    if(user == null) return false;
    var response = await ApiProvider().update('/users/${user.id}', data: {
      'fcmToken': fcmToken
    });

    print(999999999999999999);
    if (response == null) return false;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
