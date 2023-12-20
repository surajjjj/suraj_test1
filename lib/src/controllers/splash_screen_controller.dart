import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/settings_repository.dart' as setting_repo;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../repository/settings_repository.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class SplashScreenController extends ControllerMVC {
  ValueNotifier<Map<String, double>> progress = ValueNotifier({});
  GlobalKey<ScaffoldState> scaffoldKey;

  //final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  SplashScreenController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    // Should define these variables before the app loaded
    progress.value = {"Setting": 0, "User": 0};
  }

  @override
  void initState() {
    super.initState();


    setting_repo.setting.addListener(() {
      progress.value["Setting"] = 41;
      progress.value["User"] = 59;
      if (kDebugMode) {
        print('success');
      }
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      progress?.notifyListeners();
    });



    Timer(const Duration(seconds: 50), () {
      // ignore: deprecated_member_use
      /* scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('Verify your internet'),
      ));*/
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,

            NotificationDetails(
              android: AndroidNotificationDetails(
                'your channel id',
                setting.value.appName,

                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: '@i/ic_launcher',
                enableVibration: true,
                priority: Priority.high,
                playSound: true,
                importance: Importance.max,
                sound: const RawResourceAndroidNotificationSound('notification'),

              ),

            ), payload: 'item x');
      }


    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        /** Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true)); */
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //print('A new onMessageOpenedApp event was published!');
      /**  Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true)); */
    });

  }
}