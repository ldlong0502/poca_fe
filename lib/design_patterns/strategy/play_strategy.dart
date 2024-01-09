import 'package:poca/models/podcast.dart';

abstract class PlayStrategy {
  void playPodcast(Podcast podcast, int index);
}
