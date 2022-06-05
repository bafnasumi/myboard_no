// ignore_for_file: prefer_const_constructors, avoid_returning_null_for_void, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

var imglink = '';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 199, 149, 0),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 75, 107),
        title: Text(
          'Choose your background',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GridSpace(
                  link1:
                      'https://images.unsplash.com/photo-1579455223806-1ae87b23a1fb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2069&q=80',
                  link2:
                      'https://images.unsplash.com/photo-1554755229-ca4470e07232?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHZlbHZldHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                ), //Row
                GridSpace(
                  link1:
                      'https://images.unsplash.com/photo-1566305977571-5666677c6e98?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NjN8fHZlbHZldHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                  link2:
                      'https://images.unsplash.com/photo-1528459105426-b9548367069b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=964&q=80',
                ), //Row
                GridSpace(
                  link1:
                      'https://images.unsplash.com/photo-1599209248101-b9d05030d61a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
                  link2:
                      'https://images.unsplash.com/photo-1629197519111-8fa7a9b62df0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1503&q=80',
                ),
                GridSpace(
                  link1:
                      'https://images.unsplash.com/photo-1633771815090-1edf03424d49?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1007&q=80',
                  link2:
                      'https://images.unsplash.com/photo-1528459061998-56fd57ad86e3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8dGV4dHVyZSUyMHZlbHZldHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                ),

                GridSpace(
                  link1:
                      'https://images.unsplash.com/photo-1495578942200-c5f5d2137def?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8d2FsbHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                  link2:
                      'https://images.unsplash.com/photo-1611007725135-21ca8d0d5357?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTU5fHx2ZWx2ZXR8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                ),
                GridSpace(
                  link1:
                      'https://images.unsplash.com/photo-1571292098320-997aa03a5d19?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzN8fHdhbGx8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                  link2:
                      'https://images.unsplash.com/photo-1536566482680-fca31930a0bd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NzV8fHdhbGx8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GridBox extends StatefulWidget {
  String link;

  GridBox({this.link = ''});

  @override
  State<GridBox> createState() => _GridBoxState();
}

class _GridBoxState extends State<GridBox> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(
        height: 175,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: Colors.blueGrey,
        ), //BoxDecoration
        child: GestureDetector(
          onTap: () {
            imglink = widget.link;
            Navigator.pushNamed(context, '/homepage');

            // print(imglink);
            // imglink = '';
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                    widget.link,
                  ),
                  fit: BoxFit.cover),
              boxShadow: [
                BoxShadow(
                  // color: Colors.black87,
                  spreadRadius: 2.0,
                  blurRadius: 2.0,
                  offset: Offset(
                    1.0,
                    1.0,
                  ),
                )
              ],
              border: Border.all(
                color: Colors.black26,
                width: 9.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
              // color: Colors.blue,
            ),
          ),
        ),
      ), //Container
    ); //Flexible
  }
}

class GridSpace extends StatefulWidget {
  String link1, link2;

  GridSpace({this.link1 = '', this.link2 = ''});

  @override
  State<GridSpace> createState() => _GridSpaceState();
}

class _GridSpaceState extends State<GridSpace> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          GridBox(link: widget.link1),
          SizedBox(
            width: 20,
          ), //SizedBox
          GridBox(link: widget.link2),
        ], //<Widget>[]
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
