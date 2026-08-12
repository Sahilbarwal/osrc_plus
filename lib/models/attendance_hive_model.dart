import 'package:hive/hive.dart';

part 'attendance_hive_model.g.dart';

/// Hive model for storing attendance records locally.
/// 
/// This model is optimized for Hive local storage with simple,
/// serializable fields. Use this for offline persistence of attendance data.
@HiveType(typeId: 1)
class AttendanceHiveModel extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String date; // Format: yyyy-MM-dd

  @HiveField(2)
  late String time; // Format: HH:mm

  @HiveField(3)
  late String imagePath; // Local file path to stored image

  AttendanceHiveModel({
    required this.name,
    required this.date,
    required this.time,
    required this.imagePath,
  });

  /// Convert model to JSON-compatible Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'time': time,
      'imagePath': imagePath,
    };
  }

  /// Create model from JSON-compatible Map
  factory AttendanceHiveModel.fromMap(Map<String, dynamic> map) {
    return AttendanceHiveModel(
      name: map['name'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      imagePath: map['imagePath'] as String,
    );
  }

  /// Create a copy with modified fields
  AttendanceHiveModel copyWith({
    String? name,
    String? date,
    String? time,
    String? imagePath,
  }) {
    return AttendanceHiveModel(
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() => 'AttendanceHiveModel(name: $name, date: $date, time: $time, imagePath: $imagePath)';
}
