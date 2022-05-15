// ignore_for_file: prefer_const_constructors, unused_local_variable

 import 'package:file_picker/file_picker.dart';
 import 'package:flutter/material.dart';
 import 'package:get/get.dart';
 import 'homepage.dart';

class Memories extends StatefulWidget {
  const Memories({Key? key}) : super(key: key);

  @override
  State<Memories> createState() => _MemoriesState();
}

class _MemoriesState extends State<Memories> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       body: SafeArea(
       child: Column(
         children: [
           TextButton(
             onPressed: () async {
               final pickedPicture = await FilePicker.platform.pickFiles(
                 type: FileType.image,
                 allowedExtensions: ['jpg', 'png', 'jpeg'],
               );
               Get.to(
                 HomePage(),
                 arguments: pickedPicture,
               );
             },
             child: Text('Select Picture'),
           ),

         ],
       ),
       ),
     );
   }
 }
