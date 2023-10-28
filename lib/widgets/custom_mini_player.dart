import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:uni_wave/blocs/mini_player_cubit.dart';
import 'package:uni_wave/configs/constants.dart';
import 'package:uni_wave/features/audio_book/max_player_audio_book.dart';

import '../features/audio_book/mini_player_audio_book.dart';
import '../utils/resizable.dart';

class CustomMiniPlayer extends StatelessWidget {
  const CustomMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniPlayerCubit, int>(
      builder: (cc, state) {
        final miniPlayerCubit = cc.read<MiniPlayerCubit>();
        return miniPlayerCubit.currentAudioBook == null ? Container() : AnimatedPositioned(
          bottom: miniPlayerCubit.isMiniPlayer ? kBottomNavigationBarHeight + 10 : 0,
          left: miniPlayerCubit.isMiniPlayer ? 15 : 0,
          right: miniPlayerCubit.isMiniPlayer ? 15 : 0,
          duration: const Duration(milliseconds: 0),
          child: Miniplayer(
              minHeight: Resizable.size(context, 60),
              onDismiss: () {
                miniPlayerCubit.dismissMiniPlayer();
              },
              elevation: 8,
              controller: miniPlayerCubit.controller,
              maxHeight: Resizable.height(context),
              builder: (height, percentage) {
                if(miniPlayerCubit.isFirstOpenMax) {
                  miniPlayerCubit.openMaxPlayer();
                  miniPlayerCubit.setFirstOpenMax(false);
                }
                if (percentage > 0.2 && miniPlayerCubit.isMiniPlayer) {
                  miniPlayerCubit.openMaxPlayer();
                }
                else if (percentage < 0.2 && !miniPlayerCubit.isMiniPlayer) {
                  miniPlayerCubit.openMiniPlayer();
                }
                if(percentage < 0.2) {
                  return const MiniPlayerAudioBook();
                }
                return const MaxPlayerAudioBook();
              }
          ),
        );
      },
    );
  }
}
