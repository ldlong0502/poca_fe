import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/admin/item_header.dart';
import 'package:poca/features/admin/search_field.dart';
import 'package:poca/features/admin/users/item_content_user.dart';
import 'package:poca/features/explores/search_field.dart';
import 'package:poca/providers/api/api_user.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../../configs/constants.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_text_field.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AdminUsersCubit()
        ..load(),
      child: BlocBuilder<AdminUsersCubit, int>(
        builder: (context, state) {
          if(state == 0) return const Center(child: LoadingProgress(),);
          final cubit = context.read<AdminUsersCubit>();
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
                    itemHeaders: ['Username', 'Full name', 'Email'],
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
                       ...cubit.listUsers.map((e) {
                         return Padding(
                           padding: const EdgeInsets.only(bottom: 10),
                           child: ItemContentUser(
                               header1: e.username,
                               header2: e.fullName,
                               header3: e.email,
                               onClick: (){
                                 Navigator.pushNamed(context, AppRoutes.adminUserDetail , arguments: {
                                   'user': e,
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
                Navigator.pushNamed(context, AppRoutes.adminCreateUser , arguments: {
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

class AdminUsersCubit extends Cubit<int> {
  AdminUsersCubit() : super(0);

  List<UserModel> listUsers = [];
  List<UserModel> listBase = [];
  var searchController = TextEditingController();
  load() async {
    listUsers = await ApiUser.instance.getAllUsers();
    print(listUsers.length);
    listUsers.removeWhere((element) => element.isAdmin);

    listBase  = [...listUsers];
    emit(state + 1);
  }

  search(String value) {
    final s = value.toLowerCase();
    if(value.isEmpty) {
      listUsers = [...listBase];
    }
    else {
      listUsers = listBase.where((e) {
        if(e.fullName.toLowerCase().contains(s) || e.email.contains(s) || e.username.contains(s)){
          return true;
        }
        return false;
      }).toList();
    }
    emit(state+1);
  }
}