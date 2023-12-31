import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/channel_detail_cubit.dart';
import 'package:poca/features/channel/create_podcast_view.dart';
import 'package:poca/utils/navigator_custom.dart';
import 'package:poca/widgets/custom_button.dart';

import '../../utils/resizable.dart';
import 'create_episode_view.dart';

class CreatePodcastScreen extends StatelessWidget {
  const CreatePodcastScreen({super.key, required this.channelDetailCubit});
  final ChannelDetailCubit channelDetailCubit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Stack(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/icons/ic_bg_circle_1.png',
                width: Resizable.width(context) / 2,
                fit: BoxFit.fill,
                height: Resizable.height(context) * 4 / 9,
              )),
          Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/icons/ic_bg_circle_2.png',
                width: Resizable.width(context) / 2,
                fit: BoxFit.fill,
                height: Resizable.height(context) * 3 / 4,
              )),
          SizedBox(
            height: Resizable.height(context),
            width: double.infinity,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white,
                      icon: Icon(Platform.isAndroid
                          ? Icons.arrow_back
                          : Icons.arrow_back_ios)),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/icons/ic_create_podcast.png', scale: 2),
                          const SizedBox(height: 10,),
                          CustomButton(
                              title: 'Create a podcast',
                              onTap: () {
                                NavigatorCustom.pushNewScreen(context,  CreatePodcastView(channelDetailCubit: channelDetailCubit), '/createPodcastView');
                              },
                              backgroundColor: primaryColor,
                              textColor: Colors.white)
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/icons/ic_cretae_episode.png', scale: 2),
                          const SizedBox(height: 10,),
                          CustomButton(
                              title: 'Create a episode',
                              onTap: () {
                                NavigatorCustom.pushNewScreen(context,  CreateEpisodeView(channelDetailCubit: channelDetailCubit), '/createEpisodeView');
                              },
                              backgroundColor: secondaryColor,
                              textColor: Colors.white)
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
