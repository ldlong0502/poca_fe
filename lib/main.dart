import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:poca/blocs/mini_player_cubit.dart';
import 'package:poca/configs/app_configs.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/features/blocs/recently_play_cubit.dart';
import 'package:poca/features/blocs/subscribe_cubit.dart';
import 'package:poca/providers/api/api_user.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/services/dynamic_links_service.dart';
import 'package:poca/services/nfc_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/blocs/user_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DynamicLinksService.instance.initDynamicLink();
  await FirebaseMessaging.instance.getInitialMessage();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('fcmToken', fcmToken!);
  await ApiUser.instance.updateFCMToken(fcmToken);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  var androidInitialize = const AndroidInitializationSettings('@mipmap/logo');
  var initializeSettings = InitializationSettings(android: androidInitialize);
  flutterLocalNotificationsPlugin.initialize(initializeSettings);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatTitle: true);

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('poca', 'poca',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: false);
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
        message.notification!.body, platformChannelSpecifics,
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) async {

  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PlayerCubit(context)),
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => SubscribeCubit()),
        BlocProvider(create: (context) => LoadingCubit()),
        BlocProvider(create: (context) => RecentlyPlayCubit()),
      ],
      child: MaterialApp(
        navigatorObservers: [defaultLifecycleObserver],
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        theme: ThemeData(
          textTheme: Theme
              .of(context)
              .textTheme
              .apply(
            fontSizeFactor: 1.0,
            fontFamily: "Montserrat",
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, // Đặt màu sắc cho AppBar ở đây
          ),
        ),

        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}


