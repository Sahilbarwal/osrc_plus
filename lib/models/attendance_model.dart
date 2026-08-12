class AttendanceModel {
  final String id;
  final String userId;
  final String name;
  final String siteId;
  final DateTime checkIn;
  final DateTime? checkOut;
  final String? photoUrl;
  final double? latitude;
  final double? longitude;
  final DateTime date;

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.siteId,
    required this.checkIn,
    this.checkOut,
    this.photoUrl,
    this.latitude,
    this.longitude,
    required this.date,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      siteId: map['siteId'] as String,
      checkIn: DateTime.parse(map['checkIn'] as String),
      checkOut: map['checkOut'] == null ? null : DateTime.parse(map['checkOut'] as String),
      photoUrl: map['photoUrl'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      date: DateTime.parse(map['date'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'siteId': siteId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut?.toIso8601String(),
      'photoUrl': photoUrl,
      'latitude': latitude,
      'longitude': longitude,
      'date': date.toIso8601String(),
    };
  }
}
