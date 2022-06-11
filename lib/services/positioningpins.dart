import 'package:flutter/material.dart';
// import 'package:myboardapp/pages/boardeditpage.dart';

class PositioningPinsClass {
  late double _height;
  late double _width;
  dynamic _vacant_area;
  PositioningPins(double _height, double _width) {
    this._height = _height;
    this._width = _width;
  }

  Function Area(double h, double w) {
    _vacant_area = _height * _width;
    return _vacant_area;
  }
}

class PositioningPins extends StatefulWidget {
  const PositioningPins({Key? key}) : super(key: key);

  @override
  State<PositioningPins> createState() => _PositioningPinsState();
}

class _PositioningPinsState extends State<PositioningPins> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
