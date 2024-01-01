import 'package:flutter/material.dart';
import 'package:poca/models/channel_model.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/playlist.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_provider.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/providers/user/user_provider.dart';

import '../../models/podcast.dart';

class ApiChannel {
  ApiChannel._privateConstructor();

  static final ApiChannel _instance = ApiChannel._privateConstructor();

  static ApiChannel get instance => _instance;

  Future<ChannelModel?> getChannelById(String id) async {
    var response = await ApiProvider().get('/channel/$id');
    debugPrint(response.toString());
    if(response == null) return null;

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      return ChannelModel.fromJson(response.data);
    } else {
      return null;
    }
  }
  Future<ChannelModel?> getChannelByUser(String idUser) async {
    var response = await ApiProvider().get('/channel/find-by-user/$idUser');
    debugPrint(response.toString());
    if(response == null) return null;

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      return ChannelModel.fromJson(response.data);
    } else {
      return null;
    }
  }
  Future<bool> addOrRemoveUserSubscribe(String idChannel, String idUser , String type ) async {
    print(idChannel);
    print(idUser);
    print(type);
    var response = await ApiProvider().post('/channel/$idChannel/$type-subscribe/$idUser');

    print(response);
    if(response == null) return false;

    if(response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<ChannelModel?> addChannel(Map<String, dynamic> data ) async {
    var response = await ApiProvider().post('/channel/add', data: data);
    if(response == null) return null;

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      return ChannelModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<ChannelModel?> updateChannel(String idChannel, Map<String, dynamic> data ) async {
    var response = await ApiProvider().update('/channel/$idChannel', data: data);
    if(response == null) return null;

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      return ChannelModel.fromJson(response.data);
    } else {
      return null;
    }
  }


  Future<List<ChannelModel>> getAllChannels() async {
    var response = await ApiProvider().get('/channel');
    debugPrint(response.toString());
    if(response == null) return [];

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      List<ChannelModel> topics =
      (response.data as List).map((e) => ChannelModel.fromJson(e)).toList();
      return topics;
    } else {
      return [];
    }
  }

  Future<bool> deleteChannel(String id ) async {
    var response = await ApiProvider().delete('/channel/$id');
    if(response == null) return false;

    if(response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
