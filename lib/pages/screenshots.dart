import 'package:flutter/material.dart';

class Screenshots extends StatefulWidget {
  const Screenshots({Key? key}) : super(key: key);

  @override
  State<Screenshots> createState() => _ScreenshotsState();
}

class _ScreenshotsState extends State<Screenshots> {
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
