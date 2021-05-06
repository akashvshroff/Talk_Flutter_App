import 'package:flutter/material.dart';

import '../blocs/provider.dart';
import '../resources/flutter_fire_firestore.dart';

import '../models/active_conversation_model.dart';

class ConversationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Bloc bloc = Provider.of(context);
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Conversations',
                  style: TextStyle(
                    fontSize: 24.0,
                    letterSpacing: 2.0,
                  )),
              addNewButton(),
            ],
          ),
          SizedBox(
            height: 6.0,
          ),
          Divider(),
          Expanded(child: activeConversationsList(bloc)),
        ],
      ),
    );
  }

  addNewButton() {
    return GestureDetector(
      onTap: () {
        //add new chat
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.pink[50],
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.add,
              color: Colors.purple[600],
              size: 20,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              "Add New",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget activeConversationsList(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.activeConversationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                height: 2.0,
              );
            },
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              ActiveConversationModel activeConversation = snapshot.data[index];
              return Container(
                margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: ListTile(
                  title: Text(' ${activeConversation.username}',
                      style: TextStyle(
                        fontSize: 20.0,
                      )),
                  leading: CircleAvatar(
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(activeConversation.profilePicPath),
                    ),
                  ),
                  trailing: activeConversation.newMessage
                      ? Icon(
                          Icons.touch_app,
                          color: Colors.green,
                          size: 30,
                        )
                      : Container(height: 0.0, width: 0.0),
                  onTap: () => openConversation(activeConversation),
                ),
              );
            },
          );
        }
      },
    );
  }

  void openConversation(ActiveConversationModel activeConversation) async {
    bool result = await markConversationAsRead(activeConversation);
    print(result);
  }
}
