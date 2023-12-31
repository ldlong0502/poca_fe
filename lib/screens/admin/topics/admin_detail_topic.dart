import 'package:flutter/material.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/admin/dialogs/user_bottom_sheet.dart';
import 'package:poca/features/dialogs/normal_dialog.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_topic.dart';
import 'package:poca/providers/api/api_user.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/screens/admin/admin_topics.dart';
import 'package:poca/screens/admin/admin_users.dart';
import 'package:poca/utils/convert_utils.dart';
import 'package:poca/utils/custom_toast.dart';

import '../../../models/topic.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/resizable.dart';
import '../../../widgets/network_image_custom.dart';

class AdminDetailTopic extends StatelessWidget {
  const AdminDetailTopic({super.key, required this.cubit, required this.topic});

  final AdminTopicsCubit cubit;
  final Topic topic;

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
                  ActionBottom('Edit Topic', Icons.edit, () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.adminEditTopic , arguments: {
                      'cubit': cubit,
                      'topic': topic
                    });
                  }),
                  ActionBottom('Delete Topic', Icons.remove_circle_outline, () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return NormalDialog(
                              onYes: () async {
                                var res = await ApiTopic.instance.deleteTopic(topic.id);
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
                              title: 'Delete Topic',
                              content: 'Are you sure to delete this topic? All podcasts and episodes follow this topic will be deleted');
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
                url: topic.imageUrl,
                borderRadius: BorderRadius.circular(1000),
                width: Resizable.size(context, 220),
                height: Resizable.size(context, 220),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              topic.name,
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
          ],
        ),
      ),
    );
  }
}
