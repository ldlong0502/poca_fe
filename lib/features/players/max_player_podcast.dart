import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/features/players/sleep_time_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:poca/configs/app_configs.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/audio_book/player_row_controls.dart';
import 'package:poca/models/audio_book.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/utils/dialogs.dart';
import 'package:poca/utils/resizable.dart';

import '../../blocs/mini_player_cubit.dart';
import '../../screens/audio_book_detail_screen.dart';
import '../../services/dynamic_links_service.dart';
import '../../utils/navigator_custom.dart';

class MaxPlayerPodcast extends StatelessWidget {
  const MaxPlayerPodcast({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, int>(
      builder: (context, state) {
        final cubit = context.read<PlayerCubit>();
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              'Now playing',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_down_outlined,
                color: primaryColor,
              ),
              onPressed: () {
                cubit.openMiniPlayer();
              },
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: SizedBox(
                height: Resizable.height(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: cubit.isOnline
                          ? CachedNetworkImage(
                              imageUrl: cubit.currentPodcast!.imageUrl,
                              fit: BoxFit.fill,
                              height: Resizable.size(context, 250),
                              width: Resizable.size(context, 250),
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
                            )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                                cubit.currentPodcast!.imageUrl,
                                height: Resizable.size(context, 250),
                                width: Resizable.size(context, 250),
                              fit: BoxFit.fill,
                              ),
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                child: Marquee(
                                  text: cubit.currentPodcast!.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                    fontSize: Resizable.font(context, 20),
                                  ),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  blankSpace: 20.0,
                                  velocity: 10.0,
                                  pauseAfterRound:
                                      const Duration(milliseconds: 500),
                                  startPadding: 10.0,
                                  accelerationDuration:
                                      const Duration(milliseconds: 100),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      const Duration(milliseconds: 100),
                                  decelerationCurve: Curves.easeOut,
                                ),
                              ),
                              Text(
                                  cubit.currentPodcast!
                                      .episodesList[cubit.indexChapter].title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: secondaryColor,
                                    fontSize: Resizable.font(context, 15),
                                  )),
                            ],
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ProgressBar(
                        barHeight: 8,
                        baseBarColor: Colors.grey.shade300,
                        bufferedBarColor: Colors.grey,
                        progressBarColor: secondaryColor,
                        thumbColor: primaryColor,
                        timeLabelTextStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                        progress: cubit.isLoading
                            ? Duration.zero
                            : cubit.durationState.progress,
                        buffered: cubit.isLoading
                            ? Duration.zero
                            : cubit.durationState.buffered,
                        total: cubit.isLoading
                            ? Duration.zero
                            : cubit.durationState.total,
                        onSeek: (value) {
                          cubit.onSeek(value);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    PlayerRowControl(
                      cubit: cubit,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                DynamicLinksService.instance
                                    .createLink('episode/${cubit.currentPodcast!
                                    .episodesList[cubit.indexChapter].id}')
                                    .then((value) =>
                                    Share.share(value));
                              },
                              color: primaryColor,
                              iconSize: Resizable.size(context, 30),
                              icon: const Icon(Icons.ios_share)),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Dialogs.showBottomSheet(context, SleepTimeBottomSheet(cubit: cubit));
                                  },
                                  color: primaryColor,
                                  iconSize: Resizable.size(context, 30),
                                  icon: const Icon(Icons.timer)),
                              if(cubit.time !=0)
                              Text(
                                  cubit.formatDuration(cubit.time),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: secondaryColor,
                                    fontSize: Resizable.font(context, 15),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
