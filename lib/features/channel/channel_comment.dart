import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/channel/item_comment.dart';
import 'package:poca/models/podcast.dart';

import '../blocs/channel_detail_cubit.dart';
import 'about_channel.dart';

class CommentChannel extends StatelessWidget {
  const CommentChannel({super.key, required this.cubit});

  final ChannelDetailCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocProvider(
        create: (context) =>
        ListPodcastCubit(cubit.channel!)
          ..load(),
        child: BlocBuilder<ListPodcastCubit, List<Podcast>>(
          builder: (context, state) {
            if(state.isEmpty) return Container();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                ...state.map((e) => ItemComment(e, channel: cubit.channel!, isFinal: state.indexOf(e) == state.length - 1,)).toList(),
                const SizedBox(
                  height: 100,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}