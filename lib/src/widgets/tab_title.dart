import 'package:flutter/material.dart';

class TabTitle extends StatelessWidget {
  String text;
  VoidCallback fn;
  String buttonText;
  IconData buttonIcon;

  TabTitle(this.text, this.buttonText, this.buttonIcon, this.fn);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
            style: TextStyle(
              fontSize: 24.0,
              letterSpacing: 2.0,
            )),
        addButton(),
      ],
    );
  }

  Widget addButton() {
    return GestureDetector(
      onTap: fn,
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
              buttonIcon,
              color: Colors.purple[600],
              size: 20,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              buttonText,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
