import 'package:flutter/material.dart';
import 'package:uni_wave/providers/preference_provider.dart';
import 'package:uni_wave/routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    applicationInit(context);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void applicationInit(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    String userId = await PreferenceProvider.getString("user_id");

    if(userId == "") {
      if(context.mounted){
        Navigator.of(context, rootNavigator: true)
            .pushNamedAndRemoveUntil(AppRoutes.main, (route) => false , arguments: {
              'isLogin': false
        });
      }
    }
  }
}
