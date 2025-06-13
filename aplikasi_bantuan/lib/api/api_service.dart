// lib/api/api_service.dart

import 'package:http/http.dart' as http;

class ApiService {
  // PENTING: Ganti dengan IP Address komputer Anda
  static const String _baseUrl = 'https://bantuan-api.my.id/api';

  // Fungsi login
  static Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    return await http.post(url, body: {'email': email, 'password': password});
  }

  // Fungsi untuk mencari penerima berdasarkan NIK
  static Future<http.Response> findRecipientByNik(
    String nik,
    String token,
  ) async {
    final url = Uri.parse('$_baseUrl/recipients/verify/$nik');
    return await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  // Fungsi untuk mendapatkan riwayat verifikasi
  static Future<http.Response> getHistory(String token) async {
    final url = Uri.parse('$_baseUrl/verifications/history');
    return await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  // Fungsi submit verifikasi (diperbarui dengan status dan remarks)
  static Future<http.Response> submitVerification(
    int recipientId,
    String token,
    String status, { // <-- Parameter baru
    String? remarks, // <-- Parameter opsional baru
  }) async {
    final url = Uri.parse('$_baseUrl/verifications');

    // Siapkan body request
    final body = {'recipient_id': recipientId.toString(), 'status': status};

    // Tambahkan remarks jika ada
    if (remarks != null && remarks.isNotEmpty) {
      body['remarks'] = remarks;
    }

    return await http.post(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: body,
    );
  }
}
