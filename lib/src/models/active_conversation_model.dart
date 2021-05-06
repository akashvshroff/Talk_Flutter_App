class ActiveConversationModel {
  String username;
  String profilePicPath;
  String conversationId;
  String lastMessage;
  bool newMessage;
  String lastUpdated;

  ActiveConversationModel(
      {this.username,
      this.profilePicPath,
      this.conversationId,
      this.newMessage,
      this.lastMessage,
      this.lastUpdated});

  ActiveConversationModel.fromMap(Map<String, dynamic> data) {
    this.username = data['username'];
    this.profilePicPath = data['profile_pic_path'];
    this.conversationId = data['conversation_id'];
    this.newMessage = data['new_message'];
    this.lastMessage = data['last_message'];
    this.lastUpdated = data['last_updated'];
  }

  // toMap() {
  //   return {
  //     'conversation_id': this.conversationId,
  //     'new_message': this.newMessage,
  //     'profile_pic_path': this.profilePicPath,
  //     'username': this.username,
  //     'last_message': this.lastMessage,
  //   };
  // }
}
