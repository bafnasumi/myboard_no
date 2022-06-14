// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names, dead_code

import 'dart:io';
// import 'dart:ui' as ui;
// import 'package:vm_service/vm_service.dart';

// import 'package:audioplayers/audioplayers.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart' as audi;
// import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myboardapp/boxes.dart';
import 'package:myboardapp/pages/Documents/documents.dart';
import 'package:myboardapp/pages/imageControlller.dart';
import 'package:myboardapp/pages/remind/controller/task_controller.dart';
import 'package:myboardapp/pages/todo.dart';
import 'package:open_file/open_file.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../components/audio_widgets.dart';
import '../boardState.dart';
import '../links.dart';
import '../video.dart';
import 'package:myboardapp/models/myboard.dart' as m;
import 'dart:math' as math;

class BoardDataList extends StatefulWidget {
  const BoardDataList({Key? key}) : super(key: key);

  @override
  State<BoardDataList> createState() => _BoardDataListState();
}

class _BoardDataListState extends State<BoardDataList> {
//  Future videothumbnail(String? videofile_path) async {
// final uint8list = await VideoThumbnail.thumbnailData(
//   video: videofile_path!,
//   imageFormat: ImageFormat.JPEG,
//   maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
//   quality: 25,
// );
// return uint8list;
//   }
  late Future<int> dataFuture;

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
              int crossAxisCount = 2;
              double? mainAxisCount = 2.0;
              return StaggeredGridView.countBuilder(
                  // key: widget.key,
                  itemCount: boxofboarddata.length,
                  crossAxisCount: 9,
                  staggeredTileBuilder: (index) =>
                      // StaggeredTile.count(crossAxisCount, mainAxisCount),
                      StaggeredTile.fit(3),
                  mainAxisSpacing: 6,
                  padding: EdgeInsets.all(7),
                  crossAxisSpacing: 8,
                  itemBuilder: (BuildContext context, index) {
                    final _boarddata = boxofboarddata.getAt(index);

                    return BoardTile(
                      boarddata: _boarddata,
                    );
                  });
            },
          );
  }
}

class BoardTile extends StatefulWidget {
  m.BoardData? boarddata;
  var particularData;
  var previousImagePaths;

  BoardTile({Key? key, this.boarddata, this.particularData}) : super(key: key);

  @override
  State<BoardTile> createState() => BboardTileState();
}

class BboardTileState extends State<BoardTile> {
  bool isPause = true;
  bool startonce = false;
  bool _repeated = false;
  bool isStop = false;

  @override
  Widget build(BuildContext context) {
    switch (widget.boarddata!.type) {
      case 'image':
        {
          var imagePath = (widget.boarddata!.data!).split('*');
          print('imagepath11111111111111111');
          print(imagePath[0]);
          print('image key');
          print(imagePath[1]);

          var boxofImages = BoxofImage.getImages();
          // print('boxofImages');
          // print(boxofImages.getAt(index)!.imagesource);
          // print('length of box ========  ${boxofImages}');
          m.Images previousImagePaths;
          // for (previousImagePaths in boxofImages.toMap().values) {
          // if (boxofImages.length > 1) {
          //   for (var index = 0; index < boxofImages.length - 1; index++) {
          //     print(imagePath[0].trim());
          //     print((boxofImages.getAt(index)!.imagesource!.trim()));
          //     print(boxofImages.getAt(index)!.imagesource!.split('/')[6]);
          //     print((imagePath[0].trim()).contains(
          //         boxofImages.getAt(index)!.imagesource!.split('/')[6]));

          // boxofImages.getAt(index)!.imagesource!.trim()));

          //     if ((imagePath[0].trim()).contains(
          //         boxofImages.getAt(index)!.imagesource!.split('/')[6])) {
          //       print(
          //           '${imagePath[0]} == ${boxofImages.getAt(index)!.imagesource}');
          //       setState(() {
          //         _repeated = true;
          //       });
          //     }
          //   }
          // }
          // print('_repeated = $_repeated');

          // if (!_repeated) {
          File? finalImage = File(imagePath[0]);
          // var decodedImage =
          //     await decodeImageFromList(finalImage.readAsBytesSync());
          // double width = decodedImage.width.toDouble();
          // double height = decodedImage.height.toDouble();
          // return StaggeredGridTile.count(
          //   // crossAxisCellCount: width > height ? 3 : 2,
          //   // mainAxisCellCount: width < height ? 3 : 2,
          //   crossAxisCellCount: 2,
          //   mainAxisCellCount: 2,
          // setState(() {
          //   _repeated = false;
          // });
          var imageProvider = Image.file(finalImage).image;
          return GestureDetector(
            child: Container(
              // height: finalImage.readAsBytesSync(). > myimage.width!.toInt() ? 120 : 90,
              // width: myimage.height! > myimage.width!.toInt() ? 70 : 100,
              height: 160,
              width: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                // boxShadow: [
                //   BoxShadow(
                //     blurRadius: 3.0,
                //     spreadRadius: 0.5,
                //     offset: Offset(1, 1),
                //   ),
                // ],
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    // child: PhotoView(
                    //   imageProvider: FileImage(finalImage),
                    //   heroAttributes:
                    //       PhotoViewHeroAttributes(tag: ),
                    //       maxScale: 50.0,
                    // ),
                    child: Image.file(finalImage),
                    decoration: BoxDecoration(boxShadow: [
                      // BoxShadow(
                      //   blurRadius: 3.0,
                      //   spreadRadius: 0.5,
                      //   offset: Offset(1, 1),
                      // ),
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
            onLongPress: () {
              var alert = AlertDialog(
                title: Text("Do you want really want to delete it?"),
                //content: Text("You won't be able to "),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("Delete"),
                    onPressed: () {
                      var boardcontroller = Provider.of<BoardStateController>(
                        context,
                        listen: false,
                      );
                      var imageController = Provider.of<ImageController>(
                        context,
                        listen: false,
                      );
                      boardcontroller.removeBoardData(widget.boarddata!.key);
                      imageController.removeImage(imagePath[1]);

                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          );
          // } else {
          // var snackBar = SnackBar(
          //   content: Text('Image already on board'),
          // );
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return Dialog(
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(40)),
          //           elevation: 16,
          //           child: Text('ALready on board'));
          //     });
          //   return SizedBox(
          //     width: .1,
          //     height: .1,
          //   );
          // }

          // );
        }
        break;
      case 'video':
        {
          // return StaggeredGridTile.count(
          //   crossAxisCellCount: 2,
          //   mainAxisCellCount: 2,
          var thumbnail = videothumbnail(widget.boarddata!.data);
          return InkWell(
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
                    child: FutureBuilder<Widget>(
                      future: videothumbnail(widget.boarddata!.data!),
                      builder: (BuildContext context,
                          AsyncSnapshot<Widget> snapshot) {
                        if (snapshot.hasData) return snapshot.data!;

                        return Container(child: CircularProgressIndicator());
                      },
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
            // ),
            onLongPress: () {
              // var boxofboarddata = BoxOfBoardData.getBoardData();
              // setState(() {
              //   boxofboarddata.delete();
              // });
              // set up the AlertDialog

              var alert = AlertDialog(
                title: Text("Do you want really want to delete it?"),
                //content: Text("You won't be able to "),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("Delete"),
                    onPressed: () {
                      var boardcontroller = Provider.of<BoardStateController>(
                        context,
                        listen: false,
                      );
                      boardcontroller.removeBoardData(widget.boarddata!.key);
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          );
        }
        break;
      case 'todo':
        {
          // return StaggeredGridTile.count(
          // crossAxisCellCount: 2,
          // mainAxisCellCount: 1,
          var allData = widget.boarddata!.data!.split(':');
          return InkWell(
            child: PinnedToDo(
              allData[0],
              0,
              0,
            ),
            onLongPress: () {
              // var boxofboarddata = BoxOfBoardData.getBoardData();
              // setState(() {
              //   boxofboarddata.delete();
              // });
              // set up the AlertDialog

              var alert = AlertDialog(
                title: Text("Done?"),
                //content: Text("You won't be able to "),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("Yes, delete"),
                    onPressed: () {
                      var boardcontroller = Provider.of<BoardStateController>(
                        context,
                        listen: false,
                      );
                      boardcontroller.removeBoardData(widget.boarddata!.key);
                      var todocontroller = Provider.of<TaskController>(
                        context,
                        listen: false,
                      );
                      todocontroller.removeToDo(int.parse(allData[1]));
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          );
          // );
        }

      case 'link':
        {
          // return StaggeredGridTile.count(
          //     crossAxisCellCount: 2,
          //     mainAxisCellCount: 1,
          return InkWell(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 50,
                  width: 110,
                  decoration: BoxDecoration(),
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
            onTap: () {
              launchUrl(url: widget.boarddata!.data!.split(':')[0]);
            },
            onLongPress: () {
              // var boxofboarddata = BoxOfBoardData.getBoardData();
              // setState(() {
              //   boxofboarddata.delete();
              // });
              // set up the AlertDialog

              var alert = AlertDialog(
                title: Text("Do you want really want to delete it?"),
                //content: Text("You won't be able to "),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("Yes, delete"),
                    onPressed: () {
                      var boardcontroller = Provider.of<BoardStateController>(
                        context,
                        listen: false,
                      );
                      boardcontroller.removeBoardData(widget.boarddata!.key);
                      // var todocontroller = Provider.of<TaskController>(
                      //   context,
                      //   listen: false,
                      // );
                      // todocontroller.removeToDo(int.parse(allData[1]));
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          );
        }
      case 'voicetotext':
        {
          // return StaggeredGridTile.count(
          //   crossAxisCellCount: 2,
          //   mainAxisCellCount: widget.boarddata!.data!.length > 20 ? 2 : 1,
          return InkWell(
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
              // ),
            ),
            onLongPress: () {
              // var boxofboarddata = BoxOfBoardData.getBoardData();
              // setState(() {
              //   boxofboarddata.delete();
              // });
              // set up the AlertDialog

              var alert = AlertDialog(
                title: Text("Do you want really want to delete it?"),
                //content: Text("You won't be able to "),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("Yes, delete"),
                    onPressed: () {
                      var boardcontroller = Provider.of<BoardStateController>(
                        context,
                        listen: false,
                      );
                      boardcontroller.removeBoardData(widget.boarddata!.key);
                      // var todocontroller = Provider.of<TaskController>(
                      //   context,
                      //   listen: false,
                      // );
                      // todocontroller.removeToDo(int.parse(allData[1]));
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          );
        }
        break;
      case 'document':
        {
          var allData = widget.boarddata!.data!.split('*');
          return InkWell(
            child: Container(
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Icon(
                        Icons.file_copy_rounded,
                        color: Colors.white,
                        size: 85,
                      ),
                      Wrap(
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 10, bottom: 6),
                            width: 60,
                            child: Text(
                              allData[0].split('/').last,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 7.4,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23, top: 20),
                    child: Image.asset(
                      'assets/images/pin.png',
                      width: 13,
                      height: 13,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              if (Platform.isAndroid || Platform.isIOS) {
                OpenFile.open(allData[0]);
              }
            },
            onLongPress: () {
              var alert = AlertDialog(
                title: Text("Do you want really want to delete it?"),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("Yes, delete"),
                    onPressed: () {
                      var boardcontroller = Provider.of<BoardStateController>(
                        context,
                        listen: false,
                      );
                      boardcontroller.removeBoardData(widget.boarddata!.key);
                      var documentController = Provider.of<DocumentsController>(
                        context,
                        listen: false,
                      );
                      documentController.removeDocument(int.parse(allData[1]));
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          );
          // );
        }
        break;
      case 'text':
        {
          // return StaggeredGridTile.count(
          //   crossAxisCellCount: 2,
          //   mainAxisCellCount: (widget.boarddata!.data!.length > 10
          // ? (widget.boarddata!.data!.length > 20 ? 3 : 2)
          // : 1),
          return InkWell(
            child: PinnedText(widget.boarddata!.data!, 0, 0),
            onLongPress: () {
              // var boxofboarddata = BoxOfBoardData.getBoardData();
              // setState(() {
              //   boxofboarddata.delete();
              // });
              // set up the AlertDialog

              var alert = AlertDialog(
                title: Text("Do you want really want to delete it?"),
                //content: Text("You won't be able to "),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("Yes, delete"),
                    onPressed: () {
                      var boardcontroller = Provider.of<BoardStateController>(
                        context,
                        listen: false,
                      );
                      boardcontroller.removeBoardData(widget.boarddata!.key);
                      // var todocontroller = Provider.of<TaskController>(
                      //   context,
                      //   listen: false,
                      // );
                      // todocontroller.removeToDo(int.parse(allData[1]));
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          );
          // );
        }
        break;
      case 'audio':
        {
// FutureBuilder<int>(
//                     future: getDuration(widget.boarddata!.data!, audioPlayer),
//                     builder: (context, snapshot) {
//                       // print(snapshot.data);

//                       if (snapshot.hasData) {
//                         return TweenAnimationBuilder(
//                           tween: Tween(
//                             begin: 0.0,
//                             end: 1.0,
//                           ),
//                           duration: Duration(seconds: snapshot.data!),
//                           builder: (context, value, _) {
//                             // print(snapshot.data);
//                             return SizedBox(
//                               height: 60,
//                               width: 60,
//                               child: CircularProgressIndicator(
//                                 value: double.parse(value.toString()),
//                                 backgroundColor: Colors.grey,
//                                 strokeWidth: 6,
//                               ),
//                             );
//                           },
//                         );
//                       } else if (snapshot.hasError) {
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 16),
//                           child: Text(
//                             'Error: ${snapshot.error}',
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.white,
//                             ),
//                           ),
//                         );
//                       } else {
//                         return Padding(
//                           padding: EdgeInsets.only(top: 16),
//                           child: Text(
//                             'Awaiting result...',
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.white,
//                             ),
//                           ),
//                         );
//                       }

//                       // return snapshot.hasData
//                       //     ? TweenAnimationBuilder(
//                       //         tween: Tween(
//                       //           begin: 0,
//                       //           end: 1,
//                       //         ),
//                       //         duration: Duration(seconds: snapshot.data as int),
//                       //         builder: (context, value, _) {
//                       //           print(snapshot.data);
//                       //           return SizedBox(
//                       //             height: 100,
//                       //             width: 100,
//                       //             child: CircularProgressIndicator(
//                       //               value: value as double?,
//                       //               backgroundColor: Colors.grey,
//                       //               strokeWidth: 6,
//                       //             ),
//                       //           );
//                       //         },
//                       //       )
//                       //     : Text(
//                       //         'snapshot has no data',
//                       //         style:
//                       //             TextStyle(fontSize: 10, color: Colors.white),
//                       //       );
//                     }),

          // return StaggeredGridTile.count(
          //   crossAxisCellCount: 2,
          //   mainAxisCellCount: 1,
          //return PinnedToDo(widget.boarddata!.data!, 0, 0);
          // audi.AudioPlayer audioPlayer = audi.AudioPlayer();
          TimerController timerController = TimerController();
          final PlayerController playerController = PlayerController();
          var timercontroller = TimerWidget(controller: timerController);

          // return InkWell(
          //   child: Icon(Icons.record_voice_over),
          //   onTap: () {
          //     AudioPlayer audioPlayer = AudioPlayer();
          //     audioPlayer.play(widget.boarddata!.data!, isLocal: true);
          //   },
          // );
          //var myduration = getDuration(widget.boarddata!.data!, audioPlayer);
          //var duration = await audioPlayer.setUrl('file.mp3');
          return InkWell(
            onTap: () async {
              // if (startonce) {
              //   audioPlayer.play(widget.boarddata!.data!, isLocal: true);
              // }
              // !isPause ? audioPlayer.resume() : audioPlayer.pause();
              // startonce = true;
              // setState(() {
              //   isPause = (isPause == true) ? false : true;
              // });
              await playerController.preparePlayer(widget.boarddata!.data!);
              await playerController.startPlayer();
              setState(() {
                isPause = (isPause == true) ? false : true;
              });
              // audioPlayer.onPlayerCompletion.listen((event) {
              //   onComplete();
              //   setState(() {
              //     position = duration;
              //   });
              // });
              if (playerController.playerState == PlayerState.stopped) {
                // audioPlayer.onPlayerCompletion.listen((event) {
                setState(() {
                  isStop = true;
                  isPause = true;
                });
                // });
              }
            },
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    // FutureBuilder<int>(
//                     future: getDuration(widget.boarddata!.data!, audioPlayer),
//                     builder: (context, snapshot) {
//                       // print(snapshot.data);

//                       if (snapshot.hasData) {
//                         return TweenAnimationBuilder(
//                           tween: Tween(
//                             begin: 0.0,
//                             end: 1.0,
//                           ),
//                           duration: Duration(seconds: snapshot.data!),
//                           builder: (context, value, _) {
//                             // print(snapshot.data);
//                             return SizedBox(
//                               height: 60,
//                               width: 60,
//                               child: CircularProgressIndicator(
//                                 value: double.parse(value.toString()),
//                                 backgroundColor: Colors.grey,
//                                 strokeWidth: 6,
//                               ),
//                             );
//                           },
//                         );
//                       } else if (snapshot.hasError) {
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 16),
//                           child: Text(
//                             'Error: ${snapshot.error}',
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.white,
//                             ),
//                           ),
//                         );
//                       } else {
//                         return Padding(
//                           padding: EdgeInsets.only(top: 16),
//                           child: Text(
//                             'Awaiting result...',
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.white,
//                             ),
//                           ),
//                         );
//                       }

                    // SizedBox(
                    //   // height: 10,
                    //   width: 6,
                    // ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.only(
                          // topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          isPause ? Icons.play_arrow : Icons.pause,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Text(
                    //   'collapsed',
                    //   softWrap: true,
                    //   maxLines: 2,
                    //   style: TextStyle(color: Colors.transparent),
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        // borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: AudioFileWaveforms(
                        size: Size(
                          MediaQuery.of(context).size.width * 0.25,
                          MediaQuery.of(context).size.height * 0.12,
                        ),
                        playerController: playerController,
                      ),
                    ),
                    // tapHeaderToExpand: true,
                    // hasIcon: true,
                  ],
                ),
                Image.asset(
                  'assets/images/pin.png',
                  width: 13,
                  height: 13,
                ),
              ],
            ),
            onDoubleTap: () {
              // var boxofboarddata = BoxOfBoardData.getBoardData();
              // setState(() {
              //   boxofboarddata.delete();
              // });
              // set up the AlertDialog

              var alert = AlertDialog(
                title: Text("Do you want really want to delete it?"),
                //content: Text("You won't be able to "),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("Yes, delete"),
                    onPressed: () {
                      var boardcontroller = Provider.of<BoardStateController>(
                        context,
                        listen: false,
                      );
                      boardcontroller.removeBoardData(widget.boarddata!.key);
                      // var todocontroller = Provider.of<TaskController>(
                      //   context,
                      //   listen: false,
                      // );
                      // todocontroller.removeToDo(int.parse(allData[1]));
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          );
          // );
        }
        break;
      case 'quote':
        {
          // return StaggeredGridTile.count(
          //   crossAxisCellCount: 2,
          //   mainAxisCellCount: 2,
          // mainAxisCellCount:
          //     (quotesList[index1][kAuthor]).toString().length > 30
          //         ? 2
          //         : 1,
          return InkWell(
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
              // ),
            ),
            onLongPress: () {
              // var boxofboarddata = BoxOfBoardData.getBoardData();
              // setState(() {
              //   boxofboarddata.delete();
              // });
              // set up the AlertDialog

              var alert = AlertDialog(
                title: Text("Do you want really want to delete it?"),
                //content: Text("You won't be able to "),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("Yes, delete"),
                    onPressed: () {
                      var boardcontroller = Provider.of<BoardStateController>(
                        context,
                        listen: false,
                      );
                      boardcontroller.removeBoardData(widget.boarddata!.key);
                      // var todocontroller = Provider.of<TaskController>(
                      //   context,
                      //   listen: false,
                      // );
                      // todocontroller.removeToDo(int.parse(allData[1]));
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
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
          print('reminderdata[3]');
          print(reminderdata[3]!);
          print('reminderdata[4]');
          print(reminderdata[4]!);
          String? starttime = reminderdata[3];

          m.ReminderTask latestreminder = m.ReminderTask(
            title: reminderdata[0],
            note: reminderdata[1],
            date: dateinDateTime!,
            startTime: starttime,
            reminder: int.parse(reminderdata[4]!),
            repeat: reminderdata[5],
            alarm: reminderdata[6]! == 'true' ? true : false,
          );
          // return StaggeredGridTile.count(
          //   crossAxisCellCount: 2,
          //   mainAxisCellCount: 1,
          return InkWell(
            child: PinnedReminder(latestreminder!, 0, 0, context),
            onLongPress: () {
              // var boxofboarddata = BoxOfBoardData.getBoardData();
              // setState(() {
              //   boxofboarddata.delete();
              // });
              // set up the AlertDialog

              var alert = AlertDialog(
                title: Text("Do you want really want to delete it?"),
                //content: Text("You won't be able to "),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("Yes, delete"),
                    onPressed: () {
                      var boardcontroller = Provider.of<BoardStateController>(
                        context,
                        listen: false,
                      );
                      boardcontroller.removeBoardData(widget.boarddata!.key);
                      var remindercontroller = Provider.of<ReminderController>(
                        context,
                        listen: false,
                      );
                      remindercontroller
                          .removeReminder(int.parse(reminderdata[7]!));
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          );
          // );
        }
        break;

      default:
        return Container();
    }
  }

  Future<Widget> videothumbnail(videofile_path) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videofile_path!,
      imageFormat: ImageFormat.JPEG,
      maxWidth:
          128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.memory(
          uint8list!,
          fit: BoxFit.cover,
        ),
        Center(
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: MediaQuery.of(context).size.width * 0.2,
            shadows: [
              BoxShadow(
                blurRadius: 2.0,
                spreadRadius: 6,
                offset: Offset(2, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<int> getDuration(String s, audi.AudioPlayer audioPlayer) async {
  int duration = await audioPlayer.setUrl(s);
  return duration;
}

PinnedToDo(String? todotext, int index, int pinnedWidgetIndex) => Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 50,
          width: 110,
          child: Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 6.0, 4, 4),
                child: Text(
                  todotext!,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white70,
            image: DecorationImage(
              image: AssetImage('assets/images/todo_background.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10.0),
            // border: Border.all(
            //   color: Colors.black,
            //   width: 2.0,
            // ),
          ),
        ),
        Image.asset(
          'assets/images/pin.png',
          width: 13,
          height: 13,
        ),
      ],
    );
PinnedReminder(m.ReminderTask? task, int index, int pinnedWidgetIndex,
        BuildContext context) =>
    InkWell(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .3,
            height: MediaQuery.of(context).size.width * .13,
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
                image: AssetImage('assets/images/reminder_backgroud.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
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
      onDoubleTap: () {
        //boxofreminders.delete(index);
        // pinnedWidgets!.removeAt(pinnedWidgetIndex);
      },
    );

PinnedLink(String? url, String? description, int index, int pinnedWidgetIndex,
        context) =>
    Container(
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
        ],
      ),
      onDoubleTap: () {
        //boxofTextPage.delete(index);
        //pinnedWidgets!.removeAt(pinnedWidgetIndex);
      },
    );
