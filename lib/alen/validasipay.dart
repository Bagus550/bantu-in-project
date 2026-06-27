import 'dart:convert';

import 'package:bantuin/config/app_config.dart';
import 'package:bantuin/ida/auth/auth_service.dart';
import 'package:bantuin/utils/currency_extension.dart';
import 'package:flutter/material.dart';
import 'package:bantuin/ida/auth/auth_service.dart';
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
        headers: {
          "ngrok-skip-browser-warning": "69420",
          "Content-Type": "application/x-www-form-urlencoded", 
        },

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

  @override
  Widget build(BuildContext context) {
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
                            color: Colors.grey,
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
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                  image: DecorationImage(
                    image:
                        (_paymentDetail != null &&
                            _paymentDetail!['bukti_pembayaran'] != null)
                        ? NetworkImage(
                            "${AppConfig.baseUrl}/uploads/bukti/${_paymentDetail!['bukti_pembayaran']}",
                          )
                        : NetworkImage("https://via.placeholder.com/400x600"),
                    fit: BoxFit.cover,
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _statusValidasi = 'valid';
                      _catatanController.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Valid (Approve)",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _statusValidasi = 'tidak_valid';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _statusValidasi == 'tidak_valid'
                        ? Colors.red
                        : Colors.white,
                    foregroundColor: _statusValidasi == 'tidak_valid'
                        ? Colors.white
                        : Colors.red,
                    side: BorderSide(color: Colors.red, width: 1.5),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Invalid (Reject)",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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
                TextField(
                  controller: _catatanController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Alasan penolakan...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],

              SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : submitValidation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                          "Kirim Validasi",
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
