// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../boardState.dart';
import '../video.dart';
import 'package:myboardapp/models/myboard.dart' as m;
import 'dart:math' as math;

class BoardDataList extends StatefulWidget {
  const BoardDataList({Key? key}) : super(key: key);

  @override
  State<BoardDataList> createState() => _BoardDataListState();
}

class _BoardDataListState extends State<BoardDataList> {
  @override
  Widget build(BuildContext context) {
    return boxofboarddata.length == 0
        ? Center(
            child: Text(
            'Add your first item',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ))
        : Consumer<BoardStateController>(
            builder: (context, boarddata, child) {
              return GridView.builder(
                  key: widget.key,
                  itemCount: boxofboarddata.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 2,

                    // crossAxisCount: 6,
                  ),
                  // itemCount: myProducts.length,
                  itemBuilder: (BuildContext context, index) {
                    final _boarddata = boxofboarddata.getAt(index);
                    return BoardTile(boarddata: _boarddata);
                    // return TaskTile(
                    //   taskTitle: boarddata!.data,
                    //   isChecked: boarddata.isDone,
                    //   checkboxCallback: (checkboxState) {
                    //     taskData.removeToDo(task.key);
                    //     setState(() {});
                    //     const snackBar = SnackBar(
                    //       content: Text('Todo deleted'),
                    //     );
                    //});
                  });
            },
          );
  }
}

class BoardTile extends StatefulWidget {
  m.BoardData? boarddata;
  BoardTile({Key? key, this.boarddata}) : super(key: key);

  @override
  State<BoardTile> createState() => BboardTileState();
}

class BboardTileState extends State<BoardTile> {
  @override
  Widget build(BuildContext context) {
    switch (widget.boarddata!.type) {
      case 'image':
        {
          File finalImage = File(widget.boarddata!.data!);
          // var decodedImage =
          //     await decodeImageFromList(finalImage.readAsBytesSync());
          // double width = decodedImage.width.toDouble();
          // double height = decodedImage.height.toDouble();
          return StaggeredGridTile.count(
            // crossAxisCellCount: width > height ? 3 : 2,
            // mainAxisCellCount: width < height ? 3 : 2,
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,

            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  child: Image.file(finalImage),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      blurRadius: 3.0,
                      spreadRadius: 0.5,
                      offset: Offset(1, 1),
                    ),
                  ]),
                ),
                Image.asset(
                  'assets/images/pin.png',
                  width: 13,
                  height: 13,
                ),
              ],
            ),
          );
        }
        break;
      case 'video':
        {
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: InkWell(
              onTap: (() {
                print('tap on video catched');
                print(widget.boarddata!.data);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) =>
                        Video(localfile_path: widget.boarddata!.data!)),
                  ),
                );
              }),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      child: Text(
                        'video link; ${widget.boarddata!.data!}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      // child: Image.file(
                      //     File(videopath.toString())),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          blurRadius: 3.0,
                          spreadRadius: 0.5,
                          offset: Offset(1, 1),
                        ),
                      ]),
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
        }
        break;
      case 'todo':
        {
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: PinnedToDo(widget.boarddata!.data!, 0, 0),
          );
        }
        break;
      case 'link':
        {
          return StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        // ignore: prefer_const_literals_to_create_immutables
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3.0,
                            spreadRadius: 0.5,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: PinnedLink(widget.boarddata!.data!.split(':')[0],
                          widget.boarddata!.data!.split(':')[1], 0, 0, context),
                    ),
                    Image.asset(
                      'assets/images/pin.png',
                      width: 13,
                      height: 13,
                    ),
                  ],
                  // ),
                ),
              ));
          break;
        }
      case 'voicetotext':
        {
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: widget.boarddata!.data!.length > 20 ? 2 : 1,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PinnedVoiceToText(widget.boarddata!.data!, 0, 0),
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
          );
        }
        break;
      case 'text':
        {
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: (widget.boarddata!.data!.length > 10
                ? (widget.boarddata!.data!.length > 20 ? 3 : 2)
                : 1),
            child: PinnedText(widget.boarddata!.data!, 0, 0),
          );
        }
        break;
      case 'audio':
        {
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: PinnedToDo(widget.boarddata!.data!, 0, 0),
          );
        }
        break;
      case 'quote':
        {
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            // mainAxisCellCount:
            //     (quotesList[index1][kAuthor]).toString().length > 30
            //         ? 2
            //         : 1,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Transform.rotate(
                  angle: -math.pi / 60,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.boarddata!.data!,
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
          );
        }
        break;
      case 'reminder':
        {
          List<String?> reminderdata = widget.boarddata!.data!.split('*');
          print('reminderdata');
          print(reminderdata);
          final dateinString = reminderdata[2]!.split('-');
          DateTime? dateinDateTime = DateTime(int.parse(dateinString[0]),
              int.parse(dateinString[1]), int.parse(dateinString[2]));
          print('reminderdata[4]');
          print(reminderdata[4]!);

          m.ReminderTask latestreminder = m.ReminderTask(
            title: reminderdata[0],
            note: reminderdata[1],
            date: dateinDateTime!,
            startTime: reminderdata[3],
            reminder: int.parse(reminderdata[4]!),
            repeat: reminderdata[5],
          );
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: PinnedReminder(latestreminder!, 0, 0),
          );
        }
        break;

      default:
        return Container();
    }
  }
}

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
