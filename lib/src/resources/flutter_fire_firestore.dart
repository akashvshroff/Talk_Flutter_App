import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';

import '../models/message_model.dart';
import '../models/conversation_model.dart';
import '../models/active_conversation_model.dart';

import '../widgets/show_oktoast.dart';

Future<bool> isUsernameUnique(String username) async {
  try {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: username)
        .get();
    if (query.docs.isEmpty) {
      return true;
    } else {
      toast('Username already taken. Please select another.');
      return false;
    }
  } catch (e) {
    toast(e.toString());
    return false;
  }
}

Future<bool> addConnectionWithUsername(String username) async {
  try {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: username)
        .get();
    if (query.docs.isEmpty) {
      toast('No account exists with that username.');
      return false;
    }
    DocumentSnapshot connectionSnapshot = query.docs[0];
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      var data = snapshot.data()['connections'];
      if (username == snapshot.data()['username']) {
        toast('You cannot add yourself as a connection.');
        return false;
      }
      Map<String, String> connectionMap = {
        'user_id': connectionSnapshot.id,
        'profile_pic_path': connectionSnapshot.data()['profile_pic_path'],
        'username': connectionSnapshot.data()['username']
      };
      data.add(connectionMap);
      transaction.update(documentReference, {'connections': data});
    });
    toast('User added to connection.');
    return true;
  } catch (e) {
    toast(e.toString());
    return false;
  }
}

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
    toast(e.toString());
    return false;
  }
}

Future<bool> markConversationAsRead(
    ActiveConversationModel activeConversation) async {
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      List data = snapshot.data()['active_conversations'];
      for (int i = 0; i < data.length; i++) {
        var map = data[i];
        if (map['username'] == activeConversation.username) {
          data[i]['new_message'] = false;
          break;
        }
      }
      transaction.update(documentReference, {'active_conversations': data});
    });
    return true;
  } catch (e) {
    toast(e.toString());
    return false;
  }
}
