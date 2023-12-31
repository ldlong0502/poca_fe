import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/admin/item_header.dart';
import 'package:poca/features/admin/podcast/item_content_podcast.dart';
import 'package:poca/features/admin/search_field.dart';
import 'package:poca/features/explores/search_field.dart';
import 'package:poca/models/channel_model.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/api/api_channel.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/providers/api/api_user.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../../configs/constants.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_text_field.dart';

class AdminChannelsScreen extends StatelessWidget {
  const AdminChannelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AdminChannelsCubit()
        ..load(),
      child: BlocBuilder<AdminChannelsCubit, int>(
        builder: (context, state) {
          if(state == 0) return const Center(child: LoadingProgress(),);
          final cubit = context.read<AdminChannelsCubit>();
          return Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 30),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: Color(0xffD9D9D9),
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15)
                ),
              ),
              child: Column(
                children: [
                  const ItemHeader(
                    itemHeaders: ['Name', 'Type', 'Image'],
                  ),
                  AdminSearchField(
                      controller: cubit.searchController,
                      title: 'Search',
                      onValidate: (value) {
                        return null;
                      },

                      fontSize: 16,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: secondaryColor,
                      ),
                      onChanged: (value) {
                        cubit.search(value);
                      },
                      isMaxSize: true,
                      isPassword: false),
                  const SizedBox(height: 20,),
                  Expanded(child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...cubit.listChannels.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ItemContentPodcast(
                                header1: e.name,
                                header2: e.isUser ? 'User Channel': 'Special Channel',
                                header3: e.imageUrl,
                                onClick: (){
                                  Navigator.pushNamed(context, AppRoutes.adminDetailChannel , arguments: {
                                    'channel': e,
                                    'cubit': cubit,
                                  });
                                }),
                          );
                        }).toList()
                      ],
                    ),
                  ))
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: (){
                Navigator.pushNamed(context, AppRoutes.adminCreateChannel , arguments: {
                  'cubit': cubit,
                });
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

class AdminChannelsCubit extends Cubit<int> {
  AdminChannelsCubit() : super(0);

  List<ChannelModel> listChannels= [];
  List<ChannelModel> listBase = [];
  var searchController = TextEditingController();
  load() async {
    listChannels = await ApiChannel.instance.getAllChannels();
    print(listChannels.length);
    listBase  = [...listChannels];
    emit(state + 1);
  }

  search(String value) {
    final s = value.toLowerCase();
    if(value.isEmpty) {
      listChannels = [...listBase];
    }
    else {
      listChannels = listBase.where((e) {
        if(e.name.toLowerCase().contains(s) ){
          return true;
        }
        return false;
      }).toList();
    }
    emit(state+1);
  }
}