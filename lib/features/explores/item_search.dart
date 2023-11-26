import 'package:flutter/material.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/utils/resizable.dart';

import '../../configs/constants.dart';

class ItemSearch extends StatelessWidget {
  const ItemSearch({super.key, required this.isHistory, required this.podcast});

  final bool isHistory;
  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Resizable.size(context, 70),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: Resizable.size(context, 70),
            width: Resizable.size(context, 70),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: NetworkImage(podcast.imageUrl), fit: BoxFit.fill)),
          ),
          const SizedBox(width: 10,),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    podcast.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 18),
                        color: textColor,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    podcast.host,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 14),
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              )),
          SizedBox(
            width: Resizable.size(context, 50),
            child: isHistory ? IconButton(onPressed: () {},
                icon: const Icon(Icons.clear_rounded, color: secondaryColor,)) : null,
          )
        ],
      ),
    );
  }
}
