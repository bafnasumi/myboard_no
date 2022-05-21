import 'package:hive/hive.dart';
// import 'package:url_launcher/link.dart';
import 'models/myboard.dart';

class Boxes {
  static Box<Link> getLinks() => Hive.box<Link>('links');
}

class BoxesofImage {
  static Box<Images> getImages() => Hive.box<Images>('images');
}
