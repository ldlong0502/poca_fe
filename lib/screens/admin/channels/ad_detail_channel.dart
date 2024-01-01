import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/models/channel_model.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/api/api_channel.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/providers/api/api_topic.dart';
import 'package:poca/screens/admin/admin_channels.dart';
import 'package:poca/screens/admin/admin_podcasts.dart';

import '../../../configs/constants.dart';
import '../../../features/admin/dialogs/user_bottom_sheet.dart';
import '../../../features/channel/about_channel.dart';
import '../../../features/dialogs/normal_dialog.dart';
import '../../../models/topic.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/resizable.dart';
import '../../../widgets/network_image_custom.dart';

class AdminDetailChannel extends StatelessWidget {
  const AdminDetailChannel({super.key, required this.cubit, required this.channel});

  final AdminChannelsCubit cubit;
  final ChannelModel channel;

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
                  if(!channel.isUser)
                  ActionBottom('Edit Channel', Icons.edit, () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.adminEditChannel , arguments: {
                      'cubit': cubit,
                      'channel': channel
                    });
                  }),
                  ActionBottom('Delete Channel', Icons.remove_circle_outline, () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return NormalDialog(
                              onYes: () async {

                                var listPodcast = await ApiPodcast.instance.getListPodcastByChannelId(channel.id);

                                for(var item in listPodcast) {
                                  await ApiPodcast.instance.deletePodcast(item.id);
                                }
                                var res = await ApiChannel.instance.deleteChannel(channel.id);
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
                              title: 'Delete Channel',
                              content: 'Are you sure to delete this Channel? All podcasts and episodes belong this Channel will be deleted');
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
                url: channel.imageUrl,
                borderRadius: BorderRadius.circular(1000),
                width: Resizable.size(context, 220),
                height: Resizable.size(context, 220),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                channel.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Resizable.font(context, 20)),
              ),
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
                channel.about,
                style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: Resizable.font(context, 16)),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocProvider(
                  create: (context) =>
                  TopicsStringCubit(channel.topics)..load(),
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
            ),
          ],
        ),
      ),
    );
  }
}