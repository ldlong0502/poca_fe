import 'package:flutter/material.dart';
import 'package:uni_wave/models/audio_book.dart';
import 'package:uni_wave/screens/home_screen.dart';
import 'package:uni_wave/screens/main_screen.dart';

import '../screens/audio_book_detail_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const main = '/main';
  static const audioBookDetail = '/audioBookDetail';

  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
            builder: (context) => const SplashScreen(), settings: settings);
      case AppRoutes.main:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => MainScreen(isLogin: map['isLogin']),
            settings: settings);
      case AppRoutes.audioBookDetail:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => AudioBookDetailScreen(audioBook: map['audioBook']),
            settings: settings);
    }

    return null;
  }
}
