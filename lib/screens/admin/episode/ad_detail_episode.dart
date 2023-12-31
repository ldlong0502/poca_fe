import 'package:flutter/material.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/screens/admin/admin_episodes.dart';
import 'package:poca/screens/admin/admin_podcasts.dart';

import '../../../configs/constants.dart';
import '../../../features/admin/dialogs/user_bottom_sheet.dart';
import '../../../features/dialogs/normal_dialog.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/resizable.dart';
import '../../../widgets/network_image_custom.dart';

class AdminDetailEpisode extends StatelessWidget {
  const AdminDetailEpisode({super.key, required this.cubit, required this.episode});

  final AdminEpisodesCubit cubit;
  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        actions: [
          IconButton(
              onPressed: () {
                var list = [
                  ActionBottom('Edit Episode', Icons.edit, () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.adminEditEpisode , arguments: {
                      'cubit': cubit,
                      'episode': episode
                    });
                  }),
                  ActionBottom('Delete Episode', Icons.remove_circle_outline, () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return NormalDialog(
                              onYes: () async {
                                var res = await ApiEpisode.instance.deleteEpisode(episode.id);
                                if(res) {
                                  await cubit.load();
                                  if(context.mounted){
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    CustomToast.showBottomToast(context, 'Delete Successfully');
                                  }
                                }
                                else {
                                  if(context.mounted){
                                    Navigator.pop(context);
                                    CustomToast.showBottomToast(context, 'Delete Error');
                                  }
                                }
                              },
                              onCancel: (){
                                Navigator.pop(context);
                              },
                              title: 'Delete Episode',
                              content: 'Are you sure to delete this Episode?');
                        });
                  })
                ];
                Dialogs.showBottomSheet(
                    context, UserBottomSheet(listItem: list));
              },
              icon: const Icon(
                Icons.more_horiz_rounded,
                color: primaryColor,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: NetworkImageCustom(
                url: episode.imageUrl,
                borderRadius: BorderRadius.circular(1000),
                width: Resizable.size(context, 220),
                height: Resizable.size(context, 220),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              episode.title,
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Resizable.font(context, 20)),
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              endIndent: 50,
              indent: 50,
              color: Colors.grey.shade600,
              height: 2,
            ),

            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Duration: ',
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Resizable.font(context, 18)),
                      ),
                      Text(
                        episode.duration.toString(),
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 16)),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}