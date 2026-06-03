import 'package:bantuin/danela/message.dart';
import 'package:flutter/material.dart';

class RoomChatPage extends StatefulWidget {
  const RoomChatPage({super.key});

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  final TextEditingController pesanController = TextEditingController();
  // final List<ChatMessage> _message = [];

  // void _sendMessage (){
  //   String text = pesanController.text.trim();
  //   if (text.isEmpty) return;

  //   setState(() {
  //     _message.add(ChatMessage(text: text, isMe: true));
  //   });    
  //   pesanController.clear();

  //   if (text.toLowerCase()
  //   .contains('posisi dimana kak?')) {
  //     Future.delayed(Duration(seconds: 1), (){
  //       setState(() {
  //         _message.add(ChatMessage(text: "Depan masjid persis kak.", isMe: false));
  //       });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Message()));
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
                Text('Cimol', 
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
      ),
      body: Column(
        children: [ 
          // Expanded(child: ListView.builder(padding: EdgeInsets.all(15),
          // itemCount: _message.length,
          // itemBuilder: (context, index) => _buildChatBubble(_message[index]),
          // ),
          // ),         
          Spacer(),
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
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Theme.of(context).colorScheme.secondary),
                  onPressed: () {
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget _buildChatBubble(ChatMessage message){
//   return Align(
//     alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
//     child: 
//     Container(
//       margin: EdgeInsets.symmetric(vertical: 4),
//       padding: ,
//     ),
//   )
// }
// class ChatMessage {
//   final String text;
//   final String isMe;

//   ChatMessage({required this.text, required this.isMe});
// }