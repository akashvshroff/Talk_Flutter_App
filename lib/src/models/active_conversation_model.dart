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
}
