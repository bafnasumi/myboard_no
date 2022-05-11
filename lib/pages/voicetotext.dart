import 'package:flutter/material.dart';

class VoiceToText extends StatefulWidget {
  const VoiceToText({Key? key}) : super(key: key);

  @override
  State<VoiceToText> createState() => _VoiceToTextState();
}

class _VoiceToTextState extends State<VoiceToText> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: 30.0,
          child: const Text('homepage')),
    );
  }
}
