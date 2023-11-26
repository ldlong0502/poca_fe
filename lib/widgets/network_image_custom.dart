import 'package:flutter/material.dart';

import '../utils/resizable.dart';

class NetworkImageCustom extends StatelessWidget {
  const NetworkImageCustom(
      {super.key, this.radius = 20, required this.url, this.width, this.height});

  final String url;
  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          image: DecorationImage(
              image: NetworkImage(url), fit: BoxFit.fill)),
    );
  }
}
