// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, avoid_print

//import 'dart:html';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:myboardapp/boxes.dart';
import 'package:myboardapp/components/custom_stack.dart';
import 'package:myboardapp/pages/myvideo.dart' as vid;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pinningtrialpackage/pinningtrialpackage.dart';
import '../components/round_image_button.dart';
import 'loginpage.dart' as loginpage;
import 'package:myboardapp/models/myboard.dart' as db;
// ignore: library_prefixes
import "package:myboardapp/services/google_sign_in.dart" as GSI;
import 'package:myboardapp/components/stack_board_board.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// Custom item type
class CustomItem extends StackBoardItem {
  const CustomItem({
    required this.color,
    Future<bool> Function()? onDel,
    int? id, // <==== must
  }) : super(
          child: const Text('CustomItem'),
          onDel: onDel,
          id: id, // <==== must
        );

  final Color? color;

  @override // <==== must
  CustomItem copyWith({
    CaseStyle? caseStyle,
    Widget? child,
    int? id,
    Future<bool> Function()? onDel,
    dynamic Function(bool)? onEdit,
    bool? tapToEdit,
    Color? color,
  }) =>
      CustomItem(
        onDel: onDel,
        id: id,
        color: color ?? this.color,
      );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const batteryChannel = MethodChannel('com.example.myboardapp/method');
  int newbatterylevel = 0;
  late final StackBoardController _boardController;
  Color trialcolor = Colors.lightGreenAccent;

  double screenHeight() {
    return MediaQuery.of(context).size.height;
  }

  double screenWidth() {
    return MediaQuery.of(context).size.width;
  }

  //list of widgets
  List<Widget> pinnedWidgets = [];

  //Screenshot controller
  final screenshotController = ScreenshotController();
  final gridviewcontroller = ScrollController();

  Future _checkConnection() async {
    final arguments = {'sumi': 'flutter'};
    try {
      int batterylevel =
          await batteryChannel.invokeMethod('isConnected', arguments);
      setState(() => batterylevel = newbatterylevel);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  var box;
  ValueNotifier<db.Images> myImages = ValueNotifier<db.Images>(db.Images());

  Future addImages(Uint8List imagesource, double height, double width) async {
    final localaddImages = db.Images()
      ..imagesource = imagesource
      ..height = height
      ..width = width;
    box = BoxesofImage.getImages();
    //ValueNotifier<db.Images?> myiamges = ValueNotifier(localaddImages);
    box.add(localaddImages);
  }

// FireBaseSt
  @override
  void initState() {
    super.initState();
    _boardController = StackBoardController();
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

  Future<File> saveFilePermanently(PlatformFile file) async {
    //final File file_File = File(file.path);
    //final PlatformFile file_PlatformFile = file;
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }

  Future<FilePickerResult> selectPhotoOrVideo() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpeg', 'png', 'gif', 'mp4', 'mkv']);
    // if (result != null) return ;

    final path = result!.files.first.path!;
    setState(() {
      file = File(path);
    });
    return result;
  }

  // Future uploadPhotoOrVideo() async {
  //   if (file == null) return;
  //
  //   final fileName = p.basename(file!.path);
  //   final destination = 'files/$fileName';
  //
  //   task = FirebaseApi.uploadFile(destination, file!);
  //   setState(() {});
  //   final snapshot = await task!.whenComplete(() {});
  //   urlDownload = await snapshot.ref.getDownloadURL();
  // }

  List<double> positioningCoordinates(
      bool imageOrVideo, double? width, double? height) {
    if (imageOrVideo) {
      var num;
      switch (num) {
        case 1: //image orientation: potrait
          {
            left = left + 100;
            if (left > 300) {
              top = top + 170;
              left = 10;
            }

            setState(() {});
            return [left, top];
          }
        case 2: //image orientation: landscape
          {
            left = left + 100;
            if (left > 300) {
              top = top + 170;
              left = 10;
            }
            setState(() {});
            return [left, top];
          }
        case 3: //image orientation: squarish
          {
            left = left + 100;
            if (left > 300) {
              top = top + 170;
              left = 10;
            }
            setState(() {});
            return [left, top];
          }
        default:
          {
            left = left + 100;
            if (left > 300) {
              top = top + 170;
              left = 10;
            }
            setState(() {});
            return [left, top];
          }
      }
    } else {
      left = left + 100;
      if (left > 300) {
        top = top + 170;
        left = 10;
      }
      setState(() {});
      return [left, top];
    }
  }

  Future<bool> _onDel() async {
    final bool? r = await showDialog<bool>(
      context: context,
      builder: (_) {
        return Center(
          child: SizedBox(
            width: 400,
            child: Material(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 60),
                      child: Text('Confirm Delete?'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                            onPressed: () => Navigator.pop(context, true),
                            icon: const Icon(Icons.check)),
                        IconButton(
                            onPressed: () => Navigator.pop(context, false),
                            icon: const Icon(Icons.clear)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    return r ?? false;
  }

  double left1 = 2.0;
  double top1 = 2.0;
  double left = -140.0;
  double top = 0.0;
  double left2 = 0.0;
  double top2 = 0.0;
  double left3 = 0.0;
  double top3 = 0.0;

  @override
  Widget build(BuildContext context) {
    var scaffoldKey;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 70.0,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Text(
              'MyBoard',
              style: GoogleFonts.smooch(
                color: Colors.black87,
                fontSize: 60,
              ),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text("Header"),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.tag_faces_rounded),
                title: Text("Contact us"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () async {
                  await GSI.GoogleSignInProvider().LogOut();
                  await FirebaseAuth.instance.signOut();
                  Get.off(loginpage.LogInPage());
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                      onPressed: () => scaffoldKey.currentState.openDrawer(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7.0, bottom: 5.0),
                child: Text(
                  'edit',
                  style: GoogleFonts.adamina(
                    color: Colors.black26,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(11.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87,
                        spreadRadius: 2.0,
                        blurRadius: 3.0,
                        offset: Offset(
                          2.0,
                          2.0,
                        ),
                      )
                    ],
                    border: Border.all(
                      color: Colors.black38,
                      width: 9.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.blue,
                  ),
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 14.0, 10.0, 14.0),
                    child: StaggeredGrid.count(
                      //staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      crossAxisCount: 6,
                      //itemCount: 50,
                      children: pinnedWidgets,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: () async {
                  showModalBottomSheet(
                      constraints: BoxConstraints(
                        maxHeight: screenHeight() * .8,
                      ),
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: GridView.count(
                            padding: EdgeInsets.fromLTRB(0.0, 22.0, 0.0, 0.0),
                            crossAxisCount: 2,
                            controller: gridviewcontroller,
                            children: [
                              buildCircleButton(
                                context,
                                'Photo',
                                'assets/images/photos.jpg',
                                () async {
                                  // selectPhotoOrVideo();
                                  // uploadPhotoOrVideo();
                                  final result = await FilePicker.platform
                                      .pickFiles(
                                          type: FileType.custom,
                                          allowMultiple: false,
                                          allowedExtensions: [
                                        'jpeg',
                                        'png',
                                        'gif'
                                      ]);
                                  final oneFile = result?.files.first;

                                  final legitfile =
                                      File(oneFile!.path.toString());
                                  print(oneFile.name);
                                  print(oneFile.extension);
                                  print(oneFile.path);
                                  print(oneFile.size);
                                  //Navigator.pushNamed(context, '/memories');
                                  // ImageProvider gotFile = Get.arguments();
                                  File finalImage =
                                      await saveFilePermanently(oneFile);
                                  print('from ' + oneFile.path.toString());
                                  print('to ' + finalImage.path);

                                  var decodedImage = await decodeImageFromList(
                                      finalImage.readAsBytesSync());
                                  double width = decodedImage.width.toDouble();
                                  double height =
                                      decodedImage.height.toDouble();
                                  pinnedWidgets.add(
                                    StaggeredGridTile.count(
                                      crossAxisCellCount:
                                          width > height ? 3 : 2,
                                      mainAxisCellCount: width < height ? 3 : 2,
                                      child: Image.file(finalImage),
                                    ),
                                  );
                                  //positioningCoordinates(true, width, height);
                                  setState(
                                    () {},
                                  );
                                },
                              ),
                              buildCircleButton(
                                context,
                                'Video',
                                'assets/images/video.jpg',
                                () async {
                                  //Navigator.pushNamed(context, '/video');

                                  PlatformFile localfile =
                                      await vid.pickVideoFile();

                                  //final myvideo = await vid.saveFilePermanently(localfile);

                                  setState(
                                    () async {
                                      // final myimage = box.values.toList().cast<db.Images>();
                                      //var myimage = BoxesofImage.getImages;
                                      //print(myimage.toString());

                                      final myvideo = await vid
                                          .saveFilePermanently(localfile);

                                      _boardController.add(StackBoardItem(
                                        // child: Image.file(finalImage),
                                        child: Text(myvideo.toString()),
                                      ));
                                    },
                                  );
                                },
                              ),
                              buildCircleButton(
                                context,
                                'Voice to Text',
                                'assets/images/voicetotext.png',
                                () {
                                  Navigator.pushNamed(context, '/voicetotext');
                                },
                              ),
                              buildCircleButton(
                                context,
                                'ToDo',
                                'assets/images/todo.png',
                                () {
                                  Navigator.pushNamed(context, '/todo');
                                },
                              ),
                              buildCircleButton(
                                context,
                                'Reminders',
                                'assets/images/reminder.jpg',
                                () {
                                  Navigator.pushNamed(context, '/reminder');
                                },
                              ),
                              buildCircleButton(
                                context,
                                'Links',
                                'assets/images/links.png',
                                () {
                                  Navigator.pushNamed(context, '/links');
                                },
                              ),
                              buildCircleButton(context, 'Text',
                                  'assets/images/text.png', () {}),
                              buildCircleButton(
                                  context, 'Quotes', 'assets/images/text.png',
                                  () {
                                Navigator.pushNamed(context, '/quotes');
                              }),
                              buildCircleButton(
                                context,
                                'Audio',
                                'assets/images/audio.jpg',
                                () {
                                  Navigator.pushNamed(context, '/audio');
                                },
                              ),
                              buildCircleButton(
                                context,
                                'Scribble',
                                'assets/images/scribble.jpg',
                                () {
                                  _boardController.add(
                                    StackBoardItem(
                                      child: const Text(
                                        'Custom Widget',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onDel: _onDel,
                                      // caseStyle: const CaseStyle(initOffset: Offset(100, 100)),
                                    ),
                                  );
                                },
                              ),
                              // buildCircleButton(context, 'Video',
                              // 'assets/images/video.jpg', () {}),
                            ],
                          ),
                        );
                      });
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        width: screenWidth(),
                        height: screenHeight() * .07,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          color: Color.fromARGB(255, 161, 160, 160),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: screenWidth() * 0.88,
                        height: screenHeight() * .042,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: const Color.fromARGB(255, 197, 197, 197),
                        ),
                        child: const Text(
                          'Add Photo, Video, Link,...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names

  Widget get _spacer => const SizedBox(width: 5);

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();

    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);

    return result['filepath'];
  }
}

void openFile(File file) {
  Dialog(
    child: Image.file(file),
  );
}
