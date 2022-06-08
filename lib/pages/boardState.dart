// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myboardapp/models/myboard.dart' as m;
import 'package:myboardapp/pages/video.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

import '../boxes.dart';

var boxofboarddata = BoxOfBoardData.getBoardData();

class BoardStateController extends ChangeNotifier {
  m.BoardData? _boarddata;
  var typeList = [
    'image',
    'video',
    'todo',
    'link',
    'voicetotext',
    'text',
    'audio',
    'quotes'
  ];
  BoardStateController() {
    _boarddata = m.BoardData(
      position: 0,
      type: typeList[0],
      data: 'path or data will be given',
    );
  }

  m.BoardData? get BoardData => _boarddata;

  void setBoardData(m.BoardData boardData) {
    _boarddata = boardData;
    notifyListeners();
  }

  void addBoardData(m.BoardData boardData) {
    boxofboarddata.add(boardData);
    notifyListeners();
  }

  void removeBoardData(boardDataKey) {
    boxofboarddata.delete(boardDataKey);
    notifyListeners();
  }

  void emptyBoardData() async {
    await boxofboarddata.clear();
    notifyListeners();
  }

  // List<Widget> listofwidgets(BuildContext context) {
  //   BoardStateController boardStateController =
  //       Provider.of<BoardStateController>(context);
  //   var boxofboardData = BoxOfBoardData.getBoardData();

  //   for (var i = 0; i < boxofboardData.length; i++) {
  //     boardStateController.addThings(boxofboardData.getAt(i)!, context);
  //     print(boxofboardData.getAt(i)!.data);
  //   }

  //   return [Container()];
  // }

  // Future<Widget> addThings(m.BoardData _boarddata, BuildContext context) async {
  //   double screenHeight() {
  //     return MediaQuery.of(context).size.height;
  //   }

  //   double screenWidth() {
  //     return MediaQuery.of(context).size.width;
  //   }

  //   String? typee = _boarddata.type;
  //   switch (typee) {
  //     case 'image':
  //       {
  //         File finalImage = File(_boarddata.data!);
  //         var decodedImage =
  //             await decodeImageFromList(finalImage.readAsBytesSync());
  //         double width = decodedImage.width.toDouble();
  //         double height = decodedImage.height.toDouble();
  //         // return StaggeredGridTile.count(
  //         //   crossAxisCellCount: width > height ? 3 : 2,
  //         //   mainAxisCellCount: width < height ? 3 : 2,
  //         return Stack(
  //           alignment: Alignment.topCenter,
  //           children: [
  //             Container(
  //               child: Image.file(finalImage),
  //               decoration: BoxDecoration(boxShadow: [
  //                 BoxShadow(
  //                   blurRadius: 3.0,
  //                   spreadRadius: 0.5,
  //                   offset: Offset(1, 1),
  //                 ),
  //               ]),
  //             ),
  //             Image.asset(
  //               'assets/images/pin.png',
  //               width: 13,
  //               height: 13,
  //             ),
  //           ],
  //           // ),
  //         );
  //       }
  //       break;
  //     case 'video':
  //       {
  //         return StaggeredGridTile.count(
  //           crossAxisCellCount: 2,
  //           mainAxisCellCount: 2,
  //           child: InkWell(
  //             onTap: (() {
  //               print('tap on video catched');
  //               print(_boarddata.data);
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: ((context) =>
  //                       Video(localfile_path: _boarddata.data)),
  //                 ),
  //               );
  //             }),
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Stack(
  //                 alignment: Alignment.topCenter,
  //                 children: [
  //                   Container(
  //                     child: Text(
  //                       'video link; ${_boarddata.data}',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                     // child: Image.file(
  //                     //     File(videopath.toString())),
  //                     decoration: BoxDecoration(boxShadow: [
  //                       BoxShadow(
  //                         blurRadius: 3.0,
  //                         spreadRadius: 0.5,
  //                         offset: Offset(1, 1),
  //                       ),
  //                     ]),
  //                   ),
  //                   Image.asset(
  //                     'assets/images/pin.png',
  //                     width: 13,
  //                     height: 13,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       }
  //       break;
  //     case 'todo':
  //       {
  //         return StaggeredGridTile.count(
  //           crossAxisCellCount: 2,
  //           mainAxisCellCount: 1,
  //           child: PinnedToDo(_boarddata.data, 0, 0),
  //         );
  //       }
  //       break;
  //     case 'link':
  //       {
  //         return StaggeredGridTile.count(
  //             crossAxisCellCount: 2,
  //             mainAxisCellCount: 1,
  //             child: Padding(
  //               padding: const EdgeInsets.all(4.0),
  //               child: Stack(
  //                 alignment: Alignment.topCenter,
  //                 children: [
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       // ignore: prefer_const_literals_to_create_immutables
  //                       boxShadow: [
  //                         BoxShadow(
  //                           blurRadius: 3.0,
  //                           spreadRadius: 0.5,
  //                           offset: Offset(1, 1),
  //                         ),
  //                       ],
  //                     ),
  //                     child: PinnedLink(_boarddata.data!.split(':')[0],
  //                         _boarddata.data!.split(':')[1], 0, 0, context),
  //                   ),
  //                   Image.asset(
  //                     'assets/images/pin.png',
  //                     width: 13,
  //                     height: 13,
  //                   ),
  //                 ],
  //                 // ),
  //               ),
  //             ));
  //         break;
  //       }
  //     case 'voicetotext':
  //       {
  //         return StaggeredGridTile.count(
  //           crossAxisCellCount: 2,
  //           mainAxisCellCount: _boarddata.data!.length > 20 ? 2 : 1,
  //           child: Stack(
  //             alignment: Alignment.topCenter,
  //             children: [
  //               Container(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: PinnedVoiceToText(_boarddata.data, 0, 0),
  //                 ),
  //                 // child: Image.file(
  //                 //     File(videopath.toString())),
  //                 decoration: BoxDecoration(
  //                   color: Colors.lightGreen,
  //                   // ignore: prefer_const_literals_to_create_immutables
  //                   boxShadow: [
  //                     BoxShadow(
  //                       blurRadius: 3.0,
  //                       spreadRadius: 0.5,
  //                       offset: Offset(1, 1),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Image.asset(
  //                 'assets/images/pin.png',
  //                 width: 13,
  //                 height: 13,
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //       break;
  //     case 'text':
  //       {
  //         return StaggeredGridTile.count(
  //           crossAxisCellCount: 2,
  //           mainAxisCellCount: (_boarddata.data!.length > 10
  //               ? (_boarddata.data!.length > 20 ? 3 : 2)
  //               : 1),
  //           child: PinnedText(_boarddata.data, 0, 0),
  //         );
  //       }
  //       break;
  //     case 'audio':
  //       {
  //         return StaggeredGridTile.count(
  //           crossAxisCellCount: 2,
  //           mainAxisCellCount: 1,
  //           child: PinnedToDo(_boarddata.data, 0, 0),
  //         );
  //       }
  //       break;
  //     case 'quote':
  //       {
  //         return StaggeredGridTile.count(
  //           crossAxisCellCount: 2,
  //           mainAxisCellCount: 2,
  //           // mainAxisCellCount:
  //           //     (quotesList[index1][kAuthor]).toString().length > 30
  //           //         ? 2
  //           //         : 1,
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Stack(
  //               alignment: Alignment.topCenter,
  //               children: [
  //                 Transform.rotate(
  //                   angle: -math.pi / 60,
  //                   child: Container(
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         _boarddata.data!,
  //                         style: GoogleFonts.caveatBrush(
  //                           color: Colors.black,
  //                           fontSize: 8.5,
  //                         ),
  //                       ),
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: Colors.greenAccent,
  //                       boxShadow: [
  //                         BoxShadow(
  //                           blurRadius: 3.0,
  //                           spreadRadius: 0.5,
  //                           offset: Offset(1, 1),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Image.asset(
  //                   'assets/images/pin.png',
  //                   width: 13,
  //                   height: 13,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }
  //       break;
  //     case 'reminder':
  //       {
  //         List reminderdata = _boarddata.data!.split(':');

  //         m.ReminderTask latestreminder = m.ReminderTask(
  //           title: reminderdata[0],
  //           note: reminderdata[1],
  //           date: reminderdata[2],
  //           startTime: reminderdata[3],
  //           reminder: reminderdata[4],
  //           repeat: reminderdata[5],
  //         );
  //         return StaggeredGridTile.count(
  //           crossAxisCellCount: 2,
  //           mainAxisCellCount: 1,
  //           child: PinnedReminder(latestreminder!, 0, 0),
  //         );
  //       }
  //       break;

  //     default:
  //       return Container();
  //   }
  //   notifyListeners();
  // }

  PinnedToDo(String? todotext, int index, int pinnedWidgetIndex) => InkWell(
        child: Container(
          child: Wrap(
            alignment: WrapAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(todotext!),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white70,
            image: DecorationImage(
              image: AssetImage('assets/images/todo_background.png'),
              fit: BoxFit.contain,
            ),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
        ),
        onDoubleTap: () {
          //isDone = true;
          // boxoftodos.delete(index);
          //pinnedWidgets!.removeAt(pinnedWidgetIndex);
        },
      );

  PinnedReminder(m.ReminderTask? task, int index, int pinnedWidgetIndex) =>
      InkWell(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            //direction: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 0, 2),
                child: Text(
                  task!.title!,
                  style: GoogleFonts.openSans(fontSize: 13.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
                child: Text(
                  task.note!,
                  style: TextStyle(fontSize: 7.0),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/reminder_backgroud.png')),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
        ),
        onDoubleTap: () {
          //boxofreminders.delete(index);
          // pinnedWidgets!.removeAt(pinnedWidgetIndex);
        },
      );

  PinnedLink(String? url, String? description, int index, int pinnedWidgetIndex,
          context) =>
      InkWell(
        // onDoubleTap: () {},
        child: GestureDetector(
          onTap: () {
            //TODO: launch url !
            //launchUrl(url: url!);
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 0, 2),
                  child: Text(
                    description!,
                    style: TextStyle(fontSize: 10.0),
                  ),
                ),
                Wrap(
                  //direction: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
                      child: Text(
                        url!,
                        style: TextStyle(fontSize: 5.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: [
                BoxShadow(
                  blurRadius: 3.0,
                  spreadRadius: 0.5,
                  offset: Offset(1, 1),
                ),
              ],
              image: DecorationImage(
                image: AssetImage('assets/images/www.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10.0),
              // border: Border.all(
              //   color: Colors.black,
              //   width: 2.0,
              // ),
            ),
          ),
        ),
      );

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
        //boxofvoicetotext.delete(index);
        //pinnedWidgets!.removeAt(pinnedWidgetIndex);
      },
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
          //boxofTextPage.delete(index);
          //pinnedWidgets!.removeAt(pinnedWidgetIndex);
        },
      );

  Future<void> launchUrl({required String url}) async {
    String checkUrl(String url) {
      if (url.startsWith('http')) {
        return url;
      } else {
        return 'https://$url';
      }
    }

    url = checkUrl(url);
    try {
      final bool shouldContinue = await canLaunch(url);
      if (shouldContinue) {
        await launch(url, forceSafariVC: false);
        return;
      }
      throw Exception('Could not launch $url');
    } catch (e) {
      print('idk');
    }
  }
}
