import 'package:flutter/material.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/utils/resizable.dart';

import '../../widgets/network_image_custom.dart';

class RowInfoPodcast extends StatelessWidget {
  const RowInfoPodcast({super.key, required this.podcast});

  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Resizable.size(context, 180),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
              child: NetworkImageCustom(
            url: podcast.imageUrl,
          )),
          const SizedBox(width: 10,),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                podcast.title,
                style: TextStyle(
                    color: textColor,
                    fontSize: Resizable.font(context, 24),
                    fontWeight: FontWeight.w800),
              ),
              Text(
                podcast.host,
                style: TextStyle(
                    color: secondaryColor,
                    fontSize: Resizable.font(context, 20),
                    fontWeight: FontWeight.w600),
              ),
              Row(
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
                      const Icon(Icons.headphones ,color: primaryColor,)
                    ],
                  ),
                  const SizedBox(width: 5,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(
                          builder: (context) {
                            var fav = podcast.episodesList.fold(0, (previousValue, element) => previousValue + element.favoritesList.length);
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
