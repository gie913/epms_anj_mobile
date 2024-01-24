import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('handle background Message');
  print('Title : ${message.notification?.title}');
  print('Body : ${message.notification?.body}');
  print('Payload : ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    '@string/default_notification_channel_id',
    'ePMS Notification',
    description: 'This channel is used for importance notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> handleMessage(RemoteMessage? message) async {
    if (message == null) return;

    print('handle local foreground Message');
    print('Title : ${message.notification?.title}');
    print('Body : ${message.notification?.body}');
    print('Payload : ${message.data}');
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/launcher_icon');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          final message = RemoteMessage.fromMap(jsonDecode(details.payload!));
          handleMessage(message);
        }
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      if (notification == null) return;

      print('handle foreground Message');
      print('Title : ${message.notification?.title}');
      print('Body : ${message.notification?.body}');
      print('Payload : ${message.data}');

      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/launcher_icon',
            ),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('fcm token : $fcmToken');
    await initPushNotifications();
    await initLocalNotifications();
  }
}
