import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talk/src/models/message_model.dart';
import '../models/conversation_model.dart';
import '../models/active_conversation_model.dart';
import 'dart:async';

Future<bool> addUsernameAndProfileOnSignUp(
    String username, String profilePicPath) async {
  //save username and profile pic path to current user id
  String defaultPath =
      'https://firebasestorage.googleapis.com/v0/b/talk-chat-app-66f32.appspot.com/o/default_profile.png?alt=media&token=b3d50e26-7355-4a8f-8340-750cee75ed81';
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'username': username,
          'profile_pic_path':
              profilePicPath != '' ? profilePicPath : defaultPath,
          'connections': [],
          'active_conversations': []
        });
      }
    });
    return true;
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    return false;
  }
}

void toast(message) {
  Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
}
