// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:myboardapp/main.dart' as mains;
// import 'package:myboardapp/models/myboard.dart';

// import '../boxes.dart';

// class Links extends StatefulWidget {
//   const Links({Key? key}) : super(key: key);

//   @override
//   State<Links> createState() => _LinksState();
// }

// class _LinksState extends State<Links> {
//   late Box<Link> linksBox;
//   List<String> links = [];
//   final _linkController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   final formKey = GlobalKey<FormState>();

//   Future addLink(String url, String description) async {
//     final localaddLink = Link()
//       ..url = url
//       ..description = description;
//     //final box = Boxes.getLinks();
//     ValueNotifier<Link?> mylinks = ValueNotifier(localaddLink);
//     linksBox.add(localaddLink);
//   }

//   @override
//   void initState() {
//     _linkController.addListener(() {
//       setState(() {});
//     });
//     _descriptionController.addListener(() {
//       setState(() {});
//     });
//     linksBox = Hive.box<Link>('links');

//     super.initState();
//   }

//   // @override
//   // void dispose() {
//   //   Hive.close();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           'Links',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 24,
//             color: Color.fromARGB(255, 10, 75, 107),
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       backgroundColor: Colors.red[300],
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               // SizedBox(height: 50),

//               const SizedBox(height: 4),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Enter your links!',
//                     style: GoogleFonts.lato(
//                       fontSize: 26,
//                     ),
//                   ),
//                   // Text(
//                   //   '(YouTube, Instagram, Pinterest or others)',
//                   //   style: GoogleFonts.lato(
//                   //     fontSize: 20,
//                   //   ),
//                   // )
//                 ],
//               ),
//               const SizedBox(height: 30),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade400,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Form(
//                       key: formKey,
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 120,
//                             child: Padding(
//                               padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   border: Border.all(
//                                     color: Color.fromARGB(255, 10, 75, 107),
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 20.0),
//                                   child: TextFormField(
//                                     // onSubmitted: (value) => setState(() {
//                                     //   thisLink = value;
//                                     // }),
//                                     validator: (value) {
//                                       if (Uri.parse(_linkController.text)
//                                           .isAbsolute) {
//                                         return null;
//                                       } else {
//                                         return 'Enter valid URL';
//                                       }
//                                     },
//                                     controller: _linkController,
//                                     decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         labelText: 'Link',
//                                         hintText: 'Enter Link here'),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 120,
//                             child: Padding(
//                               padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   border: Border.all(
//                                     color: Color.fromARGB(255, 10, 75, 107),
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 20.0),
//                                   child: TextFormField(
//                                     maxLines: 3,
//                                     controller: _descriptionController,
//                                     decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         labelText: 'Description',
//                                         hintText: 'Enter description here'),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           SizedBox(
//                             height: 40,
//                             child: TextButton(
//                               style: ButtonStyle(
//                                 backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Colors.amber),
//                               ),
//                               onPressed: () {
//                                 if (formKey.currentState!.validate()) {
//                                   final newlink = _linkController.text;
//                                   final newdiscription =
//                                       _descriptionController.text;
//                                   addLink(newlink, newdiscription);
//                                   print(newdiscription);
//                                   final snackBar =
//                                       SnackBar(content: Text('Adding Link'));
//                                   ScaffoldMessenger.of(context)
//                                       .showSnackBar(snackBar);
//                                 } else {}
//                               },
//                               child: Text(
//                                 'Add Link',
//                                 style: TextStyle(color: Colors.blue),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * .6,
//                       child: Container(
//                         constraints: BoxConstraints.loose(
//                           Size(double.maxFinite, double.maxFinite),
//                         ),
//                         child: ValueListenableBuilder<Box<Link>>(
//                             valueListenable: Boxes.getLinks().listenable(),
//                             builder: (context, box, _) {
//                               final mylinks =
//                                   linksBox.values.toList().cast<Link>();
//                               return BuildContent(mylinks);
//                             }),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {},
//       //   child: const Icon(
//       //     Icons.add,
//       //     size: 32,
//       //   ),
//       //   backgroundColor: Color.fromARGB(255, 10, 75, 107),
//       // ),
//     );
//   }

//   Widget BuildContent(List<Link> mylinks) {
//     if (mylinks.isEmpty) {
//       return SizedBox(
//         height: 20,
//         child: Center(
//           child: Text(
//             'No links yet!',
//             style: TextStyle(fontSize: 24),
//           ),
//         ),
//       );
//     } else {
//       return Container(
//         width: double.infinity,
//         height: 50,
//         child: Column(
//           children: [
//             Text(
//               'links:',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//                 color: Colors.amber,
//               ),
//             ),
//             SizedBox(height: 4),
//             Expanded(
//               child: ListView.builder(
//                 padding: EdgeInsets.all(8),
//                 itemCount: mylinks.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final link = mylinks[index];
//                   return buildTransaction(context, link);
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   Widget buildTransaction(
//     BuildContext context,
//     Link link,
//   ) {
//     return Card(
//       color: Colors.white,
//       child: ExpansionTile(
//         title: Text(
//           link.url,
//           maxLines: 2,
//           //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         subtitle: Text(
//           link.description,
//           maxLines: 2,
//           //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//       ),
//     );
//   }
// }


