import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:poca/blocs/comment_cubit.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/utils/resizable.dart';

import '../blocs/mini_player_cubit.dart';
import '../configs/constants.dart';
import '../features/blocs/user_cubit.dart';
import '../models/comment.dart';
import '../services/nfc_services.dart';
import 'convert_utils.dart';

class Dialogs {
  static void showComment(BuildContext context, CommentCubit cubit) {
    final listComment = cubit.listComment;
    final userCubit = context.read<UserCubit>();
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return SizedBox(
            height: Resizable.height(context) * 0.8,
            child:  ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(
                  Resizable.padding(context, 20)
              ),
              physics: const BouncingScrollPhysics(),
              children: [
                ...cubit.listComment.toList().map((e) {
                  final time = ConvertUtils.convertIntToDateTime(e.createdAt);
                  final index =listComment.indexOf(e);
                  var model = cubit.listUserModel[index];
                  var who = userCubit.state != null && userCubit.state!.id == model.id ? 'YOU': model.fullName;
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: Resizable.padding(context, 20),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 20),
                        vertical: Resizable.padding(context, 10)),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5,),
                        Text('By $who at $time'.toUpperCase(),
                            style: TextStyle(
                                fontSize: Resizable.font(context, 12),
                                color: pinkColor,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            Text(
                              'RATING',
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 12),
                                  color: purpleColor,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 20,),
                            RatingBarIndicator(
                              rating: e.rate,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star_rounded,
                                color: purpleColor,
                              ),
                              unratedColor: Colors.grey.shade300,
                              itemCount: 5,
                              itemSize: 15.0,
                              direction: Axis.horizontal,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          e.content,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 14),
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20,),
              ],
            ),
          );
        });
  }

  static void showChapter(BuildContext context, MiniPlayerCubit cubit) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return SizedBox(
            height: Resizable.height(context) * 0.9,
            child: Column(
              children: [
                Container(
                  height: 70,
                  padding: EdgeInsets.all(Resizable.padding(context, 20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chương ',
                        style: TextStyle(
                            color: purpleColor,
                            fontWeight: FontWeight.w700,
                            fontSize: Resizable.font(context, 18)),
                      ),
                      CircleAvatar(
                          radius: 15,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.clear_rounded,
                                size: 15,
                              )))
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(Resizable.padding(context, 20)),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ...cubit.currentAudioBook!.listMp3.toList().map((e) {
                          final isListen = cubit.indexChapter + 1 == e.id;
                          return GestureDetector(
                            onTap: () {
                              if (!isListen) {
                                Navigator.pop(context);
                                cubit.changeChapter(e.id - 1);
                              } else {
                                CustomToast.showBottomToast(
                                    context, 'Bạn đang nghe chương này rồi!');
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: Resizable.padding(context, 20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 20),
                                  vertical: Resizable.padding(context, 10)),
                              decoration: BoxDecoration(
                                  color: !isListen
                                      ? Colors.white70
                                      : Colors.deepOrangeAccent
                                          .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(1000),
                                  border: !isListen
                                      ? Border.all(color: purpleColor)
                                      : null),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.headset,
                                    color: Colors.grey,
                                    size: 35,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (isListen)
                                          AutoSizeText(
                                            'Bạn đang nghe',
                                            style: TextStyle(
                                                fontSize:
                                                    Resizable.font(context, 12),
                                                color: Colors.black
                                                    .withOpacity(0.9),
                                                fontWeight: FontWeight.w600),
                                          ),
                                        AutoSizeText(
                                          e.title,
                                          style: TextStyle(
                                              fontSize:
                                                  Resizable.font(context, 18),
                                              color:
                                                  purpleColor.withOpacity(0.9),
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isListen)
                                    AvatarGlow(
                                      glowColor: Colors.blue,
                                      endRadius: 30.0,
                                      duration:
                                          const Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration:
                                          const Duration(milliseconds: 100),
                                      child: Material(
                                        // Replace this child with your own
                                        elevation: 8.0,
                                        shape: const CircleBorder(),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey.shade300,
                                          child: Icon(
                                            Icons.volume_down_rounded,
                                            color: pinkColor,
                                            size: Resizable.size(context, 20),
                                          ),
                                          radius: 15.0,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  static void showBottomSheet(BuildContext context, Widget widget) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: primaryColor.withOpacity(0.9),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return widget;
        });
  }

  static void showDialogCustom(BuildContext context, Widget widget) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return widget;
      },
    );
  }

  static void showNFCAction(BuildContext context, String type) {
    final cubit = context.read<LoadingCubit>();
    cubit.update(0);
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return BlocConsumer<LoadingCubit, int>(
            bloc: cubit,
            builder: (context, state) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    state == 0
                        ? Image.asset('assets/icons/ic_nfc.png', height: 100)
                        : state == 1
                        ? Image.asset(
                      'assets/icons/ic_check.png',
                      height: 100,
                    )
                        : Image.asset(
                      'assets/icons/ic_time.png',
                      height: 100,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      state == 0
                          ? 'Put your card ...'
                          : state == 1
                          ? '$type Successfully!!!'
                          : 'Time out',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            },
            listener: (BuildContext context, int state) async {
              if (state == 1 || state == 2) {
                await Future.delayed(const Duration(seconds: 1));
                if(context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
          );
        });
  }
}
