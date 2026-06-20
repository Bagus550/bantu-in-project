import 'dart:async';

import 'dart:convert';
import 'package:bantuin/config/app_config.dart';
import 'package:bantuin/ida/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bantuin/danela/config/message_model.dart';

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

  @override
  void initState() {
    super.initState();

    idRoom =
        int.tryParse(widget.namaData['id_room']?.toString() ?? '') ??
        int.tryParse(widget.namaData['id_task']?.toString() ?? '') ??
        0;
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
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }

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
          setState(() {
            idRoom = idRoomValid;
          });
        }
      }
    } catch (e) {
      debugPrint("Gagal menginisialisasi history room: $e");
    }

    if (mounted) {
      setState(() {});
    }

    _fetchMessages();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchMessages();
    });
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
              backgroundImage: NetworkImage('https://picsum.photos/200'),
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

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
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
                          child: Text(
                            chat.messageText,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
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
                  onPressed: _sendMessage, // Panggil fungsi kirim pesan
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
