class Message {
  String content;
  String senderId;
  String senderName;
  String receiverId;
  DateTime time;

  Message(
      {this.content = "",
      this.senderId = "",
      this.senderName = "",
      this.receiverId = "",
      this.time});
  factory Message.jsonFrom(Map<dynamic, dynamic> json) {
    return Message(
        content: json["Content"],
        senderId: json["SenderId"],
        receiverId: json["ReceiverId"],
        senderName: json["SenderName"],
        time: DateTime.parse(json["CreateDate"]));
  }
  factory Message.jsonFromInternal(Map<dynamic, dynamic> json) {
    return Message(
        content: json["content"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        senderName: json["senderName"],
        time: DateTime.now());
  }
}
