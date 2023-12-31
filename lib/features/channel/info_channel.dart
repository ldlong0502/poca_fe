import 'package:flutter/material.dart';
import 'package:poca/features/blocs/channel_detail_cubit.dart';

import '../../configs/constants.dart';
import '../../utils/resizable.dart';

class InfoChannel extends StatelessWidget {
  const InfoChannel({super.key, required this.cubit});
  final ChannelDetailCubit cubit;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20,),
          Row(
            children: [
              Text('Date of birth: ', style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Resizable.font(context, 18)
              ),),
              Text(cubit.channel!.info['dob'], style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 16)
              ),),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Text('Gender: ', style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Resizable.font(context, 18)
              ),),
              Text(cubit.channel!.info['sex'], style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 16)
              ),),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Text('Zodiac: ', style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Resizable.font(context, 18)
              ),),
              Text(cubit.channel!.info['zodiac'], style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 16)
              ),),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Text('Hobbies: ', style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Resizable.font(context, 18)
              ),),
              Text(cubit.channel!.info['hobbies'], style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 16)
              ),),
            ],
          ),
        ],
      ),
    );
  }
}
