import 'dart:async';

import 'dart:convert';
import 'package:bantuin/config/app_config.dart';
import 'package:bantuin/ida/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bantuin/danela/config/message_model.dart';
import 'package:intl/intl.dart';

class RoomChatPage extends StatefulWidget {
  final Map<String, dynamic> namaData;
  const RoomChatPage({super.key, required this.namaData});

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  final TextEditingController pesanController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AuthService _authService = AuthService();

  final List<Message> _messages = [];
  int _lastMessageId = 0;
  Timer? _pollingTimer;
  bool _isLoadingFetch = false;

  String currentUser = "";
  String currentSenderType = "requester";
  String namaLawanChat = "Loading...";
  late int idRoom;
  bool _isInitialized = false;
  String _fotoLawan = "";

  @override
  void initState() {
    super.initState();

    idRoom =
        int.tryParse(widget.namaData['id_room']?.toString() ?? '') ??
        int.tryParse(widget.namaData['id_task']?.toString() ?? '') ??
        0;

    debugPrint("DEBUG ROOM ID: $idRoom");

    debugPrint(
      "DEBUG: Data Map yang diterima di RoomChat: ${widget.namaData.toString()}",
    );
    debugPrint(
      "DEBUG: Status Task saat ini: ${widget.namaData['status_task']}",
    );

    _fotoLawan = widget.namaData['foto_lawan'] ?? "";

    _initChatUser();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    pesanController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    if (_isLoadingFetch) return;

    if (idRoom == 0) {
      debugPrint("Error: idRoom bernilai 0, batalkan fetch messages.");
      return;
    }

    _isLoadingFetch = true;

    try {
      final String url =
          "${AppConfig.chat}/$idRoom?last_message_id=$_lastMessageId";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true && responseData['data'] != null) {
          List<dynamic> incomingMessages = responseData['data'];

          if (incomingMessages.isNotEmpty) {
            if (mounted) {
              setState(() {
                List<Message> newMessages = incomingMessages
                    .map((json) => Message.fromJson(json))
                    .toList();

                _messages.addAll(newMessages);

                _lastMessageId = _messages.last.idMessage;
              });
              _scrollToBottom();
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Gagal fetching chat: $e");
    } finally {
      _isLoadingFetch = false;
    }
  }

  Future<void> _sendMessage() async {
    String statusTask = widget.namaData['status_task']?.toString() ?? '';
    if (statusTask == 'selesai' || statusTask == 'dibatalkan') {
      debugPrint(
        "Gagal kirim: Sesi chat ini sudah dikunci karena status tugas non-aktif.",
      );
      return;
    }

    final String text = pesanController.text.trim();
    if (text.isEmpty) return;

    pesanController.clear();

    try {
      final response = await http.post(
        Uri.parse(AppConfig.chat),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "id_room": idRoom,
          "id_task":
              int.tryParse(widget.namaData['id_task']?.toString() ?? '') ?? 0,
          "sender_type": currentSenderType,
          "message_text": text,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['data'] != null &&
            responseData['data']['id_room'] != null) {
          int idRoomBaru = int.parse(
            responseData['data']['id_room'].toString(),
          );

          if (idRoom != idRoomBaru) {
            setState(() {
              idRoom = idRoomBaru;
            });
          }
        }

        _fetchMessages();
      } else {}
    } catch (e) {
      debugPrint("Error kirim pesan: $e");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _initChatUser() async {
    final String? namaSession = await _authService.getUserNama();
    final String? roleSession = await _authService.getUserRole();

    currentUser = namaSession ?? "User";
    currentSenderType = roleSession ?? "requester";

    final String requester = widget.namaData['nama_requester'] ?? 'Pelanggan';
    final String helper = widget.namaData['nama_helper'] ?? 'Helper';

    if (currentSenderType == 'requester') {
      namaLawanChat = helper;
    } else {
      namaLawanChat = requester;
    }

    String statusTask = widget.namaData['status_task']?.toString() ?? '';

    if (statusTask != 'selesai' && statusTask != 'dibatalkan') {
      try {
        final response = await http.post(
          Uri.parse(AppConfig.chat),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "id_room": idRoom,
            "id_task":
                int.tryParse(widget.namaData['id_task']?.toString() ?? '') ?? 0,
            "sender_type": currentSenderType,
            "message_text": "PING_INIT_ROOM_BANTUIN",
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          if (responseData['data'] != null &&
              responseData['data']['id_room'] != null) {
            int idRoomValid = int.parse(
              responseData['data']['id_room'].toString(),
            );
            if (mounted) {
              setState(() {
                idRoom = idRoomValid;
              });
            }
          }
        }
      } catch (e) {
        debugPrint("Gagal menginisialisasi history room: $e");
      }
    }

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }

    _fetchMessages();

    if (statusTask != 'selesai' &&
        statusTask != 'dibatalkan' &&
        statusTask != 'batal') {
      _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        _fetchMessages();
      });
    }
  }

  String _getGroupDateLabel(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";

    try {
      DateTime chatDate = DateTime.parse(dateStr).toLocal();
      DateTime now = DateTime.now();

      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime yesterday = today.subtract(const Duration(days: 1));
      DateTime chatDay = DateTime(chatDate.year, chatDate.month, chatDate.day);

      if (chatDay == today) {
        return "Hari Ini";
      } else if (chatDay == yesterday) {
        return "Kemarin";
      } else {
        // Format Indonesia: d MMMM yyyy (Contoh: 20 Juni 2026)
        return DateFormat('d MMMM yyyy', 'id_ID').format(chatDate);
      }
    } catch (e) {
      return "";
    }
  }

  String _getChatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "--:--";
    try {
      DateTime chatDate = DateTime.parse(dateStr).toLocal();
      return DateFormat('H:mm').format(chatDate);
    } catch (e) {
      return "--:--";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.blue.shade900),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage: _fotoLawan.isNotEmpty ? NetworkImage(_fotoLawan) : null,
              child: _fotoLawan.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  namaLawanChat,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        toolbarHeight: 80,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text("Belum ada obrolan teks aktif."))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final chat = _messages[index];
                      final bool isMe = chat.senderType == currentSenderType;

                      String? currentMessageDate = chat.sentAt;
                      bool showDateHeader = false;

                      if (index == 0) {
                        showDateHeader = true;
                      } else {
                        final previousMessage = _messages[index - 1];
                        String? previousMessageDate = previousMessage.sentAt;

                        if (_getGroupDateLabel(currentMessageDate) !=
                            _getGroupDateLabel(previousMessageDate)) {
                          showDateHeader = true;
                        }
                      }

                      return Column(
                        children: [
                          if (showDateHeader && currentMessageDate != null)
                            Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _getGroupDateLabel(currentMessageDate),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.only(
                                left: 14,
                                right: 14,
                                top: 10,
                                bottom: 6,
                              ),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? Colors.blue.shade100
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(12),
                                  topRight: const Radius.circular(12),
                                  bottomLeft: Radius.circular(isMe ? 12 : 0),
                                  bottomRight: Radius.circular(isMe ? 0 : 12),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    chat.messageText,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  Text(
                                    _getChatTime(chat.sentAt),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: () {
              String statusTask =
                  widget.namaData['status_task']?.toString() ?? '';

              if (statusTask == 'selesai' || statusTask == 'dibatalkan') {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Tugas telah selesai atau dibatalkan. Sesi obrolan ini telah diarsipkan dan Anda tidak dapat mengirim pesan lagi.",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: pesanController,
                      decoration: InputDecoration(
                        hintText: "Ketikan pesan",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: _sendMessage,
                  ),
                ],
              );
            }(),
          ),
        ],
      ),
    );
  }
}
