import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/podcast/podcast_detail_view.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/api/api_podcast.dart';

import '../../routes/app_routes.dart';
import '../../utils/navigator_custom.dart';
import '../../utils/resizable.dart';
import '../../widgets/network_image_custom.dart';

class RecommendPodcast extends StatelessWidget {
  const RecommendPodcast({super.key, required this.podcast});
  final Podcast podcast;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecommendCubit()..load(podcast),
      child: BlocBuilder<RecommendCubit, int>(

        builder: (context, state) {
          final cubit = context.read<RecommendCubit>();
          if(state == 0 || cubit.listPodcast.isEmpty) return Container();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Same topic',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Resizable.font(context, 20),
                      color: textColor),
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 20),
                  children: [
                    ...cubit.listPodcast.map((e) {
                      return InkWell(
                        onTap: () {
                          NavigatorCustom.pushNewScreen(context, PodcastDetailView(podcast: e), AppRoutes.podcastDetail + e.id.toString());
                        },
                        child: SizedBox(
                          width: 150,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Column(
                              children: [
                                Expanded(
                                    child:
                                    LayoutBuilder(
                                        builder: (context, c) {
                                          return Stack(
                                            children: [
                                              NetworkImageCustom(
                                                  url: e.imageUrl,
                                                  height: c.maxHeight,
                                                  width: c.maxWidth,
                                                  borderRadius: BorderRadius.circular(20)),
                                            ],
                                          );
                                        }
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList()
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}


class RecommendCubit extends Cubit<int> {
  RecommendCubit() : super(0);

  List<Podcast> listPodcast = [];


  load(Podcast podcast) async {
    for(var item in podcast.topicsList) {
      var temp = await ApiPodcast.instance.getListPodcastByTopicId(item.id);
      for(var k in temp) {
        if(!listPodcast.map((e) => e.id).contains(k.id)) {
          listPodcast.add(k);
        }
      }
     }
    listPodcast.removeWhere((element) => element.id == podcast.id);
    emit(state + 1);
  }
}


