// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class Audio extends StatefulWidget {
  const Audio({Key? key}) : super(key: key);

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recorder'),
        backgroundColor: Color.fromARGB(255, 10, 75, 107),
        centerTitle: true,
      ),
      // backgroundColor: Colors.black87,
      body: Center(
        child: starter(),
      ),
    );
    // Widger starter() {}
  }
}

class starter extends StatefulWidget {
  const starter({Key? key}) : super(key: key);

  @override
  State<starter> createState() => _starterState();
}

class _starterState extends State<starter> {
  final recorder = SoundRecorder();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recorder.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    recorder.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_declarations
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? 'STOP' : 'START';
    // final primary = isRecording ? Colors.red : Colors.white;
    // final onprimary = isRecording ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(175, 50),
        // primary: primary,
        // onPrimary: onprimary,
      ),
      onPressed: () async {
        print('1');
        await recorder.toggleRecorder();
        print('2');
        setState(() {});
        print('3');
      },
      icon: Icon(icon),
      label: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

final pathToSaveAudio = 'audioexample.aac';

class SoundRecorder {
  FlutterSoundRecorder? audioRecorder;
  bool isRecorderinit = false;
  bool get isRecording => audioRecorder!.isRecording;

  Future init() async {
    audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone access was denied');
    }

    await audioRecorder!.openAudioSession();
    isRecorderinit = true;
  }

  Future dispose() async {
    if (!isRecorderinit) return;
    audioRecorder!.closeAudioSession();
    audioRecorder = null;
    isRecorderinit = false;
  }

  Future record() async {
    if (!isRecorderinit) return;
    await audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }

  Future stop() async {
    if (!isRecorderinit) return;
    await audioRecorder!.stopRecorder();
  }

  Future toggleRecorder() async {
    if (audioRecorder!.isStopped) {
      await record();
    } else {
      await stop();
    }
  }
}
