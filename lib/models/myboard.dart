import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'myboard.g.dart';

@HiveType(typeId: 0)
class images extends HiveObject {
  @HiveField(0)
  late Image imagesource;
  @HiveField(1)
  late double height;
  @HiveField(2)
  late double width;
}

@HiveType(typeId: 1)
class Link extends HiveObject {
  @HiveField(0)
  late String url;
  @HiveField(1)
  late String description;
}
