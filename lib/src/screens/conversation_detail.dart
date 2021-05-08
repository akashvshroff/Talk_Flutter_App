import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../blocs/provider.dart';

import '../models/conversation_model.dart';
import '../models/message_model.dart';

import '../widgets/message.dart';

class ConversationDetail extends StatefulWidget {
  String conversationId;

  ConversationDetail(this.conversationId);

  @override
  _ConversationDetailState createState() =>
      _ConversationDetailState(conversationId);
}

class _ConversationDetailState extends State<ConversationDetail> {
  String username = 'Loading...';
  String profilePicPath =
      'https://firebasestorage.googleapis.com/v0/b/talk-chat-app-66f32.appspot.com/o/default_profile.png?alt=media&token=b3d50e26-7355-4a8f-8340-750cee75ed81';
  String conversationId;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  _ConversationDetailState(this.conversationId);

  @override
  Widget build(BuildContext context) {
    final Bloc bloc = Provider.of(context);

    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(bloc),
    );
  }

  buildAppBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16, top: 4),
          child: Row(children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(
              width: 2,
            ),
            CircleAvatar(
              maxRadius: 20,
              child: CircleAvatar(
                backgroundImage: NetworkImage(profilePicPath),
                maxRadius: 20,
              ),
            ),
          ]),
        ),
      ),
      title: Text(username,
          style: TextStyle(
            color: Colors.black,
          )),
      centerTitle: true,
    );
  }

  Widget buildBody(Bloc bloc) {
    return Stack(children: [
      buildMessagesList(bloc),
      buildBottomTextField(),
    ]);
  }

  Widget buildMessagesList(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.getConversationStream(conversationId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        ConversationModel conversation = snapshot.data;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (FirebaseAuth.instance.currentUser.uid == conversation.user1) {
            setState(() {
              username = conversation.username2;
              profilePicPath = conversation.profilePicPath2;
              scrollController.animateTo(0.0,
                  curve: Curves.easeOut, duration: Duration(milliseconds: 300));
            });
          } else {
            setState(() {
              username = conversation.username1;
              profilePicPath = conversation.profilePicPath1;
            });
          }
        });
        List<MessageModel> messages = conversation.messages;
        return ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Message(messages[index]);
            });
      },
    );
  }

  Widget buildBottomTextField() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 30, bottom: 10, top: 20),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Write message...',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: sendMessage,
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: Colors.blue[200],
            )
          ],
        ),
      ),
    );
  }

  void sendMessage() {}
}
