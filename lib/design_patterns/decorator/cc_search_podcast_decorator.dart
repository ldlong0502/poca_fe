import 'package:poca/design_patterns/decorator/podcast_list_decorator.dart';
import 'package:poca/models/podcast.dart';

import 'i_podcast_list.dart';

class SearchablePodcastListDecorator extends PodcastListDecorator {
  SearchablePodcastListDecorator(PodcastList podcastList, this.query) : super(podcastList);
  final String query;


  @override
  Future<List<Podcast>> getPodcasts()  async {
    return (await podcastList.getPodcasts())
        .where((podcast) => podcast.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}