// lib/screens/history_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aplikasi_bantuan/api/api_service.dart';
import 'package:aplikasi_bantuan/models/aid_history_model.dart'; // Ensure this model exists

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<AidHistory>> _futureHistories;

  @override
  void initState() {
    super.initState();
    _futureHistories = _fetchHistories();
  }

  Future<List<AidHistory>> _fetchHistories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      final response = await ApiService.getHistory(token);

      if (!mounted) return []; // Check if widget is still mounted

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> historyListJson = responseData['data']['data'];
        return historyListJson
            .map((json) => AidHistory.fromJson(json))
            .toList();
      } else {
        final responseData = jsonDecode(response.body);
        final message =
            responseData['message'] ?? 'Gagal memuat riwayat verifikasi.';
        throw Exception(message);
      }
    } catch (e) {
      print('Error fetching history: $e'); // For debugging
      // Show a snackbar for network/other errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Terjadi kesalahan: ${e.toString().contains('SocketException') ? 'Periksa koneksi internet Anda.' : e.toString()}',
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      rethrow; // Re-throw the error so FutureBuilder can catch it
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Verifikasi Bantuan'),
        backgroundColor: const Color(0xFF1976D2), // Consistent blue
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFBBDEFB),
            ], // Lighter blue gradient for background
          ),
        ),
        child: FutureBuilder<List<AidHistory>>(
          future: _futureHistories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Belum ada riwayat verifikasi yang tercatat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              );
            } else {
              final histories = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 8.0,
                ),
                itemCount: histories.length,
                itemBuilder: (context, index) {
                  final history = histories[index];
                  final bool isRejected = history.status == 'ditolak';

                  String subtitleText =
                      'NIK: ${history.recipientNik}\nTanggal: ${history.verifiedAt}';
                  if (isRejected &&
                      history.remarks != null &&
                      history.remarks!.isNotEmpty) {
                    subtitleText += '\nAlasan: ${history.remarks}';
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal:
                          8, // Adjusted for slightly more spacing from edge
                      vertical: 6,
                    ),
                    elevation: 4, // Slightly increased elevation for more pop
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Consistent rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ), // Added padding inside card for listtile
                      child: ListTile(
                        leading: Container(
                          width: 50, // Fixed width for leading icon container
                          height: 50, // Fixed height for leading icon container
                          decoration: BoxDecoration(
                            color:
                                isRejected
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.green.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isRejected
                                ? Icons.cancel_outlined
                                : Icons
                                    .check_circle_outline, // Changed to outlined icons
                            color: isRejected ? Colors.red : Colors.green,
                            size: 30, // Adjusted icon size
                          ),
                        ),
                        title: Text(
                          history.recipientName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16, // Slightly larger title
                            color: Colors.blueGrey, // More subdued color
                          ),
                        ),
                        subtitle: Text(
                          subtitleText,
                          style: TextStyle(
                            color:
                                Colors
                                    .grey
                                    .shade700, // Darker grey for readability
                            fontSize: 13,
                          ),
                        ),
                        isThreeLine: true,
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey.shade400,
                          size: 16,
                        ),
                        // You can add an onTap for more details if needed
                        // onTap: () {
                        //   // Navigate to a detail screen or show a dialog
                        // },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
