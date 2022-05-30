// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myboardapp/pages/homepage.dart';
import 'package:myboardapp/pages/quotes/constants.dart';
import 'package:myboardapp/pages/quotes/quotes_list.dart';
import 'dart:math' as math;

class Quotes extends StatefulWidget {
  const Quotes({Key? key}) : super(key: key);

  @override
  State<Quotes> createState() => _QuotesState();
}

var listOfRandomDegrees = [0];

class _QuotesState extends State<Quotes> {
  final index1 = quotesList.length;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 5, 33, 47),
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: CarouselSlider.builder(
            itemCount: quotesList.length,
            itemBuilder: (context, index1, index2) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Text(
                          quotesList[index1][kQuote],
                          style: quoteTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        '- ${quotesList[index1][kAuthor]} -',
                        style: authorTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      pinnedWidgets.add(
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 2,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Transform.rotate(
                                angle: -math.pi / 60,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '"${quotesList[index1][kQuote]}"',
                                      style: GoogleFonts.caveatBrush(
                                        color: Colors.black,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                  ),
                                  // child: Image.file(
                                  //     File(videopath.toString())),
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3.0,
                                        spreadRadius: 0.5,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Image.asset(
                                'assets/images/pin.png',
                                width: 13,
                                height: 13,
                              ),
                            ],
                          ),
                        ),
                      );
                      Navigator.pushNamed(context, '/homepage');
                    },
                    child: Text(
                      'Pin',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blueGrey.shade700),
                      //  elevation: MaterialStateProperty.all(6.0),
                      //  shadowColor: MaterialStateProperty.all(
                      //   Colors.white)
                    ),
                  )
                ],
              );
            },
            options: CarouselOptions(
              scrollDirection: Axis.vertical,
              pageSnapping: true,
              initialPage: 0,
              enlargeCenterPage: true,
              // onPageChanged: (index, value) {
              //   HapticFeedback.lightImpact();
              // },
            ),
          ),
        ),
      ),
    );
  }
}
