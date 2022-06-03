// ignore_for_file: avoid_print, use_key_in_widget_constructors, non_constant_identifier_names, prefer_const_constructors, unused_field

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myboardapp/boxes.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:myboardapp/models/myboard.dart' as m;
import 'homepage.dart';

class VoiceToText extends StatefulWidget {
  const VoiceToText({Key? key}) : super(key: key);

  @override
  State<VoiceToText> createState() => _VoiceToTextState();
}

class _VoiceToTextState extends State<VoiceToText> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice to Text',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  late bool _isEnabled;

  String localtext = 'Press the button and start speaking';
  double _confidence = 1.0;

  double screenHeight() {
    return MediaQuery.of(context).size.height;
  }

  double screenWidth() {
    return MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    super.initState();
    _isEnabled = false;
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_outlined),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                iconSize: 40.0,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                'Voice to Text',
                style: GoogleFonts.italiana(
                  color: Colors.black87,
                  fontSize: screenHeight() * 0.05,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      // Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 150.0),
          // decoration:
          //     BoxDecoration(color: Colors.white12, border: Border.all()),
          child: Column(
            children: [
              Center(
                child: Text(
                  localtext,
                  style: const TextStyle(
                    fontSize: 32.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight() * .4,
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: _isEnabled
                    ? () {
                        print('localtext::::::: $localtext');
                        Provider.of<VoiceToTextController>(context,
                                listen: false)
                            .addVoiceToText(
                          m.VoiceToText(
                            text: localtext,
                          ),
                        );
                        final box = BoxOfVoiceToText.getVoiceToText();
                        final latestvoicetotext = box.getAt(box.length - 1);
                        var index = box.length - 1;
                        print('pinnedwidget length: ${pinnedWidgets.length}');
                        int pinnedWidgetIndex = pinnedWidgets.length;
                        pinnedWidgets.add(
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount:
                                latestvoicetotext!.text!.length > 20 ? 2 : 1,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: PinnedVoiceToText(
                                        latestvoicetotext.text,
                                        index,
                                        pinnedWidgetIndex),
                                  ),
                                  // child: Image.file(
                                  //     File(videopath.toString())),
                                  decoration: BoxDecoration(
                                    color: Colors.lightGreen,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3.0,
                                        spreadRadius: 0.5,
                                        offset: Offset(1, 1),
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
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      }
                    : () {
                        final snackBar = SnackBar(
                          content: const Text(
                            'Please say something to pin',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth() * 0.22,
                      vertical: screenHeight() * 0.01),
                  child: Text(
                    'Pin the text',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      });
      _speech.stop();
      setState(() {
        _isEnabled = true;
      });
    }
  }

  PinnedVoiceToText(String? localtext, int index, int pinnedWidgetIndex) {
    return InkWell(
      child: Container(
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.horizontal,
          children: [
            Wrap(
              //direction: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 5, 2, 2),
                  child: Text(
                    localtext!,
                    style: TextStyle(fontSize: 10.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onDoubleTap: () {
        boxofvoicetotext.delete(index);
        pinnedWidgets.removeAt(pinnedWidgetIndex);
      },
    );
  }
}

var boxofvoicetotext = BoxOfVoiceToText.getVoiceToText();

class VoiceToTextController with ChangeNotifier {
  late m.VoiceToText _text;
  VoiceToTextController() {
    _text = m.VoiceToText(text: '_');
  }

  m.VoiceToText get VoiceToText => _text;

  void setVoiceToText(m.VoiceToText text) {
    _text = text;
    notifyListeners();
  }

  void addVoiceToText(m.VoiceToText text) {
    boxofvoicetotext.add(text);
    notifyListeners();
  }

  void removeVoiceToText(textkey) {
    boxofvoicetotext.delete(textkey);
    notifyListeners();
  }

  void emptyVoiceToText() async {
    await boxofvoicetotext.clear();
    notifyListeners();
  }
}
