import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/admin/item_header.dart';
import 'package:poca/features/admin/search_field.dart';
import 'package:poca/features/admin/topics/item_content_topic.dart';
import 'package:poca/features/explores/search_field.dart';
import 'package:poca/providers/api/api_topic.dart';
import 'package:poca/providers/api/api_user.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../../configs/constants.dart';
import '../../features/admin/users/item_content_user.dart';
import '../../models/topic.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_text_field.dart';

class AdminTopicsScreen extends StatelessWidget {
  const AdminTopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminTopicsCubit()..load(),
      child: BlocBuilder<AdminTopicsCubit, int>(
        builder: (context, state) {
          if (state == 0) {
            return const Center(
              child: LoadingProgress(),
            );
          }
          final cubit = context.read<AdminTopicsCubit>();
          return Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 30),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: Color(0xffD9D9D9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Column(
                children: [
                  const ItemHeader(
                    itemHeaders: ['Name', 'Image'],
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
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...cubit.listTopics.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ItemContentTopic(
                                header1: e.name,
                                header2: e.imageUrl,
                                onClick: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.adminDetailTopic,
                                      arguments: {
                                        'topic': e,
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
                Navigator.pushNamed(context, AppRoutes.adminCreateTopic , arguments: {
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

class AdminTopicsCubit extends Cubit<int> {
  AdminTopicsCubit() : super(0);

  List<Topic> listTopics = [];
  List<Topic> listBase = [];
  var searchController = TextEditingController();

  load() async {
    listTopics = await ApiTopic.instance.getListTopics();

    listBase = [...listTopics];
    emit(state + 1);
  }

  search(String value) {
    final s = value.toLowerCase();
    if (value.isEmpty) {
      listTopics = [...listBase];
    } else {
      listTopics = listBase.where((e) {
        if (e.name.toLowerCase().contains(s)) {
          return true;
        }
        return false;
      }).toList();
    }
    emit(state + 1);
  }
}
