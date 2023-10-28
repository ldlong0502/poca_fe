import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uni_wave/blocs/mini_player_cubit.dart';
import 'package:uni_wave/configs/constants.dart';
import 'package:uni_wave/utils/custom_toast.dart';

class PlayerRowControl extends StatelessWidget {
  const PlayerRowControl({super.key, required this.cubit});

  final MiniPlayerCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniPlayerCubit, int>(
      bloc: cubit,
      builder: (context, state) {
        return Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    if(cubit.indexChapter - 1 < 0 ) {
                      CustomToast.showBottomToast(context, 'Bạn đang nghe chương đầu!');
                    }
                    else {
                      cubit.changeChapter(cubit.indexChapter - 1);
                    }
                  },
                  icon: const Icon(
                    Icons.skip_previous_rounded,
                    color: Colors.white,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {
                    cubit.seekPrevious(const Duration(seconds: 30));
                  },
                  icon: Image.asset('assets/icons/ic_replay30.png',
                      color: Colors.white, height: 30)),
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                        onPressed: () {
                          if (cubit.isPlay && cubit.status == ProcessingState
                              .ready) {
                            cubit.pause();
                          }
                          else {
                            cubit.play();
                          }
                        },
                        icon: cubit.isLoading ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: purpleColor,
                            strokeWidth: 2,

                          ),
                        ) : Icon(
                          cubit.isPlay &&
                              cubit.status == ProcessingState.ready ? Icons
                              .pause_rounded : Icons.play_arrow_rounded,
                          color: purpleColor,
                          size: 20,
                        ))),
              ),
              IconButton(
                  onPressed: () {
                    cubit.seekNext(const Duration(seconds: 30));
                  },
                  icon: Image.asset('assets/icons/ic_next30.png',
                      color: Colors.white, height: 30)),
              IconButton(
                  onPressed: () {
                   if(cubit.indexChapter + 1 > cubit.currentAudioBook!.listMp3.length - 1) {
                     CustomToast.showBottomToast(context, 'Bạn đang nghe chương cuối!');
                   }
                   else {
                     cubit.changeChapter(cubit.indexChapter + 1);
                   }
                  },
                  icon: const Icon(
                    Icons.skip_next_rounded,
                    color: Colors.white,
                    size: 30,
                  )),
            ],
          ),
        );
      },
    );
  }
}
