import 'package:flutter/material.dart';

import '../blocs/provider.dart';

import '../resources/flutter_fire_firestore.dart';
import '../resources/date_formatting.dart';

import '../models/active_conversation_model.dart';

import 'tab_title.dart';

class ConversationsList extends StatelessWidget {
  GlobalKey navBarKey;
  ConversationsList(this.navBarKey);

  @override
  Widget build(BuildContext context) {
    final Bloc bloc = Provider.of(context);
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: [
          TabTitle('Conversations', 'Add New', Icons.add, addNewConverstion),
          SizedBox(
            height: 6.0,
          ),
          Divider(),
          Expanded(child: activeConversationsList(bloc)),
        ],
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
          if (snapshot.data.isEmpty) {
            return Center(
                child: Text(
              'Start a conversation using the button above.',
              style: TextStyle(fontSize: 16.0),
            ));
          }
          return ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                height: 2.0,
              );
            },
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              ActiveConversationModel activeConversation = snapshot.data[index];

              String toShow =
                  getActiveConversationDate(activeConversation.lastUpdated);

              return Container(
                margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: ListTile(
                  title: Text(' ${activeConversation.username}',
                      style: TextStyle(
                        fontSize: 20.0,
                      )),
                  subtitle: Text(
                    ' ${activeConversation.lastMessage}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: CircleAvatar(
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(activeConversation.profilePicPath),
                    ),
                  ),
                  trailing: Text(toShow,
                      style: TextStyle(
                        fontWeight: activeConversation.newMessage
                            ? FontWeight.bold
                            : FontWeight.normal,
                      )),
                  onTap: () => openConversation(context, activeConversation),
                ),
              );
            },
          );
        }
      },
    );
  }

  void openConversation(
      BuildContext context, ActiveConversationModel activeConversation) async {
    await markConversationAsRead(activeConversation);
    Navigator.pushNamed(
        context, '/conversation_detail/${activeConversation.conversationId}');
  }

  void addNewConverstion() {
    BottomNavigationBar navBar = navBarKey.currentWidget;
    navBar.onTap(1);
  }
}
