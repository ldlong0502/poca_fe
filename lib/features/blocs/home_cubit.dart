import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/models/channel_model.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/providers/api/api_channel.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/providers/api/api_topic.dart';

class HomeCubit extends Cubit<int> {
  HomeCubit() : super(0) {
    load();
  }
  List<Topic> listTopics = [];
  List<ChannelModel> listChannels = [];
  Episode? latestEpisode;
  Podcast? podcastContainLatestEpisode;
  load() async {
    listTopics = await ApiTopic.instance.getListTopics();
    listChannels = await ApiChannel.instance.getAllChannels();
    latestEpisode = await ApiEpisode.instance.getEpisodeLatest();
    if(latestEpisode != null) {
      podcastContainLatestEpisode = await ApiPodcast.instance.getPodcastByEpisodeId(latestEpisode!.id);
    }
    if(isClosed) return;
    emit(state+1);
  }
}
