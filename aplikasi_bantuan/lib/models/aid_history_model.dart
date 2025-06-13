// Model ini merepresentasikan satu baris data riwayat dari API
class AidHistory {
  final int id;
  final String status;
  final String verifiedAt;
  final String recipientName;
  final String recipientNik;
  final String? remarks;

  AidHistory({
    required this.id,
    required this.status,
    required this.verifiedAt,
    required this.recipientName,
    required this.recipientNik,
    this.remarks,
  });

  // Fungsi untuk membuat objek AidHistory dari data JSON
  factory AidHistory.fromJson(Map<String, dynamic> json) {
    return AidHistory(
      id: json['id'],
      status: json['status'] ?? 'N/A',
      verifiedAt: json['verified_at'] ?? '',
      // Mengambil data dari objek 'recipient' yang bersarang
      recipientName: json['recipient']?['name'] ?? 'Nama Tidak Ditemukan',
      recipientNik: json['recipient']?['nik'] ?? 'NIK Tidak Ditemukan',
      remarks: json['remarks'],
    );
  }
}
