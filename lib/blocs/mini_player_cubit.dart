import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:uni_wave/models/audio_book.dart';
import 'package:uni_wave/models/duration_state.dart';
import 'package:uni_wave/models/mp3.dart';
import 'package:uni_wave/providers/preference_provider.dart';
import 'package:uni_wave/services/sound_service.dart';
import 'package:uni_wave/utils/resizable.dart';

class MiniPlayerCubit extends Cubit<int> {
  MiniPlayerCubit() : super(0);

  bool isMiniPlayer = true;
  double speed = 1;
  final MiniplayerController controller = MiniplayerController();
  final soundService = SoundService.instance;
  bool isPlay = false;
  ProcessingState status = ProcessingState.idle;
  bool isLoading = false;
  bool isFirstOpenMax = true;
  int indexChapter = 0;
  AudioBook? currentAudioBook;
  DurationState durationState = const DurationState(
      progress: Duration.zero, buffered: Duration.zero, total: Duration.zero);

  load() {}

  init() {
    isPlay = false;
    isFirstOpenMax = true;
    status = ProcessingState.idle;
    isLoading = false;
    indexChapter = 0;
    currentAudioBook = null;
    DurationState durationState = const DurationState(
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

  listen(AudioBook audioBook  , [int value = 0]) async {
    var temp = await PreferenceProvider.getString('audio_speed');
    if(temp.isNotEmpty) {
      speed = double.parse(temp);
    }
    isFirstOpenMax = true;
    isLoading = true;
    emitState();
    currentAudioBook = audioBook;
    indexChapter = value;

    final duration = await soundService.setUrl(audioBook.listMp3[indexChapter].url);
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
        if(indexChapter == currentAudioBook!.listMp3.length - 1) {
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
    init();
    await soundService.stop();
    soundService.dispose();
    emitState();
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
    listen(currentAudioBook! , index);
  }

  void setSpeed (double value) async {
    await PreferenceProvider.setString('audio_speed', value.toString());

    speed = value;
    emitState();
  }
}
