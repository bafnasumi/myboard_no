// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

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
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: AddQuotesScreen(),
                  ),
                ),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Color.fromARGB(255, 5, 33, 47),
          ),
        ),
        body: Container(
          color: Color.fromARGB(255, 5, 33, 47),
          height: double.infinity,
          width: double.infinity,
          child: SafeArea(
            child: CarouselSlider.builder(
              itemCount: quotesList.length,
              itemBuilder: (context, index1, index2) {
                return SingleChildScrollView(
                  child: Column(
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
                              mainAxisCellCount: (quotesList[index1][kAuthor])
                                          .toString()
                                          .length >
                                      30
                                  ? 2
                                  : 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                      ),
                    ],
                  ),
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
      ),
    );
  }
}

class AddQuotesScreen extends StatelessWidget {
  
  final _newQuoteController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Quote',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Color.fromARGB(255, 10, 75, 107),
              ),
            ),
            TextField(
              controller: _newQuoteController,
              maxLines: 3,
              autofocus: true,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            // ignore: deprecated_member_use
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
                pinnedWidgets.add(
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 2,
                    // mainAxisCellCount:
                    //     (quotesList[index1][kAuthor]).toString().length > 30
                    //         ? 2
                    //         : 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Transform.rotate(
                            angle: -math.pi / 60,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_newQuoteController.text,
                                  style: GoogleFonts.caveatBrush(
                                    color: Colors.black,
                                    fontSize: 8.5,
                                  ),
                                ),
                              ),
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
                  ),
                );
                Navigator.pushNamed(context, '/homepage');
              },
            ),
          ],
        ),
      ),
    );
  }
}
