import 'package:flutter/material.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/utils/resizable.dart';

class ItemHeader extends StatelessWidget {
  const ItemHeader({super.key, required this.itemHeaders});
  final List<String> itemHeaders;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Row(
        children: [
         ...itemHeaders.map((e) {
           return  Expanded(child: Align(
             alignment: Alignment.centerLeft,
             child: Text(
               e,
               maxLines: 2,
               overflow: TextOverflow.ellipsis,
               style: TextStyle(
                   color: primaryColor,
                   fontWeight: FontWeight.bold,
                   fontSize: Resizable.font(context, 18)
               ),
             ),
           ));
         }).toList()
        ],
      ),
    );
  }
}
