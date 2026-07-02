import 'dart:convert';

import 'package:bantuin/config/app_config.dart';
import 'package:bantuin/ida/auth/auth_service.dart';
import 'package:bantuin/utils/currency_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ValidPage extends StatefulWidget {
  final String name;
  final String amount;
  final String transactionId;

  const ValidPage({
    super.key,
    required this.name,
    required this.amount,
    required this.transactionId,
  });

  @override
  State<ValidPage> createState() => _ValidPageState();
}

class _ValidPageState extends State<ValidPage> {
  String _statusValidasi = '';
  final TextEditingController _catatanController = TextEditingController();
  bool _isLoading = true;
  Map<String, dynamic>? _paymentDetail;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConfig.baseUrl}/api/admin/payment-detail/${widget.transactionId}',
        ),
        headers: {"ngrok-skip-browser-warning": "69420"},
      );
      if (response.statusCode == 200) {
        var rawData = jsonDecode(response.body);
        debugPrint("Response Detail: $rawData");
        setState(() {
          _paymentDetail = rawData['data'];
          _isLoading = false;
        });
      }
      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          _paymentDetail = jsonDecode(response.body)['data'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> submitValidation() async {
    if (_statusValidasi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih Valid atau Invalid dulu.')),
      );
      return;
    }

    if (_statusValidasi == 'tidak_valid' &&
        _catatanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan penolakan wajib diisi')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      String? adminId = await authService.getUserId() ?? '1';

      final url = Uri.parse(
        '${AppConfig.baseUrl}/api/admin/verifikasi-pembayaran',
      );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},

        body: {
          'id_payment': widget.transactionId.toString(),
          'id_admin': adminId,
          'status_validasi': _statusValidasi,
          'catatan_admin': _statusValidasi == 'tidak_valid'
              ? _catatanController.text
              : '',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status berhasil diperbarui!')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${response.statusCode}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Widget _buildChoiceButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onPressed,
    required Color selectedColor,
    required Color selectedForeground,
    required Color unselectedBackground,
    required Color unselectedForeground,
    required Color borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? selectedColor : unselectedBackground,
          foregroundColor: isSelected ? selectedForeground : unselectedForeground,
          side: BorderSide(
            color: borderColor,
            width: isSelected ? 0 : 1.5,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: isSelected ? 2 : 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String catatanHelper =
        (_paymentDetail?['catatan_tambahan'] ??
                _paymentDetail?['catatan_helper'] ??
                _paymentDetail?['catatan'] ??
                '')
            .toString()
            .trim();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Validasi Pembayaran",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Pending Review",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.grey),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "User",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _paymentDetail?['nama_requester'] ??
                                  "Loading user...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Amount",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              (_paymentDetail?['nominal_pembayaran'] != null)
                                  ? _paymentDetail!['nominal_pembayaran']
                                        .toString()
                                        .toRupiah()
                                  : "Rp 0",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Bukti Pembayaran",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              if (catatanHelper.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Catatan dari Helper",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        catatanHelper,
                        style: TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: const EdgeInsets.all(16),
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            InteractiveViewer(
                              minScale: 1.0,
                              maxScale: 4.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      (_paymentDetail != null &&
                                              _paymentDetail!['bukti_pembayaran'] != null)
                                          ? "${AppConfig.baseUrl}/uploads/bukti/${_paymentDetail!['bukti_pembayaran']}"
                                          : "https://via.placeholder.com/400x600",
                                  httpHeaders: const {
                                    'ngrok-skip-browser-warning': '69420',
                                  },
                                  fit: BoxFit.contain,
                                  memCacheWidth: 1200,
                                  maxWidthDiskCache: 1200,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.close, color: Colors.white),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl:
                        (_paymentDetail != null &&
                                _paymentDetail!['bukti_pembayaran'] != null)
                            ? "${AppConfig.baseUrl}/uploads/bukti/${_paymentDetail!['bukti_pembayaran']}"
                            : "https://via.placeholder.com/400x600",
                    httpHeaders: const {
                      'ngrok-skip-browser-warning': '69420',
                    },
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    memCacheWidth: 800,
                    maxWidthDiskCache: 800,
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported_outlined, size: 48),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  "Klik Gambar untuk Memperbesar Detail Transaksi",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
              SizedBox(height: 32),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildChoiceButton(
                        label: "Setujui",
                        icon: Icons.check_circle_rounded,
                        isSelected: _statusValidasi == 'valid',
                        onPressed: () {
                          setState(() {
                            _statusValidasi = 'valid';
                            _catatanController.clear();
                          });
                        },
                        selectedColor: Colors.green.shade600,
                        selectedForeground: Colors.white,
                        unselectedBackground: Colors.transparent,
                        unselectedForeground: Colors.green.shade700,
                        borderColor: Colors.green.shade100,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildChoiceButton(
                        label: "Tolak",
                        icon: Icons.cancel_rounded,
                        isSelected: _statusValidasi == 'tidak_valid',
                        onPressed: () {
                          setState(() {
                            _statusValidasi = 'tidak_valid';
                          });
                        },
                        selectedColor: Colors.red.shade600,
                        selectedForeground: Colors.white,
                        unselectedBackground: Colors.transparent,
                        unselectedForeground: Colors.red.shade700,
                        borderColor: Colors.red.shade100,
                      ),
                    ),
                  ],
                ),
              ),
              if (_statusValidasi == 'tidak_valid') ...[
                SizedBox(height: 24),
                Text(
                  "Catatan Penolakan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _catatanController,
                  maxLines: 4,
                  minLines: 3,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText:
                        "Tuliskan alasan penolakan agar helper bisa memperbaiki bukti pembayaran.",
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    prefixIcon: Icon(
                      Icons.edit_note_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(14),
                  ),
                ),
              ],

              SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : submitValidation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _statusValidasi == 'valid'
                        ? Colors.green.shade600
                        : _statusValidasi == 'tidak_valid'
                        ? Colors.red.shade600
                        : Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _statusValidasi == 'valid'
                              ? "Kirim Persetujuan"
                              : _statusValidasi == 'tidak_valid'
                              ? "Kirim Penolakan"
                              : "Kirim Validasi",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
