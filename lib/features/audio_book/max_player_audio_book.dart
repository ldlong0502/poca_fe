import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_wave/configs/app_configs.dart';
import 'package:uni_wave/configs/constants.dart';
import 'package:uni_wave/features/audio_book/player_row_controls.dart';
import 'package:uni_wave/models/audio_book.dart';
import 'package:uni_wave/routes/app_routes.dart';
import 'package:uni_wave/utils/dialogs.dart';
import 'package:uni_wave/utils/resizable.dart';

import '../../blocs/mini_player_cubit.dart';
import '../../screens/audio_book_detail_screen.dart';
import '../../utils/navigator_custom.dart';

class MaxPlayerAudioBook extends StatelessWidget {
  const MaxPlayerAudioBook({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniPlayerCubit, int>(
      builder: (context, state) {
        final cubit = context.read<MiniPlayerCubit>();
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_down_outlined, color: Colors.white,),
              onPressed: () {
                cubit.openMiniPlayer();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.more_vert_outlined, color: Colors.white,),
                onPressed: () async {
                  cubit.openMiniPlayer();
                  await Future.delayed(const Duration(seconds: 1));
                  popToAudioBookDetail(AppConfigs.contextApp! , cubit.currentAudioBook!);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              height: Resizable.height(context),
              width: Resizable.width(context),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      purpleColor,
                      pinkColor
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: kToolbarHeight + 30,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: cubit.currentAudioBook!.image,
                      fit: BoxFit.fill,

                      height: Resizable.size(context, 300),
                      width: Resizable.size(context, 200),
                      placeholder: (context, s) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Image.asset(
                              'assets/images/book_temp.jpg'),
                        );
                      },
                      errorWidget: (context, s, _) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Image.asset(
                              'assets/images/book_temp.jpg'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    height: 50,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal:Resizable.padding(context, 30) ),
                      child: Marquee(
                        text: cubit.currentAudioBook!.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: whiteColor,
                          fontSize: Resizable.font(context, 20),
                        ),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        blankSpace: 20.0,
                        velocity: 10.0,
                        pauseAfterRound: const Duration(milliseconds: 500),
                        startPadding: 10.0,
                        accelerationDuration: const Duration(milliseconds: 100),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: const Duration(
                            milliseconds: 100),
                        decelerationCurve: Curves.easeOut,
                      ),
                    ),
                  ),
                  Text(cubit.currentAudioBook!.listMp3[cubit.indexChapter].title , style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: whiteColor,
                    fontSize: Resizable.font(context, 15),
                  )),
                  const SizedBox(height: 20,),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25
                    ),
                    child: ProgressBar(
                      barHeight: 8,
                      baseBarColor: Colors.white38,
                      bufferedBarColor: Colors.grey,
                      progressBarColor: Colors.white,
                      thumbColor: Colors.white,
                      timeLabelTextStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                      progress: cubit.isLoading ? Duration.zero : cubit.durationState.progress,
                      buffered: cubit.isLoading ? Duration.zero : cubit.durationState.buffered,
                      total: cubit.isLoading ? Duration.zero : cubit.durationState.total,
                      onSeek: (value) {
                        cubit.onSeek(value);
                      },
                    ),
                  ),
                  PlayerRowControl(cubit: cubit,),
                   Expanded(child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(child: GestureDetector(
                        onTap: () {
                          Dialogs.showChapter(context, cubit);
                        },
                        child: const Column(
                          children: [
                            Icon(Icons.menu_open, size: 30, color: Colors.white,),
                            Text('Chương' , style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      )),
                      const Flexible(child: Column(
                        children: [
                          Icon(Icons.speed, size: 30, color: Colors.white,),
                          Text('1.0x' , style: TextStyle(color: Colors.white),)
                        ],
                      ))
                    ],
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void popToAudioBookDetail(BuildContext context , AudioBook audioBook) {

    final newRouteName = AppRoutes.audioBookDetail + audioBook.id.toString();
    bool isNewRouteSameAsCurrent = false;

    Navigator.popUntil(context, (route) {
      if (route.settings.name == newRouteName) {
        isNewRouteSameAsCurrent = true;
      }
      return true;
    });

    if (!isNewRouteSameAsCurrent) {
      if(context.mounted) {
        NavigatorCustom.pushNewScreen(AppConfigs.contextApp!,  AudioBookDetailScreen(
            audioBook: audioBook ), newRouteName);
      }
    }
    else {
      Navigator.popUntil(context, ModalRoute.withName(newRouteName));
    }


  }

}
