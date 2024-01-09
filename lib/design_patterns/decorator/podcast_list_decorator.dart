import '../../models/podcast.dart';
import 'i_podcast_list.dart';

abstract class PodcastListDecorator implements PodcastList {
  late PodcastList wrappe;

  PodcastListDecorator(PodcastList podcastList) {
    wrappe = podcastList;
  }

  PodcastList get podcastList => wrappe;


}