import 'package:flutter/material.dart';

import 'screens/login.dart';
import 'screens/sign_up.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Fira',
      ),
      title: 'talk',
      home: LoginPage(),
      onGenerateRoute: routes,
    );
  }

  Route routes(RouteSettings settings) {
    String routeName = settings.name;
    if (routeName == '/') {
      //loading page
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
    } else if (routeName == '/conversations') {
      //conversation home page
    }
  }
}
