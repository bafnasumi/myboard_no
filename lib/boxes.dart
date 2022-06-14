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

class BoxOfVideos {
  static Box<Video> getVideos() => Hive.box<Video>('video');
}

class BoxOfReminders {
  static Box<ReminderTask> getReminders() => Hive.box<ReminderTask>('reminder');
}

class BoxOfVoiceToText {
  static Box<VoiceToText> getVoiceToText() =>
      Hive.box<VoiceToText>('voicetotext');
}

class BoxOfText {
  static Box<Text> getText() => Hive.box<Text>('text');
}

class BoxOfBoardData {
  static Box<BoardData> getBoardData() => Hive.box<BoardData>('boarddata');
}

class BoxOfBackgroundImage {
  static Box<BackgroundImage> getBgImage() =>
      Hive.box<BackgroundImage>('backgroundimage');
}

class BoxOfDocuments {
  static Box<Documents> getDocuments() => Hive.box<Documents>('document');
}
