import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_wave/blocs/home_cubit.dart';
import 'package:uni_wave/configs/constants.dart';
import 'package:uni_wave/features/home/appbar_item.dart';
import 'package:uni_wave/features/home/home_slider_book.dart';
import 'package:uni_wave/utils/resizable.dart';

import '../../providers/firebase_provider.dart';
import '../../routes/app_routes.dart';

class AppBarHome extends StatelessWidget {
  const AppBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();
    cubit.scrollController.addListener(() {
      if(cubit.scrollController.offset > Resizable.size(context, 150) - kToolbarHeight) {
        cubit.changeAppBarColor(true);

      }
      else if (cubit.appBarColor == purpleColor.withOpacity(0.9)) {
        cubit.changeAppBarColor(false);
      }
    });
    return SliverAppBar(
      backgroundColor: cubit.appBarColor,
      elevation: 0,
      expandedHeight: Resizable.size(context, 150),
      floating: false,
      pinned: true,
      leading: IconButton(
        onPressed: (){
          // FireBaseProvider.instance.addJsonToFireBase();
        },
        icon: const Icon(
          Icons.ac_unit,
          color: Colors.white,
        ),
      ),
      title: Text(
        'UniWave',
        style: TextStyle(
            color: Colors.white,
            fontSize: Resizable.font(context, 20),
            fontWeight: FontWeight.bold),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 15),
        ),
        background: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppBarItem(
                  asset: 'assets/icons/ic_audio_book.png',
                  height: 40,
                  title: 'Sách nghe',
                  onTap: (){}),
              AppBarItem(
                  asset: 'assets/icons/ic_ebook.png',
                  height: 40,
                  title: 'Ebook',
                  onTap: (){}),
            ],
          ),
        ),
      ),
    );
  }
}
