import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
    );
  }

  Widget buildBody(context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(
            flex: 2,
          ),
          Text(
            'TALK',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0, letterSpacing: 2.0),
          ),
          Spacer(),
          emailField(context),
          SizedBox(
            height: 20.0,
          ),
          passwordField(context),
          Spacer(),
          submitButton(context),
          SizedBox(
            height: 30.0,
          ),
          forgotPassword(context),
          Spacer(
            flex: 2,
          ),
          signUpInstead(context),
        ],
      ),
    );
  }

  Container emailField(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      child: TextField(
        style: TextStyle(fontSize: 18.0),
        controller: emailController,
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.only(left: 2.0),
        ),
      ),
    );
  }

  Container passwordField(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      child: TextField(
        style: TextStyle(fontSize: 18.0),
        controller: passwordController,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.only(left: 2.0),
        ),
      ),
    );
  }

  Container submitButton(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.purple[600])),
      child: MaterialButton(
        onPressed: () {},
        child: Text('SUBMIT'),
      ),
    );
  }

  Container forgotPassword(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 45,
      child: MaterialButton(
        onPressed: () {},
        child: Text('Forgot your password?'),
      ),
    );
  }

  Container signUpInstead(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 45,
      child: MaterialButton(
        onPressed: () {},
        child: Text(
          'Not a member? Sign Up',
          style: TextStyle(color: Colors.purple[600]),
        ),
      ),
    );
  }
}
