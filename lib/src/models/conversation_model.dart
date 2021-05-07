import 'message_model.dart';

class ConversationModel {
  String conversationId;
  String user1;
  String user2;
  String username1;
  String username2;
  String profilePicPath1;
  String profilePicPath2;
  List<MessageModel> messages;

  ConversationModel(
      {this.conversationId,
      this.user1,
      this.user2,
      this.messages,
      this.username1,
      this.username2,
      this.profilePicPath1,
      this.profilePicPath2});

  ConversationModel.fromMap(Map data) {
    this.conversationId = data['conversation_id'];
    this.user1 = data['user_1'];
    this.user2 = data['user_2'];
    this.username1 = data['username_1'];
    this.username2 = data['username_2'];
    this.profilePicPath1 = data['profile_pic_path_1'];
    this.profilePicPath2 = data['profile_pic_path_2'];
    this.messages = data['messages'];
  }
}
