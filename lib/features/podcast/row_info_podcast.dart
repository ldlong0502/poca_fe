import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/podcast_cubit.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/screens/channel_screen.dart';
import 'package:poca/utils/navigator_custom.dart';
import 'package:poca/utils/resizable.dart';

import '../../models/channel_model.dart';
import '../../widgets/network_image_custom.dart';
import '../blocs/channel_cubit.dart';

class RowInfoPodcast extends StatelessWidget {
  const RowInfoPodcast({super.key, required this.podcastCubit});

  final PodcastCubit podcastCubit;

  @override
  Widget build(BuildContext context) {
    var podcast = podcastCubit.podcast!;
    return SizedBox(
      height: Resizable.size(context, 180),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
              child: NetworkImageCustom(
            url: podcast.imageUrl,
                borderRadius: BorderRadius.circular(20),
          )),
          const SizedBox(width: 10,),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                podcast.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: textColor,
                    fontSize: Resizable.font(context, 24),
                    fontWeight: FontWeight.w800),
              ),
              BlocProvider(
                create: (context) => ChannelCubit(podcast.host),
                child: BlocBuilder<ChannelCubit, ChannelModel?>(
                  builder: (context, state) {
                    if(state ==  null) {
                      return const Text('');
                    }
                    return InkWell(
                      onTap: () {
                        NavigatorCustom.pushNewScreen(context, ChannelScreen(channel: state), AppRoutes.channel);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              state.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: Resizable.font(context, 20),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Icon(Icons.navigate_next)
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Builder(
                        builder: (context) {
                          var listens = podcast.episodesList.fold(0, (previousValue, element) => previousValue + element.listens);

                          return Text(
                            listens.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 13),
                                color: primaryColor,
                                fontWeight: FontWeight.w600),
                          );
                        }
                      ),
                      const SizedBox(width: 2,),
                      const Icon(Icons.headphones ,color: primaryColor,)
                    ],
                  ),
                  const SizedBox(width: 20,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(
                          builder: (context) {
                            var fav = podcast.favoritesList.length;
                            return Text(
                              fav.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 13),
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600),
                            );
                          }
                      ),
                      const SizedBox(width: 2,),
                      const Icon(Icons.favorite ,color: primaryColor,)
                    ],
                  ),
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
