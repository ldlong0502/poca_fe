import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/blocs/player_cubit.dart';
import '../../models/podcast.dart';
import 'play_strategy.dart';

class OfflinePlayStrategy implements PlayStrategy {

  OfflinePlayStrategy(this.context);
  final BuildContext context;
  @override
  void playPodcast(Podcast podcast , int index) {

    debugPrint('offline');
    context.read<PlayerCubit>().listen( podcast, index , 0 , false);
  }
}