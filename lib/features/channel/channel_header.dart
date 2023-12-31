import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/blocs/channel_detail_cubit.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/features/dialogs/normal_dialog.dart';
import 'package:poca/models/channel_model.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/widgets/custom_button.dart';

import '../../configs/constants.dart';
import '../../routes/app_routes.dart';
import '../../utils/resizable.dart';
import '../../widgets/network_image_custom.dart';

class ChannelHeader extends StatelessWidget {
  const ChannelHeader({super.key, required this.cubit});

  final ChannelDetailCubit cubit;

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return SizedBox(
        height: Resizable.size(context, 180),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                  child: LayoutBuilder(
                    builder: (context ,c ) {
                      return NetworkImageCustom(
                url: cubit.channel!.imageUrl,
                width: c.maxWidth,
                height: c.maxHeight,
                borderRadius: BorderRadius.circular(20),
              );
                    }
                  )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      cubit.channel!.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: textColor,
                          fontSize: Resizable.font(context, 24),
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Subscribed: ${cubit.channel!.subscribed.length}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: Resizable.font(context, 20),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if(cubit.channel!.idUser != userCubit.state?.id)
                    Builder(builder: (context) {
                      var isSubscribe = cubit.channel!.subscribed
                          .contains(userCubit.state?.id);

                      return isSubscribe
                          ? TextButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return NormalDialog(
                                        onYes: () async {
                                          var res = await cubit.subscribeChannel('remove', userCubit.state!.id);
                                          if(res && context.mounted) {
                                            CustomToast.showBottomToast(context, 'Successfully');
                                          }
                                          else if(context.mounted) {
                                            CustomToast.showBottomToast(context, 'Error');
                                          }
                                       if(context.mounted) {
                                         Navigator.pop(context);
                                       }
                                        },
                                        onCancel: () {
                                          Navigator.pop(context);
                                        },
                                        title: 'Unsubscribe',
                                        content:
                                            'Do you want to unsubscribe this channel?');
                                  },
                                );
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(purpleColor),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(1000)))),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Subscribed',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.check_circle)
                                ],
                              ))
                          : TextButton(
                          onPressed: () async {
                            if(userCubit.state == null) {
                              Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.login);
                              return;
                            }
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return NormalDialog(
                                    onYes: () async {
                                      var res = await cubit.subscribeChannel('add', userCubit.state!.id);

                                      if(res && context.mounted) {
                                        CustomToast.showBottomToast(context, 'Successfully');
                                      }
                                      else if(context.mounted) {
                                        CustomToast.showBottomToast(context, 'Error');
                                      }
                                      if(context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    onCancel: () {
                                      Navigator.pop(context);
                                    },
                                    title: 'Subscribe',
                                    content:
                                    'Do you want to subscribe this channel?');
                              },
                            );
                          },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  side: MaterialStateProperty.all(
                                      const BorderSide(color: purpleColor)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(1000)))),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Subscribe',
                                    style: TextStyle(
                                        color: purpleColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.add)
                                ],
                              ));
                    })
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
