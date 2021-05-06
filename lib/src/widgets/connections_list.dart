import 'package:flutter/material.dart';
import 'package:talk/src/models/connection_model.dart';

import '../blocs/provider.dart';

class ConnectionsList extends StatelessWidget {
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
              Text('Connections',
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
          Expanded(child: activeConnectionsList(bloc)),
        ],
      ),
    );
  }

  addNewButton() {
    return GestureDetector(
      onTap: addNewConnection,
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

  void startConversation(ConnectionModel connectionModel) {}

  void addNewConnection() {}
}
