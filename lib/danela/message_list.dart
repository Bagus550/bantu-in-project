import 'package:flutter/material.dart';
import 'roomchat.dart';

class MessageList extends StatelessWidget {

  const MessageList({super.key,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('https://picsum.photos/200'),
                ),
                title: Text(
                  "Cimol",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Depan masjid persis kak.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  "09.26",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RoomChatPage()),
                  );
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('https://picsum.photos/201'),
                ),
                title: Text(
                  "Meng",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Terima kasih atas bantuannya kak",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  "09.14",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
