// import 'dart:async';

// import 'api/sound_recorder.dart';
// import 'widget/timer_widget.dart';
// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// // Future main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await SystemChrome.setPreferredOrientations([
// //     DeviceOrientation.portraitUp,
// //     DeviceOrientation.portraitDown,
// //   ]);

// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   static final String title = 'Audio Recorder';

// //   @override
// //   Widget build(BuildContext context) => MaterialApp(
// //         debugShowCheckedModeBanner: false,
// //         title: title,
// //         theme: ThemeData(primarySwatch: Colors.red),
// //         home: NewAudio(),
// //       );
// // }

// class NewAudio extends StatefulWidget {
//   @override
//   _NewAudioState createState() => _NewAudioState();
// }

// class _NewAudioState extends State<NewAudio> {
//   final timerController = TimerController();
//   final recorder = SoundRecorder();

//   @override
//   void initState() {
//     super.initState();

//     recorder.init();
//   }

//   @override
//   void dispose() {
//     recorder.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         // appBar: AppBar(
//         //   title: Text(MyApp.title),
//         //   centerTitle: true,
//         // ),
//         backgroundColor: Colors.black87,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               buildPlayer(),
//               SizedBox(height: 16),
//               buildStart(),
//             ],
//           ),
//         ),
//       );

//   Widget buildStart() {
//     final isRecording = recorder.isRecording;
//     final icon = isRecording ? Icons.stop : Icons.mic;
//     final text = isRecording ? 'STOP' : 'START';
//     final primary = isRecording ? Colors.red : Colors.white;
//     final onPrimary = isRecording ? Colors.white : Colors.black;

//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         minimumSize: Size(175, 50),
//         primary: primary,
//         onPrimary: onPrimary,
//       ),
//       icon: Icon(icon),
//       label: Text(
//         text,
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//       onPressed: () async {
//         await recorder.toggleRecording();
//         final isRecording = recorder.isRecording;
//         setState(() {});

//         if (isRecording) {
//           timerController.startTimer();
//         } else {
//           timerController.stopTimer();
//         }
//       },
//     );
//   }

//   Widget buildPlayer() {
//     final text = recorder.isRecording ? 'Now Recording' : 'Press Start';
//     final animate = recorder.isRecording;

//     return AvatarGlow(
//       endRadius: 140,
//       animate: animate,
//       repeatPauseDuration: Duration(milliseconds: 100),
//       child: CircleAvatar(
//         radius: 100,
//         backgroundColor: Colors.white,
//         child: CircleAvatar(
//           radius: 92,
//           backgroundColor: Colors.indigo.shade900.withBlue(70),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.mic, size: 32),
//               TimerWidget(controller: timerController),
//               SizedBox(height: 8),
//               Text(text),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }