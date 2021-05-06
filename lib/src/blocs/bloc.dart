import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/active_conversation_model.dart';

class Bloc {
  //StreamControllers
  final _activeConversations = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .snapshots();

  //getters
  Stream<List<ActiveConversationModel>> get activeConversationStream =>
      _activeConversations.transform(activeConversationsTransformer());

  activeConversationsTransformer() {
    return StreamTransformer<DocumentSnapshot,
            List<ActiveConversationModel>>.fromHandlers(
        handleData: (DocumentSnapshot snapshot, sink) {
      var activeConversations = snapshot.data()['active_conversations'];
      List<ActiveConversationModel> activeConversationModels = [];
      activeConversations.forEach((element) {
        activeConversationModels.add(ActiveConversationModel.fromMap(element));
      });
      sink.add(activeConversationModels);
    });
  }

  void dispose() {}
}
