import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'myboard.g.dart';

@HiveType(typeId: 0)
class Images extends HiveObject {
  @HiveField(0)
  late Uint8List imagesource;
  @HiveField(1)
  late double height;
  @HiveField(2)
  late double width;
}

@HiveType(typeId: 1)
class Link extends HiveObject {
  @HiveField(0)
  late String? url;
  @HiveField(1)
  late String? description;
  Link({this.url, this.description});
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
