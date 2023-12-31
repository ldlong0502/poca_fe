import 'package:flutter/material.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/screens/admin/admin_podcasts.dart';

import '../../../configs/constants.dart';
import '../../../features/admin/dialogs/user_bottom_sheet.dart';
import '../../../features/dialogs/normal_dialog.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/resizable.dart';
import '../../../widgets/network_image_custom.dart';

class AdminDetailPodcast extends StatelessWidget {
  const AdminDetailPodcast({super.key, required this.cubit, required this.podcast});

  final AdminPodcastsCubit cubit;
  final Podcast podcast;

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
                  ActionBottom('Edit Podcast', Icons.edit, () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.adminEditPodcast , arguments: {
                      'cubit': cubit,
                      'podcast': podcast
                    });
                  }),
                  ActionBottom('Delete Podcast', Icons.remove_circle_outline, () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return NormalDialog(
                              onYes: () async {
                                var res = await ApiPodcast.instance.deletePodcast(podcast.id);
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
                              title: 'Delete Podcast',
                              content: 'Are you sure to delete this Podcast? All episodes follow this podcast will be deleted');
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
                url: podcast.imageUrl,
                borderRadius: BorderRadius.circular(1000),
                width: Resizable.size(context, 220),
                height: Resizable.size(context, 220),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              podcast.title,
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                podcast.description,
                style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: Resizable.font(context, 16)),
              ),
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
                        'Topics: ',
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Resizable.font(context, 18)),
                      ),
                      Text(
                        podcast.topicsList.map((e) => e.name).join(', '),
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