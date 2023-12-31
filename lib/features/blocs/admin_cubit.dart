import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:poca/screens/admin/admin_episodes.dart';
import 'package:poca/screens/admin/admin_podcasts.dart';
import 'package:poca/screens/admin/admin_statistics.dart';
import 'package:poca/screens/admin/admin_topics.dart';
import 'package:poca/screens/admin/admin_users.dart';

import '../../screens/admin/admin_channels.dart';

class AdminCubit extends Cubit<int> {
  AdminCubit() : super(0);

  GlobalKey<SliderDrawerState> key = GlobalKey<SliderDrawerState>();

  Widget? currentScreen;
  String title  = 'Home';
  int currentIndex  = 0;
  setCurrentScreen(Widget widget) {
    currentScreen  = widget;
    emit(state+1);
  }

  clickSliderItem(int index , String value) {
      title = value;
      currentIndex = index;
      setCurrentScreen(getWidget(index));
  }

  Widget getWidget(int index) {
    print(index);
    switch(index) {
      case 0: return const AdminStatisticsScreen();
      case 1: return const AdminUsersScreen();
      case 2: return const AdminPodcastsScreen();
      case 3: return const AdminEpisodesScreen();
      case 4: return const AdminTopicsScreen();
      case 5: return const AdminChannelsScreen();
      default: return const AdminStatisticsScreen();
    }
  }


}
