import 'package:flutter/material.dart';

class DetailTugas extends StatefulWidget {
  const DetailTugas({super.key});

  @override
  State<DetailTugas> createState() => _DetailTugasState();
}

class _DetailTugasState extends State<DetailTugas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(        
        title: Text("Bantu.In", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 2,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
        actions: [
          Padding(padding: EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,            
            backgroundImage: NetworkImage('https://picsum.photos/199'),
          ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text("Bersihin Ruang Tamu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                SizedBox(width: 10), 
                Text('Rp. 75.000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              ],
            ),
            SizedBox(height: 6),
            Icon(Icons.location_on_sharp),
            Text("Hari ini, 09.25", style: TextStyle(fontSize: 13)),
          ],
        ),
      )
    );
  }
}