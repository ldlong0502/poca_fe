import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_wave/blocs/home_cubit.dart';
import 'package:uni_wave/blocs/mini_player_cubit.dart';
import 'package:uni_wave/configs/constants.dart';
import 'package:uni_wave/features/home/appbar_home.dart';
import 'package:uni_wave/features/home/home_slider_book.dart';
import 'package:uni_wave/utils/resizable.dart';

import '../configs/app_configs.dart';
import '../widgets/custom_mini_player.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    AppConfigs.contextApp = context;
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, int>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: state == 0
                               ? cubit.defaultImage
                                : cubit.top5Audiobooks[cubit.indexEbook].image,
                          fit: BoxFit.fill,
                          width: double.infinity,
                          placeholder: (context, s) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Image.asset(
                                  'assets/images/book_temp.jpg'),
                            );
                          },
                          errorWidget: (context, s, _) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Image.asset(
                                  'assets/images/book_temp.jpg'),
                            );
                          },
                        ),

                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                // Điều chỉnh mức độ mờ ở đây
                child: Container(
                  color: Colors.black
                      .withOpacity(0.05), // Điều chỉnh màu nền mờ ở đây
                ),
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: CustomScrollView(
                  controller: cubit.scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const AppBarHome(),
                    const SliverToBoxAdapter(child: HomeSliderBook()),
                    SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.white,
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text('Item $index'),
                                  );
                                }),
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                            // Điều chỉnh mức độ mờ ở đây
                            child: Container(
                              color: Colors.black
                                  .withOpacity(0.05), // Điều chỉnh màu nền mờ ở đây
                            ),
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text('Item $index'),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}
