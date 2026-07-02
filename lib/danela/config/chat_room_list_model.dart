class ChatRoomListModel {
  final int idRoom;
  final int idTask;
  final int isActive;
  final int? idRequester;
  final int? idHelper;
  final String? namaRequester;
  final String? namaHelper;
  final String? lastMessage;
  final String? statusTask;
  final String? fotoRequester;
  final String? fotoHelper;

  ChatRoomListModel({
    required this.idRoom,
    required this.idTask,
    required this.isActive,
    this.idRequester,
    this.idHelper,
    this.namaRequester,
    this.namaHelper,
    this.lastMessage,
    this.sentAt,
    this.statusTask,
    this.fotoRequester,
    this.fotoHelper,
  });

  factory ChatRoomListModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomListModel(
      idRoom: int.tryParse(json['id_room']?.toString() ?? '') ?? 0,
      idTask: int.tryParse(json['id_task']?.toString() ?? '') ?? 0,
      isActive: int.tryParse(json['is_active']?.toString() ?? '') ?? 0,
      idRequester: json['id_requester'] != null ? int.tryParse(json['id_requester'].toString()) : null,
      idHelper: json['id_helper'] != null ? int.tryParse(json['id_helper'].toString()) : null,
      namaRequester: json['nama_requester'],
      namaHelper: json['nama_helper'],
      lastMessage: json['last_message'],
      sentAt: json['sent_at'],
      statusTask: json['status']?.toString() ?? json['status_task']?.toString(),
      fotoRequester: json['foto_requester'],
      fotoHelper: json['foto_helper'],
    );
  }
}
