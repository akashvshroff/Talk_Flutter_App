import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/show_oktoast.dart';

Future<bool> signUp(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    print(e);
    String message;
    if (e.code == 'weak-password') {
      message = 'The password that you have chosen is weak. Try again.';
    } else if (e.code == 'email-already-in-use') {
      message = 'Account for this email exists, log-in instead.';
    } else {
      message = e.toString();
    }

    toast(message);

    return false;
  }
}

Future<bool> logIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    String message;
    if (e.code == 'user-not-found') {
      message = 'No user found for that email, sign up instead.';
    } else if (e.code == 'wrong-password') {
      message = 'The password that you have entered is wrong. Try again.';
    } else {
      message = e.toString();
    }

    toast(message);

    return false;
  }
}

Future<bool> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return true;
  } on FirebaseAuthException catch (e) {
    toast(e.toString());
    return false;
  }
}

Future<bool> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    return true;
  } on FirebaseAuthException catch (e) {
    toast(e.toString());
    return false;
  }
}
