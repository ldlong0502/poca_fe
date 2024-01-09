import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/design_patterns/strategy/play_strategy.dart';
import 'package:poca/models/podcast.dart';

import '../../features/blocs/player_cubit.dart';

class OnlinePlayStrategy implements PlayStrategy {
  OnlinePlayStrategy(this.context);
  final BuildContext context;
  @override
  void playPodcast(Podcast podcast , int index) {
    debugPrint('online');
    context.read<PlayerCubit>().listen( podcast, index , 0 , false);
  }
}