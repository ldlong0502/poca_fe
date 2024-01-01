import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:poca/configs/app_configs.dart';
import 'package:poca/features/blocs/recently_play_cubit.dart';
import 'package:poca/models/audio_book.dart';
import 'package:poca/models/duration_state.dart';
import 'package:poca/models/mp3.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/services/history_services.dart';
import 'package:poca/services/sound_service.dart';
import 'package:poca/utils/custom_toast.dart';

class PlayerCubit extends Cubit<int> {
  PlayerCubit(this.context) : super(0);
  final BuildContext context;
  bool isOnline = true;
  bool isMiniPlayer = true;
  bool isHideBottomNavigator = false;
  double speed = 1;
  final MiniplayerController controller = MiniplayerController();
  final soundService = SoundService.instance;
  bool isPlay = false;
  ProcessingState status = ProcessingState.idle;
  bool isLoading = false;
  bool isFirstOpenMax = true;
  int indexChapter = 0;
  Podcast? currentPodcast;
  DurationState durationState = const DurationState(
      progress: Duration.zero, buffered: Duration.zero, total: Duration.zero);
  PersistentTabController persistentTabController = PersistentTabController();
  int time =0 ;
  Timer? timer;
  List<String> listTime = ['5 minutes', '10 minutes', '15 minutes', '30 minutes' , '1 hour'];

  setTime(int index) {
    print('=>>>>>>>$index');
    timer?.cancel();
    if(index == -1) {
      timer = null;
      time = 0;
      emitState();
      return;
    }
    switch(index) {
      case 0: time = 300;
      case 1: time = 600;
      case 2: time = 900;
      case 3: time = 1800;
      case 4: time = 3600;
    }
    emit(state+1);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      time--;
      emit(state+1);
      if(time == 0) {
        pause();
        timer.cancel();
      }
    });
  }

  String formatDuration(int s) {
    Duration duration = Duration(seconds: s);
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$minutes:$seconds';
  }
  load() {}

  updateHideBottomNavigator(bool value) {
    isHideBottomNavigator = value;
    emitState();
  }

  init() {
    isPlay = false;
    isFirstOpenMax = true;
    status = ProcessingState.idle;
    isLoading = false;
    indexChapter = 0;
    currentPodcast = null;
    durationState = const DurationState(
        progress: Duration.zero, buffered: Duration.zero, total: Duration.zero);
  }

  emitState() {
    if (isClosed) return;
    emit(state + 1);
  }
  setFirstOpenMax(bool value) {
    isFirstOpenMax = value;
    emitState();
  }
  openMaxPlayer() {
    isMiniPlayer = false;
    controller.animateToHeight(state: PanelState.MAX);
    emit(state + 1);
  }

  openMiniPlayer() {
    isMiniPlayer = true;
    controller.animateToHeight(state: PanelState.MIN);
    emit(state + 1);
  }
  bool checkPermissionBeforeListen(Podcast podcast  , int value) {
    if(podcast.episodesList.isEmpty) {
      Fluttertoast.showToast(msg: 'Sorry! None of Episodes');
      return false;
    }
    if(currentPodcast!= null && podcast.id == currentPodcast!.id &&  value == indexChapter) {
      Fluttertoast.showToast(msg: 'You are listening this episodes');
      return false;
    }
    return true;
  }
  listen(Podcast podcast  , [int value = 0 , int historyDuration = 0 ,  bool checkOnline = true]) async {
    isOnline =  checkOnline;
   if( !checkPermissionBeforeListen(podcast, value)) {
     return;
   }
    var temp = await PreferenceProvider.instance.getString('audio_speed');
    if(temp.isNotEmpty) {
      speed = double.parse(temp);
    }
    updateHistory();
    isFirstOpenMax = true;
    isLoading = true;
    emitState();
    currentPodcast = podcast;
    indexChapter = value;
    Duration? duration;
    if(isOnline) {
      duration = await soundService.setUrl(podcast.episodesList[indexChapter].audioFile, Duration(milliseconds: historyDuration) );
    }
    else {
      duration = await soundService.setFile(podcast.episodesList[indexChapter].audioFile, Duration(milliseconds: historyDuration) );
    }
    durationState = durationState.copyWith(total: duration);
    isLoading = false;
    emitState();
    soundService.player!.positionStream.listen((event) {
      durationState = durationState.copyWith(progress: event);
      emitState();
    });
    soundService.player!.bufferedPositionStream.listen((event) {
      durationState = durationState.copyWith(buffered: event);
      emitState();
    });
    soundService.player!.playerStateStream.listen((event) {
      isPlay = event.playing;
      status = event.processingState;
      if (!isLoading && status == ProcessingState.completed) {
        soundService.stop();
        if(indexChapter == currentPodcast!.episodesList.length - 1) {
          onSeek(Duration.zero);
        }
        else {
          changeChapter(indexChapter + 1);
        }
      }
      emitState();
    });
    play();
  }

  play()  {
    soundService.play();
  }
  pause()  {
    soundService.pause();
  }
  dismissMiniPlayer() async {
    setTime(-1);
    updateHistory();
    init();
    await soundService.stop();
    soundService.dispose();
    emitState();
  }
  updateHistory() async {

    if(currentPodcast != null) {
      if(currentPodcast!.id == 'download') return;
      await HistoryService.instance.updateNewHistory(currentPodcast!, indexChapter, durationState.progress.inMilliseconds);
      var context = AppConfigs.contextApp!;
      if(context.mounted) {
        context.read<RecentlyPlayCubit>().load();
      }
    }
  }
  onSeek(Duration duration) async {
    await soundService.seek(duration);
  }
  void seekPrevious(Duration duration) async {
    Duration newPosition = durationState.progress - duration;
    await soundService.seek(newPosition);
  }
  void seekNext(Duration duration) async {
    Duration newPosition = durationState.progress + duration;
    await soundService.seek(newPosition);
  }


  void changeChapter (int index) {
    listen(currentPodcast! , index);
  }

  void setSpeed (double value) async {
    await PreferenceProvider.instance.setString('audio_speed', value.toString());

    speed = value;
    emitState();
  }
}
