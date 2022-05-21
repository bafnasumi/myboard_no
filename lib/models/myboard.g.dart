// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myboard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class imagesAdapter extends TypeAdapter<images> {
  @override
  final int typeId = 0;

  @override
  images read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return images()
      ..imagesource = fields[0] as Image
      ..height = fields[1] as double
      ..width = fields[2] as double;
  }

  @override
  void write(BinaryWriter writer, images obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.imagesource)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.width);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is imagesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LinkAdapter extends TypeAdapter<Link> {
  @override
  final int typeId = 1;

  @override
  Link read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Link()
      ..url = fields[0] as String
      ..description = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, Link obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
