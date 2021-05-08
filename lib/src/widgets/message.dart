import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/message_model.dart';

class Message extends StatelessWidget {
  MessageModel message;
  bool sender;

  Message(this.message) {
    if (message.senderId == FirebaseAuth.instance.currentUser.uid) {
      sender = true;
    } else {
      sender = false;
    }
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
              color: sender ? Colors.blue[100] : Colors.grey[200],
            ),
            padding: EdgeInsets.all(12),
            child: Text(message.text,
                textAlign: sender ? TextAlign.right : TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.black)),
          ),
        ));
  }
}
