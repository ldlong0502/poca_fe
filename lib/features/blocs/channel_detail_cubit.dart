import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/providers/api/api_channel.dart';

import '../../models/channel_model.dart';

class ChannelDetailCubit extends Cubit<int> {


  ChannelDetailCubit() : super(0);

  List<String> tabs = [];
  ChannelModel? channel;
  load(String idChannel) async {
    channel = await ApiChannel.instance.getChannelById(idChannel);
    if(channel!.isUser) {
      tabs = ['About', 'Comments' , 'Infor'];
    }
    else {
      tabs = ['About', 'Comments'];
    }
    emit(state + 1);
  }


  Future<bool> subscribeChannel(String type, String idUser) async{
   var res =  await ApiChannel.instance.addOrRemoveUserSubscribe(channel!.id, idUser, type);
   await load(channel!.id);
   return res;
  }
}