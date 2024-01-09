import '../../models/podcast.dart';

abstract class PodcastList {
  Future<List<Podcast>> getPodcasts();
}
