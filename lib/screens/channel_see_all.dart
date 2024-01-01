import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/features/blocs/subscribe_cubit.dart';
import 'package:poca/features/dialogs/subcsribe_bottom_sheet.dart';
import 'package:poca/features/podcast/podcast_detail_view.dart';
import 'package:poca/models/channel_model.dart';
import 'package:poca/providers/api/api_channel.dart';
import 'package:poca/screens/channel_screen.dart';
import 'package:poca/utils/dialogs.dart';

import '../configs/constants.dart';
import '../routes/app_routes.dart';
import '../utils/navigator_custom.dart';
import '../utils/resizable.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/custom_button.dart';
import '../widgets/network_image_custom.dart';

class ChannelSeeAll extends StatelessWidget {
  const ChannelSeeAll(
      {super.key,required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom('', context),
      body: BlocProvider(
        create: (context) => ChannelSeeAllCubit()..load(),
        child: BlocBuilder<ChannelSeeAllCubit, int>(
          builder: (context, state) {
            final cubit = context.read<ChannelSeeAllCubit>();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        var text = title;
                        return Text(
                          text,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 24),
                              color: textColor,
                              fontWeight: FontWeight.w600),
                        );
                      }),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                cubit.updateView();
                              },
                              splashRadius: 20,
                              iconSize: Resizable.size(context, 25),
                              color: primaryColor,
                              icon: Icon(
                                cubit.isGrid ? Icons.grid_view_rounded : Icons.sort,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                if (cubit.listChannel.isEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your subscription is empty!\nExplore and return again',
                            style: TextStyle(
                                fontSize: Resizable.font(context, 20),
                                color: primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 50,
                            child: CustomButton(
                                title: 'Explore and Subscribe Podcast',
                                fontSize: 17,
                                onTap: () {
                                  final playCubit = context.read<PlayerCubit>();
                                  playCubit.persistentTabController.jumpToTab(1);
                                },
                                backgroundColor: primaryColor,
                                textColor: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                if (cubit.listChannel.isNotEmpty && cubit.isGrid)
                  Expanded(
                      child: GridView.builder(
                          itemCount: cubit.listChannel.length,
                          padding: EdgeInsets.symmetric(
                              vertical: Resizable.padding(context, 15),
                              horizontal: Resizable.padding(context, 20)),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: Resizable.padding(context, 15),
                            mainAxisSpacing: Resizable.padding(context, 15),
                          ),
                          itemBuilder: (context, index) {
                            var playlist = cubit.listChannel[index];
                            return GestureDetector(
                              onTap: () {
                                NavigatorCustom.pushNewScreen(context, ChannelScreen(channel: playlist), AppRoutes.channel);
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                      child: LayoutBuilder(builder: (context, c) {
                                        return NetworkImageCustom(
                                          url: playlist.imageUrl,
                                          width: c.maxWidth,
                                          height: c.maxHeight,
                                          borderRadius: BorderRadius.circular(20),
                                        );
                                      })),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    playlist.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 20)),
                                  )
                                ],
                              ),
                            );
                          })),
                if (cubit.listChannel.isNotEmpty && !cubit.isGrid)
                  Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 20)
                        ),
                        children: [
                          ...cubit.listChannel.map((e) {
                            return GestureDetector(
                              onTap: () {
                                NavigatorCustom.pushNewScreen(context, ChannelScreen(channel: e), AppRoutes.channel);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    NetworkImageCustom(
                                      url: e.imageUrl,
                                      width: Resizable.size(context, 100),
                                      height: Resizable.size(context, 100),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.name,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: Resizable.font(context, 20)),
                                          ),
                                          Text(
                                            e.about,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: secondaryColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: Resizable.font(context, 15)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList()
                        ],
                      )),
              ],
            );
          },
        ),
      ),
    );
  }
}


class ChannelSeeAllCubit extends Cubit<int> {
  ChannelSeeAllCubit() : super(0);
  List<ChannelModel> listChannel = [];

  bool isGrid = true;

  updateView() {
    isGrid = !isGrid;
    emit(state+1);
  }
  load() async {
    listChannel = await ApiChannel.instance.getAllChannels();
    emit(state + 1);
  }
}
