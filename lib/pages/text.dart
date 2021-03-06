// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names, prefer_final_fields, prefer_const_literals_to_create_immutables

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myboardapp/pages/homepage.dart';
import 'package:myboardapp/pages/voicetotext.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart';
import '../boxes.dart';
import 'package:myboardapp/models/myboard.dart' as m;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:core';

import 'boardState.dart';

class TextPage extends StatefulWidget {
  const TextPage({Key? key}) : super(key: key);

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  final _textController = TextEditingController();
  var thisText = '';
  double screenHeight() {
    return MediaQuery.of(context).size.height;
  }

  double screenWidth() {
    return MediaQuery.of(context).size.width;
  }

  late stt.SpeechToText _speech;
  bool _isListening = false;
  late bool _isEnabled;

  String localtext = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    _textController.addListener(() {
      setState(() {});
    });
    super.initState();
    _isEnabled = false;
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    setState(
      () {
        _isEnabled = false;
      },
    );
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            localtext = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
            _isEnabled = true;
          }),
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _textController.text = localtext;
      });
      _speech.stop();
      setState(() {
        _isEnabled = true;
      });
    }
  }

  // @override
  // void dispose() {
  //   Hive.close();
  //   super.dispose();
  // }
  // late stt.SpeechToText _speech;
  // bool _isListening = false;
  String textSpeech = 'Press the button and start speaking';
  var snackBar = SnackBar(
    content: Text(
      'Enter text to pin data!',
      style: TextStyle(fontSize: 18),
    ),
  );
  @override
  Widget build(BuildContext context) {
    var TextPageprovider = Provider.of<TextPageController>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Text',
            style: GoogleFonts.italiana(
              color: Colors.black87,
              fontSize: screenHeight() * 0.05,
            ),
          ),
          // child: Row(
          //   children: [
          //     // IconButton(
          //     //   icon: Icon(Icons.arrow_back_outlined),
          //     //   color: Colors.black,
          //     //   onPressed: () {
          //     //     Navigator.pop(context);
          //     //   },
          //     //   iconSize: 40.0,
          //     // ),
          //     // SizedBox(
          //     //   height: 10.0,
          //     // ),
          //     Text(
          //       'Text',
          //       style: GoogleFonts.italiana(
          //         color: Colors.black87,
          //         fontSize: screenHeight() * 0.05,
          //       ),
          //     ),
          //   ],
          // ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 110),
            Text(
              'Enter your Text!',
              style: GoogleFonts.reenieBeanie(
                fontSize: 36,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(
                    color: Color.fromARGB(255, 10, 75, 107),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.7,
                      // decoration: BoxDecoration(
                      //   color: Colors.grey[200],
                      //   border: Border.all(
                      //     color: Color.fromARGB(255, 10, 75, 107),
                      //   ),
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                        ),
                        child: SizedBox(
                          width: 180,
                          height: 100,
                          child: TextField(
                            maxLines: 3,
                            controller: _textController,
                            onSubmitted: (value) => setState(() {
                              thisText = value;
                            }),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Text here'),
                          ),
                        ),
                      ),
                    ),
                    AvatarGlow(
                      animate: _isListening,
                      glowColor: Theme.of(context).primaryColor,
                      endRadius: 25.0,
                      duration: const Duration(milliseconds: 2000),
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      repeat: true,
                      child: IconButton(
                        // backgroundColor: Colors.red,

                        onPressed: _listen,
                        icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            // Center(
            //   child: Text(
            //     localtext,
            //     style: const TextStyle(
            //       fontSize: 32.0,
            //       color: Colors.black,
            //       fontWeight: FontWeight.w400,
            //     ),
            //   ),
            // ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromARGB(255, 10, 75, 107),
                ),
              ),
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  Provider.of<TextPageController>(context, listen: false)
                      .addText(
                    m.Text(
                      text: _textController.text,
                    ),
                  );
                  final box = BoxOfText.getText();
                  final latestText = box.getAt(box.length - 1);
                  var index = box.length - 1;
                  //print('pinnedwidget length: ${pinnedWidgets!.length}');
                  //int pinnedWidgetIndex = pinnedWidgets!.length;

                  // StaggeredGridTile.count(
                  //   crossAxisCellCount: 2,
                  //   mainAxisCellCount: (latestText!.text!.length > 10
                  //       ? (latestText!.text!.length > 20 ? 3 : 2)
                  //       : 1),
                  //   child:
                  //       PinnedText(latestText!.text, index, pinnedWidgetIndex),
                  // );

                  Provider.of<BoardStateController>(context, listen: false)
                      .addBoardData(
                    m.BoardData(
                      position: BoxOfBoardData.getBoardData().length,
                      data: latestText!.text,
                      isDone: false,
                      type: 'text',
                    ),
                  );
                  setState(() {});
                  Navigator.pushNamed(context, '/homepage');
                } else {
                  // Get.snackbar('Oops', 'Item already on board');
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth() * 0.22,
                    vertical: screenHeight() * 0.01),
                child: Text(
                  'Add Text',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            // SpeechScreen(),
          ],
        ),
      ),
    );
  }

  PinnedText(String? mytext, int index, int pinnedWidgetIndex) => InkWell(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.yellow[200],
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3.0,
                    spreadRadius: 0.5,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Wrap(
                //direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,

                direction: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 0, 4),
                    child: Center(
                      child: Text(
                        mytext!,
                        style: GoogleFonts.gloriaHallelujah(
                          height: 0,
                          fontSize: 10.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/images/pin.png',
              width: 13,
              height: 13,
            ),
          ],
        ),
        onDoubleTap: () {
          boxofTextPage.delete(index);
          // pinnedWidgets!.removeAt(pinnedWidgetIndex);
        },
      );

  Widget BuildContent(List<m.Text> myTextPage) {
    if (myTextPage.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'No TextPage yet!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
    } else {
      return Expanded(
        child: Column(
          children: [
            Text(
              'TextPage: ${myTextPage[0]}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.amber,
              ),
            ),
            SizedBox(height: 5),
            Consumer<TextPageController>(
                builder: (context, TextPageData, child) {
              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: boxofTextPage.length,
                itemBuilder: (BuildContext context, int index) {
                  final Text = boxofTextPage.getAt(index);
                  return buildTextPagePage(context, Text!);
                },
              );
            }),
          ],
        ),
      );
    }
  }

  Widget buildTextPagePage(
    BuildContext context,
    m.Text MyText,
  ) {
    return Card(
      color: Colors.white,
      child: Text(
        MyText.text!,
        maxLines: 2,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

var boxofTextPage = BoxOfText.getText();

class TextPageController with ChangeNotifier {
  late m.Text _mytext;
  TextPageController() {
    _mytext = m.Text(
      text: '_',
    );
  }

  m.Text get Text => _mytext;

  void setText(m.Text Text) {
    _mytext = Text;
    notifyListeners();
  }

  void addText(m.Text Text) {
    boxofTextPage.add(Text);
    notifyListeners();
  }

  void removeText(TextKey) {
    boxofTextPage.delete(TextKey);
    notifyListeners();
  }

  void emptyText() async {
    await boxofTextPage.clear();
    notifyListeners();
  }
}
