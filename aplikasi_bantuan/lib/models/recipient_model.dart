class Recipient {
  final int id;
  final String nik;
  final String name;
  final String address;

  var status;

  var remarks;

  Recipient({
    required this.id,
    required this.nik,
    required this.name,
    required this.address,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      id: json['id'],
      nik: json['nik'],
      name: json['name'],
      address: json['address'],
    );
  }
}
