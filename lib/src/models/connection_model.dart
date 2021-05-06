class ConnectionModel {
  String userId;
  String username;
  String profilePicPath;

  ConnectionModel({this.userId, this.username, this.profilePicPath});

  ConnectionModel.fromMap(Map data) {
    this.userId = data['user_id'];
    this.username = data['username'];
    this.profilePicPath = data['profile_pic_path'];
  }
}
