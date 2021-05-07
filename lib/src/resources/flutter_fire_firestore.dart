import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message_model.dart';
import '../models/conversation_model.dart';
import '../models/active_conversation_model.dart';
import '../models/connection_model.dart';

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
    String connectionUid = connectionSnapshot.id;
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    DocumentReference connectionReference =
        FirebaseFirestore.instance.collection('Users').doc(connectionUid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      var doc = snapshot.data();
      var data = doc['connections'];
      if (username == doc['username']) {
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

      //add current logged in user to connection's connections
      List user2Connections = connectionSnapshot.data()['connections'];
      user2Connections.add({
        'user_id': uid,
        'username': doc['username'],
        'profile_pic_path': doc['profile_pic_path'],
      });
      transaction
          .update(connectionReference, {'connections': user2Connections});
    });
    toast('User added as a connection.');
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
          'active_conversations': [],
          'active_conversations_array': []
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

Future<bool> addNewConversationWithConnection(
    ConnectionModel connectionModel) async {
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    Map<String, dynamic> conversationMap = {};
    if ((uid.compareTo(connectionModel.userId)) == -1) {
      conversationMap['user_1'] = uid;
      conversationMap['user_2'] = connectionModel.userId;
    } else {
      conversationMap['user_1'] = connectionModel.userId;
      conversationMap['user_2'] = uid;
    }
    conversationMap['messages'] = [];
    String conversationId =
        conversationMap['user_1'] + conversationMap['user_2'];
    DocumentReference user1DocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(conversationMap['user_1']);
    DocumentReference user2DocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(conversationMap['user_2']);
    DocumentReference conversationDocRef = FirebaseFirestore.instance
        .collection('Conversations')
        .doc(conversationId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot user1Doc = await transaction.get(user1DocRef);
      List activeConversations1 = user1Doc.data()['active_conversations'];
      List activeConversationsArray1 =
          user1Doc.data()['active_conversations_array'];
      String username1 = user1Doc.data()['username'];
      String profilePicPath1 = user1Doc.data()['profile_pic_path'];

      if (activeConversationsArray1.contains(conversationId)) {
        toast('A conversation with the user already exists.');
        return false;
      }

      DocumentSnapshot user2Doc = await transaction.get(user2DocRef);
      List activeConversations2 = user2Doc.data()['active_conversations'];
      List activeConversationsArray2 =
          user2Doc.data()['active_conversations_array'];
      String username2 = user2Doc.data()['username'];
      String profilePicPath2 = user2Doc.data()['profile_pic_path'];

      activeConversationsArray1.add(conversationId);
      activeConversationsArray2.add(conversationId);

      Map activeConversationMap1 = {
        'username': username2,
        'profile_pic_path': profilePicPath2,
        'new_message': true,
        'conversation_id': conversationId,
        'last_updated': DateTime.now().toIso8601String(),
        'last_message': 'Click to start chatting.'
      };

      Map activeConversationMap2 = {
        'username': username1,
        'profile_pic_path': profilePicPath1,
        'new_message': true,
        'conversation_id': conversationId,
        'last_updated': DateTime.now().toIso8601String(),
        'last_message': 'Click to start chatting.'
      };

      activeConversations1.add(activeConversationMap1);
      activeConversations2.add(activeConversationMap2);

      transaction.update(user1DocRef, {
        'active_conversations': activeConversations1,
        'active_conversations_array': activeConversationsArray1
      });

      transaction.update(user2DocRef, {
        'active_conversations': activeConversations2,
        'active_conversations_array': activeConversationsArray2
      });

      transaction.set(conversationDocRef, conversationMap);
    });
    toast('Conversation added.');
    return true;
  } catch (e) {
    toast(e.toString());
    return false;
  }
}
