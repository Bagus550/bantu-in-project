class Message {
  final int idMessage;
  final int idRoom;
  final String senderType;
  final String messageText;
  final String? sentAt;

  Message({
    required this.idMessage,
    required this.idRoom,
    required this.senderType,
    required this.messageText,
    this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      idMessage: int.parse(json['id_message'].toString()),
      idRoom: int.parse(json['id_room'].toString()),
      senderType: json['sender_type'],
      messageText: json['message_text'],
      sentAt: json['sent_at'],
    );
  }
}
