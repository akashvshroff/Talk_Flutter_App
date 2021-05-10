import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_notification_service.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('handling background message: ${message.messageId}');
  var notification = message.notification;
  String title = notification.title;
  String messageText = notification.body;
  String conversationId = '';
  NotificationService()
      .showNotification(message.messageId, title, messageText, conversationId);
}
