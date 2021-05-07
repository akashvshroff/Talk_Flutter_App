class MessageModel {
  String text;
  String senderId;
  String sentTime;

  MessageModel({this.text, this.senderId, this.sentTime});

  MessageModel.fromMap(Map data) {
    this.text = data['text'];
    this.senderId = data['sender_id'];
    this.sentTime = data['sent_time'];
  }
}
