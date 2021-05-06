class ActiveConversationModel {
  String username;
  String profilePicPath;
  String conversationId;
  bool newMessage;

  ActiveConversationModel(
      {this.username,
      this.profilePicPath,
      this.conversationId,
      this.newMessage});

  ActiveConversationModel.fromMap(Map<String, dynamic> data) {
    this.username = data['username'];
    this.profilePicPath = data['profile_pic_path'];
    this.conversationId = data['conversation_id'];
    this.newMessage = data['new_message'];
  }

  toMap() {
    return {
      'conversation_id': this.conversationId,
      'new_message': this.newMessage,
      'profile_pic_path': this.profilePicPath,
      'username': this.username,
    };
  }
}
