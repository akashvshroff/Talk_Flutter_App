import 'package:flutter/material.dart';
import '../resources/flutter_fire_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: buildBody(),
    );
  }

  Widget buildBody() {
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
          Container(
            height: 45,
          ),
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
        onPressed: () {
          submitSignUp();
        },
        child: Text('SIGN UP'),
      ),
    );
  }

  Container signUpInstead(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 45,
      child: MaterialButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: Text(
          'Already have an account? Login',
          style: TextStyle(color: Colors.purple[600]),
        ),
      ),
    );
  }

  void submitSignUp() async {
    FocusScope.of(context).unfocus();
    String email = emailController.text;
    String password = passwordController.text;
    if (email == '' || password == '') {
      alertDialog(
          'Error', 'Please ensure that you enter an email and password.');
      return;
    }
    bool result = await signUp(email, password);
    if (result) {
      //change page
      Navigator.pushReplacementNamed(context, '/signup/profile');
    }
  }

  void alertDialog(String title, String message) {
    AlertDialog alert = AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontSize: 20.0),
      ),
      content: Text(
        message,
        style: TextStyle(fontSize: 18.0),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Continue')),
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }
}
