class UserProfileModel {
  String username;
  String profilePicPath;

  UserProfileModel({this.username, this.profilePicPath});

  UserProfileModel.fromMap(Map data) {
    this.username = data['username'];
    this.profilePicPath = data['profile_pic_path'];
  }
}
