import 'package:flutter/material.dart';

import 'blocs/provider.dart';

import 'screens/login.dart';
import 'screens/sign_up.dart';
import 'screens/loading.dart';
import 'screens/signup_profile.dart';
import 'screens/conversations.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Fira',
        ),
        title: 'talk',
        // home: LoadingPage(),
        onGenerateRoute: routes,
      ),
    );
  }

  Route routes(RouteSettings settings) {
    String routeName = settings.name;
    if (routeName == '/') {
      //loading page
      return MaterialPageRoute(builder: (context) {
        return LoadingPage();
      });
    } else if (routeName == '/signup') {
      //signup page
      return MaterialPageRoute(builder: (context) {
        return SignUpPage();
      });
    } else if (routeName == '/login') {
      //login page
      return MaterialPageRoute(builder: (context) {
        return LoginPage();
      });
    } else if (routeName == '/signup/profile') {
      //sign up profile page
      return MaterialPageRoute(builder: (context) {
        return SignUpProfile();
      });
    } else if (routeName == '/conversations') {
      //conversation home page
      return MaterialPageRoute(builder: (context) {
        return ConversationsPage();
      });
    }
  }
}
