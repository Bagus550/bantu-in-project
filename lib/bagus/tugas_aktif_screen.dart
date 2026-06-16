import 'package:flutter/material.dart';
import 'tugas_aktif_helper.dart';

class TugasAktifScreen extends StatelessWidget {
  final Map<String, dynamic> detailTugas;
  const TugasAktifScreen({super.key, required this.detailTugas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tugas Aktif"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        toolbarHeight: 80,
      ),
      body: TugasAktifHelper(detailTugas: detailTugas),
    );
  }
}
