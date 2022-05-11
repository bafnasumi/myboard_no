import 'package:flutter/material.dart';

class Links extends StatefulWidget {
  const Links({Key? key}) : super(key: key);

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {
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
