import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'roomchat.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageState();
}

class _MessageState extends State<MessageList> {
  final String apiUrl = "https://lid-jarring-angler.ngrok-free.dev/api/chat";
  List<dynamic> _chatRooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChatRooms();
  }

  Future<void> _fetchChatRooms() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          _chatRooms = responseData['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching chat list: $e");
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

                // LOGIKA FRONTEND: Tentukan nama lawan bicara dinamis berdasarkan data role
                // (Sesuaikan dengan data user session login di frontend-mu)
                String namaLawanBicara = room['nama_requester'] ?? 'Pelanggan';

                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue.shade900,
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/200?random=$index',
                    ),
                  ),
                  title: Text(
                    namaLawanBicara,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    room['last_message'] ?? 'Belum ada pesan teks.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: room['last_message'] != null
                          ? Colors.black87
                          : Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    room['sent_at'] ?? '--.--',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    // Data satu objek 'room' dari API dioper langsung ke RoomChatPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomChatPage(namaData: room),
                      ),
                    ).then((value) {
                      // REFRESH DATA DAFTAR CHAT ketika user menekan tombol back dari RoomChatPage
                      _fetchChatRooms();
                    });
                  },
                );
              },
            ),
    );
  }
}
