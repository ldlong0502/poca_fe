import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/admin/item_header.dart';
import 'package:poca/features/admin/podcast/item_content_podcast.dart';
import 'package:poca/features/admin/search_field.dart';
import 'package:poca/features/explores/search_field.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/providers/api/api_user.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../../configs/constants.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_text_field.dart';

class AdminEpisodesScreen extends StatelessWidget {
  const AdminEpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AdminEpisodesCubit()
        ..load(),
      child: BlocBuilder<AdminEpisodesCubit, int>(
        builder: (context, state) {
          if(state == 0) return const Center(child: LoadingProgress(),);
          final cubit = context.read<AdminEpisodesCubit>();
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
                    itemHeaders: ['Title', 'Duration', 'Image'],
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
                        ...cubit.listEpisodes.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ItemContentPodcast(
                                header1: e.title,
                                header2: e.duration.toString(),
                                header3: e.imageUrl,
                                onClick: (){
                                  Navigator.pushNamed(context, AppRoutes.adminDetailEpisode , arguments: {
                                    'episode': e,
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
                Navigator.pushNamed(context, AppRoutes.adminCreateEpisode , arguments: {
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

class AdminEpisodesCubit extends Cubit<int> {
  AdminEpisodesCubit() : super(0);

  List<Episode> listEpisodes= [];
  List<Episode> listBase = [];
  var searchController = TextEditingController();
  load() async {
    listEpisodes = await ApiEpisode.instance.getAllEpisode();
    print(listEpisodes.length);
    listBase  = [...listEpisodes];
    emit(state + 1);
  }

  search(String value) {
    final s = value.toLowerCase();
    if(value.isEmpty) {
      listEpisodes = [...listBase];
    }
    else {
      listEpisodes = listBase.where((e) {
        if(e.title.toLowerCase().contains(s) ){
          return true;
        }
        return false;
      }).toList();
    }
    emit(state+1);
  }
}