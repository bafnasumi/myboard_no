import 'package:flutter/material.dart';

class ScreenTime extends StatefulWidget {
  const ScreenTime({Key? key}) : super(key: key);

  @override
  State<ScreenTime> createState() => _ScreenTimeState();
}

class _ScreenTimeState extends State<ScreenTime> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Screen Time'),
    );
  }
}
