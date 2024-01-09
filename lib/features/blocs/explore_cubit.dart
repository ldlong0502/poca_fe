import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/providers/api/api_topic.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/utils/helper_utils.dart';

import '../../design_patterns/decorator/decorator.dart';

class ExploreCubit extends Cubit<int> {
  ExploreCubit() : super(0) {
    load();
  }
  List<Podcast> listPodcast = [];
  Episode? latestEpisode;
  Podcast? podcastContainLatestEpisode;
  bool isFocus = false;
  bool isSearching = false;
  load() async {
    listPodcast = await getHistorySearch();
    if(isClosed) return;
    emit(state+1);
  }

  Future<List<Podcast>> getHistorySearch() async {
    var user = await HelperUtils.checkLogin();
    var idUser = user == null ? 'local': user.id;
    var json = await PreferenceProvider.instance.getString('${idUser}_explore_history_search');

    print('=>>>>>> $json');
    if(json.isEmpty) {
      return [];
    }
    List<Podcast> podcasts =
    (jsonDecode(json) as List).map((e) => Podcast.fromJson(e)).toList();
    return podcasts;
  }

  addPodcast(Podcast podcast) async {
    var listHistory = await getHistorySearch();
    final index =
    listHistory.map((e) => e.id).toList().indexOf(podcast.id);
    if (index != -1) {
      return;
    }
    listHistory.insert(0, podcast);
    if(listHistory.length > 4) {
      listHistory.removeAt(listHistory.length - 1);
    }
    final json = jsonEncode(listHistory);
    var user = (await HelperUtils.checkLogin());
    var idUser = user == null ? 'local' : user.id;
    await PreferenceProvider.instance.setString( '${idUser}_explore_history_search', json);

    load();
  }

  removePodcast(Podcast podcast) async {
    var listHistory = await getHistorySearch();
    final index =
    listHistory.map((e) => e.id).toList().indexOf(podcast.id);
    if (index != -1) {
      listHistory.removeAt(index);
    }
    final json = jsonEncode(listHistory);
    var user = (await HelperUtils.checkLogin());
    var idUser = user == null ? 'local' : user.id;
    await PreferenceProvider.instance.setString('${idUser}_explore_history_search', json);

    load();
  }

  removeAll() async {
    var user = (await HelperUtils.checkLogin());
    var idUser = user == null ? 'local' : user.id;
    await PreferenceProvider.instance.removeJsonToPref('${idUser}_explore_history_search');

    load();
  }
  updateFocus(bool value) {
    isFocus = value;
    emit(state+1);
  }
  searchPodcasts(String searchText) async {
    if(searchText.isEmpty) {
      isSearching = false;
      listPodcast = await getHistorySearch();
    }
    else {
      isSearching = true;
      PodcastList basicPodcastList = BasicPodcastList();
      PodcastList searchableAndSortableList = SortablePodcastListDecorator(
          SearchablePodcastListDecorator(basicPodcastList, searchText));
      listPodcast =  await searchableAndSortableList.getPodcasts();
    }
    emit(state+1);
  }
}
