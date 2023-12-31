import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/comment/shimmer_loading_comment.dart';
import 'package:poca/models/podcast.dart';

import '../../blocs/comment_cubit.dart';
import '../../configs/constants.dart';
import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../blocs/user_cubit.dart';
import 'add_comment.dart';
import 'comment_detail.dart';
import 'empty_comment.dart';

class ListComment extends StatelessWidget {
  const ListComment({super.key, required this.podcast,});

  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (cc, state) {
        return BlocProvider(
          create: (context) => CommentCubit(podcast)..load(),
          child: BlocBuilder<CommentCubit, int>(builder: (ccc, i) {
            final cubit = ccc.read<CommentCubit>();
            if (i == 0) {
              return const ShimmerLoadingComment();
            }
            return Column(
              children: [
                if (cubit.listComment.isEmpty) const EmptyComment(),
                if (cubit.listComment.isNotEmpty)
                  CommentDetail(commentCubit: cubit),
                CustomButton(
                    title: state == null ? 'Log in to rating' : 'Add your rating',
                    onTap: () async {
                      if(state == null) {
                        Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.login);
                      }
                      else {
                        await showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AddComment(
                             podcast: podcast,
                              commentCubit: cubit,
                            );
                          },
                        );
                      }
                    },
                    fontSize: 13,
                    border: true,
                    radius: 30,
                    backgroundColor: Colors.white,
                    textColor: pinkColor),
                const SizedBox(
                  height: 20,
                )
              ],
            );
          }),
        );
      },
    );
  }
}