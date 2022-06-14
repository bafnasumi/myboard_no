// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names, prefer_final_fields, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myboardapp/pages/homepage.dart';
import 'package:myboardapp/pages/voicetotext.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import '../../boxes.dart';
import 'package:myboardapp/models/myboard.dart' as m;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:path_provider/path_provider.dart';
import 'dart:core';

import '../boardState.dart';
import 'file_format_dropdown.dart';
import 'files_page.dart';

class Documents extends StatefulWidget {
  const Documents({Key? key}) : super(key: key);

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  FileType fileType = FileType.custom;

  double screenHeight() {
    return MediaQuery.of(context).size.height;
  }

  double screenWidth() {
    return MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   Hive.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var Documentsprovider = Provider.of<DocumentsController>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Documents',
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
            SizedBox(height: 80),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset('assets/images/file_pic.png'),
            ),

            Text(
              'Pick your documents!',
              style: GoogleFonts.reenieBeanie(
                fontSize: 36,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            // TextButton(
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all(Colors.blue),
            //   ),
            //   onPressed: () {

            //   },
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(
            //         horizontal: screenWidth() * 0.22,
            //         vertical: screenHeight() * 0.01),
            //     child: Text(
            //       'Pick Document',
            //       style: TextStyle(color: Colors.black),
            //     ),
            //   ),
            // ),
            buildFiles(),
          ],
        ),
      ),
    );
  }

  Widget buildFiles() => Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text(
              //   'Pick Files',
              //   style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              // ),
              // FileFormatDropdown(
              //   fileType: fileType,
              //   onChanged: (fileType) => setState(() => this.fileType = fileType),
              // ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                width: 180,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF4684EF))),
                  child: Text('Open Files'),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: fileType,
                      allowedExtensions: [
                        'pdf',
                        'doc',
                        'ppt',
                        'xlsx',
                        'xls',
                        'html',
                        'docx',
                        'txt'
                      ],
                    );

                    if (result == null) return;

                    /// Open single file
                    final file = result.files.first;
                    openFile(file);

                    print('Name: ${file.name}');
                    print('Bytes: ${file.bytes}');
                    print('Size: ${file.size}');
                    print('Extension: ${file.extension}');
                    print('Path: ${file.path}');

                    /// Works only for Android & iOS
                    final newFile = await saveFilePermanently(file);

                    // print('From Path: ${file.path!}');
                    // print('To Path: ${newFile.path}');
                    var box = BoxOfDocuments.getDocuments();
                    final latestDocument = box.getAt(box.length - 1);

                    var _repeated = false;
                    // for (previousImagePaths in boxofImages.toMap().values) {
                    if (boxofDocuments.length > 0) {
                      for (var index = 0;
                          index < boxofDocuments.length;
                          index++) {
                        print(newFile.path.trim());
                        print((box.getAt(index)!.path!.trim()));
                        // print(box.getAt(index)!.path!.split('/')[6]);
                        print((newFile.path.trim())
                            .contains(box.getAt(index)!.path!.split('*').last));

                        // boxofImages.getAt(index)!.imagesource!.trim()));

                        if ((newFile.path.trim()).contains(
                            box.getAt(index)!.path!.split('*').last)) {
                          print(
                              '${newFile.path.trim()} == ${box.getAt(index)!.path}');
                          setState(() {
                            _repeated = true;
                          });
                        }
                      }
                    }
                    print('_repeated = $_repeated');
                    if (!_repeated) {
                      Provider.of<DocumentsController>(context, listen: false)
                          .addDocument(
                        m.Documents(
                          path: newFile.path,
                        ),
                      );

                      Provider.of<BoardStateController>(context, listen: false)
                          .addBoardData(
                        m.BoardData(
                          position: BoxOfBoardData.getBoardData().length,
                          data: ('${newFile.path}*${latestDocument!.key}'),
                          isDone: false,
                          type: 'document',
                        ),
                      );
                      setState(() {});
                      Navigator.pushNamed(context, '/homepage');
                    } else {
                      Get.snackbar('Oops', 'Document already on board');
                    }
                  },
                ),
              ),
              // const SizedBox(height: 16),
              // ElevatedButton(
              //   child: Text('Pick MULTIPLE'),
              //   onPressed: () async {
              //     final result = await FilePicker.platform.pickFiles(
              //       type: fileType,
              //       allowMultiple: false,
              //     );
              //     if (result == null) return;

              //     if (result.count == 1) {
              //       /// Open single file
              //       final file = result.files.first;
              //       openFile(file);
              //     }
              //     // else {
              //     //   /// Open multiple files
              //     //   openFiles(result.files);
              //     // }
              //     Provider.of<DocumentsController>(context, listen: false)
              //           .addDocument(
              //         m.Documents(
              //           path: path,
              //         ),
              //       );

              //       Provider.of<BoardStateController>(context, listen: false)
              //           .addBoardData(
              //         m.BoardData(
              //           position: BoxOfBoardData.getBoardData().length,
              //           data: path,
              //           isDone: false,
              //           type: 'text',
              //         ),
              //       );
              //       setState(() {});
              //       Navigator.pushNamed(context, '/homepage');
              //   },
              // ),
            ],
          ),
        ),
      );

  void openFile(PlatformFile file) {
    if (Platform.isAndroid || Platform.isIOS) {
      OpenFile.open(file.path!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Not supported to open natively on ${Platform.operatingSystem}',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }
  }

  void openFiles(List<PlatformFile> files) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FilesPage(
          files: files,
          onOpenedFile: openFile,
        ),
      ));

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }
}

var boxofDocuments = BoxOfDocuments.getDocuments();

class DocumentsController with ChangeNotifier {
  late m.Documents _myDocument;
  DocumentsController() {
    _myDocument = m.Documents(
      path: '_',
    );
  }

  m.Documents get Documents => _myDocument;

  void setDcoument(m.Documents document) {
    _myDocument = document;
    notifyListeners();
  }

  void addDocument(m.Documents documents) {
    boxofDocuments.add(documents);
    notifyListeners();
  }

  void removeDocument(DocumentKey) {
    boxofDocuments.delete(DocumentKey);
    notifyListeners();
  }

  void emptyDocument() async {
    await boxofDocuments.clear();
    notifyListeners();
  }
}
