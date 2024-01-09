import 'package:poca/design_patterns/decorator/podcast_list_decorator.dart';
import 'package:poca/models/podcast.dart';

import 'i_podcast_list.dart';

class SortablePodcastListDecorator extends PodcastListDecorator {
  SortablePodcastListDecorator(PodcastList podcastList) : super(podcastList);

  @override
  Future<List<Podcast>> getPodcasts() async {
    var list  = (await podcastList.getPodcasts());
    list.sort((a,b) => b.publishDate.compareTo(a.publishDate));
    return list;
  }
}
