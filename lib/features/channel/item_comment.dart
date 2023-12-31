import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/comment/list_comment.dart';
import 'package:poca/models/channel_model.dart';
import 'package:poca/utils/convert_utils.dart';
import 'package:poca/utils/resizable.dart';
import 'package:poca/widgets/network_image_custom.dart';

import '../../models/comment.dart';
import '../../models/podcast.dart';
import '../../providers/api/api_comment.dart';
import '../../routes/app_routes.dart';
import '../../utils/navigator_custom.dart';
import '../podcast/podcast_detail_view.dart';

class ItemComment extends StatelessWidget {
  const ItemComment(this.podcast,
      {super.key, required this.channel, required this.isFinal});

  final Podcast podcast;
  final ChannelModel channel;
  final bool isFinal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigatorCustom.pushNewScreen(context,
            PodcastDetailView(podcast: podcast), AppRoutes.podcastDetail);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Column(
                    children: [
                      NetworkImageCustom(
                        url: podcast.imageUrl,
                        width: 100,
                        height: 100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      BlocProvider(
                        create: (context) =>
                        StarCubit(podcast)
                          ..load(),
                        child: BlocBuilder<StarCubit, double>(
                          builder: (context, state) {
                            return RatingBarIndicator(
                              rating: state,
                              itemBuilder: (context, index) =>
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.yellow,
                              ),
                              unratedColor: secondaryColor,
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          podcast.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 18),
                              color: textColor,
                              fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          channel.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 14),
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ConvertUtils.convertIntToDateString(
                              podcast.publishDate),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 14),
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          ListComment(podcast: podcast),
          if (!isFinal)
            Divider(
              height: 2,
              color: Colors.grey.shade600,
              endIndent: 20,
              indent: 20,
            ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}

class StarCubit extends Cubit<double> {
  StarCubit(this.podcast) : super(0);
  final Podcast podcast;
  List<Comment> listComment = [];

  load() async {
    listComment = await ApiComment.instance.getCommentsPodcast(podcast.id);

    if (listComment.isEmpty) {
      emit(5);
    } else {
      double allRating = 0;
      for (var i in listComment) {
        allRating += i.rate;
      }
      emit(allRating / listComment.length);
    }
  }
}
