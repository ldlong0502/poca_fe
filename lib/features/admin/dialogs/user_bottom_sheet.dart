import 'package:flutter/material.dart';

import '../../../utils/resizable.dart';
import '../../account/playlist/base_bottom_sheet.dart';

class UserBottomSheet extends StatelessWidget {
  const UserBottomSheet({super.key, required this.listItem});

  final List<ActionBottom> listItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight:  Resizable.height(context) * 0.2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 20)),
            child: Column(
              children: [
                ...listItem.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: e.onPress,
                      child: Row(
                        children: [
                          Icon(e.icon, color: Colors.white,),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            e.title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Resizable.font(context, 20)),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ActionBottom {
  ActionBottom(this.title,  this.icon, this.onPress);
  final String title;
  final IconData icon;
  final Function() onPress;
}