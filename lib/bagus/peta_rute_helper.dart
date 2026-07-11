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
  final Map<String, dynamic>? tugasAktif;

  const PetaRuteHelper({super.key, this.tugasAktif});

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
  final TextEditingController _searchController = TextEditingController();
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
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _inisialisasiRute() async {
    // 1. Validasi Koordinat Tugas
    if (widget.tugasAktif != null && widget.tugasAktif!.isNotEmpty) {
      final lat =
          widget.tugasAktif!['latitude_tugas'] ??
          widget.tugasAktif!['latitude'];
      final lng =
          widget.tugasAktif!['longitude_tugas'] ??
          widget.tugasAktif!['longitude'];

      if (lat != null && lng != null) {
        _lokasiTugas = LatLng(
          double.parse(lat.toString()),
          double.parse(lng.toString()),
        );
      }
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

  void _searchKoordinat() {
    final input = _searchController.text.trim();
    if (input.isEmpty) return;

    final parts = input.split(',');
    if (parts.length == 2) {
      final lat = double.tryParse(parts[0].trim());
      final lng = double.tryParse(parts[1].trim());

      if (lat != null && lng != null) {
        setState(() {
          _lokasiTugas = LatLng(lat, lng);
        });
        _tarikGarisRute();

        if (_isMapReady) {
          _mapController.move(_lokasiTugas!, 16.0);
        }
      } else {
        _tampilkanPesanSalah();
      }
    } else {
      _tampilkanPesanSalah();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();

    _lokasiTugas = null;
    _ruteKoordinat = [];

    if (widget.tugasAktif != null && widget.tugasAktif!.isNotEmpty) {
      final lat =
          widget.tugasAktif!['latitude_tugas'] ??
          widget.tugasAktif!['latitude'];
      final lng =
          widget.tugasAktif!['longitude_tugas'] ??
          widget.tugasAktif!['longitude'];

      if (lat != null && lng != null) {
        _lokasiTugas = LatLng(
          double.parse(lat.toString()),
          double.parse(lng.toString()),
        );
      }
    }

    setState(() {});

    if (_lokasiTugas != null) {
      _tarikGarisRute();
      if (_isMapReady) {
        _mapController.move(_lokasiTugas!, 16.0);
      }
    } else if (_lokasiHelper != null && _isMapReady) {
      _mapController.move(_lokasiHelper!, 16.0);
    }
  }

  void _tampilkanPesanSalah() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Format koordinat salah! Gunakan format: latitude, longitude",
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // KUNCI: Harus ada Scaffold agar tidak blank putih
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter:
                        _lokasiHelper ??
                        _lokasiTugas ??
                        const LatLng(-6.2, 106.8),
                    initialZoom: 16.0,
                    onMapReady: () {
                      setState(() => _isMapReady = true);
                      debugPrint("Peta siap digunakan!");
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.bantu.in',
                      tileProvider: CancellableNetworkTileProvider(),
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _ruteKoordinat,
                          color: Theme.of(context).colorScheme.primary,
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
                Positioned(
                  top: 40,
                  left: 15,
                  right: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: "Cari koordinat (lat, lng)",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                            ),
                            onSubmitted: (_) => _searchKoordinat(),
                          ),
                        ),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _searchController,
                          builder: (context, value, child) {
                            if (value.text.isNotEmpty) {
                              return IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                                onPressed: _clearSearch,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.blue),
                          onPressed: _searchKoordinat,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
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
