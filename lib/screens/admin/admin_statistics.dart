import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/admin/statistics/channel_report.dart';
import 'package:poca/features/admin/statistics/user_chart.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_channel.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/providers/api/api_topic.dart';
import 'package:poca/providers/api/api_user.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../../configs/constants.dart';
import '../../features/admin/statistics/app_report.dart';
import '../../models/channel_model.dart';
import '../../models/topic.dart';
import '../../utils/resizable.dart';

class AdminStatisticsScreen extends StatelessWidget {
  const AdminStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminStatisticsCubit()..load(),
      child: BlocBuilder<AdminStatisticsCubit, int>(
        builder: (context, state) {
          if (state == 0) {
            return const Center(
              child: LoadingProgress(),
            );
          }
          final cubit = context.read<AdminStatisticsCubit>();
          return SingleChildScrollView(
              child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: AppReport(
                  cubit: cubit,
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topLeft,
                child: ChannelReport(
                  cubit: cubit,
                ),
              ),

              const SizedBox(height: 10,),
              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Users Report',
                        style: TextStyle(
                            color: textColor,
                            fontSize: Resizable.font(context, 20),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.black87,
                      child: UserChart(cubit: cubit,)),
                ],
              ),

              const SizedBox(height: 20,),
            ],
          ));
        },
      ),
    );
  }
}

class AdminStatisticsCubit extends Cubit<int> {
  AdminStatisticsCubit() : super(0);

  List<Topic> listTopics = [];
  List<ChannelModel> listChannels = [];
  List<Episode> listEpisodes = [];
  List<Podcast> listPodcasts = [];
  List<UserModel> listUsers = [];

  load() async {
    listTopics = await ApiTopic.instance.getListTopics();
    listUsers = await ApiUser.instance.getAllUsers();
    listPodcasts = await ApiPodcast.instance.getAllPodcasts();
    listEpisodes = await ApiEpisode.instance.getAllEpisode();
    listChannels = await ApiChannel.instance.getAllChannels();

    emit(state + 1);
  }
}
