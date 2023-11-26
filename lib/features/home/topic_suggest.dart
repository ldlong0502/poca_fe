import 'package:flutter/material.dart';
import 'package:poca/features/blocs/home_cubit.dart';

import '../../configs/constants.dart';
import '../../routes/app_routes.dart';
import '../../utils/navigator_custom.dart';
import '../../utils/resizable.dart';
import '../topics/topic_detail_view.dart';

class TopicSuggest extends StatelessWidget {
  const TopicSuggest({super.key, required this.homeCubit});

  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          left: 20,
          top: 10
        ),
        scrollDirection: Axis.horizontal,
        children: homeCubit.listTopics.map((e) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: (){
                NavigatorCustom.pushNewScreen(
                    context,
                    TopicDetailView(
                        topic: e),
                    AppRoutes.topicDetail);
              },
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        e.imageUrl,
                        height: Resizable.size(context, 150),
                        width: Resizable.size(context, 150),
                        fit: BoxFit.fill,
                      )),
                  const SizedBox(height: 5,),
                  Text(
                    e.name,
                    style: TextStyle(
                      fontSize: Resizable.font(context, 20),
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
