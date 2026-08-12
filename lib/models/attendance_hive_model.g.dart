// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceHiveModelAdapter extends TypeAdapter<AttendanceHiveModel> {
  @override
  final int typeId = 1;

  @override
  AttendanceHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceHiveModel(
      name: fields[0] as String,
      date: fields[1] as String,
      time: fields[2] as String,
      imagePath: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
