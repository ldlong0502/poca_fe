import 'package:flutter/material.dart';
import 'package:poca/models/audio_book.dart';
import 'package:poca/screens/admin/admin_home.dart';
import 'package:poca/screens/admin/channels/ad_channel_create.dart';
import 'package:poca/screens/admin/channels/ad_detail_channel.dart';
import 'package:poca/screens/admin/channels/ad_edit_channel.dart';
import 'package:poca/screens/admin/episode/ad_create_episode.dart';
import 'package:poca/screens/admin/episode/ad_detail_episode.dart';
import 'package:poca/screens/admin/episode/ad_edit_episode.dart';
import 'package:poca/screens/admin/podcasts/ad_create_podcast.dart';
import 'package:poca/screens/admin/podcasts/ad_edit_podcast.dart';
import 'package:poca/screens/admin/podcasts/admin_detail_podcast.dart';
import 'package:poca/screens/admin/topics/admin_detail_topic.dart';
import 'package:poca/screens/admin/users/admin_detail_user.dart';
import 'package:poca/screens/admin/users/create_user_view.dart';
import 'package:poca/screens/forgot_password_screen.dart';
import 'package:poca/screens/home_screen.dart';
import 'package:poca/screens/login_screen.dart';
import 'package:poca/screens/main_screen.dart';
import 'package:poca/screens/on_board_screen.dart';
import 'package:poca/screens/sign_up_screen.dart';

import '../screens/admin/topics/create_topic_view.dart';
import '../screens/admin/topics/edit_topic_view.dart';
import '../screens/audio_book_detail_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const main = '/main';
  static const forgotPass = '/forgotPass';
  static const audioBookDetail = '/audioBookDetail';
  static const onBoarding = '/onBoarding';
  static const login = '/login';
  static const signUp = '/signUp';
  static const topicDetail = '/topicDetail';
  static const podcastDetail = '/podcastDetail';
  static const playlist = '/playlist';
  static const playlistDetail = '/playlistDetail';
  static const subsSeeAll = '/subsSeeAll';
  static const recentlySeeAll = '/recentlySeeAll';
  static const editAccount = '/editAccount';
  static const channel = '/channel';

  static const adminHome = '/adminHome';
  static const adminUserDetail = '/adminUserDetail';
  static const adminCreateUser = '/adminCreateUser';

  static const adminCreateTopic = '/adminCreateTopic';
  static const adminEditTopic = '/adminEditTopic';
  static const adminDetailTopic = '/adminDetailTopic';

  static const adminCreatePodcast = '/adminCreatePodcast';
  static const adminDetailPodcast = '/adminDetailPodcast';
  static const adminEditPodcast = '/adminEditPodcast';

  static const adminCreateEpisode = '/adminCreateEpisode';
  static const adminDetailEpisode = '/adminDetailEpisode';
  static const adminEditEpisode = '/adminEditEpisode';


  static const adminCreateChannel = '/adminCreateChannel';
  static const adminDetailChannel= '/adminDetailChannel';
  static const adminEditChannel= '/adminEditChannel';

  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
            builder: (context) => const SplashScreen(), settings: settings);
      case AppRoutes.forgotPass:
        return MaterialPageRoute(
            builder: (context) => const ForgotPasswordScreen(), settings: settings);
      case AppRoutes.main:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => MainScreen(isLogin: map['isLogin']),
            settings: settings);
      case AppRoutes.onBoarding:
        return MaterialPageRoute(
            builder: (context) => const OnBoardingScreen(), settings: settings);
      case AppRoutes.login:
        return MaterialPageRoute(
            builder: (context) => const LoginScreen(), settings: settings);
      case AppRoutes.signUp:
        return MaterialPageRoute(
            builder: (context) => const SignUpScreen(), settings: settings);

      case AppRoutes.adminHome:
        return MaterialPageRoute(
            builder: (context) => const AdminHomeScreen(), settings: settings);
      case AppRoutes.adminUserDetail:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) =>
                AdminDetailUsers(cubit: map['cubit'], user: map['user']),
            settings: settings);
      case AppRoutes.adminCreateUser:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => CreateUserView(
                  adminUsersCubit: map['cubit'],
                ),
            settings: settings);
      case AppRoutes.adminCreateTopic:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => CreateTopicView(
                  adminTopicsCubit: map['cubit'],
                ),
            settings: settings);
      case AppRoutes.adminDetailTopic:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => AdminDetailTopic(
                  cubit: map['cubit'],
                  topic: map['topic'],
                ),
            settings: settings);

      case AppRoutes.adminEditTopic:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => EditTopicView(
                  adminTopicsCubit: map['cubit'],
                  topic: map['topic'],
                ),
            settings: settings);

      case AppRoutes.adminCreatePodcast:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => AdCreatePodcastView(
                  adminPodcastsCubit: map['cubit'],
                ),
            settings: settings);

      case AppRoutes.adminDetailPodcast:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => AdminDetailPodcast(
                  cubit: map['cubit'],
                  podcast: map['podcast'],
                ),
            settings: settings);

      case AppRoutes.adminEditPodcast:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => AdEditPodcastView(
                  adminPodcastsCubit: map['cubit'],
                  podcast: map['podcast'],
                ),
            settings: settings);

      case AppRoutes.adminCreateEpisode:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => AdCreateEpisodeView(
                  adminEpisodesCubit: map['cubit'],
                ),
            settings: settings);

      case AppRoutes.adminDetailEpisode:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => AdminDetailEpisode(
                  cubit: map['cubit'],
                  episode: map['episode'],
                ),
            settings: settings);

      case AppRoutes.adminEditEpisode:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => AdEditEpisodeView(
                adminEpisodesCubit: map['cubit'], episode: map['episode']),
            settings: settings);

      case AppRoutes.adminCreateChannel:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => AdCreateChannelScreen(
              adminChannelsCubit: map['cubit'],
            ),
            settings: settings);

      case AppRoutes.adminDetailChannel:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => AdminDetailChannel(
              cubit: map['cubit'],
              channel: map['channel'],
            ),
            settings: settings);

      case AppRoutes.adminEditChannel:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => AdEditChannelScreen(
                adminChannelsCubit: map['cubit'], channel: map['channel']),
            settings: settings);
    }

    return null;
  }
}
