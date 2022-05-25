import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:myboardapp/pages/quotes/constants.dart';
import 'package:myboardapp/pages/quotes/quotes_list.dart';

class Quotes extends StatefulWidget {
  const Quotes({Key? key}) : super(key: key);

  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      // ignore: prefer_const_constructors
      body: Container(
        color: Color.fromARGB(255, 10, 75, 107),
        height: double.infinity,
        width: double.infinity,
        child: CarouselSlider.builder(
          itemCount: quotesList.length,
          itemBuilder: (context, index1, index2) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  quotesList[index1][kAuthor],
                  style: authorTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
          options: CarouselOptions(
            scrollDirection: Axis.vertical,
            pageSnapping: true,
            initialPage: 0,
            enlargeCenterPage: true,
          ),
        ),
      ),
    );
  }
}
