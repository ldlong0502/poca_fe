import 'package:flutter/material.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_provider.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/providers/user/user_provider.dart';

import '../../models/podcast.dart';

class ApiEpisode {
  ApiEpisode._privateConstructor();

  static final ApiEpisode _instance = ApiEpisode._privateConstructor();

  static ApiEpisode get instance => _instance;

  Future<Episode?> getEpisodeLatest() async {
    var response = await ApiProvider().get('/podcasts/latest-episode');
    debugPrint(response.toString());
    if(response == null) return null;

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      return Episode.fromJson(response.data);
    } else {
      return null;
    }
  }

}