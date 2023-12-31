import 'package:flutter/material.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/admin/dialogs/user_bottom_sheet.dart';
import 'package:poca/features/dialogs/normal_dialog.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_user.dart';
import 'package:poca/screens/admin/admin_users.dart';
import 'package:poca/utils/convert_utils.dart';
import 'package:poca/utils/custom_toast.dart';

import '../../../utils/dialogs.dart';
import '../../../utils/resizable.dart';
import '../../../widgets/network_image_custom.dart';

class AdminDetailUsers extends StatelessWidget {
  const AdminDetailUsers({super.key, required this.cubit, required this.user});

  final AdminUsersCubit cubit;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        actions: [
          IconButton(
              onPressed: () {
                var list = [
                  ActionBottom('Delete User', Icons.remove_circle_outline, () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return NormalDialog(
                              onYes: () async {
                                var res = await ApiUser.instance.deleteUser(user.id);
                                if(res) {
                                  await cubit.load();
                                  if(context.mounted){
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    CustomToast.showBottomToast(context, 'Delete Successfully');
                                  }
                                }
                                else {
                                  if(context.mounted){
                                    Navigator.pop(context);
                                    CustomToast.showBottomToast(context, 'Delete Error');
                                  }
                                }
                              },
                              onCancel: (){
                                Navigator.pop(context);
                              },
                              title: 'Delete User',
                              content: 'Are you sure to delete this user');
                        });
                  })
                ];
                Dialogs.showBottomSheet(
                    context, UserBottomSheet(listItem: list));
              },
              icon: const Icon(
                Icons.more_horiz_rounded,
                color: primaryColor,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: NetworkImageCustom(
                url: user.imageUrl,
                borderRadius: BorderRadius.circular(1000),
                width: Resizable.size(context, 220),
                height: Resizable.size(context, 220),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              user.username,
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Resizable.font(context, 20)),
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              endIndent: 50,
              indent: 50,
              color: Colors.grey.shade600,
              height: 2,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Full Name: ',
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Resizable.font(context, 18)),
                      ),
                      Text(
                        user.fullName,
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 16)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Email: ',
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Resizable.font(context, 18)),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 16)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Date of Birth: ',
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Resizable.font(context, 18)),
                      ),
                      Text(
                        ConvertUtils.convertDob(user.dateOfBirth),
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 16)),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
