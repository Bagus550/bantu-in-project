import 'package:flutter/material.dart';

class NotifikasiRequester extends StatefulWidget {
  const NotifikasiRequester({super.key});

  @override
  State<NotifikasiRequester> createState() => _NotifikasiRequesterState();
}

class _NotifikasiRequesterState extends State<NotifikasiRequester> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notifikasi",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Tandai semua dibaca",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            
          ]
        ),
      ),
    );
  }
}