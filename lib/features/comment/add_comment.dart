
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:poca/models/comment.dart';
import 'package:poca/models/podcast.dart';

import '../../blocs/comment_cubit.dart';
import '../../configs/constants.dart';
import '../../providers/api/api_comment.dart';
import '../../utils/custom_toast.dart';
import '../../utils/resizable.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../blocs/user_cubit.dart';

class AddComment extends StatelessWidget {
  const AddComment(
      {super.key,
        required this.podcast,
        required this.commentCubit});

  final Podcast podcast;
  final CommentCubit commentCubit;
  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      insetPadding: EdgeInsets.zero,
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
        child: BlocProvider(
          create: (context) => AddCommentCubit(),
          child: BlocBuilder<AddCommentCubit, int>(
            builder: (context, state) {
              final cubit = context.read<AddCommentCubit>();
              return Column(
                children: [
                  const Text(
                    'New comment!',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: purpleColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RatingBar.builder(
                    initialRating: cubit.rate,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star_rounded,
                      color: pinkColor,
                    ),
                    onRatingUpdate: (rating) {
                      cubit.updateRate(rating);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      controller: cubit.controller,
                      title: 'Your comment',
                      onValidate: () {},
                      isPassword: false),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      title: 'Rating now',
                      onTap: () async {

                        if (cubit.controller.text.isEmpty) {
                          CustomToast.showBottomToast(
                              context, 'Comment is empty');
                          return;
                        }
                        var comment = Comment(
                            podcastId: podcast.id,
                            userId: userCubit.state!.id,
                            rate: cubit.rate,
                            content: cubit.controller.text,
                            createdAt: DateTime.now().millisecondsSinceEpoch);
                        var res = await ApiComment.instance
                            .addComment(comment.toMap());
                        if (res) {
                          await commentCubit.load();
                          if (context.mounted) {
                            Navigator.pop(context, true);


                          }
                        } else {
                          if (context.mounted) {
                            CustomToast.showBottomToast(
                                context, 'Có lỗi xảy ra');
                          }
                        }
                      },
                      backgroundColor: purpleColor,
                      textColor: Colors.white)
                ],
              );
            },
          ),
        ),
      ),
    );
  }


}

class AddCommentCubit extends Cubit<int> {
  AddCommentCubit() : super(0);

  double rate = 1;
  TextEditingController controller = TextEditingController();

  updateRate(double value) {
    rate = value;
    emit(state + 1);
  }
}
