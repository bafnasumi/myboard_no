import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:myboardapp/components/audio_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class Audio extends StatelessWidget {
  const Audio({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
              primary: Colors.white,
              onPrimary: Colors.black,
            ),
          ),
          textTheme: const TextTheme(
            bodyText2: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const MainPage(),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final timerController = TimerController();
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      await recorder.openRecorder();
      isRecorderReady = true;
      recorder.setSubscriptionDuration(
        const Duration(milliseconds: 500),
      );
    }
  }

  Future record() async {
    if (!isRecorderReady) return;
    if (recorder.isPaused) {
      await recorder.resumeRecorder();
    } else {
      await recorder.startRecorder(toFile: 'audio');
    }
    timerController.startTimer();
  }

  Future stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    print('Recorded audio: $audioFile');
    timerController.resetTimer();
  }

  Future pause() async {
    if (!isRecorderReady) return;
    await recorder.pauseRecorder();
    timerController.pauseTimer();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TimerWidget(controller: timerController),
              /*StreamBuilder<RecordingDisposition>(
                stream: recorder.onProgress,
                builder: (context, snapshot) {
                  final duration = snapshot.hasData
                      ? snapshot.data!.duration
                      : Duration.zero;
                  // return Text('${duration.inSeconds} s');
                  String twoDigits(int n) => n.toString().padLeft(2, '0');
                  final twoDigitMinutes =
                      twoDigits(duration.inMinutes.remainder(60));
                  final twoDigitSeconds =
                      twoDigits(duration.inSeconds.remainder(60));
                  return Text(
                    '$twoDigitMinutes:$twoDigitSeconds',
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),*/
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (recorder.isRecording)
                    ElevatedButton(
                      child: const Icon(Icons.stop, size: 80),
                      onPressed: () async {
                        await stop();
                        setState(() {});
                      },
                    ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    child: Icon(
                      recorder.isRecording ? Icons.pause : Icons.mic,
                      size: 80,
                    ),
                    onPressed: () async {
                      if (recorder.isRecording) {
                        await pause();
                      } else {
                        await record();
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}


// // ignore_for_file: prefer_const_constructors, camel_case_types

// import 'package:flutter/material.dart';
// import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:myboardapp/components/audio_widgets.dart';

// class Audio extends StatefulWidget {
//   const Audio({Key? key}) : super(key: key);

//   @override
//   State<Audio> createState() => _AudioState();
// }

// class _AudioState extends State<Audio> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recorder'),
//         backgroundColor: Color.fromARGB(255, 10, 75, 107),
//         centerTitle: true,
//       ),
//       // backgroundColor: Colors.black87,
//       body: Center(
//         child: starter(),
//       ),
//     );
//     // Widger starter() {}
//   }
// }

// class starter extends StatefulWidget {
//   const starter({Key? key}) : super(key: key);

//   @override
//   State<starter> createState() => _starterState();
// }

// class _starterState extends State<starter> {
//   final recorder = SoundRecorder();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     recorder.init();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     recorder.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ignore: prefer_const_declarations
//     final isRecording = recorder.isRecording;
//     final icon = isRecording ? Icons.stop : Icons.mic;
//     final text = isRecording ? 'STOP' : 'START';
//     // final primary = isRecording ? Colors.red : Colors.white;
//     // final onprimary = isRecording ? Colors.white : Colors.black;

//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         minimumSize: Size(175, 50),
//         // primary: primary,
//         // onPrimary: onprimary,
//       ),
//       onPressed: () async {
//         print('1');
//         await recorder.toggleRecorder();
//         print('2');
//         setState(() {});
//         print('3');
//       },
//       icon: Icon(icon),
//       label: Text(
//         text,
//         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }

// final pathToSaveAudio = 'audioexample.aac';

// class SoundRecorder {
//   FlutterSoundRecorder? audioRecorder;
//   bool isRecorderinit = false;
//   bool get isRecording => audioRecorder!.isRecording;

//   Future init() async {
//     audioRecorder = FlutterSoundRecorder();

//     final status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw RecordingPermissionException('Microphone access was denied');
//     }

//     await audioRecorder!.openAudioSession();
//     isRecorderinit = true;
//   }

//   Future dispose() async {
//     if (!isRecorderinit) return;
//     audioRecorder!.closeAudioSession();
//     audioRecorder = null;
//     isRecorderinit = false;
//   }

//   Future record() async {
//     if (!isRecorderinit) return;
//     await audioRecorder!.startRecorder(toFile: pathToSaveAudio);
//   }

//   Future stop() async {
//     if (!isRecorderinit) return;
//     await audioRecorder!.stopRecorder();
//   }

//   Future toggleRecorder() async {
//     if (audioRecorder!.isStopped) {
//       await record();
//     } else {
//       await stop();
//     }
//   }
// }