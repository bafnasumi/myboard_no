// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class Screenshots extends StatefulWidget {
  const Screenshots({Key? key}) : super(key: key);

  @override
  State<Screenshots> createState() => _ScreenshotsState();
}

class _ScreenshotsState extends State<Screenshots> {
  final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Column(
          children: [
            MyContainer(),
            TextButton(
              onPressed: (() async {
                final ss = await controller.captureFromWidget(
                  MyContainer(),
                );
                await saveImage(ss);
              }),
              child: Text('take ss'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();

    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);

    return result['filepath'];
  }

  Widget MyContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.73,
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 3.0,
            blurStyle: BlurStyle.outer,
            color: Colors.black54,
          )
        ],
        borderRadius: BorderRadius.circular(25.0),
        image: const DecorationImage(
          image: NetworkImage(
              'https://media.istockphoto.com/photos/blue-velvet-picture-id174897941?k=20&m=174897941&s=612x612&w=0&h=earrO_3wBH7HIFScdG5hpUvOUVb35CjrO8McEkHi9x4='),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
