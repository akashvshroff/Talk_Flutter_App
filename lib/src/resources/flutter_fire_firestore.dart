import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
    String uid = FirebaseAuth.instance.currentUser.uid;

    DocumentSnapshot connectionSnapshot = query.docs[0];
    String connectionUid = connectionSnapshot.id;

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

      //add connection to user's connections
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
    String fcmToken = await FirebaseMessaging.instance.getToken();
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
          'active_conversations_array': [],
          'fcm_token': fcmToken,
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
      List<Map> updatedData = [];
      for (int i = 0; i < data.length; i++) {
        updatedData.add(data[i]);
        var map = data[i];
        if (map['conversation_id'] == activeConversation.conversationId) {
          updatedData[i]['new_message'] = false;
          break;
        }
      }

      if (updatedData == data) {
        return true;
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
    //conversationId is alphabetic ordering of both user ids
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
      //data for user1
      DocumentSnapshot user1Doc = await transaction.get(user1DocRef);
      List activeConversations1 = user1Doc.data()['active_conversations'];
      List activeConversationsArray1 =
          user1Doc.data()['active_conversations_array'];
      String username1 = user1Doc.data()['username'];
      String profilePicPath1 = user1Doc.data()['profile_pic_path'];
      String fcmToken1 = user1Doc.data()['fcm_token'];

      if (activeConversationsArray1.contains(conversationId)) {
        toast('A conversation with the user already exists.');
        return false;
      }

      //data for user2
      DocumentSnapshot user2Doc = await transaction.get(user2DocRef);
      List activeConversations2 = user2Doc.data()['active_conversations'];
      List activeConversationsArray2 =
          user2Doc.data()['active_conversations_array'];
      String username2 = user2Doc.data()['username'];
      String profilePicPath2 = user2Doc.data()['profile_pic_path'];
      String fcmToken2 = user2Doc.data()['fcm_token'];

      //add common conversationId for both users
      activeConversationsArray1.add(conversationId);
      activeConversationsArray2.add(conversationId);

      //active conversation info to add to user1 doc
      Map activeConversationMap1 = {
        'username': username2,
        'profile_pic_path': profilePicPath2,
        'new_message': true,
        'conversation_id': conversationId,
        'last_updated': DateTime.now().toIso8601String(),
        'last_message': 'Click to start chatting.'
      };

      //active conversation info to add to user2 doc
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

      conversationMap['username_1'] = username1;
      conversationMap['username_2'] = username2;
      conversationMap['profile_pic_path_1'] = profilePicPath1;
      conversationMap['profile_pic_path_2'] = profilePicPath2;
      conversationMap['fcm_token_1'] = fcmToken1;
      conversationMap['fcm_token_2'] = fcmToken2;

      //create conversation doc
      transaction.set(conversationDocRef, conversationMap);
    });
    toast('Conversation added.');
    return true;
  } catch (e) {
    toast(e.toString());
    return false;
  }
}

Future<bool> sendMessageWithConversationId(
    String newMessage, String conversationId) async {
  try {
    String sentMessage = DateTime.now().toIso8601String();
    DocumentReference conversationDocRef = FirebaseFirestore.instance
        .collection('Conversations')
        .doc(conversationId);
    String user1;
    String user2;
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot conversationSnapshot =
          await transaction.get(conversationDocRef);
      var messages = conversationSnapshot.data()['messages'];
      user1 = conversationSnapshot.data()['user_1'];
      user2 = conversationSnapshot.data()['user_2'];
      messages.add({
        'text': newMessage,
        'sender_id': FirebaseAuth.instance.currentUser.uid,
        'sent_time': sentMessage,
      });
      transaction.update(conversationDocRef, {'messages': messages});
      updateActiveConversations(
          user1, user2, newMessage, conversationId, sentMessage);
    });
    return true;
  } catch (e) {
    toast(e.toString());
    return false;
  }
}

Future<bool> updateActiveConversations(String user1, String user2,
    String newMessage, String conversationId, String lastUpdated) async {
  try {
    String userId = FirebaseAuth.instance.currentUser.uid;
    DocumentReference user1Ref =
        FirebaseFirestore.instance.collection('Users').doc(user1);
    DocumentReference user2Ref =
        FirebaseFirestore.instance.collection('Users').doc(user2);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot user1Doc = await transaction.get(user1Ref);
      var user1ActiveConversations = user1Doc.data()['active_conversations'];

      DocumentSnapshot user2Doc = await transaction.get(user2Ref);
      var user2ActiveConversations = user2Doc.data()['active_conversations'];

      for (int i = 0; i < user1ActiveConversations.length; i++) {
        if (user1ActiveConversations[i]['conversation_id'] == conversationId) {
          user1ActiveConversations[i]['last_message'] = newMessage;
          user1ActiveConversations[i]['new_message'] =
              userId == user1 ? false : true;
          user1ActiveConversations[i]['last_updated'] = lastUpdated;
          break;
        }
      }

      for (int i = 0; i < user2ActiveConversations.length; i++) {
        if (user2ActiveConversations[i]['conversation_id'] == conversationId) {
          user2ActiveConversations[i]['last_message'] = newMessage;
          user2ActiveConversations[i]['new_message'] =
              userId == user2 ? false : true;
          user2ActiveConversations[i]['last_updated'] = lastUpdated;
          break;
        }
      }

      transaction
          .update(user1Ref, {'active_conversations': user1ActiveConversations});
      transaction
          .update(user2Ref, {'active_conversations': user2ActiveConversations});
      return true;
    });
  } catch (e) {
    toast(e.toString());
    return false;
  }
}
