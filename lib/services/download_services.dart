import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poca/configs/app_configs.dart';
import 'package:poca/models/download_episode.dart';
import 'package:poca/models/history_podcast.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/local/history_podcast_provider.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/utils/helper_utils.dart';

import '../models/episode.dart';

class DownloadService {
  DownloadService._privateConstructor();

  static final DownloadService _instance =
      DownloadService._privateConstructor();

  static DownloadService get instance => _instance;

  final local = PreferenceProvider.instance;

  Future<List<EpisodeDownLoad>> getListEpisodeDownLoad() async {
    var user = (await HelperUtils.checkLogin());
    var idUser = user == null ? 'local' : user.id;
    var response =
        await local.getString(idUser + AppConfigs.KEY_DOWNLOAD_EPISODE);

    if (response.isEmpty) {
      return [];
    } else {
      List<EpisodeDownLoad> podcasts = (jsonDecode(response) as List)
          .map((e) => EpisodeDownLoad.fromJson(e))
          .toList();
      podcasts.sort((a, b) => b.dateDown.compareTo(a.dateDown));
      return podcasts;
    }
  }

  addDownload(Episode item, String path) async {
    var listDown = await getListEpisodeDownLoad();
    final index = listDown.map((e) => e.item.id).toList().indexOf(item.id);
    if (index != -1) {
      Fluttertoast.showToast(msg: 'This episode has already downloaded');
      return;
    }
    var downItem = EpisodeDownLoad(
        item: item,
        path: path,
        dateDown: DateTime.now().millisecondsSinceEpoch);
    listDown.insert(0, downItem);
    final json = jsonEncode(listDown);
    var user = (await HelperUtils.checkLogin());
    var idUser = user == null ? 'local' : user.id;
    await PreferenceProvider.instance
        .setString(idUser + AppConfigs.KEY_DOWNLOAD_EPISODE, json);
    debugPrint('=>>>>>>>>>>>>> ${listDown.length}');
  }

  removeItem(EpisodeDownLoad item) async {


    var listDown = await getListEpisodeDownLoad();
    final index = listDown.map((e) => e.item.id).toList().indexOf(item.item.id);
    if (index != -1) {
      listDown.removeAt(index);
    }
    final json = jsonEncode(listDown);
    var user = (await HelperUtils.checkLogin());
    var idUser = user == null ? 'local' : user.id;
    await PreferenceProvider.instance
        .setString(idUser + AppConfigs.KEY_DOWNLOAD_EPISODE, json);

   await  File(item.path).delete();
  }

}
