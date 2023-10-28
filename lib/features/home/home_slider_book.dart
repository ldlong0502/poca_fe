import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_wave/blocs/home_cubit.dart';
import 'package:uni_wave/configs/constants.dart';
import 'package:uni_wave/routes/app_routes.dart';
import 'package:uni_wave/screens/audio_book_detail_screen.dart';
import 'package:uni_wave/utils/resizable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/navigator_custom.dart';

class HomeSliderBook extends StatelessWidget {
  const HomeSliderBook({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, int>(builder: (context, state) {
      final cubit = context.read<HomeCubit>();
      return state == 0 || cubit.top5Audiobooks.isEmpty
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
              child: SizedBox(
                height: Resizable.size(context, 300),
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        cubit.defaultImage,
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                  itemCount: 5,
                  viewportFraction: 0.5,
                  scale: 0.4,
                  onIndexChanged: (index) {
                    cubit.changeIndexEbook(index);
                  },
                ),
              ),
            )
          : SizedBox(
              height: Resizable.size(context, 300),
              child: Swiper(
                itemBuilder: (BuildContext cc, int index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    child: GestureDetector(
                      onTap: () {
                        NavigatorCustom.pushNewScreen(
                            context,
                            AudioBookDetailScreen(
                                audioBook: cubit.top5Audiobooks[index]),
                            AppRoutes.audioBookDetail +
                                cubit.top5Audiobooks[index].id.toString());
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Hero(
                          tag: 'audio_book_${cubit.top5Audiobooks[index].id}',
                          child: Column(
                            children: [
                              Flexible(
                                child: CachedNetworkImage(
                                  imageUrl: cubit.top5Audiobooks[index].image,
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
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                height: index == cubit.indexEbook
                                    ? Resizable.size(context, 20)
                                    : 0,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [purpleColor, pinkColor],
                                    ),
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(15))),
                                child: Center(
                                  child: Text(
                                    'Mới cập nhật',
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: Resizable.font(context, 13)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: cubit.top5Audiobooks.length,
                viewportFraction: 0.5,
                scale: 0.4,
                onIndexChanged: (index) {
                  cubit.changeIndexEbook(index);
                },
              ),
            );
    });
  }
}
