import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:evently/app_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMServices {
  static late AndroidNotificationChannel channel;
  static bool isFlutterLocalNotificationsInitialized = false;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static Future<void> printDeviceToken() async {
    final checkConnection = await isNetworkConnected();
    if (checkConnection) {
      var deviceToken = await FirebaseMessaging.instance.getToken();
      log("Device Token is  $deviceToken");
    }
  }

  static Future<void> setupFlutterNotifications() async {
    final checkConnection = await isNetworkConnected();
    if (checkConnection) {
      if (isFlutterLocalNotificationsInitialized) {
        return;
      }
      channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.high,
        showBadge: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        ledColor: AppTheme.red,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        vibrationPattern: Int64List(4),
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
      isFlutterLocalNotificationsInitialized = true;
    }
  }

  static void showFlutterNotification(RemoteMessage message) async {
    final checkConnection = await isNetworkConnected();
    if (checkConnection) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'launch_background',
            ),
          ),
        );
      }
    }
  }

  static Future<bool> isNetworkConnected() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    bool result = false;

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      result = true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      result = true;
    } else {
      result = false;
    }

    return result;
  }
}
