// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, avoid_print, unused_import, avoid_unnecessary_containers

//import 'dart:html';
import 'dart:math';
import 'dart:typed_data';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:myboardapp/boxes.dart';
import 'package:myboardapp/main.dart';
import 'package:myboardapp/pages/imageControlller.dart';
import 'package:myboardapp/pages/links.dart';
import 'package:myboardapp/pages/myvideo.dart' as vid;
import 'package:myboardapp/pages/quotes/quotes.dart';
import 'package:myboardapp/pages/remind/controller/task_controller.dart';
import 'package:myboardapp/pages/remind/notificationAPI2.dart';
import 'package:myboardapp/pages/remind/notificationApi.dart';
import 'package:myboardapp/pages/remind/reminder.dart';
import 'package:myboardapp/pages/settingspage.dart';
import 'package:myboardapp/pages/text.dart';
import 'package:myboardapp/pages/todo.dart';
import 'package:myboardapp/pages/video.dart';
import 'package:myboardapp/pages/voicetotext.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
// import 'package:pinningtrialpackage/pinningtrialpackage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import '../components/innerShadow.dart';
import '../components/round_image_button.dart';
import 'package:myboardapp/models/myboard.dart' as db;
import 'package:myboardapp/models/myboard.dart' as m;
import 'audio.dart';
import 'boardState.dart';
import 'boardState/BoardDataList.dart';
import 'Documents/documents.dart';
import 'todo.dart';
import 'background.dart';
import 'dart:math' as math;
import 'package:stack_board/stack_board.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
// List<Widget>? pinnedWidgets;

class HomePage extends StatefulWidget {
  HomePage({Key? gridviewKey}) : super(key: gridviewKey);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SolidController _controller = SolidController();

  static const batteryChannel = MethodChannel('com.example.myboardapp/method');
  int newbatterylevel = 0;
  StackBoardController _boardController = StackBoardController();
  Color trialcolor = Colors.lightGreenAccent;

  // List<Widget> scribble_list =
  var height_multiplier = 0.0001;

  var width_multiplier = 0.0001;

  //list of widgets

  //Screenshot controller
  final screenshotController = ScreenshotController();
  final gridviewcontroller = ScrollController();

  // Future _checkConnection() async {
  //   final arguments = {'sumi': 'flutter'};
  //   try {
  //     int batterylevel =
  //         await batteryChannel.invokeMethod('isConnected', arguments);
  //     setState(() => batterylevel = newbatterylevel);
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  // }

  var box;
  ValueNotifier<db.Images> myImages = ValueNotifier<db.Images>(db.Images());
  ValueNotifier<m.ToDo> myToDos = ValueNotifier<m.ToDo>(m.ToDo());

  Future addImages(String? imagesource) async {
    final localaddImages = db.Images()..imagesource = imagesource,
        box = BoxofImage.getImages();
    //ValueNotifier<db.Images?> myiamges = ValueNotifier(localaddImages);
    box.add(localaddImages);
  }

// FireBaseSt
  @override
  void initState() {
    super.initState();
    _boardController = StackBoardController();

    //NotificationApi.init();
    // Provider.of<NotificationService>(context, listen: false).initialize();
  }

  @override
  void dispose() {
    _boardController.dispose();
    super.dispose();
  }

  File? file;
  UploadTask? task;
  String? urlDownload;

  dynamic path;

  Future saveFilePermanently(PlatformFile file) async {
    //final File file_File = File(file.path);
    //final PlatformFile file_PlatformFile = file;
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');

    return [
      File(file.path!).copy(newFile.path),
      '${appStorage.path}/${file.name}'
    ];
  }

  Future<FilePickerResult> selectPhotoOrVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpeg', 'png', 'gif', 'mp4', 'mkv'],
    );
    //if (result != null) return ;

    final path = result!.files.first.path!;
    setState(() {
      file = File(path);
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight() {
      return MediaQuery.of(context).size.height;
    }

    double screenWidth() {
      return MediaQuery.of(context).size.width;
    }

    Future<String?> getStringFromSharedPref() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('imgurl');
    }

    BackgroundController imageController =
        Provider.of<BackgroundController>(context, listen: false);
    var scaffoldKey;
    final box = BoxOfBackgroundImage.getBgImage();
    box.add(m.BackgroundImage(
        imgurl:
            'https://media.navyasfashion.com/catalog/product/cache/184a226590f48e7f268fa34c124ed9e1/_/d/_dsc0087.jpg'));
    var latestImage = box.getAt(box.length > 0 ? box.length - 1 : 0);

    // var imgPath = latestImage!.imgurl;
    // var imgPath = imageController.imgLink;
    // var myimage = imgPath

    // var boardprovider = Provider.of<BoardStateController>(context);
    var boxofboarddata = BoxOfBoardData.getBoardData();
    Key containerKey;
    bool should_be_visible = false;

    return ColorfulSafeArea(
      overflowRules: OverflowRules.all(true),
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            key: scaffoldKey,
            // appBar: AppBar(
            //   toolbarHeight: 80.0,
            //   actions: [
            //     IconButton(
            //       icon: Icon(Icons.delete),
            //       onPressed: () {
            //         setState(() {
            //           pinnedWidgets.clear();
            //         });
            //       },
            //     ),
            //   ],
            //   centerTitle: true,
            //   title: Padding(
            //     padding: const EdgeInsets.only(top: 35.0),
            //     child: Text(
            //       'MYBOARD',
            //       style: GoogleFonts.italiana(
            //         color: Colors.black87,
            //         fontSize: screenHeight() * 0.05,
            //       ),
            //     ),
            //   ),
            //   backgroundColor: Color.fromARGB(255, 255, 255, 255),
            //   elevation: 0.0,
            //   iconTheme: IconThemeData(color: Colors.black),
            // ),
            appBar: AppBar(
              toolbarHeight: 80.0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'MyBoard',
                    style: GoogleFonts.montserratAlternates(
                      color: Colors.black87,
                      fontSize: screenHeight() * 0.055,
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  IconButton(
                    icon: Icon(Icons.ios_share_sharp),
                    onPressed: () async {
                      // final image = screenshotController
                      //     .captureFromWidget(board(
                      //   imageController: imageController,
                      //   height: MediaQuery.of(context).size.height,
                      //   width: MediaQuery.of(context).size.width,
                      // ));
                      final image = await screenshotController.capture(
                          // pixelRatio: 1000,
                          delay: Duration(
                        microseconds: 100,
                      ));
                      final imagepath = await saveAndShare(image!);
                      // int location = WallpaperManager.HOME_SCREEN;
                      // var result =
                      //     await WallpaperManager.setWallpaperFromAsset(
                      //         imagepath, location);
                    },
                  ),
                ],
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            drawer: Drawer(
              backgroundColor: Colors.grey.shade300,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    // decoration: BoxDecoration(color: Colors.grey.shade300),
                    child: Container(
                      color: Colors.blueGrey,
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "MYBOARD",
                              style: GoogleFonts.italiana(
                                color: Colors.white,
                                fontSize: 35.0,
                              ),
                            ),
                            Text(
                              "Extras",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.change_circle_sharp),
                    title: Text("Change Background"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Background()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete_forever),
                    title: Text("Reset Board"),
                    onTap: () {
                      setState(() {
                        Provider.of<BoardStateController>(context,
                                listen: false)
                            .emptyBoardData();
                        Provider.of<ImageController>(context, listen: false)
                            .emptyImage();
                        Provider.of<TaskController>(context, listen: false)
                            .emptyToDo();
                        Provider.of<ReminderController>(context, listen: false)
                            .emptyReminder();
                        Provider.of<LinksController>(context, listen: false)
                            .emptyLink();
                        Provider.of<AudioController>(context, listen: false)
                            .emptyAudio();
                        // Provider.of<VoiceToTextController>(context, listen: false)
                        //     .emptyVoiceToText();
                        Provider.of<TextPageController>(context, listen: false)
                            .emptyText();
                        Provider.of<DocumentsController>(context, listen: false)
                            .emptyDocument();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.delete_forever),
                  //   title: Text("Wipe all data"),
                  //   onTap: () {
                  //     setState(() {
                  //       Provider.of<BoardStateController>(context, listen: false)
                  //           .emptyBoardData();
                  //       Provider.of<ImageController>(context, listen: false)
                  //           .emptyImage();
                  //       Provider.of<TaskController>(context, listen: false)
                  //           .emptyToDo();
                  //       Provider.of<ReminderController>(context, listen: false)
                  //           .emptyReminder();
                  //       Provider.of<LinksController>(context, listen: false)
                  //           .emptyLink();
                  //       Provider.of<AudioController>(context, listen: false)
                  //           .emptyAudio();
                  //     });
                  //   },
                  // ),
                  ListTile(
                    leading: Icon(Icons.tag_faces_rounded),
                    title: Text("Contact us"),
                    onTap: () {},
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.logout),
                  //   title: Text("Logout"),
                  //   onTap: () async {
                  //     await GSI.GoogleSignInProvider().LogOut();
                  //     await FirebaseAuth.instance.signOut();
                  //     Get.off(loginpage.LogInPage());
                  //   },
                  // ),
                ],
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // boxofboarddata.isNotEmpty
                  //     ? (boxofboarddata.length > 0)
                  //         ? GestureDetector(
                  //             onTap: () async {
                  //               // final image = await screenshotController
                  //               //     .captureFromWidget(board(
                  //               //   imageController: imageController,
                  //               //   height: MediaQuery.of(context).size.height,
                  //               //   width: MediaQuery.of(context).size.width,
                  //               // ));
                  //               final image = await screenshotController.capture(
                  //                   // pixelRatio: 1000,
                  //                   delay: Duration(
                  //                 microseconds: 100,
                  //               ));
                  //               final imagepath = await saveAndShare(image!);
                  //               // int location = WallpaperManager.HOME_SCREEN;
                  //               // var result =
                  //               //     await WallpaperManager.setWallpaperFromAsset(
                  //               //         imagepath, location);
                  //               var extendedfile = ExtendedImage.file(
                  //                 File(imagepath),
                  //                 width: MediaQuery.of(context).size.width,
                  //                 height: MediaQuery.of(context).size.height,
                  //                 fit: BoxFit.scaleDown,
                  //               );
                  //               int location = WallpaperManagerFlutter.HOME_SCREEN;
                  //               print(imagepath);
                  //               var result =
                  //                   WallpaperManagerFlutter().setwallpaperfromFile(
                  //                       // File(imagepath), location);
                  //                       extendedfile,
                  //                       location);
                  //             },
                  //             child: Container(
                  //               color: Colors.amber,
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Text('Set as home screen wallpaper'),
                  //               ),
                  //             ),
                  //           )
                  //         : SizedBox(
                  //             height: 0.000001,
                  //           )
                  //     : SizedBox(
                  //         height: 0.000001,
                  //       ),
                  Stack(
                    children: [
                      Center(
                          child: Column(
                        children: <Widget>[],
                      )),
                      Positioned(
                        left: 10,
                        top: 20,
                        child: IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () =>
                              scaffoldKey.currentState.openDrawer(),
                        ),
                      ),
                    ],
                  ),
                  // board(
                  //   imageController: imageController,
                  //   height: MediaQuery.of(context).size.height,
                  //   width: MediaQuery.of(context).size.width,
                  // ),
                  Consumer<BackgroundController>(
                    builder: ((context, value, child) {
                      return Stack(
                        children: [
                          Screenshot(
                            controller: screenshotController,
                            child: Container(
                              clipBehavior: Clip.hardEdge,

                              // key: containerKey,
                              // decoration: imglink.isNotEmpty ? networkimg : localimg,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  // BoxShadow(
                                  //   color: your_shadow_color,
                                  // ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 3.0,
                                    blurRadius: 3.0,
                                    offset: Offset(
                                      2.0,
                                      2.0,
                                    ),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.5),
                                  width: 8.0,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(value.imgLink.imgurl ??
                                      'https://media.navyasfashion.com/catalog/product/cache/184a226590f48e7f268fa34c124ed9e1/_/d/_dsc0087.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: MediaQuery.of(context).size.height * 0.75,
                              width: MediaQuery.of(context).size.width * 0.93,
                              child:
                                  BoardDataList(), ////****************************************************BOARD DATA LIST**** */
                            ),
                          ),
                          Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    height_multiplier,
                                width: MediaQuery.of(context).size.width *
                                    width_multiplier,
                                child: StackBoard(
                                  controller: _boardController,
                                  background: const ColoredBox(
                                      color: Colors.transparent),
                                ),
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: should_be_visible
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                ),
                                onTap: () {
                                  height_multiplier = 0.0001;
                                  width_multiplier = 0.0001;
                                  // bin_color = Colors.transparent;
                                  should_be_visible = false;
                                  setState(() {});
                                  print('ontap of delete icon');
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            bottomSheet: SolidBottomSheet(
              // draggableBody: true,
              controller: _controller,
              maxHeight: screenHeight() * .65,
              headerBar: Container(
                // color: Colors.grey,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      "Swipe me",
                      style: TextStyle(
                        // backgroundColor: Colors.grey.shade100,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade400,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
              ),
              body: Container(
                child: GridView.count(
                  padding: EdgeInsets.fromLTRB(0.0, 22.0, 0.0, 0.0),
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 3,
                  controller: gridviewcontroller,
                  children: [
                    buildCircleButton(
                      context,
                      'Document',
                      'assets/images/docfinal.jpg',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => Documents()),
                          ),
                        );
                      },
                    ),
                    buildCircleButton(context, 'Text', 'assets/images/text.png',
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => TextPage())));
                      setState(() {});
                    }),

                    buildCircleButton(
                      context,
                      'ToDo',
                      'assets/images/todo_final.jpg',
                      () async {
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ToDo()));
                        // if (ifVisited) {
                        //   final box = BoxOfToDos.getToDos();
                        //   final latesttodo =
                        //       box.getAt(box.length - 1);

                        //   pinnedWidgets.add(
                        //     StaggeredGridTile.count(
                        //       crossAxisCellCount: 2,
                        //       mainAxisCellCount: 1,
                        //       child: Text(
                        //         latesttodo.toString(),
                        //         style: TextStyle(
                        //             fontSize: 10.0,
                        //             color: Colors.white),
                        //       ),
                        //     ),
                        //   );
                        // }
                      },
                    ),
                    buildCircleButton(
                      context,
                      'Reminders',
                      'assets/images/remindersfinal.jpg',
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Reminder()));
                      },
                    ),
                    buildCircleButton(
                      context,
                      'Photo',
                      'assets/images/photosfinal.jpg',
                      () async {
                        // selectPhotoOrVideo();
                        // uploadPhotoOrVideo();
                        final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowMultiple: false,
                            allowedExtensions: ['jpeg', 'png', 'gif']);
                        final oneFile = result?.files.first;

                        final legitfile = File(oneFile!.path.toString());
                        print(oneFile.name);
                        print(oneFile.extension);
                        print(oneFile.path);
                        print(oneFile.size);
                        //Navigator.pushNamed(context, '/memories');
                        // ImageProvider gotFile = Get.arguments();
                        var finalImage = await saveFilePermanently(oneFile);
                        print('from ' + oneFile.path.toString());
                        print('to ' + finalImage[1]);

                        // var decodedImage = await decodeImageFromList(
                        //     finalImage[0].readAsBytesSync());
                        // double width = decodedImage.width.toDouble();
                        // double height =
                        //     decodedImage.height.toDouble();
                        // pinnedWidgets!.add(
                        //   StaggeredGridTile.count(
                        //     crossAxisCellCount:
                        //         width > height ? 3 : 2,
                        //     mainAxisCellCount: width < height ? 3 : 2,
                        //     child: Stack(
                        //       alignment: Alignment.topCenter,
                        //       children: [
                        //         Container(
                        //           child: Image.file(finalImage),
                        //           decoration:
                        //               BoxDecoration(boxShadow: [
                        //             BoxShadow(
                        //               blurRadius: 3.0,
                        //               spreadRadius: 0.5,
                        //               offset: Offset(1, 1),
                        //             ),
                        //           ]),
                        //         ),
                        //         Image.asset(
                        //           'assets/images/pin.png',
                        //           width: 13,
                        //           height: 13,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // );
                        m.Images previousImagePaths;
                        var _repeated = false;
                        // for (previousImagePaths in boxofImages.toMap().values) {
                        if (boxofImages.length > 0) {
                          for (var index = 0;
                              index < boxofImages.length;
                              index++) {
                            print(finalImage[1].trim());
                            print((boxofImages
                                .getAt(index)!
                                .imagesource!
                                .trim()));
                            print(boxofImages
                                .getAt(index)!
                                .imagesource!
                                .split('/')[6]);
                            print((finalImage[1].trim()).contains(boxofImages
                                .getAt(index)!
                                .imagesource!
                                .split('/')[6]));

                            // boxofImages.getAt(index)!.imagesource!.trim()));

                            if ((finalImage[1].trim()).contains(boxofImages
                                .getAt(index)!
                                .imagesource!
                                .split('/')[6])) {
                              print(
                                  '${finalImage[1]} == ${boxofImages.getAt(index)!.imagesource}');
                              setState(() {
                                _repeated = true;
                              });
                            }
                          }
                        }
                        print('_repeated = $_repeated');
                        if (!_repeated) {
                          Provider.of<ImageController>(context, listen: false)
                              .addImage(
                            m.Images(
                              imagesource: finalImage[1],
                            ),
                          );

                          var latestImage =
                              boxofImages.getAt(boxofImages.length - 1);
                          Provider.of<BoardStateController>(context,
                                  listen: false)
                              .addBoardData(
                            m.BoardData(
                              position: BoxOfBoardData.getBoardData().length,
                              data: '${finalImage[1]}*${latestImage!.key}',
                              isDone: false,
                              type: 'image',
                            ),
                          );
                          //positioningCoordinates(true, width, height);
                          setState(
                            () {},
                          );
                        } else {
                          Get.snackbar('Oops', 'Item already on board');
                        }

                        Navigator.pop(context);

                        // print(pinnedWidgets!);
                        // print(pinnedWidgets![0]);
                      },
                    ),
                    buildCircleButton(
                      context,
                      'Video',
                      'assets/images/video_new.jpg',
                      () async {
                        //Navigator.pushNamed(context, '/video');

                        PlatformFile localfile = await vid.pickVideoFile();
                        var videopath = localfile.path;
                        print('Video picked path: $videopath');
                        var videobox = BoxOfVideos.getVideos();
                        videobox.add(m.Video(
                          videosource: videopath,
                        ));
                        print(videobox.keys);
                        // pinnedWidgets!.add(
                        //   StaggeredGridTile.count(
                        //     crossAxisCellCount: 2,
                        //     mainAxisCellCount: 2,
                        //     child: InkWell(
                        //       onTap: (() {
                        //         print('tap on video catched');
                        //         print(localfile.path.toString());
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: ((context) => Video(
                        //                 localfile_path:
                        //                     localfile.path)),
                        //           ),
                        //         );
                        //       }),
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Stack(
                        //           alignment: Alignment.topCenter,
                        //           children: [
                        //             Container(
                        //               child: Text(
                        //                 'video link; ${videopath.toString()}',
                        //                 style: TextStyle(
                        //                   color: Colors.white,
                        //                 ),
                        //               ),
                        //               // child: Image.file(
                        //               //     File(videopath.toString())),
                        //               decoration:
                        //                   BoxDecoration(boxShadow: [
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
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // );
                        Provider.of<BoardStateController>(context,
                                listen: false)
                            .addBoardData(
                          m.BoardData(
                            position: BoxOfBoardData.getBoardData().length,
                            data: videopath.toString(),
                            isDone: false,
                            type: 'video',
                          ),
                        );
                        setState(
                          () {},
                        );
                      },
                    ),

                    buildCircleButton(
                      context,
                      'Audio',
                      'assets/images/audio_new.png',
                      () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyAudio()));
                      },
                    ),

                    buildCircleButton(
                      context,
                      'Links',
                      'assets/images/linksfinal.jpg',
                      () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Links()));
                      },
                    ),
                    buildCircleButton(
                        context, 'Quotes', 'assets/images/quotes_new.png', () {
                      print(DateTime.now().toString());

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Quotes()));
                    }),
                    buildCircleButton(
                      context,
                      'Scribble',
                      'assets/images/scribblefinal.jpg',
                      () {
                        _boardController.add(
                          const StackDrawing(
                            caseStyle: CaseStyle(
                              borderColor: Colors.grey,
                              iconColor: Colors.white,
                              boxAspectRatio: 1,
                            ),
                          ),
                        );
                        height_multiplier = 0.75;
                        width_multiplier = .93;
                        // bin_color = Colors.white;
                        should_be_visible = true;

                        setState(() {});
                        Navigator.pop(context);
                      },
                    ),
                    // buildCircleButton(context, 'Video',
                    // 'assets/images/video.jpg', () {}),
                  ],
                ),
              ),
            )),
      ),
    );
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

  // ignore: non_constant_identifier_names

  Widget get _spacer => const SizedBox(width: 5);

  // Future<String> saveImage(String? bytes) async {
  //   await [Permission.storage].request();

  //   final time = DateTime.now()
  //       .toIso8601String()
  //       .replaceAll('.', '-')
  //       .replaceAll(':', '-');
  //   final name = 'screenshot_$time';
  //   final result = await ImageGallerySaver.saveImage(bytes, name: name);

  //   return result['filepath'];
  // }
}

class board extends StatefulWidget {
  // final Key? containerKey;
  final BackgroundController? imageController;
  final double? height;
  final double? width;

  const board({
    Key? key,
    this.imageController,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  State<board> createState() => _boardState();
}

class _boardState extends State<board> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        // key: containerKey,
        // decoration: imglink.isNotEmpty ? networkimg : localimg,
        decoration: BoxDecoration(
          boxShadow: [
            // BoxShadow(
            //   color: your_shadow_color,
            // ),
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3.0,
              blurRadius: 3.0,
              offset: Offset(
                2.0,
                2.0,
              ),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black.withOpacity(0.5),
            width: 8.0,
          ),
          image: DecorationImage(
            image: NetworkImage(widget.imageController!.imgLink.imgurl!),
            fit: BoxFit.cover,
          ),
        ),
        height: widget.height! * 0.75,
        width: widget.width! * 0.93,
        child:
            BoardDataList(), ////******************************************************** */
      ),
    );
  }
}

Future<String> saveAndShare(Uint8List bytes) async {
  final directory = await getApplicationDocumentsDirectory();
  final image = File('${directory.path}/flutter.png');
  image.writeAsBytesSync(bytes);

  final text = 'Shared From MyBoard';
  await Share.shareFiles([image.path], text: text);
  return '${directory.path}/flutter.png';
}

Future<String> saveImage(Uint8List bytes) async {
  await [Permission.storage].request();

  final time = DateTime.now()
      .toIso8601String()
      .replaceAll('.', '-')
      .replaceAll(':', '-');
  final name = 'screenshot_$time';
  final result = await ImageGallerySaver.saveImage(bytes, name: name);

  return result['filePath'];
}

void openFile(File file) {
  Dialog(
    child: Image.file(file),
  );
}

// var localimg = BoxDecoration(
//   image: DecorationImage(
//       // image: NetworkImage(
//       //   'https://media.istockphoto.com/photos/blue-color-velvet-texture-background-picture-id587220352?b=1&k=20&m=587220352&s=170667a&w=0&h=aznCAcatYJ2kORIffDkNOVD3QWezdkd-d-X8Ms9DCss=',
//       // ),
//       image: ExactAssetImage('assets/images/board.jpg'),
//       fit: BoxFit.cover),
//   boxShadow: [
//     BoxShadow(
//       color: Colors.black87,
//       spreadRadius: 2.0,
//       blurRadius: 3.0,
//       offset: Offset(
//         2.0,
//         2.0,
//       ),
//     )
//   ],
//   border: Border.all(
//     color: Colors.black38,
//     width: 9.0,
//   ),
//   borderRadius: BorderRadius.circular(20.0),
//   color: Colors.blue,
// );

// var networkimg = BoxDecoration(
//   image: DecorationImage(
//       image: NetworkImage(

//       ),
//       fit: BoxFit.cover),
//   boxShadow: [
//     BoxShadow(
//       color: Colors.black87,
//       spreadRadius: 2.0,
//       blurRadius: 3.0,
//       offset: Offset(
//         2.0,
//         2.0,
//       ),
//     )
//   ],
//   border: Border.all(
//     color: Colors.black38,
//     width: 9.0,
//   ),
//   borderRadius: BorderRadius.circular(20.0),
//   color: Colors.blue,
// );
