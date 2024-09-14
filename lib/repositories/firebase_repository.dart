import 'dart:async';
import 'dart:convert';
import 'package:active_ecommerce_flutter/screens/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:one_context/one_context.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseRepository {
  final _firebaseInstance = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseInstance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<String> getToken() async {
    String? token = await _firebaseInstance.getToken();
    return token ?? '';
  }

  initInfo(BuildContext context) {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      AndroidNotificationDetails androidPlatformChannelSpecific =
          AndroidNotificationDetails(
        'GHL', 'GHL',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
        // sound: const RawResourceAndroidNotificationSound('notification')
      );
      NotificationDetails platformChannelSpecific =
          NotificationDetails(android: androidPlatformChannelSpecific);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecific,
          payload: message.data['data']);
      initLocalNotifications(message, context);
    });
  }

  void initLocalNotifications(
      RemoteMessage message, BuildContext context) async {
    Map<String, dynamic> notificationData = message.data;
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(message.data);
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage.data);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      handleMessage(event.data);
    });
  }

  void handleMessage(Map<String, dynamic> message) {
    OneContext().push(
      MaterialPageRoute(
          builder: (context) => ChatScreen(
                conversation_id: int.parse(message['conversation_id']),
                messenger_name: message['messenger_name'],
                messenger_title: message['messenger_title'],
                messenger_image: message['messenger_image'],
              )),
    );
  }
}
