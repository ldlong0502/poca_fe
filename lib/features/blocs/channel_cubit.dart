import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/providers/api/api_channel.dart';

import '../../models/channel_model.dart';

class ChannelCubit extends Cubit<ChannelModel?> {
  ChannelCubit(this.idChannel) : super(null) {
    load();
  }
  final String idChannel;
  load() async {
    emit(await ApiChannel.instance.getChannelById(idChannel));
  }

}