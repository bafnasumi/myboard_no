import 'package:hive/hive.dart';
// import 'package:url_launcher/link.dart';
import 'models/myboard.dart';

class BoxesOfLinks {
  static Box<Link> getLinks() => Hive.box<Link>('links');
}

class BoxesofImage {
  static Box<Images> getImages() => Hive.box<Images>('images');
}

class BoxOfToDos {
  static Box<ToDo> getToDos() => Hive.box<ToDo>('todo');
}
