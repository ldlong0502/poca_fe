import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/features/podcast/row_info_podcast.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/screens/base_screen.dart';
import 'package:poca/utils/resizable.dart';
import 'package:poca/widgets/network_image_custom.dart';

import '../../utils/convert_utils.dart';

class PodcastDetailView extends StatelessWidget {
  const PodcastDetailView({super.key, required this.podcast});

  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: '',
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RowInfoPodcast(
                podcast: podcast,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: primaryColor,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_border,
                            color: primaryColor,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share,
                            color: primaryColor,
                          )),
                    ],
                  )),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(child: IconButton(
                    onPressed: (){
                        context.read<PlayerCubit>().listen(podcast);
                    },
                    iconSize: Resizable.size(context, 50),
                    icon: const Icon(Icons.play_circle_outline , color: primaryColor,),
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ExpandableText(
                podcast.description,
                expandText: 'see more',
                linkStyle: const TextStyle(fontWeight: FontWeight.bold),
                collapseText: 'show less',
                style: TextStyle(
                    fontSize: Resizable.font(context, 16),
                    color: secondaryColor,
                    fontWeight: FontWeight.w500),
                maxLines: 4,
                linkColor: primaryColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                ...podcast.episodesList
                    .map((e) => InkWell(

                    onTap: () {
                      context.read<PlayerCubit>().listen(podcast, podcast.episodesList.indexOf(e));
                    },
                      child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                NetworkImageCustom(
                                  url: e.imageUrl,
                                  height: Resizable.size(context, 85),
                                  width: Resizable.size(context, 85),
                                  radius: 10,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.title,
                                      style: TextStyle(
                                          fontSize: Resizable.font(context, 16),
                                          color: textColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${ConvertUtils.convertIntToDateString(e.publishDate * 1000)} - ${ConvertUtils.convertIntToDuration(e.duration)}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize:
                                                  Resizable.font(context, 13),
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              e.favoritesList.length.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize:
                                                      Resizable.font(context, 13),
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const Icon(
                                              Icons.favorite,
                                              color: primaryColor,
                                            )
                                          ],
                                        ),
                                        InkWell(
                                          onTap: (){},
                                            child: const Icon(
                                          Icons.more_horiz_rounded,
                                          color: primaryColor,
                                        ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                    ))
                    .toList()
              ],
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
