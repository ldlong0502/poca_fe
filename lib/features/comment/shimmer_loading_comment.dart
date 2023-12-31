import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:poca/utils/resizable.dart';

class ShimmerLoadingComment extends StatelessWidget {
  const ShimmerLoadingComment({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[100]!,
        highlightColor: Colors.grey[300]!,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Container(
                height: Resizable.size(context, 80),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                height: Resizable.size(context, 80),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ));
  }
}
