import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeProvider with ChangeNotifier {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  double progress = 0.0;
  Timer? _timer;

  HomeProvider() {
    initializeFCM();
  }
  bool isDialogOpen = false;

  void setDialogOpen(bool value) {
    isDialogOpen = value;
    notifyListeners();
  }

  void initializeFCM() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSettings = InitializationSettings(android: android);
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request notification permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else {
      log('User declined or has not accepted permission');
    }

    // Request FCM token
    String? fcmToken = await messaging.getToken();
    log("FCM Token: $fcmToken");

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        log("onMessage received: ${message.notification?.title} - ${message.notification?.body}");

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'your_channel_id',
                'your_channel_name',
                channelDescription: 'your_channel_description',
                icon: android.smallIcon,
              ),
            ),
            payload: message.data['payload'],
          );
        }
      },
    );
  }

  void startProgress(BuildContext context) {
    progress = 0.0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      progress += 0.01;
      if (progress >= 1.0) {
        _timer?.cancel();
        log('Progress reached, auto-rejecting...');
        autoReject(context);
      }

      notifyListeners();
    });
  }

  void autoReject(BuildContext context) {
    Navigator.of(context).pop();
    log('Auto-rejected');
  }

  void stopProgress() {
    _timer?.cancel();
    progress = 0.0;
    notifyListeners();
  }
}
