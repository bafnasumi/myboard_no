// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Links extends StatefulWidget {
  const Links({Key? key}) : super(key: key);

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {
  List<String> links = [];
  final _linkController = TextEditingController();
  final _linkHeader = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Links',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 10, 75, 107),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    // SizedBox(height: 50),

                    const SizedBox(height: 4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Enter your links!',
                          style: GoogleFonts.lato(
                            fontSize: 26,
                          ),
                        ),
                        // Text(
                        //   '(YouTube, Instagram, Pinterest or others)',
                        //   style: GoogleFonts.lato(
                        //     fontSize: 20,
                        //   ),
                        // )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8,3,8,3),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(
                                  color: Color.fromARGB(255, 10, 75, 107),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextField(
                                  controller: _linkHeader,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Name'),
                                ),
                              ),
                            ),
                          ),
                        
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(
                                  color: Color.fromARGB(255, 10, 75, 107),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextField(
                                  maxLines: 3,
                                  controller: _linkController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter link here'),
                                ),
                              ),
                            ),
                          ),
                           SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
          size: 32,
        ),
        backgroundColor: Color.fromARGB(255, 10, 75, 107),
      ),
    );
  }
}

class L {}
