import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talk/src/resources/date_formatting.dart';

import '../models/message_model.dart';

class Message extends StatelessWidget {
  MessageModel message;
  bool sender;
  String sentInfo;

  Message(this.message) {
    if (message.senderId == FirebaseAuth.instance.currentUser.uid) {
      sender = true;
    } else {
      sender = false;
    }
    sentInfo =
        '${getFormattedTime(message.sentTime)} on ${getFormattedDate(message.sentTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 14, right: 14, top: 5, bottom: 5),
        child: Align(
          alignment: sender ? Alignment.topRight : Alignment.topLeft,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: sender ? Colors.blue[50] : Colors.grey[100],
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.text,
                    textAlign: sender ? TextAlign.right : TextAlign.left,
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                SizedBox(height: 6.0),
                Text(
                  sentInfo,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  textAlign: sender ? TextAlign.right : TextAlign.left,
                )
              ],
            ),
          ),
        ));
  }
}
