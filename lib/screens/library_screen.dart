import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/blocs/recently_play_cubit.dart';
import 'package:poca/screens/lib_download_screen.dart';
import 'package:poca/screens/recently_see_all.dart';

import '../configs/constants.dart';

class YourLibrary extends StatelessWidget {
  const YourLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            toolbarHeight: 60,
            iconTheme: IconThemeData(color: primaryColor),
            title: Text('Library' , style: TextStyle(color: textColor , fontWeight: FontWeight.bold),),
            centerTitle: true,
            bottom:  TabBar(

              padding: const EdgeInsets.symmetric(
                  horizontal: 20
              ),
              tabs: [
                ...['History Listen' , 'Episode Downloaded'].map((e) {
                  return Tab(
                    icon: Text(e ,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: textColor),),

                  );
                }).toList()
              ],
            ),
          ),
          body: TabBarView(
            children: [
              RecentlySeeAll(cubit: context.read<RecentlyPlayCubit>(), title: ''),const LibDownloadScreen()
            ],
          ),
        ),
      ),
    );
  }
}
