import 'package:flutter/material.dart';
import 'package:poca/models/channel_model.dart';
import 'package:poca/models/comment.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/playlist.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_provider.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/providers/user/user_provider.dart';

import '../../models/podcast.dart';

class ApiComment {
  ApiComment._privateConstructor();

  static final ApiComment _instance = ApiComment._privateConstructor();

  static ApiComment get instance => _instance;


  Future<List<Comment>> getCommentsPodcast(String idPodcast) async {
    var response = await ApiProvider().get('/comment/podcasts/$idPodcast' );
    if(response == null) return [];

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      List<Comment> data =
      (response.data as List).map((e) => Comment.fromJson(e)).toList();
      return data;
    } else {
      return [];
    }
  }

  Future<bool> addComment(Map<String, dynamic> data) async {
    var response = await ApiProvider().post('/comment', data: data);
    if (response == null) return false;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
