import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tentang Kami"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/logo/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                Text("Bantu.in", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            
              ],
            ),
          ),
          Text("Selamat Datang di Bantu.in",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          Text("Bantu.In adalah platform yang menghubungkan Anda dengan penyediajasa terpercaya untuk berbagaikebutuhan. Dari perbaikan, pembersihan hingga berbelanja, kami di sini  untuk membantu."),
          Text("Misi Kami"),
          Text("Menyediakan layanan berkualitas Membangun komunitas terpecaya Memberikan kemudahan akses untuk semua"),
          Text("Misi - Misi Kami"),
        ],
      ),
    );
  }
}
