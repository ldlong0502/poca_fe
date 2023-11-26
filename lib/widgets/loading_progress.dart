import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../configs/constants.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const Center(
      child: SizedBox(
          child: SpinKitCircle(
            color: primaryColor,
            size: 50.0,
            duration: Duration(seconds: 1),
          )),
    );
  }
}