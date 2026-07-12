import 'dart:convert';
import 'package:bantuin/config/app_config.dart';
import 'package:bantuin/ida/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bantuin/danela/config/chat_room_list_model.dart';
import 'roomchat.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageState();
}

class _MessageState extends State<MessageList> {
  final String apiUrl = AppConfig.chat;
  final AuthService _authService = AuthService();

  List<ChatRoomListModel> _chatRooms = [];
  bool _isLoading = true;
  String currentUser = "";
  String currentUserId = "";

  @override
  void initState() {
    super.initState();
    _fetchChatRooms();
  }

  Future<void> _fetchChatRooms() async {
    try {
      final String? idUserAktif = await _authService.getUserId();
      final String? roleSession = await _authService.getUserRole();
      final String? namaSession = await _authService.getUserNama();

      if (idUserAktif == null || roleSession == null) {
        debugPrint("Session user tidak ditemukan.");
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      if (mounted) {
        setState(() {
          currentUser = namaSession ?? "";
          currentUserId = idUserAktif.toString();
        });
      }

      final String urlDenganParameter =
          "$apiUrl?id_user=$idUserAktif&role=$roleSession";

      final response = await http.get(Uri.parse(urlDenganParameter));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (mounted) {
          setState(() {
            List<dynamic> listMentah = responseData['data'] ?? [];
            debugPrint("Jumlah data room didapat: ${listMentah.length}");
            try {
              _chatRooms = listMentah
                  .map((json) => ChatRoomListModel.fromJson(json))
                  .toList();
            } catch (modelError) {
              debugPrint(
                "ERROR PARSING MODEL: Gagal konversi JSON ke ChatRoomListModel!",
              );
              debugPrint("Detail Error Model: $modelError");
            }
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Gagal fetching list chat: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chatRooms.isEmpty
          ? const Center(child: Text("Belum ada obrolan teks aktif."))
          : ListView.builder(
              itemCount: _chatRooms.length,
              itemBuilder: (context, index) {
                final room = _chatRooms[index];

                String namaLawanBicara = "";
                String fotoLawanBicara = "";
                if (room.idRequester?.toString() == currentUserId) {
                  namaLawanBicara = room.namaHelper ?? 'Helper';
                  fotoLawanBicara = room.fotoHelper ?? '';
                } else {
                  namaLawanBicara = room.namaRequester ?? 'Pelanggan';
                  fotoLawanBicara = room.fotoRequester ?? '';
                }

                String avatarUrl = AppConfig.getProfileUrl(fotoLawanBicara) ?? "";

                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                    child: avatarUrl.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
                  ),
                  title: Text(
                    namaLawanBicara,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    room.lastMessage ?? 'Belum ada pesan teks.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: room.lastMessage != null
                          ? Colors.black87
                          : Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    room.sentAt ?? '--.--',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    Map<String, dynamic> dataMap = {
                      'id_room': room.idRoom,
                      'id_task': room.idTask,
                      'is_active': room.isActive,
                      'nama_requester': room.namaRequester,
                      'nama_helper': room.namaHelper,
                      'nama_lawan': namaLawanBicara,
                      'status_task': room.statusTask,
                      'foto_lawan': avatarUrl,
                    };

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomChatPage(namaData: dataMap),
                      ),
                    ).then((value) {
                      _fetchChatRooms();
                    });
                  },
                );
              },
            ),
    );
  }
}
