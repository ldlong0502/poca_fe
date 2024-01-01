
import 'package:flutter/material.dart';
import 'package:poca/features/home/title_see_all.dart';
import 'package:poca/screens/channel_screen.dart';
import 'package:poca/screens/channel_see_all.dart';

import '../../configs/constants.dart';
import '../../routes/app_routes.dart';
import '../../utils/navigator_custom.dart';
import '../../utils/resizable.dart';
import '../../widgets/network_image_custom.dart';
import '../blocs/home_cubit.dart';

class ChannelsSuggest extends StatelessWidget {
  const ChannelsSuggest({super.key, required this.homeCubit});

  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSeeAll(title: 'Best Channels', onSeeAll: () {
          NavigatorCustom.pushNewScreen(context, ChannelSeeAll( title: "Channels"), '/channel_all');
        }),
        SizedBox(
          height: 220,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(
                left: 20,
                top: 10
            ),
            scrollDirection: Axis.horizontal,
            children: homeCubit.listChannels.take(5).map((e) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: (){
                    NavigatorCustom.pushNewScreen(
                        context,
                        ChannelScreen(
                            channel: e),
                        AppRoutes.channel);
                  },
                  child: SizedBox(
                    width: Resizable.size(context, 150),
                    child: Column(

                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: NetworkImageCustom(
                              url: e.imageUrl,
                              height: Resizable.size(context, 150),
                              width: Resizable.size(context, 150),
                              borderRadius: BorderRadius.circular(20),
                            )),
                        const SizedBox(height: 5,),
                        Expanded(
                          child: Text(
                            e.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Resizable.font(context, 20),
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
