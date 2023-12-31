import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/admin_cubit.dart';

import '../../features/admin/slider.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit()..clickSliderItem(0, 'Home'),
      child: BlocBuilder<AdminCubit, int>(
        builder: (context, state) {
          final cubit = context.read<AdminCubit>();
          return Scaffold(
            body: SliderDrawer(
              key: cubit.key,
              appBar: SliderAppBar(
                  appBarColor: Colors.white,
                  appBarHeight: 80,
                  title: Text(cubit.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700))),
              slider: AdminSlider(cubit: cubit),
              child: cubit.currentScreen!,
            ),

          );
        },
      ),
    );
  }
}
