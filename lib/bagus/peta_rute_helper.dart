// lib/bagus/peta_rute_helper.dart
import 'dart:async';
import 'dart:convert';
import 'package:bantuin/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class PetaRuteHelper extends StatefulWidget {
  final Map<String, dynamic> tugasAktif;

  const PetaRuteHelper({super.key, required this.tugasAktif});

  @override
  State<PetaRuteHelper> createState() => _PetaRuteHelperState();
}

class _PetaRuteHelperState extends State<PetaRuteHelper>
    with AutomaticKeepAliveClientMixin {
  StreamSubscription<Position>? _positionStream;
  LatLng? _lokasiHelper;
  LatLng? _lokasiTugas;
  List<LatLng> _ruteKoordinat = [];
  bool _isLoading = true;
  bool _isMapReady = false;

  @override
  bool get wantKeepAlive => true;

  final MapController _mapController = MapController();
  bool _isFollowing = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLocationStream();
      _inisialisasiRute();
    });
  }

  void _startLocationStream() {
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) {
          if (!mounted) return;

          setState(() {
            _lokasiHelper = LatLng(position.latitude, position.longitude);
          });

          if (_isFollowing && _isMapReady) {
            _mapController.move(_lokasiHelper!, 16.0);
          }
          _tarikGarisRute();
        });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _inisialisasiRute() async {
    // 1. Validasi Koordinat Tugas
    final lat = widget.tugasAktif['latitude_tugas'];
    final lng = widget.tugasAktif['longitude_tugas'];

    if (lat != null && lng != null) {
      _lokasiTugas = LatLng(
        double.parse(lat.toString()),
        double.parse(lng.toString()),
      );
    }

    try {
      // 2. Cek izin lokasi
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw 'Izin lokasi ditolak';

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      if (mounted) {
        setState(() {
          _lokasiHelper = LatLng(position.latitude, position.longitude);
        });

        // 3. Tarik rute setelah posisi helper didapat
        if (_lokasiTugas != null) {
          await _tarikGarisRute();
        }
      }
    } catch (e) {
      debugPrint("Error lokasi: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _tarikGarisRute() async {
    if (_lokasiHelper == null || _lokasiTugas == null) return;

    final url = Uri.parse(
      '${AppConfig.osrmServer}/route/v1/driving/${_lokasiHelper!.longitude},${_lokasiHelper!.latitude};${_lokasiTugas!.longitude},${_lokasiTugas!.latitude}?geometries=geojson',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final geometry = data['routes'][0]['geometry']['coordinates'] as List;
          if (mounted) {
            setState(() {
              _ruteKoordinat = geometry.map((c) => LatLng(c[1], c[0])).toList();
            });
          }
        }
      } else {
        // Log status code jika gagal
        debugPrint(
          "Gagal narik rute, status code: ${response.statusCode}, body: ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("Gagal narik rute: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // KUNCI: Harus ada Scaffold agar tidak blank putih
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.tugasAktif.isEmpty
          ? const Center(child: Text("Tidak ada tugas aktif."))
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter:
                    _lokasiHelper ?? _lokasiTugas ?? const LatLng(-6.2, 106.8),
                initialZoom: 16.0,
                onMapReady: () {
                  setState(() => _isMapReady = true);
                  debugPrint("Peta siap digunakan!");
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.example.bantuin',
                  tileProvider: CancellableNetworkTileProvider(),
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _ruteKoordinat,
                      color: Colors.green.shade300,
                      strokeWidth: 5.0,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    if (_lokasiHelper != null)
                      Marker(
                        point: _lokasiHelper!,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                    if (_lokasiTugas != null)
                      Marker(
                        point: _lokasiTugas!,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                  ],
                ),
              ],
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FloatingActionButton(
              mini: true,
              child: const Icon(Icons.navigation), // Tombol Auto-Utara
              onPressed: () => _mapController.rotate(0),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              mini: true,
              child: Icon(
                _isFollowing ? Icons.my_location : Icons.location_searching,
              ),
              onPressed: () {
                setState(() => _isFollowing = !_isFollowing);
                if (_isFollowing && _lokasiHelper != null) {
                  _mapController.move(_lokasiHelper!, 16.0);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
