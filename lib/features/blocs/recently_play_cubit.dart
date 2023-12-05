import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/app_configs.dart';
import 'package:poca/models/history_podcast.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/local/history_podcast_provider.dart';
import 'package:poca/providers/preference_provider.dart';

class RecentlyPlayCubit extends Cubit<List<HistoryPodcast>> {
  RecentlyPlayCubit() : super([]);


  final local = PreferenceProvider.instance;


  load() async {
    final data = await HistoryPodcastProvider.instance.getListHistoryPodcast();

    debugPrint('=>>>>>>Data: $data');
    emit(data);
  }

}
