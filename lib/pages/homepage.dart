// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, avoid_print

// import 'dart:html';
// import 'package:myboardapp/services/firebaseApi.dart';
// import 'package:path/path.dart' as p;
// import 'package:myboardapp/pages/stack_board.dart' as sb;
// import 'package:firebase_core/firebase_core.dart';
// import 'dart:math' as math;
//import 'package:file_picker/file_picker.dart';
import 'package:myboardapp/boxes.dart';
import 'package:myboardapp/pages/myvideo.dart' as vid;
//import 'dart:ffi';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stack_board/stack_board.dart';
import 'loginpage.dart' as loginpage;
import 'package:myboardapp/models/myboard.dart' as db;
// ignore: library_prefixes
import "package:myboardapp/services/google_sign_in.dart" as GSI;

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
  late StackBoardController _boardController;
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

  @override
  Widget build(BuildContext context) {
    var scaffoldKey;
    return Scaffold(
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
          ],
        ),
      ),
      //drawer: Drawer(child: ListView()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
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
            Container(
              height: MediaQuery.of(context).size.height * 0.73,
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 3.0,
                    blurStyle: BlurStyle.outer,
                    color: Colors.black54,
                  )
                ],
                borderRadius: BorderRadius.circular(25.0),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://media.istockphoto.com/photos/blue-velvet-picture-id174897941?k=20&m=174897941&s=612x612&w=0&h=earrO_3wBH7HIFScdG5hpUvOUVb35CjrO8McEkHi9x4='),
                  fit: BoxFit.fill,
                ),
              ),
              child: StackBoard(
                controller: _boardController,
                caseStyle: const CaseStyle(
                  borderColor: Colors.grey,
                  iconColor: Colors.white,
                ),
                //background: ColoredBox(color: Colors.grey[100]!),
                customBuilder: (StackBoardItem t) {
                  if (t is CustomItem) {
                    return ItemCase(
                      key: Key('StackBoardItem${t.id}'), // <==== must
                      isCenter: false,
                      onDel: () async => _boardController.remove(t.id),
                      onTap: () => _boardController.moveItemToTop(t.id),
                      caseStyle: const CaseStyle(
                        borderColor: Colors.grey,
                        iconColor: Colors.white,
                      ),
                      child: Container(
                        width: 100,
                        height: 100,
                        color: t.color,
                        alignment: Alignment.center,
                        child: const Text(
                          'Custom item',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }

                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Container(
                        color: Color.fromARGB(255, 214, 214, 214),
                        child: Wrap(
                          //TODO: Converti Wrap into GridView
                          children: [
                            Divider(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            // SizedBox(
                            //   height: MediaQuery.of(context).size.height * .01,
                            // ),
                            Row(
                              children: [
                                AddPin(
                                  'Text',
                                  () {
                                    _boardController.add(
                                      const AdaptiveText(
                                        'Flutter Candies',
                                        tapToEdit: true,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  },
                                ),
                                AddPin(
                                  'Photo',
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
                                    setState(
                                      () {
                                        // final myimage = box.values.toList().cast<db.Images>();
                                        //var myimage = BoxesofImage.getImages;
                                        //print(myimage.toString());
                                        _boardController.add(StackBoardItem(
                                          child: Image.file(finalImage),
                                        ));
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
                                  },
                                ),
                              ],
                            ),
                            Divider(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            Row(
                              children: [
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
                                ),
                              ],
                            ),
                            Divider(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            Row(
                              children: [
                                AddPin(
                                  'Link',
                                  () {
                                    Navigator.pushNamed(context, '/links');
                                  },
                                ),
                                AddPin(
                                  'Scribble',
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
                              ],
                            ),
                            Divider(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            Row(
                              children: [
                                AddPin(
                                  'Audio',
                                  () {
                                    Navigator.pushNamed(context, '/audio');
                                  },
                                ),
                                AddPin(
                                  'Voice to Text',
                                  () {
                                    Navigator.pushNamed(
                                        context, '/voicetotext');
                                  },
                                ),
                              ],
                            ),
                            Divider(
                              height: MediaQuery.of(context).size.height * .01,
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
                      width: MediaQuery.of(context).size.width * 0.92,
                      height: MediaQuery.of(context).size.height * .042,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
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
    );
  }

  Widget AddPin(String textt, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 117, 117, 117),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
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
      ),
    );
  }

  Widget get _spacer => const SizedBox(width: 5);
}

Future<File> saveFilePermanently(PlatformFile file) async {
  final appStorage = await getApplicationDocumentsDirectory();
  final newFile = File('${appStorage.path}/${file.name}');

  return File(file.path!).copy(newFile.path);
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
