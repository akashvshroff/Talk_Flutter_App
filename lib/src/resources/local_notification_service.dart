import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  }

  Future selectNotification(String payload) async {}

  void showNotification(String messageId, String title, String newMessage,
      String conversationId) async {
    print('showing notification now');

    int id = messageId.hashCode;

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      newMessage,
      const NotificationDetails(
          android: AndroidNotificationDetails(channelId, 'com.example.talk',
              'To inform you of incoming messages.')),
      payload: conversationId,
    );
  }
}
