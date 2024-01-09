import 'package:poca/models/podcast.dart';
import 'package:poca/providers/api/api_podcast.dart';

import 'i_podcast_list.dart';

class BasicPodcastList implements PodcastList {
  @override
  Future<List<Podcast>> getPodcasts() async {
    return await ApiPodcast.instance.getAllPodcasts();
  }
}