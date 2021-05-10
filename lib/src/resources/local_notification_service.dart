import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('chat');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future selectNotification(String payload) async {}

  void showNotification(String messageId, String title, String newMessage,
      String conversationId) async {
    int id = messageId.hashCode;

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      newMessage,
      const NotificationDetails(
          android: AndroidNotificationDetails(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.max,
      )),
      payload: conversationId,
    );
  }
}
