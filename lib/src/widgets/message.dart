import 'package:flutter/material.dart';
import '../models/message_model.dart';

class Message extends StatelessWidget {
  MessageModel message;

  Message(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Text(message.text),
    );
  }
}
