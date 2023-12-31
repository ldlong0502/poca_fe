import 'package:flutter/material.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/utils/resizable.dart';

class ItemContentUser extends StatelessWidget {
  const ItemContentUser({super.key, required this.header1, required this.header2, required this.header3, required this.onClick});
  final String header1;
  final String header2;
  final String header3;
  final Function() onClick;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),
      child: InkWell(
        onTap: onClick,
        child: Row(
          children: [
            Expanded(child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  header1,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 16)
                  ),
                ),
              ),
            )),
            Expanded(child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  header2,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 16)
                  ),
                ),
              ),
            )),
            Expanded(child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  header3,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 16)
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}