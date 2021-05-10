import 'package:flutter/material.dart';
import 'package:talk/src/blocs/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../resources/local_notification_service.dart';
import '../widgets/conversations_list.dart';
import '../widgets/connections_list.dart';
import '../widgets/profile.dart';

class ConversationsPage extends StatefulWidget {
  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  int currentIndex = 0;
  GlobalKey navBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      NotificationService().showNotification(
          message.messageId, notification.title, notification.body, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: Scaffold(
        body: SafeArea(child: buildBody()),
        bottomNavigationBar: BottomNavigationBar(
          key: navBarKey,
          currentIndex: currentIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: "Chats",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_work),
              label: "Connections",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    //conditional with the current index of the nav bar.
    if (currentIndex == 0) {
      return ConversationsList(navBarKey);
    } else if (currentIndex == 1) {
      return ConnectionsList(navBarKey);
    } else {
      return Profile();
    }
  }
}
