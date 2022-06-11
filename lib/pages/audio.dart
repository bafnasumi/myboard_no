// // // ignore_for_file: prefer_const_constructors
//
// // ignore_for_file: prefer_const_constructors
//
//USING AUDIO_WAVEFORMS
// ignore_for_file: prefer_const_constructors

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myboardapp/boxes.dart';
import 'package:myboardapp/pages/boardState.dart';
import 'package:provider/provider.dart';

import '../models/myboard.dart' as m;
import 'package:flutter/material.dart';

class MyAudio extends StatefulWidget {
  const MyAudio({Key? key}) : super(key: key);

  @override
  State<MyAudio> createState() => _MyAudioState();
}

class _MyAudioState extends State<MyAudio> {
  late final RecorderController recorderController;
  late final PlayerController playerController;
  var path;
  bool _isRecorded = false;
  bool _isRecordPause = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    recorderController = RecorderController();
    playerController = PlayerController();
  }

  @override
  void dispose() {
    recorderController.disposeFunc();
    super.dispose();
    playerController.disposeFunc();
  }

  @override
  Widget build(BuildContext context) {
    var mysnackbar = SnackBar(content: Text('Already recording'));

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Audio',
            style: GoogleFonts.italiana(
              color: Colors.black87,
              fontSize: MediaQuery.of(context).size.height * 0.05,
            ),
          ),
          // child: Row(
          //   children: [
          //     // IconButton(
          //     //   icon: Icon(Icons.arrow_back_outlined),
          //     //   color: Colors.black,
          //     //   onPressed: () {
          //     //     Navigator.pop(context);
          //     //   },
          //     //   iconSize: 40.0,
          //     // ),
          //     // SizedBox(
          //     //   height: 10.0,
          //     // ),
          //     Text(
          //       'Text',
          //       style: GoogleFonts.italiana(
          //         color: Colors.black87,
          //         fontSize: screenHeight() * 0.05,
          //       ),
          //     ),
          //   ],
          // ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: AudioWaveforms(
                size: Size(MediaQuery.of(context).size.width, 200.0),
                recorderController: recorderController,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  disabledColor: Colors.grey,
                  onPressed: !_isRecorded
                      ? () async {
                          !_isRecording
                              ? await recorderController.record()
                              : ScaffoldMessenger.of(context)
                                  .showSnackBar(mysnackbar);
                          setState(
                            () {
                              _isRecording = true;
                            },
                          );
                        }
                      : null,
                  icon: Icon(
                    Icons.mic,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // IconButton(
                //   onPressed: () async {
                //     // _isRecordPause?
                //     await recorderController.pause();
                //     _isRecordPause = true;
                //   },
                //   icon: Icon(
                //     _isRecordPause ? Icons.play_arrow : Icons.pause,
                //   ),
                // ),
                _isRecording
                    ? IconButton(
                        disabledColor: Colors.grey,
                        onPressed: !_isRecorded
                            ? () async {
                                path = await recorderController.stop();
                                await playerController.preparePlayer(path);

                                var boxofboarddata =
                                    BoxOfBoardData.getBoardData();
                                boxofboarddata.add(
                                  m.BoardData(
                                    data: path,
                                    position: boxofboarddata.length,
                                    type: 'audio',
                                  ),
                                );

                                setState(() {
                                  _isRecorded = true;
                                  _isRecording = false;
                                });
                              }
                            : null,
                        icon: Icon(
                          Icons.stop,
                          color: Colors.red,
                        ),
                      )
                    : Container(),
              ],
            ),
            _isRecorded
                ? Column(
                    children: [
                      // IconButton(
                      //   onPressed: () async {
                      //     await playerController.preparePlayer(path);
                      //   },
                      //   icon: Icon(
                      //     Icons.color_lens,
                      //   ),
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: AudioFileWaveforms(
                          size: Size(
                            MediaQuery.of(context).size.width * 0.7,
                            100.0,
                          ),
                          playerController: playerController,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await playerController.startPlayer();
                        },
                        icon: Icon(Icons.play_arrow),
                      ),
                      IconButton(
                        onPressed: () async {
                          await playerController.stopPlayer();
                          setState(() {
                            _isRecorded = false;
                            _isRecording = false;
                          });
                        },
                        icon: Icon(Icons.stop),
                      ),
                    ],
                  )
                : SizedBox(
                    width: 1,
                  ),
          ],
        ),
      ),
    ));
  }
}

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// // import 'dart:io';
//
// // import 'package:audio_waveforms/audio_waveforms.dart';
// // import 'package:audioplayers/audioplayers.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
// // import 'package:get/get.dart';
// // import 'package:get/get_core/src/get_main.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:provider/provider.dart';
//
// // import '../models/myboard.dart' as m;
// // import 'boardState.dart';
//
// // class myAudio extends StatefulWidget {
// //   const myAudio({Key? key}) : super(key: key);
//
// //   @override
// //   State<myAudio> createState() => _myAudioState();
// // }
//
// // class _myAudioState extends State<myAudio> {
// //   @override
// //   void initState() {
// //     super.initState();
// //   }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         appBar: AppBar(
// //           iconTheme: IconThemeData(color: Colors.black),
// //           toolbarHeight: 80.0,
// //           backgroundColor: Colors.white,
// //           centerTitle: true,
// //           title: Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Text(
// //               'Text',
// //               style: GoogleFonts.italiana(
// //                 color: Colors.black87,
// //                 fontSize: MediaQuery.of(context).size.height * 0.05,
// //               ),
// //             ),
// //           ),
// //         ),
// //         backgroundColor: Colors.white,
// //         body: FeatureButtonsView(),
// //       ),
// //     );
// //   }
// // }
//
// // class FeatureButtonsView extends StatefulWidget {
// //   // final Function onUploadComplete;
// //   const FeatureButtonsView({
// //     Key? key,
// //     // required this.onUploadComplete,
// //   }) : super(key: key);
// //   @override
// //   _FeatureButtonsViewState createState() => _FeatureButtonsViewState();
// // }
//
// // class _FeatureButtonsViewState extends State<FeatureButtonsView> {
// //   late bool _isPlaying;
// //   // late bool _isUploading;
// //   late bool _isRecorded;
// //   late bool _isRecording;
//
// //   late AudioPlayer _audioPlayer;
// //   late String _filePath;
//
// //   late FlutterAudioRecorder2 _audioRecorder;
// //   late final RecorderController recorderController;
//
// //   @override
// //   void initState() {
// //     super.initState();
// //     _isPlaying = false;
// //     // _isUploading = false;
// //     _isRecorded = false;
// //     _isRecording = false;
// //     _audioPlayer = AudioPlayer();
// //     recorderController = RecorderController();
// //   }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: _isRecorded
// //           // ? _isUploading
// //           // ? Column(
// //           //     mainAxisAlignment: MainAxisAlignment.center,
// //           //     crossAxisAlignment: CrossAxisAlignment.center,
// //           //     children: [
// //           //       Padding(
// //           //           padding: const EdgeInsets.symmetric(horizontal: 20),
// //           //           child: LinearProgressIndicator()),
// //           //       Text('Uplaoding to Firebase'),
// //           //     ],
// //           //   )
// //           ? Material(
// //               child: Column(
// //                 children: [
// //                   AudioWaveforms(
// //                     size: Size(MediaQuery.of(context).size.width, 200.0),
// //                     recorderController: recorderController,
// //                   ),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       IconButton(
// //                         icon: Icon(
// //                           Icons.replay,
// //                           color: Colors.blue,
// //                           size: 40,
// //                         ),
// //                         // onPressed: _onRecordAgainButtonPressed,
// //                         onPressed: () async {
// //                           await recorderController.record();
// //                         },
// //                       ),
// //                       IconButton(
// //                         icon: Icon(
// //                           _isPlaying ? Icons.pause : Icons.play_arrow,
// //                           size: 40,
// //                           color: Colors.blue,
// //                         ),
// //                         // onPressed: _onPlayButtonPressed,
// //                         onPressed: () {
// //                           // await recorderController.record();
// //                         },
// //                       ),
// //                       // IconButton(
// //                       //   icon: Icon(Icons.upload_file),
// //                       //   onPressed: _onFileUploadButtonPressed,
// //                       // ),
// //                       TextButton(
// //                         style: ButtonStyle(
// //                           backgroundColor:
// //                               MaterialStateProperty.all(Colors.blue),
// //                         ),
// //                         child: Text(
// //                           'Pin the audio',
// //                           style: TextStyle(color: Colors.white),
// //                         ),
// //                         onPressed: () {
// //                           if (!_isRecorded) {
// //                             Provider.of<BoardStateController>(context,
// //                                     listen: false)
// //                                 .addBoardData(m.BoardData(
// //                               type: 'audio',
// //                               data: filePath,
// //                             ));
// //                             // Provider.of<>(context, listen: false)
// //                             //     .addBoardData(m.BoardData(
// //                             //   type: 'audio',
// //                             //   data: filePath,
// //                             // ));
//
// //                           } else {
// //                             Get.snackbar('Oops', 'Record the audio please',
// //                                 icon: const Icon(
// //                                   Icons.warning_amber_rounded,
// //                                   color: Colors.white,
// //                                 ),
// //                                 shouldIconPulse: true,
// //                                 colorText: Colors.white,
// //                                 backgroundColor: Colors.grey,
// //                                 snackPosition: SnackPosition.TOP);
// //                           }
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             )
// //           : Material(
// //               child: Container(
// //                 child: IconButton(
// //                   icon: _isRecording
// //                       ? Icon(
// //                           Icons.pause,
// //                           size: 40,
// //                           color: Colors.blue,
// //                         )
// //                       : Icon(
// //                           Icons.fiber_manual_record,
// //                           size: 40,
// //                           color: Colors.blue,
// //                         ),
// //                   // onPressed: _onRecordButtonPressed,
// //                   onPressed: () async {
// //                     await recorderController.record();
// //                   },
// //                 ),
// //               ),
// //             ),
// //     );
// //   }
//
// //   // Future<void> _onFileUploadButtonPressed() async {
// //   //   FirebaseStorage firebaseStorage = FirebaseStorage.instance;
// //   //   setState(() {
// //   //     // _isUploading = true;
// //   //   });
// //   //   try {
// //   //     await firebaseStorage
// //   //         .ref('upload-voice-firebase')
// //   //         .child(
// //   //             _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length))
// //   //         .putFile(File(_filePath));
// //   //     // widget.onUploadComplete();
// //   //   } catch (error) {
// //   //     print('Error occured while uplaoding to Firebase ${error.toString()}');
// //   //     ScaffoldMessenger.of(context).showSnackBar(
// //   //       SnackBar(
// //   //         content: Text('Error occured while uplaoding'),
// //   //       ),
// //   //     );
// //   //   } finally {
// //   //     setState(() {
// //   //       // _isUploading = false;
// //   //     });
// //   //   }
// //   // }
//
// //   void _onRecordAgainButtonPressed() {
// //     setState(() {
// //       _isRecorded = false;
// //     });
// //   }
//
// //   Future<void> _onRecordButtonPressed() async {
// //     if (_isRecording) {
// //       _audioRecorder.stop();
// //       _isRecording = false;
// //       _isRecorded = true;
// //     } else {
// //       _isRecorded = false;
// //       _isRecording = true;
//
// //       await _startRecording();
// //     }
// //     setState(() {});
// //   }
//
// //   void _onPlayButtonPressed() {
// //     if (!_isPlaying) {
// //       _isPlaying = true;
//
// //       _audioPlayer.play(_filePath, isLocal: true);
// //       _audioPlayer.onPlayerCompletion.listen((duration) {
// //         setState(() {
// //           _isPlaying = false;
// //         });
// //       });
// //     } else {
// //       _audioPlayer.pause();
// //       _isPlaying = false;
// //     }
// //     setState(() {});
// //   }
//
// //   Future<void> _startRecording() async {
// //     final bool? hasRecordingPermission =
// //         await FlutterAudioRecorder2.hasPermissions;
//
// //     if (hasRecordingPermission ?? false) {
// //       await recorderController.record();
//
// //       Directory directory = await getApplicationDocumentsDirectory();
// //       String filepath = directory.path +
// //           '/' +
// //           DateTime.now().millisecondsSinceEpoch.toString() +
// //           '.aac';
// //       _audioRecorder =
// //           FlutterAudioRecorder2(filepath, audioFormat: AudioFormat.AAC);
// //       await _audioRecorder.initialized;
// //       _audioRecorder.start();
// //       _filePath = filepath;
// //       setState(() {});
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Center(
// //             child: Text(
// //               'Please enable recording permission',
// //             ),
// //           ),
// //         ),
// //       );
// //     }
// //   }
// // }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// // // import 'dart:io';
//
// // // import 'package:audioplayers/audioplayers.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
// // // import 'package:myboardapp/models/myboard.dart' as m;
// // // import 'package:myboardapp/pages/boardState.dart';
// // // import 'package:path_provider/path_provider.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:get/get.dart';
//
// // // class FeatureButtonsView extends StatefulWidget {
// // //   const FeatureButtonsView({Key? key}) : super(key: key);
// // //   @override
// // //   _FeatureButtonsViewState createState() => _FeatureButtonsViewState();
// // // }
//
// // // class _FeatureButtonsViewState extends State<FeatureButtonsView> {
// // //   late bool _isPlaying;
// // //   late bool _isRecorded;
// // //   late bool _isRecording;
//
// // //   late AudioPlayer _audioPlayer;
// // //   String? filePath;
//
// // //   late FlutterAudioRecorder2 _audioRecorder;
//
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _isPlaying = false;
// // //     _isRecorded = false;
// // //     _isRecording = false;
// // //     _audioPlayer = AudioPlayer();
// // //   }
//
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: Center(
// // //           child:
// // //               //  _isRecorded
// // //               // ? _isUploading
// // //               // ? Column(
// // //               //     mainAxisAlignment: MainAxisAlignment.center,
// // //               //     crossAxisAlignment: CrossAxisAlignment.center,
// // //               //     // ignore: prefer_const_literals_to_create_immutables
// // //               //     children: [
// // //               //       const Padding(
// // //               //           padding: EdgeInsets.symmetric(horizontal: 20),
// // //               //           child: LinearProgressIndicator()),
// // //               //       const Text('Uplaoding to Firebase'),
// // //               //     ],
// // //               //   )
// // //               // ?
// // //               Column(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         crossAxisAlignment: CrossAxisAlignment.center,
// // //         children: [
// // //           IconButton(
// // //             icon: const Icon(Icons.replay),
// // //             onPressed: _onRecordAgainButtonPressed,
// // //             iconSize: 40,
// // //           ),
// // //           IconButton(
// // //             icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
// // //             iconSize: 40,
// // //             onPressed: _onPlayButtonPressed,
// // //           ),
// // //           TextButton(
// // //             style: ButtonStyle(
// // //               backgroundColor: MaterialStateProperty.all(Colors.blue),
// // //             ),
// // //             child: Text(
// // //               'Pin the audio',
// // //               style: TextStyle(color: Colors.white),
// // //             ),
// // //             onPressed: () {
// // //               if (!_isRecorded) {
// // //                 Provider.of<BoardStateController>(context, listen: false)
// // //                     .addBoardData(m.BoardData(
// // //                   type: 'audio',
// // //                   data: filePath,
// // //                 ));
// // //                 // Provider.of<>(context, listen: false)
// // //                 //     .addBoardData(m.BoardData(
// // //                 //   type: 'audio',
// // //                 //   data: filePath,
// // //                 // ));
//
// // //               } else {
// // //                 Get.snackbar('Oops', 'Record the audio please',
// // //                     icon: const Icon(
// // //                       Icons.warning_amber_rounded,
// // //                       color: Colors.white,
// // //                     ),
// // //                     shouldIconPulse: true,
// // //                     colorText: Colors.white,
// // //                     backgroundColor: Colors.grey,
// // //                     snackPosition: SnackPosition.TOP);
// // //               }
// // //             },
// // //           ),
// // //         ],
// // //       )
// // //           // : IconButton(
// // //           //     icon: _isRecording
// // //           //         ? const Icon(Icons.pause)
// // //           //         : const Icon(Icons.fiber_manual_record),
// // //           //     onPressed: _onRecordButtonPressed,
// // //           //   ),
// // //           ),
// // //     );
// // //   }
//
// // //   void _onRecordAgainButtonPressed() {
// // //     setState(() {
// // //       _isRecorded = false;
// // //     });
// // //   }
//
// // //   Future<void> _onRecordButtonPressed() async {
// // //     if (_isRecording) {
// // //       _audioRecorder.stop();
// // //       _isRecording = false;
// // //       _isRecorded = true;
// // //     } else {
// // //       _isRecorded = false;
// // //       _isRecording = true;
//
// // //       await _startRecording();
// // //     }
// // //     setState(() {});
// // //   }
//
// // //   void _onPlayButtonPressed() {
// // //     if (!_isPlaying) {
// // //       _isPlaying = true;
//
// // //       _audioPlayer.play(filePath!, isLocal: true);
// // //       _audioPlayer.onPlayerCompletion.listen((duration) {
// // //         setState(() {
// // //           _isPlaying = false;
// // //         });
// // //       });
// // //     } else {
// // //       _audioPlayer.pause();
// // //       _isPlaying = false;
// // //     }
// // //     setState(() {});
// // //   }
//
// // //   Future<void> _startRecording() async {
// // //     final bool? hasRecordingPermission =
// // //         await FlutterAudioRecorder2.hasPermissions;
//
// // //     if (hasRecordingPermission ?? false) {
// // //       Directory directory = await getApplicationDocumentsDirectory();
// // //       filePath = directory.path +
// // //           '/' +
// // //           DateTime.now().millisecondsSinceEpoch.toString() +
// // //           '.aac';
// // //       _audioRecorder =
// // //           FlutterAudioRecorder2(filePath!, audioFormat: AudioFormat.AAC);
// // //       await _audioRecorder.initialized;
// // //       _audioRecorder.start();
// // //       setState(() {
// // //         filePath = filePath;
// // //       });
// // //     } else {
// // //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
// // //           content:
// // //               const Center(child: Text('Please enable recording permission'))));
// // //     }
// // //   }
// // // }
