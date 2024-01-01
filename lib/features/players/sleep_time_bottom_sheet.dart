
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/models/download_episode.dart';
import 'package:poca/screens/lib_download_screen.dart';

import '../../../models/episode.dart';
import '../../../utils/resizable.dart';
import '../../../widgets/network_image_custom.dart';
import '../account/playlist/base_bottom_sheet.dart';

class SleepTimeBottomSheet extends StatelessWidget {
  const SleepTimeBottomSheet(
      {super.key, required this.cubit
      });
  final PlayerCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: Resizable.height(context) * 0.4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 20)),
            child: Text(
              'Sleep Time',
              maxLines: 2,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Resizable.font(context, 20),
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 20) , vertical: 10),
            child: Column(
              children: [
                ...cubit.listTime.asMap().entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        cubit.setTime(e.key);
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Text(
                              e.value,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Resizable.font(context, 20)),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList()
              ],
            ),
          )
        ],
      ),
    );
  }
}
