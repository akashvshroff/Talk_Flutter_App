import 'message_model.dart';

class ConversationModel {
  String conversationId;
  String user1;
  String user2;
  List<MessageModel> messages;

  ConversationModel(
      {this.conversationId, this.user1, this.user2, this.messages});

  ConversationModel.fromMap(Map data) {
    this.conversationId = data['conversation_id'];
    this.user1 = data['user_1'];
    this.user2 = data['user_2'];
    this.messages = data['messages'];
  }
}
