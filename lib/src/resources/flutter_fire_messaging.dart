import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_notification_service.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  var data = message.data;
  String title = data['title'];
  String messageText = data['messageText'];
  String conversationId = '';
  NotificationService()
      .showNotification(message.messageId, title, messageText, conversationId);
}
