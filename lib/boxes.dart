import 'package:hive/hive.dart';
// import 'package:url_launcher/link.dart';
import 'models/myboard.dart';

class BoxOfLinks {
  static Box<Link> getLinks() => Hive.box<Link>('links');
}

class BoxofImage {
  static Box<Images> getImages() => Hive.box<Images>('images');
}

class BoxOfToDos {
  static Box<ToDo> getToDos() => Hive.box<ToDo>('todo');
}

class BoxOfAudios {
  static Box<Audio> getAudios() => Hive.box<Audio>('audio');
}

