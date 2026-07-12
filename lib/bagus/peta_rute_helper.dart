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
import 'dart:math' as math;
import 'package:bantuin/danela/detail_task_helper.dart';
import 'package:bantuin/utils/currency_extension.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetaRuteHelper extends StatefulWidget {
  final Map<String, dynamic>? tugasAktif;
  final List<dynamic>? semuaTugas;
  final Map<String, dynamic>? userData;
  final String? token;

  const PetaRuteHelper({
    super.key,
    this.tugasAktif,
    this.semuaTugas,
    this.userData,
    this.token,
  });

  @override
  State<PetaRuteHelper> createState() => _PetaRuteHelperState();
}

class _PetaRuteHelperState extends State<PetaRuteHelper>
    with AutomaticKeepAliveClientMixin {
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<CompassEvent>? _compassStream;
  StreamSubscription<MagnetometerEvent>? _magnetometerStream;
  StreamSubscription<AccelerometerEvent>? _accelerometerStream;
  List<double> _gravity = [0, 0, 9.8];
  List<double> _geomagnetic = [0, 0, 0];
  LatLng? _lokasiHelper;
  LatLng? _lokasiTugas;
  List<LatLng> _ruteKoordinat = [];
  bool _isLoading = true;
  bool _isMapReady = false;
  final List<String> _sensorBermasalah = [];

  @override
  bool get wantKeepAlive => true;

  final MapController _mapController = MapController();
  bool _isFollowing = true;
  bool _isCalibrationDialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inisialisasiRute();
    });
  }

  Color ambilWarnaBantuan(String kategoriLayanan) {
    switch (kategoriLayanan.toLowerCase().trim()) {
      case 'bantuclean':
        return Colors.green;
      case 'bantufix':
        return Colors.orange;
      case 'bantushop':
        return Colors.blue;
      case 'bantustudy':
        return Colors.purple;
      default:
        return Colors.red;
    }
  }

  void _showTaskBottomSheet(Map<String, dynamic> task) {
    final String judul = task['judul_tugas'] ?? 'Tidak ada judul';
    final String harga = task['nominal_pembayaran'] ?? '0';
    final String kategori = task['kategori_layanan'] ?? 'Lainnya';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      judul,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ambilWarnaBantuan(kategori).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      kategori,
                      style: TextStyle(
                        color: ambilWarnaBantuan(kategori),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                harga.toString().toRupiah(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTugasHelper(
                          taskData: task,
                          userData: widget.userData,
                          token: widget.token,
                          adaTugasAktif:
                              widget.tugasAktif != null &&
                              widget.tugasAktif!.isNotEmpty,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Lihat Detail Tugas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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

  void _startCompassStream() {
    _compassStream = FlutterCompass.events?.listen((CompassEvent event) {
      if (!mounted) return;

      if (event.accuracy == null) {
        _compassStream?.cancel();
        if (!_sensorBermasalah.contains("Kompas / Magnetometer")) {
          _sensorBermasalah.add("Kompas / Magnetometer");
        }
        _cekDanTampilkanDialogSensor(); // Cek apakah perlu memunculkan dialog peringatan
        return;
      }

      // Jika accuracy null, berarti sensor Unreliable di Android
      if (event.accuracy! < 0 && !_isCalibrationDialogShown) {
        _isCalibrationDialogShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showCalibrationDialog();
        });
      }
    });

    // Pakai sensors_plus untuk heading yang lebih reliable
    _accelerometerStream = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        _gravity = [event.x, event.y, event.z];
        _updateHeading();
      },
      onError: (error) {
        _accelerometerStream?.cancel();
        if (!_sensorBermasalah.contains("Accelerometer (Arah Layar)")) {
          _sensorBermasalah.add("Accelerometer (Arah Layar)");
        }
        _cekDanTampilkanDialogSensor();
      },
    );

    _magnetometerStream = magnetometerEventStream().listen(
      (MagnetometerEvent event) {
        _geomagnetic = [event.x, event.y, event.z];
        _updateHeading();
      },
      onError: (error) {
        _magnetometerStream
            ?.cancel(); // Hentikan agar tidak menyumbat main thread Android
        if (!_sensorBermasalah.contains("Magnetometer (Kompas Fisik)")) {
          _sensorBermasalah.add("Magnetometer (Kompas Fisik)");
        }
        _cekDanTampilkanDialogSensor();
      },
    );
  }

  void _cekDanTampilkanDialogSensor() async {
    if (_isLoading || !mounted) return;

    if (_sensorBermasalah.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();

      bool sudahPernahMelihat =
          prefs.getBool('sudah_tampil_warning_sensor') ?? false;

      if (!sudahPernahMelihat && mounted) {
        await prefs.setBool('sudah_tampil_warning_sensor', true);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showSensorWarningDialog();
        });
      }
    }
  }

  void _showSensorWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 10),
              Text(
                "Keterbatasan Perangkat",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Aplikasi mendeteksi bahwa perangkat Anda tidak mendukung atau memiliki masalah pada sensor berikut:",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              // Menampilkan daftar sensor yang bermasalah secara dinamis
              ..._sensorBermasalah.map(
                (sensor) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          sensor,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Dampaknya, fitur rotasi otomatis peta mengikuti arah hadapan tubuh tidak dapat digunakan. Namun, Anda tetap bisa melihat peta dan melacak rute perjalanan dengan lancar.",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Saya Mengerti"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _updateHeading() {
    if (!_isFollowing || !_isMapReady || !mounted) return;

    if (_gravity[0] == 0 && _gravity[1] == 0 && _gravity[2] == 9.8) return;
    if (_geomagnetic[0] == 0 && _geomagnetic[1] == 0 && _geomagnetic[2] == 0) {
      return;
    }

    // Hitung rotation matrix dari accelerometer + magnetometer
    final double ax = _gravity[0], ay = _gravity[1], az = _gravity[2];
    final double mx = _geomagnetic[0],
        my = _geomagnetic[1],
        mz = _geomagnetic[2];

    final double normA = math.sqrt(ax * ax + ay * ay + az * az);
    if (normA == 0) return;

    final double hx = my * az - mz * ay;
    final double hy = mz * ax - mx * az;
    final double normH = math.sqrt(hx * hx + hy * hy);
    if (normH < 0.1) return;

    final double heading = math.atan2(hy, hx) * 180 / math.pi;
    _mapController.rotate(-heading);
  }

  void _showCalibrationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Kalibrasi Kompas",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Sensor kompas Anda perlu dikalibrasi agar arah peta lebih akurat.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Lottie.asset(
                'assets/logo/device_calibration.json',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              const Text(
                "Ayunkan HP Anda membentuk angka 8 selama beberapa detik.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Saya Mengerti",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _compassStream?.cancel();
    _magnetometerStream?.cancel();
    _accelerometerStream?.cancel();
    _mapController.dispose();
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

      if (lat != null &&
          lng != null &&
          lat.toString().isNotEmpty &&
          lng.toString().isNotEmpty) {
        final parsedLat = double.tryParse(lat.toString());
        final parsedLng = double.tryParse(lng.toString());
        if (parsedLat != null && parsedLng != null) {
          _lokasiTugas = LatLng(parsedLat, parsedLng);
        }
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

      _startLocationStream();
      _startCompassStream();

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
      _cekDanTampilkanDialogSensor();
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
                        if (widget.semuaTugas != null &&
                            widget.tugasAktif == null)
                          ...widget.semuaTugas!
                              .where((t) {
                                final lat =
                                    t['latitude_tugas'] ?? t['latitude'];
                                final lng =
                                    t['longitude_tugas'] ?? t['longitude'];
                                return lat != null &&
                                    lng != null &&
                                    lat.toString().isNotEmpty &&
                                    lng.toString().isNotEmpty;
                              })
                              .map((tugasFeed) {
                                final lat = double.tryParse(
                                  (tugasFeed['latitude_tugas'] ??
                                          tugasFeed['latitude'])
                                      .toString(),
                                );
                                final lng = double.tryParse(
                                  (tugasFeed['longitude_tugas'] ??
                                          tugasFeed['longitude'])
                                      .toString(),
                                );
                                final kategori =
                                    tugasFeed['kategori_layanan']?.toString() ??
                                    '';
                                if (lat == null || lng == null) return null;
                                // debugPrint("Tampil marker untuk tugas feed: $lat, $lng");

                                return Marker(
                                  point: LatLng(lat, lng),
                                  width: 45,
                                  height: 45,
                                  child: GestureDetector(
                                    onTap: () => _showTaskBottomSheet(
                                      Map<String, dynamic>.from(tugasFeed),
                                    ),
                                    child: Icon(
                                      Icons.location_pin,
                                      color: ambilWarnaBantuan(kategori),
                                      size: 45,
                                    ),
                                  ),
                                );
                              })
                              .whereType<Marker>(),
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
              ],
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'btnAutoUtara',
              mini: true,
              child: const Icon(Icons.navigation), // Tombol Auto-Utara
              onPressed: () => _mapController.rotate(0),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'btnLocation',
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
