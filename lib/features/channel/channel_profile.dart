import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/blocs/channel_detail_cubit.dart';
import 'package:poca/features/channel/edit_podcast_bottom_sheet.dart';
import 'package:poca/features/topics/topic_detail_view.dart';
import 'package:poca/models/channel_model.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/providers/api/api_topic.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/utils/navigator_custom.dart';
import 'package:poca/widgets/custom_button.dart';

import '../../configs/constants.dart';
import '../../utils/dialogs.dart';
import '../../utils/resizable.dart';
import '../../widgets/network_image_custom.dart';
import '../blocs/user_cubit.dart';
import '../podcast/podcast_detail_view.dart';

class AboutChannel extends StatelessWidget {
  const AboutChannel({super.key, required this.cubit});

  final ChannelDetailCubit cubit;

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final check = cubit.channel!.idUser == userCubit.state?.id;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ExpandableText(
              cubit.channel!.about,
              expandText: 'see more',
              textAlign: TextAlign.start,
              linkStyle: const TextStyle(fontWeight: FontWeight.bold),
              collapseText: 'show less',
              style: TextStyle(
                  fontSize: Resizable.font(context, 18),
                  color: textColor,
                  fontWeight: FontWeight.w600),
              maxLines: 4,
              linkColor: primaryColor,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocProvider(
              create: (context) =>
                  TopicsStringCubit(cubit.channel!.topics)..load(),
              child: BlocBuilder<TopicsStringCubit, List<Topic>>(
                builder: (context, state) {
                  return Wrap(
                    children: [
                      Text(
                        'Topics: ',
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Resizable.font(context, 18)),
                      ),
                      ...state.map((e) {
                        var isFinal = state.indexOf(e) == state.length - 1;
                        return InkWell(
                          onTap: () {
                            NavigatorCustom.pushNewScreen(
                                context,
                                TopicDetailView(topic: e),
                                AppRoutes.topicDetail);
                          },
                          child: Text(
                            '${e.name}${isFinal ? '' : ', '}',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 16)),
                          ),
                        );
                      }).toList()
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocProvider(
              create: (context) => ListPodcastCubit(cubit.channel!)..load(),
              child: BlocBuilder<ListPodcastCubit, List<Podcast>>(
                builder: (context, state) {
                  if (state.isEmpty) return Container();

                  return Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Podcasts(${state.length}) ',
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: Resizable.font(context, 18)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ...state.map((e) {
                        return InkWell(
                          onTap: () {
                            NavigatorCustom.pushNewScreen(
                                context,
                                PodcastDetailView(podcast: e),
                                AppRoutes.podcastDetail);
                          },
                          child: Container(
                            height: Resizable.size(context, 100),
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    NetworkImageCustom(
                                      url: e.imageUrl,
                                      borderRadius: BorderRadius.circular(15),
                                      height: Resizable.size(context, 70),
                                      width: Resizable.size(context, 70),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          e.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize:
                                                  Resizable.font(context, 18),
                                              color: textColor,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          cubit.channel!.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize:
                                                  Resizable.font(context, 14),
                                              color: Colors.grey.shade400,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    )),
                                    if (check)
                                      IconButton(
                                          onPressed: () {
                                            final cubit = context.read<ListPodcastCubit>();
                                            Dialogs.showBottomSheet(context, EditPodcastBottomSheet(podcast: e, cubit: cubit));
                                          },
                                          color: primaryColor,
                                          icon: const Icon(Icons.more_vert))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                if (state.indexOf(e) != state.length - 1)
                                  Divider(
                                    height: 2,
                                    color: Colors.grey.shade600,
                                  )
                              ],
                            ),
                          ),
                        );
                      }).toList()
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopicsStringCubit extends Cubit<List<Topic>> {
  TopicsStringCubit(this.topics) : super([]);

  final List<String> topics;

  load() async {
    final listTopics = await ApiTopic.instance.getListTopics();
    List<Topic> temp = [];
    for (var item in topics) {
      final topic = listTopics.firstWhere((element) => element.id == item);
      temp.add(topic);
    }

    emit(temp);
  }
}

class ListPodcastCubit extends Cubit<List<Podcast>> {
  ListPodcastCubit(this.channel) : super([]);

  final ChannelModel channel;

  load() async {
    emit(await ApiPodcast.instance.getListPodcastByChannelId(channel.id));
  }
}
