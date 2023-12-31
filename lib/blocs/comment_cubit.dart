
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_comment.dart';
import 'package:poca/providers/api/api_user.dart';
import 'package:poca/providers/firebase_provider.dart';

import '../models/comment.dart';

class CommentCubit extends Cubit<int> {
  CommentCubit(this.podcast) : super(0);

  List<Comment> listComment = [];
  List<UserModel> listUserModel = [];
  final Podcast podcast;
  load() async {
    listComment = await ApiComment.instance.getCommentsPodcast(podcast.id);

    for(var i in listComment) {
      final user = await ApiUser.instance.getUserById(i.userId);
      print('=>>>>>>$user');
      if(user != null) {
        listUserModel.add(user);
      }
    }

    listComment.sort((a,b) => b.createdAt.compareTo(a.createdAt));
    debugPrint('=>>>>>>> listUserModel: ${listUserModel.length}');
    emit(state+1);
  }

}
