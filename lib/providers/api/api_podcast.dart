import 'package:flutter/material.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_provider.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/providers/user/user_provider.dart';

import '../../models/podcast.dart';

class ApiPodcast {
  ApiPodcast._privateConstructor();

  static final ApiPodcast _instance = ApiPodcast._privateConstructor();

  static ApiPodcast get instance => _instance;

  Future<Podcast?> getPodcastByEpisodeId(String id) async {
    var response = await ApiProvider().get('/podcasts/findByEpisode/$id');
    if(response == null) return null;

    if(response.statusCode == 200) {
      return Podcast.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<List<Podcast>> getListPodcastByTopicId(String id) async {
    var response = await ApiProvider().get('/podcasts/findByTopic/$id');
    if(response == null) return [];

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      List<Podcast> podcasts =
      (response.data as List).map((e) => Podcast.fromJson(e)).toList();
      return podcasts;
    } else {
      return [];
    }
  }

  Future<List<Podcast>> searchPodcast(String text) async {
    var response = await ApiProvider().get('/podcasts/search?keyword=$text');
    if(response == null) return [];

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      List<Podcast> podcasts =
      (response.data as List).map((e) => Podcast.fromJson(e)).toList();
      return podcasts;
    } else {
      return [];
    }
  }

}