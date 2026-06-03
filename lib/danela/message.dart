import 'package:bantuin/danela/roomchat.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        title: Text('Pesan', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage('https://picsum.photos/200'),
            ),
            title: Text("Cimol", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Depan masjid persis kak.",style: TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text("09.26", style: TextStyle(fontSize: 12, color: Colors.grey)),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RoomChatPage()));
            },
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage('https://picsum.photos/201'),
            ),
            title: Text("Meng", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Terima kasih atas bantuannya kak",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text("09.14", style: TextStyle(fontSize: 12, color: Colors.grey)),
            onTap: (){              
            },
          ),
        ],
      )
    );
  }
}

