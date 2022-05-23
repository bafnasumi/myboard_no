// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, avoid_print

//import 'dart:html';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:myboardapp/boxes.dart';
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
import 'loginpage.dart' as loginpage;
import 'package:myboardapp/models/myboard.dart' as db;
// ignore: library_prefixes
import "package:myboardapp/services/google_sign_in.dart" as GSI;
import 'package:myboardapp/components/stack_board_board.dart';

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

  //list of widgets
  List<Widget> pinnedWidgets = [];

  //Screenshot controller
  final screenshotController = ScreenshotController();

  AddPin(String textt, VoidCallback onPressed, ImageProvider givenimage) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            height: MediaQuery.of(context).size.height * .18,
            width: MediaQuery.of(context).size.width * .2,

            //padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              image: DecorationImage(image: givenimage, fit: BoxFit.cover),
              color: Color.fromARGB(255, 117, 117, 117),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Text(
              '$textt',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

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
  double left = 0.0;
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
              'MyBoard $newbatterylevel',
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
            // ignore: prefer_const_literals_to_create_immutables
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
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Screenshot"),
                onTap: () {
                  Navigator.pushNamed(context, '/screenshots');
                },
              ),
            ],
          ),
        ),
        //drawer: Drawer(child: ListView()),
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
              Stack(
                alignment: Alignment.topRight,
                children: [
                  //personalBoard(context, _boardController),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    color: Colors.green,
                    width: double.infinity,
                    child: Screenshot(
                      controller: screenshotController,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Stack(
                          children: pinnedWidgets,
                          // children: [
                          //   Positioned(
                          //     left: left,
                          //     top: top,
                          //     child: GestureDetector(
                          //       onPanUpdate: (details) {
                          //         left = max(0, left + details.delta.dx);
                          //         top = max(0, top + details.delta.dy);
                          //         setState(() {});
                          //       },
                          //       onTap: () {},
                          //       child: Container(
                          //         height: 50,
                          //         width: 50,
                          //         color: Colors.red,
                          //       ),
                          //     ),
                          //   ),
                          //   Positioned(
                          //     left: left1,
                          //     top: top1,
                          //     child: GestureDetector(
                          //       onPanUpdate: (details) {
                          //         left1 = max(0, left1 + details.delta.dx);
                          //         top1 = max(0, top1 + details.delta.dy);
                          //         setState(() {});
                          //       },
                          //       onTap: () {},
                          //       child: Container(
                          //         height: 50,
                          //         width: 50,
                          //         color: Colors.yellowAccent,
                          //       ),
                          //     ),
                          //   ),
                          //   Positioned(
                          //     left: left2,
                          //     top: top2,
                          //     child: GestureDetector(
                          //       onPanUpdate: (details) {
                          //         left2 = max(0, left2 + details.delta.dx);
                          //         top2 = max(0, top2 + details.delta.dy);
                          //         setState(() {});
                          //       },
                          //       onTap: () {},
                          //       child: Container(
                          //         height: 50,
                          //         width: 50,
                          //         color: Colors.green,
                          //       ),
                          //     ),
                          //   ),
                          //   Positioned(
                          //     left: left3,
                          //     top: top3,
                          //     child: GestureDetector(
                          //       onPanUpdate: (details) {
                          //         left3 = max(0, left3 + details.delta.dx);
                          //         top3 = max(0, top3 + details.delta.dy);
                          //         setState(() {});
                          //       },
                          //       onTap: () {},
                          //       child: Container(
                          //         height: 50,
                          //         width: 50,
                          //         color: Colors.pink,
                          //       ),
                          //     ),
                          //   ),
                          //   ListView.builder(
                          //     itemBuilder: (context, index) {
                          //       return GestureDetector();
                          //     },
                          //     itemCount: widgetlist.length,
                          //   )
                          // ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () async {
                        final ss = await screenshotController.capture();
                        print(ss);
                        final File ss_file = File.fromRawPath(ss!);
                        final String filepath = await saveImage(ss);
                        print('path os ss file: $filepath');
                        //await saveFilePermanently(ss_platform_file);
                      },
                      icon: Icon(
                        Icons.done_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: () async {
                  showModalBottomSheet(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * .8,
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
                          child: ListView(
                            //TODO: Convert Wrap into GridView
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .04,
                              ),
                              // SizedBox(
                              //   height: MediaQuery.of(context).size.height * .01,
                              // ),
                              Row(
                                children: [
                                  AddPin('Photo and Screenshots', () async {
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

                                    pinnedWidgets.add(
                                      Positioned(
                                        left: left,
                                        top: top,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onPanUpdate: (details) {
                                            left =
                                                max(0, left + details.delta.dx);
                                            top =
                                                max(0, top + details.delta.dy);
                                            setState(() {
                                              pinnedWidgets;
                                            });
                                          },
                                          onTap: () {},
                                          child: Container(
                                            height: 100,
                                            width: 60,
                                            color: Colors.red,
                                            child: Image.file(finalImage),
                                          ),
                                        ),
                                      ),
                                    );

                                    setState(
                                      () {
                                        // final myimage = box.values.toList().cast<db.Images>();
                                        //var myimage = BoxesofImage.getImages;
                                        //print(myimage.toString());
                                        // _boardController.add(StackBoardItem(
                                        //   child: Image.file(finalImage),
                                        // ));
                                      },
                                    );

                                    // print(yesfile);
                                    // if (pickedPicture != null) {
                                    //   var fileBytes =
                                    //       pickedPicture.files.first.bytes!;
                                    //   String fileName =
                                    //       pickedPicture.files.first.name;

                                    // Upload file

                                    // await FirebaseStorage.instance
                                    //     .ref('uploads/$fileName')
                                    //     .putData(fileBytes);
                                    //}
                                  }, AssetImage('assets/images/photos.png')),
                                ],
                              ),
                              Divider(
                                height:
                                    MediaQuery.of(context).size.height * .02,
                              ),
                              Row(
                                children: [
                                  AddPin(
                                    'Text',
                                    () {
                                      pinnedWidgets.add(GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        // onPanUpdate: (details) {
                                        //   left1 = max(
                                        //       0, left1 + details.delta.dx);
                                        //   top1 =
                                        //       max(0, top1 + details.delta.dy);
                                        //   setState(() {});
                                        // },
                                        onTap: () {
                                          trialcolor = Colors.blue;
                                        },
                                        child: Container(
                                          height: 150,
                                          width: 50,
                                          color: trialcolor,
                                        ),
                                      ));

                                      // _boardController.add(
                                      //   const AdaptiveText(
                                      //     'Enter text here',
                                      //     tapToEdit: true,
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.bold),
                                      //   ),
                                      // );
                                    },
                                    AssetImage('assets/images/text.png'),
                                  ),
                                  AddPin(
                                    'Video',
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

                                          // final result = await FilePicker.platform
                                          //     .pickFiles(
                                          //         type: FileType.custom,
                                          //         allowMultiple: false,
                                          //         allowedExtensions: [
                                          //       'mp4',
                                          //       'mkv',
                                          //       'heic'
                                          //     ]);
                                          // final oneFile = result?.files.first;

                                          // final legitfile =
                                          //     File(oneFile!.path.toString());
                                          // print(oneFile.name);
                                          // print(oneFile.extension);
                                          // print(oneFile.path);
                                          // print(oneFile.size);
                                          // //Navigator.pushNamed(context, '/memories');
                                          // // ImageProvider gotFile = Get.arguments();
                                          // File finalImage =
                                          //     await saveFilePermanently(oneFile);
                                          // print('from ' + oneFile.path.toString());
                                          // print('to ' + finalImage.path);
                                          // setState(
                                          //   () {
                                          //     // final myimage = box.values.toList().cast<db.Images>();
                                          //     //var myimage = BoxesofImage.getImages;
                                          //     //print(myimage.toString());
                                          //     _boardController.add(StackBoardItem(
                                          //       // child: Image.file(finalImage),
                                          //       child: Text('VIdeo will come here'),
                                          //     ));
                                          //   },
                                          // );
                                        },
                                      );
                                    },
                                    AssetImage('assets/images/video.jpg'),
                                  ),
                                ],
                              ),
                              Divider(
                                height:
                                    MediaQuery.of(context).size.height * .02,
                              ),
                              Row(
                                children: [
                                  AddPin(
                                    'Link',
                                    () {
                                      Navigator.pushNamed(context, '/links');
                                    },
                                    AssetImage('assets/images/links.png'),
                                  ),
                                  AddPin(
                                    'Scribble',
                                    () {
                                      _boardController.add(
                                        StackBoardItem(
                                          child: const Text(
                                            'Custom Widget',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          onDel: _onDel,
                                          // caseStyle: const CaseStyle(initOffset: Offset(100, 100)),
                                        ),
                                      );
                                    },
                                    AssetImage('assets/images/scribble.jpg'),
                                  ),
                                ],
                              ),
                              Divider(
                                height:
                                    MediaQuery.of(context).size.height * .02,
                              ),
                              Row(
                                children: [
                                  AddPin(
                                    'Audio',
                                    () {
                                      Navigator.pushNamed(context, '/audio');
                                    },
                                    AssetImage('assets/images/audio.jpg'),
                                  ),
                                  AddPin(
                                    'Voice to Text',
                                    () {
                                      Navigator.pushNamed(
                                          context, '/voicetotext');
                                    },
                                    AssetImage('assets/images/voicetotext.png'),
                                  ),
                                ],
                              ),
                              Divider(
                                height:
                                    MediaQuery.of(context).size.height * .02,
                              ),
                              Row(
                                children: [
                                  AddPin(
                                    'ToDo',
                                    () {
                                      Navigator.pushNamed(context, '/todo');
                                    },
                                    AssetImage('assets/images/todo.png'),
                                  ),
                                  AddPin(
                                    'Reminders',
                                    () {
                                      Navigator.pushNamed(context, '/reminder');
                                    },
                                    AssetImage('assets/images/reminder.jpg'),
                                  ),
                                ],
                              ),
                              Divider(
                                height:
                                    MediaQuery.of(context).size.height * .02,
                              ),
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
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .07,
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
                        width: MediaQuery.of(context).size.width * 0.88,
                        height: MediaQuery.of(context).size.height * .042,
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

  double randomCoordinates() {
    double myint = Random().nextDouble() * 50.0;
    return myint;
  }

  Positioned draggableWidget(Color mycolor, double qleft, double qtop) {
    return Positioned(
      left: qleft,
      top: qtop,
      child: GestureDetector(
        onPanUpdate: (details) {
          qleft = max(0, qleft + details.delta.dx);
          qtop = max(0, qtop + details.delta.dy);
          setState(() {});
        },
        onTap: () {},
        child: Container(
          height: 50,
          width: 50,
          color: mycolor,
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

class ItemCaseDemo extends StatefulWidget {
  const ItemCaseDemo({Key? key}) : super(key: key);

  @override
  _ItemCaseDemoState createState() => _ItemCaseDemoState();
}

class _ItemCaseDemoState extends State<ItemCaseDemo> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ItemCase(
          isCenter: false,
          child: const Text('Custom case'),
          onDel: () async {},
          onOperatStateChanged: (OperatState operatState) => null,
          onOffsetChanged: (Offset offset) => null,
          onSizeChanged: (Size size) => null,
        ),
      ],
    );
  }
}
