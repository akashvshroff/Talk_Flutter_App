import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/active_conversation_model.dart';
import '../models/connection_model.dart';
import '../models/user_profile_model.dart';
import '../models/message_model.dart';
import '../models/conversation_model.dart';

class Bloc {
  //StreamControllers
  final _activeConversation = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .snapshots();

  final _connections = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .snapshots();

  final _profile = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .snapshots();

  //getters
  Stream<List<ActiveConversationModel>> get activeConversationStream =>
      _activeConversation.transform(activeConversationsTransformer());
  Stream<List<ConnectionModel>> get connectionsStream =>
      _connections.transform(connectionsTransformer());
  Stream<UserProfileModel> get profileStream =>
      _profile.transform(profileTransformer());

  Stream<ConversationModel> getConversationStream(String conversationId) {
    return FirebaseFirestore.instance
        .collection('Conversations')
        .doc(conversationId)
        .snapshots()
        .transform(conversationTransformer());
  }

  conversationTransformer() {
    return StreamTransformer<DocumentSnapshot, ConversationModel>.fromHandlers(
        handleData: (DocumentSnapshot snapshot, sink) {
      var data = snapshot.data();
      var messages = data['messages'];
      List<MessageModel> messageModels = [];
      messages.forEach((element) {
        messageModels.add(MessageModel.fromMap(element));
      });
      data['messages'] = messageModels;
      data['conversation_id'] = snapshot.id;
      sink.add(ConversationModel.fromMap(data));
    });
  }

  activeConversationsTransformer() {
    return StreamTransformer<DocumentSnapshot,
            List<ActiveConversationModel>>.fromHandlers(
        handleData: (DocumentSnapshot snapshot, sink) {
      var activeConversations = snapshot.data()['active_conversations'];
      List<ActiveConversationModel> activeConversationModels = [];
      activeConversations.forEach((element) {
        activeConversationModels.add(ActiveConversationModel.fromMap(element));
      });
      activeConversationModels
          .sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
      sink.add(activeConversationModels);
    });
  }

  connectionsTransformer() {
    return StreamTransformer<DocumentSnapshot,
            List<ConnectionModel>>.fromHandlers(
        handleData: (DocumentSnapshot snapshot, sink) {
      var connections = snapshot.data()['connections'];
      List<ConnectionModel> connectionModels = [];
      connections.forEach((element) {
        connectionModels.add(ConnectionModel.fromMap(element));
      });
      sink.add(connectionModels);
    });
  }

  profileTransformer() {
    return StreamTransformer<DocumentSnapshot, UserProfileModel>.fromHandlers(
        handleData: (DocumentSnapshot snapshot, sink) {
      Map data = snapshot.data();
      sink.add(UserProfileModel(
          username: data['username'],
          profilePicPath: data['profile_pic_path']));
    });
  }

  void dispose() {}
}
