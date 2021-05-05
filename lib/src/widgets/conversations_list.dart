import 'package:flutter/material.dart';

class ConversationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          )
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
}
