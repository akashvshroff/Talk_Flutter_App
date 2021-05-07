import 'package:flutter/material.dart';

import '../resources/flutter_fire_firestore.dart';
import '../models/connection_model.dart';

import '../widgets/tab_title.dart';

import '../blocs/provider.dart';

class ConnectionsList extends StatefulWidget {
  @override
  _ConnectionsListState createState() => _ConnectionsListState();
}

class _ConnectionsListState extends State<ConnectionsList> {
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Bloc bloc = Provider.of(context);
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: [
          TabTitle('Connections', 'Add New', Icons.add, addUsernameDialog),
          SizedBox(
            height: 6.0,
          ),
          Divider(),
          Expanded(child: activeConnectionsList(bloc)),
        ],
      ),
    );
  }

  Widget activeConnectionsList(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.connectionsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<ConnectionModel> connections = snapshot.data;
        if (connections.isEmpty) {
          return Center(
              child: Text(
            'Add connections using the button above.',
            style: TextStyle(fontSize: 16.0),
          ));
        }
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            height: 2.0,
          ),
          itemCount: connections.length,
          itemBuilder: (context, index) {
            ConnectionModel connectionModel = connections[index];
            return Container(
              margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: ListTile(
                title: Text(' ${connectionModel.username}',
                    style: TextStyle(
                      fontSize: 20.0,
                    )),
                leading: CircleAvatar(
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(connectionModel.profilePicPath),
                  ),
                ),
                onTap: () => startConversation(connectionModel),
              ),
            );
          },
        );
      },
    );
  }

  void startConversation(ConnectionModel connectionModel) async {
    bool result = await addNewConversationWithConnection(connectionModel);
    if (result) {
      print('conversation added');
      //change page
    }
  }

  void addNewConnection() async {
    String username = usernameController.text;
    await addConnectionWithUsername(username);
  }

  void addUsernameDialog() {
    usernameController.text = '';
    var dialog = AlertDialog(
      title: Text(
        'Add Connection',
        style: TextStyle(fontSize: 20.0),
      ),
      content: TextField(
        controller: usernameController,
        decoration: InputDecoration(hintText: 'Enter username'),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 16.0),
            )),
        TextButton(
            onPressed: () {
              addNewConnection();
              Navigator.of(context).pop();
            },
            child: Text('Submit', style: TextStyle(fontSize: 16.0))),
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return dialog;
        });
  }
}
