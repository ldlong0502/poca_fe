import 'package:flutter/material.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_provider.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/providers/user/user_provider.dart';

class ApiTopic {
  ApiTopic._privateConstructor();

  static final ApiTopic _instance = ApiTopic._privateConstructor();

  static ApiTopic get instance => _instance;

  Future<List<Topic>> getListTopics() async {
    var response = await ApiProvider().get('/topics');
    debugPrint(response.toString());
    if(response == null) return [];

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      List<Topic> topics =
      (response.data as List).map((e) => Topic.fromJson(e)).toList();
      return topics;
    } else {
      return [];
    }
  }

  Future<bool> createTopic(Map<String , dynamic> data) async {
    var response = await ApiProvider().post('/topics',data: data);
    if (response == null) return false;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteTopic(String idTopic) async {
    var response = await ApiProvider().delete('/topics/$idTopic');
    if (response == null) return false;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  Future<bool> updateTopic(String idTopic , Map<String , dynamic> data) async {
    var response = await ApiProvider().update('/topics/$idTopic' , data: data);
    if (response == null) return false;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}