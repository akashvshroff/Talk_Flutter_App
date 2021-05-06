class ActiveConversationModel {
  String username;
  String profilePicPath;
  String conversationId;
  String lastMessage;
  bool newMessage;

  ActiveConversationModel(
      {this.username,
      this.profilePicPath,
      this.conversationId,
      this.newMessage,
      this.lastMessage});

  ActiveConversationModel.fromMap(Map<String, dynamic> data) {
    this.username = data['username'];
    this.profilePicPath = data['profile_pic_path'];
    this.conversationId = data['conversation_id'];
    this.newMessage = data['new_message'];
    this.lastMessage = data['last_message'];
  }

  toMap() {
    return {
      'conversation_id': this.conversationId,
      'new_message': this.newMessage,
      'profile_pic_path': this.profilePicPath,
      'username': this.username,
      'last_message': this.lastMessage,
    };
  }
}
