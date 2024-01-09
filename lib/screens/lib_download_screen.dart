import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/design_patterns/strategy/context_play_strategy.dart';
import 'package:poca/design_patterns/strategy/offline_play_strategy.dart';
import 'package:poca/features/account/library/episode_download_bottom_sheet.dart';
import 'package:poca/models/download_episode.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/services/download_services.dart';
import 'package:poca/services/history_services.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../configs/constants.dart';
import '../features/blocs/player_cubit.dart';
import '../models/podcast.dart';
import '../providers/preference_provider.dart';
import '../utils/dialogs.dart';
import '../utils/resizable.dart';
import '../widgets/custom_button.dart';
import '../widgets/network_image_custom.dart';

class LibDownloadScreen extends StatelessWidget {
  const LibDownloadScreen(
      {super.key});
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => EpisodeDownloadCubit()..load(),
        child: BlocBuilder<EpisodeDownloadCubit, int>(
          builder: (context, state) {
            if(state == 0) return const LoadingProgress();
            final cubit = context.read<EpisodeDownloadCubit>();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        var text = '';
                        return Text(
                          text,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 24),
                              color: textColor,
                              fontWeight: FontWeight.w600),
                        );
                      }),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                cubit.updateView();
                              },
                              splashRadius: 20,
                              iconSize: Resizable.size(context, 25),
                              color: primaryColor,
                              icon: Icon(
                                cubit.isGrid ? Icons.grid_view_rounded : Icons.sort,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                if (cubit.listDownLoad.isEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your downloaded is empty!\nExplore and return again',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 20),
                                color: primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 50,
                            child: CustomButton(
                                title: 'Explore',
                                fontSize: 17,
                                onTap: () {
                                  final playCubit = context.read<PlayerCubit>();
                                  playCubit.persistentTabController.jumpToTab(1);
                                },
                                backgroundColor: primaryColor,
                                textColor: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                if (cubit.listDownLoad.isNotEmpty && cubit.isGrid)
                  Expanded(
                      child: GridView.builder(
                          itemCount: cubit.listDownLoad.length,
                          padding: EdgeInsets.symmetric(
                              vertical: Resizable.padding(context, 15),
                              horizontal: Resizable.padding(context, 20)),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: Resizable.padding(context, 15),
                            mainAxisSpacing: Resizable.padding(context, 15),
                          ),
                          itemBuilder: (context, index) {
                            var playlist = cubit.listDownLoad[index];
                            return GestureDetector(
                              onTap: () {
                                cubit.play(playlist, context);
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                      child: LayoutBuilder(builder: (context, c) {
                                        return NetworkImageCustom(
                                          url: playlist.item.imageUrl,
                                          width: c.maxWidth,
                                          height: c.maxHeight,
                                          borderRadius: BorderRadius.circular(20),
                                        );
                                      })),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    playlist.item.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 20)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            );
                          })),
                if (cubit.listDownLoad.isNotEmpty && !cubit.isGrid)
                  Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 20)
                        ),
                        children: [
                          ...cubit.listDownLoad.map((e) {
                            return GestureDetector(
                              onTap: () {
                                cubit.play(e, context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    NetworkImageCustom(
                                      url: e.item.imageUrl,
                                      width: Resizable.size(context, 100),
                                      height: Resizable.size(context, 100),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.item.title,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: Resizable.font(context, 20)),
                                          ),
                                          const SizedBox(height: 5,),
                                        ],
                                      ),
                                    ),
                                    IconButton(onPressed: () {

                                      Dialogs.showBottomSheet(context, EpisodeDownloadBottomSheet(cubit: cubit, episodeDownLoad: e));
                                    }, icon: const Icon(Icons.more_vert_rounded) , color: primaryColor , splashRadius: 20,)
                                  ],
                                ),
                              ),
                            );
                          }).toList()
                        ],
                      )),
              ],
            );
          },
        ),
      ),
    );
  }
}

class EpisodeDownloadCubit extends Cubit<int> {
  EpisodeDownloadCubit() : super(0);
  List<EpisodeDownLoad> listDownLoad = [];

  final local = PreferenceProvider.instance;

  bool isGrid = false;
  updateView() {
    isGrid = !isGrid;
    emit(state+1);
  }

  load() async {
    listDownLoad = await DownloadService.instance.getListEpisodeDownLoad();

    emit(state + 1);
  }


  removeHistory(EpisodeDownLoad episode) async {
    await DownloadService.instance.removeItem(episode);
    load();
  }


  play(EpisodeDownLoad item , BuildContext context) async {
    var podcast = Podcast(
        id: 'download',
        title: 'Episode_Downloaded',
        description: '',
        topicsList: [],
        host: '',
        episodesList: listDownLoad.map((e) => e.item.copyWith(audioFile: e.path)).toList(),
        publishDate: DateTime.now().millisecondsSinceEpoch,
        subscribesList: [],
        favoritesList: [],
        imageUrl: 'assets/images/local_podcast.jpg');
    var index  = listDownLoad.indexOf(item);

    ContextPlayStrategy podcastApp = ContextPlayStrategy();
    podcastApp.setPlayStrategy(OfflinePlayStrategy(context));
    podcastApp.playStrategy.playPodcast(podcast, index);

  }
}