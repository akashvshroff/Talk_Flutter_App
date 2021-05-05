import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/conversations');
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/login');
            });
          }
          return Center(
            child: Text(
              'TALK',
              style: TextStyle(fontSize: 30.0, letterSpacing: 2.0),
            ),
          );
        },
      ),
    );
  }
}
