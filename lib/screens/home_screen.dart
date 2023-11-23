import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:poca/blocs/home_cubit.dart';
import 'package:poca/blocs/mini_player_cubit.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/home/appbar_home.dart';
import 'package:poca/features/home/home_slider_book.dart';
import 'package:poca/utils/resizable.dart';

import '../configs/app_configs.dart';
import '../widgets/header_custom.dart';
import '../widgets/custom_mini_player.dart';
import 'base_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    AppConfigs.contextApp = context;
    return const BaseScreen(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderCustom(title: 'Good morning,')
          ],
        ),
      ),
    );
  }
}
