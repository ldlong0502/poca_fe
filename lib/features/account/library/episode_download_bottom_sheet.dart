
import 'package:flutter/material.dart';
import 'package:poca/models/download_episode.dart';
import 'package:poca/screens/lib_download_screen.dart';

import '../../../models/episode.dart';
import '../../../utils/resizable.dart';
import '../../../widgets/network_image_custom.dart';
import '../playlist/base_bottom_sheet.dart';

class EpisodeDownloadBottomSheet extends StatelessWidget {
  const EpisodeDownloadBottomSheet(
      {super.key, required this.cubit, required this.episodeDownLoad,
      });
  final EpisodeDownloadCubit cubit;
  final EpisodeDownLoad episodeDownLoad;

  @override
  Widget build(BuildContext context) {
    var mapItems = [
      {
        'title': 'Remove episode',
        'icon': const Icon(
          Icons.remove_circle_outline,
          color: Colors.white,
        ),
        'onPress': () async {
          await cubit.removeHistory(episodeDownLoad);
          Navigator.pop(context);
        },
      },
      {
        'title': 'Play',
        'icon': const Icon(
          Icons.play_circle_outline_rounded,
          color: Colors.white,
        ),
        'onPress': () async {

          Navigator.pop(context);
          cubit.play(episodeDownLoad, context);
        },
      },
    ];
    return BaseBottomSheet(
      child: SizedBox(
        height: Resizable.height(context) * 0.4,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 20)),
              child: Row(
                children: [
                  NetworkImageCustom(
                      height: Resizable.size(context, 100),
                      width: Resizable.size(context, 100),
                      url: episodeDownLoad.item.imageUrl,
                      borderRadius: BorderRadius.circular(20)),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          episodeDownLoad.item.title,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Resizable.font(context, 20),
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 20)),
              child: Column(
                children: [
                  ...mapItems.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: e['onPress'] as Function(),
                        child: Row(
                          children: [
                            e['icon'] as Widget,
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              e['title'] as String,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Resizable.font(context, 20)),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
