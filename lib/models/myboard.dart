import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'myboard.g.dart';

@HiveType(typeId: 0)
class Images extends HiveObject with ChangeNotifier {
  @HiveField(0)
  late String? imagesource;
  Images({this.imagesource});
}

@HiveType(typeId: 1)
class Link extends HiveObject {
  @HiveField(0)
  late String? url;
  @HiveField(1)
  late String? description;
  Link({this.url, this.description});
}

@HiveType(typeId: 2)
class ReminderTask extends HiveObject with ChangeNotifier {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? note;
  @HiveField(3)
  String? date;
  @HiveField(4)
  String? startTime;
  @HiveField(5)
  String? endTime;
  @HiveField(6)
  int? reminder;
  @HiveField(7)
  String? repeat;
  @HiveField(8)
  int? isCompleted;
  @HiveField(9)
  String? color;

  ReminderTask({
    this.id,
    this.title,
    this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.reminder,
    this.repeat,
    this.isCompleted,
    this.color,
  });

  ReminderTask.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        note = json['note'],
        date = json['date'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        reminder = json['reminder'],
        repeat = json['repeat'],
        color = json['color'],
        isCompleted = json['isCompleted'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['note'] = note;
    data['date'] = date;
    data['color'] = color;
    data['isCompleted'] = isCompleted;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['reminder'] = reminder;
    data['repeat'] = repeat;
    return data;
  }
}

@HiveType(typeId: 3)
class ToDo extends HiveObject with ChangeNotifier {
  @HiveField(0)
  late String? todo;
  @HiveField(1)
  late bool isDone;

  ToDo({this.todo, this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }
}

@HiveType(typeId: 4)
class Audio extends HiveObject with ChangeNotifier {
  @HiveField(0)
  late String? audiosource;

  Audio({this.audiosource});
}

@HiveType(typeId: 5)
class Video extends HiveObject with ChangeNotifier {
  @HiveField(0)
  late String? videosource;

  Video({this.videosource});
}

@HiveType(typeId: 6)
class Text extends HiveObject with ChangeNotifier {
  @HiveField(0)
  late String? text;

  Text({this.text});
}

@HiveType(typeId: 7)
class VoiceToText extends HiveObject with ChangeNotifier {
  @HiveField(0)
  late String? text;

  VoiceToText({this.text});
}
