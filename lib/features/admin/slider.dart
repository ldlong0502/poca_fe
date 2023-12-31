import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/admin_cubit.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/widgets/network_image_custom.dart';

import '../../providers/api/api_auth.dart';

class AdminSlider extends StatelessWidget {
  const AdminSlider({super.key, required this.cubit});

  final AdminCubit cubit;

  @override
  Widget build(BuildContext context) {
    var itemSlider1 = [
      {
        'index': 0,
        'title': 'Home',
        'icon': 'assets/icons/ic_home.png',
      },
      {
        'index': 1,
        'title': 'Users',
        'icon': 'assets/icons/ic_admin_user.png',
      },
      {
        'index': 2,
        'title': 'Podcasts',
        'icon': 'assets/icons/ic_admin_podcast.png',
      },
      {
        'index': 3,
        'title': 'Episodes',
        'icon': 'assets/icons/ic_admin_episode.png',
      },
      {
        'index': 4,
        'title': 'Topics',
        'icon': 'assets/icons/ic_admin_topic.png',
      },
      {
        'index': 5,
        'title': 'Channels',
        'icon': 'assets/icons/ic_admin_channel.png',
      },
    ];

    var itemSlider2 = [
      {
        'index': 0,
        'title': 'Logout',
        'icon': 'assets/icons/ic_admin_logout.png',
      },
    ];
    return SafeArea(
      child: BlocBuilder<UserCubit, UserModel?>(
        builder: (context, state) {
          if(state == null) return Container();
          return Container(
            color: primaryColor.withOpacity(0.9),
            height: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        NetworkImageCustom(url: state.imageUrl, borderRadius: BorderRadius.circular(1000),
                        height: 80,
                          width: 80,
                        ),
                        const SizedBox(width: 10,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.fullName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Admin',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        )),
                      ],
                    ),
                    ...itemSlider1.map((e) {
                      return InkWell(
                        onTap: () {
                          cubit.clickSliderItem(e['index'] as int, e['title'] as String);
                          cubit.key.currentState?.closeSlider();
                        },
                        child: SizedBox(
                          height: 70,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 35,
                                child: Center(
                                  child: Image.asset(
                                    e['icon'] as String,
                                    scale: 2.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                  child: Text(
                                    e['title'] as String,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    const Divider( color: Colors.white, height: 2, thickness: 2,),
                    ...itemSlider2.map((e) {
                      return InkWell(
                        onTap: () async {
                          if(e['index'] == 0) {
                            await ApiAuthentication.instance.logOut(context);
                          }
                        },
                        child: SizedBox(
                          height: 70,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 35,
                                child: Center(
                                  child: Image.asset(
                                    e['icon'] as String,
                                    scale: 2.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                  child: Text(
                                    e['title'] as String,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
