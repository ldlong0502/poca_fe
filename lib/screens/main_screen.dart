import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:poca/blocs/app_cubit.dart';
import 'package:poca/blocs/mini_player_cubit.dart';
import 'package:poca/configs/app_configs.dart';
import 'package:poca/configs/constants.dart';

import '../utils/resizable.dart';
import '../widgets/custom_mini_player.dart';
import 'account_screen.dart';
import 'home_screen.dart';
import 'library_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    var child = [
      HomeScreen(isLogin: isLogin),
      LibraryScreen(isLogin: isLogin),
      AccountScreen(isLogin: isLogin),
      AccountScreen(isLogin: isLogin)
    ];

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon:  Image.asset('assets/icons/ic_home_fill.png' , color: purpleColor,),
          inactiveIcon:  Image.asset('assets/icons/ic_home.png' , color: purpleColor,),
          title: ('Home'),
          activeColorPrimary: purpleColor,
          inactiveColorPrimary: purpleColor,
        ),
        PersistentBottomNavBarItem(
          icon:  Image.asset('assets/icons/ic_structure_fill.png' , color: purpleColor,),
          inactiveIcon:  Image.asset('assets/icons/ic_structure.png' , color: purpleColor,),
          title: ("Categories"),
          activeColorPrimary: purpleColor,
          inactiveColorPrimary: purpleColor,
        ),
        PersistentBottomNavBarItem(
          icon:  Image.asset('assets/icons/ic_search_fill.png' , color: purpleColor,),
          inactiveIcon:  Image.asset('assets/icons/ic_search.png' , color: purpleColor,),
          title: ("Explore"),
          activeColorPrimary: purpleColor,
          inactiveColorPrimary: purpleColor,
        ),
        PersistentBottomNavBarItem(
          icon:  Image.asset('assets/icons/ic_setting_fill.png' , color: purpleColor,),
          inactiveIcon:  Image.asset('assets/icons/ic_setting.png' , color: purpleColor,),
          title: ("Settings"),
          activeColorPrimary: purpleColor,
          inactiveColorPrimary: purpleColor,
        ),
      ];
    }
    return Scaffold(
      body: BlocBuilder<MiniPlayerCubit, int>(
        builder: (context, state) {
          final cubit = context.read<MiniPlayerCubit>();

          return Scaffold(
            body: Stack(
              children: [
                PersistentTabView(
                  context,
                  screens: child,
                  hideNavigationBar: !cubit.isMiniPlayer,
                  items: navBarsItems(),
                  confineInSafeArea: true,
                  backgroundColor: Colors.white,
                  handleAndroidBackButtonPress: true,
                  resizeToAvoidBottomInset: true,
                  stateManagement: true,
                  hideNavigationBarWhenKeyboardShows: true,
                  decoration: NavBarDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15)
                    ),
                    colorBehindNavBar: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  popAllScreensOnTapOfSelectedTab: true,
                  popActionScreens: PopActionScreensType.all,
                  itemAnimationProperties: const ItemAnimationProperties(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease,
                  ),
                  screenTransitionAnimation: const ScreenTransitionAnimation(
                    animateTabTransition: true,
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 200),
                  ),
                  navBarStyle: NavBarStyle
                      .style9, // Choose the nav bar style with this property.
                ),
                const CustomMiniPlayer()
              ],
            ),
          );
        },
      ),

    );
  }
}
