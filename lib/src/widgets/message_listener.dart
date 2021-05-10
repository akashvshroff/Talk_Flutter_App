import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../resources/local_notification_service.dart';

class MessageListener extends StatelessWidget {
  Widget child;
  MessageListener(this.child);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseMessaging.onMessage,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            RemoteMessage message = snapshot.data;
            var data = message.data;
            String title = data['title'];
            String newMessage = data['newMessage'];
            String conversationId = data['conversationId'];
            NotificationService().showNotification(
                message.messageId, title, newMessage, conversationId);
          }
          return child;
        });
  }
}
