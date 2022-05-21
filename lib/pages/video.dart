// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class Video extends StatefulWidget {
  const Video({Key? key}) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController controller;
  //final File file = File('/data/user/0/com.example.myboardapp/app_flutter/screen-20220516-145624.mp4');
  late final File localfile;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(localfile)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((_) => controller.play());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = controller.value.volume == 0;
    if (controller.value.isInitialized) {
      return SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () => controller.value.isPlaying
                ? controller.pause()
                : controller.play(),
            child: Stack(
              children: [
                VideoPlayerWidget(controller: controller),
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      isMuted ? Icons.volume_mute : Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: () => controller.setVolume(isMuted ? 1 : 0),
                  ),
                ),
                controller.value.isPlaying
                    ? Container()
                    : Container(
                        alignment: Alignment.center,
                        color: Colors.black26,
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                BasicOverlayWidget(
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Text('Media not initialized'),
      );
    }
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;
  const VideoPlayerWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) => controller.value.isInitialized
      ? Container(
          alignment: Alignment.topCenter,
          child: buildVideo(),
        )
      // ignore: sized_box_for_whitespace
      : Container(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );

  Widget buildVideo() => AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller));

  Future<File> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
    );
    var localfile = result!.files.single;
    //if (result == null) return null;
    return File(localfile.path.toString());
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }

  // Future<File> selectVideo() async {
  //   final result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowMultiple: false,
  //       allowedExtensions: ['mp4', 'mkv', 'heic']);
  //   final oneFile = result?.files.first;

  //   final legitfile = File(oneFile!.path.toString());
  //   print(oneFile.name);
  //   print(oneFile.extension);
  //   print(oneFile.path);
  //   print(oneFile.size);
  //   //Navigator.pushNamed(context, '/memories');
  //   // ImageProvider gotFile = Get.arguments();
  //   //File finalImage = await saveFilePermanently(oneFile);
  //   print('from ' + oneFile.path.toString());
  //   //print('to ' + finalImage.path);
  //   return legitfile;
  // }
}

class BasicOverlayWidget extends StatelessWidget {
  final VideoPlayerController controller;
  const BasicOverlayWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: VideoProgressIndicator(
        controller,
        allowScrubbing: true,
      ));
}
