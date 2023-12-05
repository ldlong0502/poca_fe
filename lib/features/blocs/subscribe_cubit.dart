import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/models/user_model.dart';

import '../../providers/api/api_podcast.dart';

class SubscribeCubit extends Cubit<List<Podcast>> {
  SubscribeCubit() : super([]);

  load(UserModel user) async {
    var listSubscribes = await ApiPodcast.instance.getPodcastSubscribeByUserId(user.id);
    emit(listSubscribes);
  }
}
