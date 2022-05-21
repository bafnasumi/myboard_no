import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

// ignore: prefer_typing_uninitialized_variables
var localfile;

Future<PlatformFile> pickVideoFile() async {
  final result = await FilePicker.platform
      .pickFiles(type: FileType.video); //, allowedExtensions: ['mp4', 'mkv']
  localfile = result!.files.single;
  //if (result == null) return null;
  return localfile;
}

Future<File> saveFilePermanently(PlatformFile file) async {
  final appStorage = await getApplicationDocumentsDirectory();
  final newFile = File('${appStorage.path}/${file.name}');

  return File(file.path!).copy(newFile.path);
}
