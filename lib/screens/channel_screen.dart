import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/channel_detail_cubit.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/features/channel/about_channel.dart';
import 'package:poca/features/channel/channel_header.dart';
import 'package:poca/features/channel/comment_channel.dart';
import 'package:poca/features/channel/edit_info_channel.dart';
import 'package:poca/features/channel/info_channel.dart';
import 'package:poca/models/channel_model.dart';
import 'package:poca/utils/navigator_custom.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../features/channel/create_podcast.dart';

class ChannelScreen extends StatelessWidget {
  const ChannelScreen({super.key, required this.channel});

  final ChannelModel channel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChannelDetailCubit()..load(channel.id),
      child: BlocBuilder<ChannelDetailCubit, int>(
        builder: (context, state) {
          final cubit = context.read<ChannelDetailCubit>();
          final userCubit = context.read<UserCubit>();
          if(state == 0 ) return const Scaffold(body: LoadingProgress());
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              iconTheme: const IconThemeData(color: purpleColor),
              centerTitle: true,
              title: Builder(
                builder: (context) {
                  var text = cubit.channel!.isUser ? 'User Channel' : 'Special Channel';
                  return Text(text, style: const TextStyle(color: purpleColor, fontWeight: FontWeight.bold),);
                }
              ),

            ),
            body: Column(
              children: [
                ChannelHeader(cubit: cubit),
                Expanded(
                  child: DefaultTabController(
                    length: cubit.tabs.length,
                    child: Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        toolbarHeight: 20,
                        bottom:  TabBar(

                          padding: const EdgeInsets.symmetric(
                            horizontal: 20
                          ),
                          tabs: [
                            ...cubit.tabs.map((e) {
                              return Tab(
                                icon: Text(e , style: const TextStyle(color: textColor),),

                              );
                            }).toList()
                          ],
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          AboutChannel(cubit: cubit),
                          CommentChannel(cubit: cubit),
                          if(cubit.tabs.length > 2)
                            InfoChannel(cubit: cubit)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: channel.idUser == userCubit.state?.id ? SpeedDial(
                useRotationAnimation: true,
                  backgroundColor: primaryColor,
                  overlayColor: Colors.black.withOpacity(0.4),
                  children: [
                    SpeedDialChild(
                      child: const Icon(Icons.mic),
                      label: 'Create Podcast',
                      onTap: () {
                        NavigatorCustom.pushNewScreen(context,  CreatePodcastScreen(channelDetailCubit: cubit), '/createPodcast');
                      },),
                    SpeedDialChild(
                      child: const Icon(Icons.edit),
                      label: 'Edit info',
                      onTap: () {
                        NavigatorCustom.pushNewScreen(context, EditInfoChannelScreen(channelDetailCubit: cubit), '/editInfoChannel');
                      },),
                  ],
                child: const Icon(Icons.add)
              ): null,
            ),
          );
        },
      ),
    );
  }
}
