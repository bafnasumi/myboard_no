// ignore_for_file: prefer_const_constructors, unused_import

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myboardapp/pages/quotes/constants.dart';
import 'package:myboardapp/pages/quotes/quotes_list.dart';

class Quotes extends StatefulWidget {
  const Quotes({Key? key}) : super(key: key);

  @override
  State<Quotes> createState() => _QuotesState();
}

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
                    onPressed: null,
                    child: Text(
                      'Pin',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700,fontSize: 17),
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
