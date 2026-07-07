import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class PilihLokasiPeta extends StatefulWidget {
  const PilihLokasiPeta({super.key});

  @override
  State<PilihLokasiPeta> createState() => _PilihLokasiPetaState();
}

class _PilihLokasiPetaState extends State<PilihLokasiPeta> {
  final MapController _mapController = MapController();
  
  // Koordinat default (misal titik tengah Indonesia/Jakarta) jika GPS belum ditarik
  LatLng _centerLokasi = const LatLng(-6.2088, 106.8456); 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dapatkanLokasiAwal();
  }

  Future<void> _dapatkanLokasiAwal() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'GPS belum aktif';

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw 'Izin ditolak';
      }
      
      if (permission == LocationPermission.deniedForever) throw 'Izin diblokir permanen';

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      if (mounted) {
        setState(() {
          _centerLokasi = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });
      }
    } catch (e) {
      // Jika GPS gagal, tetap tampilkan peta di lokasi default
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menarik GPS: $e"), backgroundColor: Colors.orange),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geser Peta ke Titik Tugas", style: TextStyle(fontSize: 16)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _centerLokasi,
                    initialZoom: 16.0,
                    // Saat peta digeser, perbarui _centerLokasi dengan titik tengah layar
                    onPositionChanged: (position, hasGesture) {
                      if (position.center != null) {
                        _centerLokasi = position.center!;
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      // Pakai server OSM gratis
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.bantu.in',
                    ),
                  ],
                ),
                // TRIK PIN DROP: Ikon ditaruh statis di tengah layar (menumpuk di atas peta)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 40.0), // Diangkat dikit biar ujung pin pas di tengah
                    child: Icon(
                      Icons.location_pin,
                      color: Color(0xFFCD2528),
                      size: 50,
                    ),
                  ),
                ),
              ],
            ),
      // Tombol Konfirmasi di bawah
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Kembalikan koordinat terpilih ke halaman sebelumnya
                Navigator.pop(context, _centerLokasi);
              },
              child: const Text("Pilih Lokasi Ini", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}