// ignore_for_file: prefer_const_constructors

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileFormatDropdown extends StatelessWidget {
  final FileType fileType;
  final ValueChanged<FileType> onChanged;

  const FileFormatDropdown({
    Key? key,
    required this.fileType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => DropdownButton<FileType>(
        icon: Icon(Icons.extension),
        style: TextStyle(fontSize: 24, color: Colors.black),
        value: fileType,
        onChanged: (value) {
          if (value == null) return;

          onChanged(value);
        },
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          DropdownMenuItem(
            child: Text('All Files'),
            value: FileType.any,
          ),
          DropdownMenuItem(
            child: Text('Media Files'),
            value: FileType.media,
          ),
          DropdownMenuItem(
            child: Text('Image Files'),
            value: FileType.image,
          ),
          DropdownMenuItem(
            child: Text('Video Files'),
            value: FileType.video,
          ),
          DropdownMenuItem(
            child: Text('Audio Files'),
            value: FileType.audio,
          ),
        ],
      );
}
