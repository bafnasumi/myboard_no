// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:myboardapp/boxes.dart';
import 'package:myboardapp/components/audio_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:myboardapp/models/myboard.dart' as db;
import 'package:provider/provider.dart';

import 'homepage.dart';

bool audiopresent = false;

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

  late final audiopath;
  Future stop() async {
    if (!isRecorderReady) return;
    final audiopath = await recorder.stopRecorder();
    var audioFile = File(audiopath!);
    timerController.resetTimer();
  }

  Future pause() async {
    if (!isRecorderReady) return;
    await recorder.pauseRecorder();
    timerController.pauseTimer();
  }

  Future addAudio(String? audioSource) async {
    final localAudioPath = db.Audio()..audiosource = audioSource,
        box = BoxOfAudios.getAudios();
    //ValueNotifier<db.Images?> myiamges = ValueNotifier(localaddImages);
    box.add(localAudioPath);
  }

  //   Future<String> saveAudioPermanently(String? audiosource) async {
  //   //final File file_File = File(file.path);
  //   //final PlatformFile file_PlatformFile = file;
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   final newFile = File('${appStorage.path}/${file.name}');
  //   return File(file.path!).copy(newFile.path);
  // }

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
                        setState(() {
                          audiopresent = true;
                          print('Recorded audio: $audiopath');
                        });
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
                  Row(
                    children: [
                      ElevatedButton(
                        child: Text(
                          'Discard',
                          style: TextStyle(
                              // color: Colors.white,
                              // backgroundcolor: Color.fromARGB(255, 10, 75, 107),
                              ),
                        ),
                        onPressed: () {},
                      ),
                      ElevatedButton(
                        child: Text(
                          'Add',
                          style: TextStyle(
                              // color: Colors.white,
                              // backgroundcolor: Color.fromARGB(255, 10, 75, 107),
                              ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 10, 75, 107),
                        ),
                        onPressed: () {
                          if (audiopresent) {
                            Provider.of<AudioController>(context, listen: false)
                                .addAudio(db.Audio(audiosource: audiopath));
                            final box = BoxOfAudios.getAudios();
                            final audio = box.getAt(box.length - 1);
                            var index = box.length - 1;
                            print(
                                'pinnedwidget index: ${pinnedWidgets.length}');
                            int pinnedWidgetIndex = pinnedWidgets.length;

                            pinnedWidgets.add(
                              StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 1,
                                child: PinnedAudio(audio!.audiosource, index,
                                    pinnedWidgetIndex),
                              ),
                            );
                            Navigator.pushNamed(context, '/homepage');
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );

  PinnedAudio(String? audiosource, int index, int pinnedWidgetIndex) => InkWell(
        child: Container(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(audiosource!),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.volume_up,
                  color: Colors.black,
                  size: 15.0,
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
        ),
        onDoubleTap: () {
          boxofaudio.delete(index);
          pinnedWidgets.removeAt(pinnedWidgetIndex);
        },
      );
}

var boxofaudio = BoxOfAudios.getAudios();

class AudioController extends ChangeNotifier {
  db.Audio? _audio;

  AudioController() {
    _audio = db.Audio(audiosource: 'hardcoded: from constructor');
  }

//getters
  db.Audio? get audio => _audio;

//setters
  void setAudio(db.Audio audio) {
    _audio = audio;
    notifyListeners();
  }

  void addAudio(db.Audio audio) {
    // boxodtodos = BoxOfAudios.getToDos();
    boxofaudio.add(audio);
    notifyListeners();
  }

  void removeAudio(int audiokey) {
    boxofaudio = BoxOfAudios.getAudios();
    boxofaudio.delete(audiokey);
    notifyListeners();
  }

  void emptyAudio() async {
    boxofaudio = BoxOfAudios.getAudios();
    await boxofaudio.clear();
    notifyListeners();
  }
}
