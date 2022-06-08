// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myboard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImagesAdapter extends TypeAdapter<Images> {
  @override
  final int typeId = 0;

  @override
  Images read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Images(
      imagesource: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Images obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.imagesource);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImagesAdapter &&
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
    return Link(
      url: fields[0] as String?,
      description: fields[1] as String?,
    );
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

class ReminderTaskAdapter extends TypeAdapter<ReminderTask> {
  @override
  final int typeId = 2;

  @override
  ReminderTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderTask(
      title: fields[0] as String?,
      note: fields[1] as String?,
      date: fields[2] as DateTime?,
      startTime: fields[3] as String?,
      endTime: fields[4] as String?,
      reminder: fields[5] as int?,
      repeat: fields[6] as String?,
      isCompleted: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderTask obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.note)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.reminder)
      ..writeByte(6)
      ..write(obj.repeat)
      ..writeByte(7)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ToDoAdapter extends TypeAdapter<ToDo> {
  @override
  final int typeId = 3;

  @override
  ToDo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToDo(
      todo: fields[0] as String?,
      isDone: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ToDo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.todo)
      ..writeByte(1)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToDoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AudioAdapter extends TypeAdapter<Audio> {
  @override
  final int typeId = 4;

  @override
  Audio read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Audio(
      audiosource: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Audio obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.audiosource);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VideoAdapter extends TypeAdapter<Video> {
  @override
  final int typeId = 5;

  @override
  Video read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Video(
      videosource: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Video obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.videosource);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TextAdapter extends TypeAdapter<Text> {
  @override
  final int typeId = 6;

  @override
  Text read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Text(
      text: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Text obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VoiceToTextAdapter extends TypeAdapter<VoiceToText> {
  @override
  final int typeId = 7;

  @override
  VoiceToText read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoiceToText(
      text: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VoiceToText obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceToTextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PinnedWidgetsAdapter extends TypeAdapter<PinnedWidgets> {
  @override
  final int typeId = 8;

  @override
  PinnedWidgets read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PinnedWidgets(
      text: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PinnedWidgets obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PinnedWidgetsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BoardDataAdapter extends TypeAdapter<BoardData> {
  @override
  final int typeId = 10;

  @override
  BoardData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoardData(
      position: fields[0] as int?,
      type: fields[1] as String?,
      data: fields[2] as String?,
      isDone: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, BoardData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.position)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
