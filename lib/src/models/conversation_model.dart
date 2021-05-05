import 'message_model.dart';

class ConversationModel {
  String conversationId;
  String user1;
  String user2;
  List<MessageModel> messages;

  ConversationModel(
      {this.conversationId, this.user1, this.user2, this.messages});
}
