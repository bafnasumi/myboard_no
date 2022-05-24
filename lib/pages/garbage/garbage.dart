 // CustomStack(
              //   //alignment: Alignment.topRight,
              //   children: [
              //     //personalBoard(context, _boardController),
              //     Container(
              //       height: MediaQuery.of(context).size.height * 0.65,
              //       color: Colors.green,
              //       width: double.infinity,
              //       child: Screenshot(
              //         controller: screenshotController,
              //         child: GestureDetector(
              //           behavior: HitTestBehavior.translucent,
              //           child: CustomStack(
              //               //children: pinnedWidgets,
              //               // children: [

              //               //   Positioned(
              //               //     left: left,
              //               //     top: top,
              //               //     child: GestureDetector(
              //               //       onPanUpdate: (details) {
              //               //         left = max(0, left + details.delta.dx);
              //               //         top = max(0, top + details.delta.dy);
              //               //         setState(() {});
              //               //       },
              //               //       onTap: () {},
              //               //       child: Container(
              //               //         height: 50,
              //               //         width: 50,
              //               //         color: Colors.red,
              //               //       ),
              //               //     ),
              //               //   ),
              //               //   Positioned(
              //               //     left: left1,
              //               //     top: top1,
              //               //     child: GestureDetector(
              //               //       onPanUpdate: (details) {
              //               //         left1 = max(0, left1 + details.delta.dx);
              //               //         top1 = max(0, top1 + details.delta.dy);
              //               //         setState(() {});
              //               //       },
              //               //       onTap: () {},
              //               //       child: Container(
              //               //         height: 50,
              //               //         width: 50,
              //               //         color: Colors.yellowAccent,
              //               //       ),
              //               //     ),
              //               //   ),
              //               //   Positioned(
              //               //     left: left2,
              //               //     top: top2,
              //               //     child: GestureDetector(
              //               //       onPanUpdate: (details) {
              //               //         left2 = max(0, left2 + details.delta.dx);
              //               //         top2 = max(0, top2 + details.delta.dy);
              //               //         setState(() {});
              //               //       },
              //               //       onTap: () {},
              //               //       child: Container(
              //               //         height: 50,
              //               //         width: 50,
              //               //         color: Colors.green,
              //               //       ),
              //               //     ),
              //               //   ),
              //               //   Positioned(
              //               //     left: left3,
              //               //     top: top3,
              //               //     child: GestureDetector(
              //               //       onPanUpdate: (details) {
              //               //         left3 = max(0, left3 + details.delta.dx);
              //               //         top3 = max(0, top3 + details.delta.dy);
              //               //         setState(() {});
              //               //       },
              //               //       onTap: () {},
              //               //       child: Container(
              //               //         height: 50,
              //               //         width: 50,
              //               //         color: Colors.pink,
              //               //       ),
              //               //     ),
              //               //   ),
              //               //   ListView.builder(
              //               //     itemBuilder: (context, index) {
              //               //       return GestureDetector();
              //               //     },
              //               //     itemCount: widgetlist.length,
              //               //   )
              //               ),
              //         ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: IconButton(
              //         onPressed: () async {
              //           final ss = await screenshotController.capture();
              //           print(ss);
              //           final File ss_file = File.fromRawPath(ss!);
              //           final String filepath = await saveImage(ss);
              //           print('path os ss file: $filepath');
              //           //await saveFilePermanently(ss_platform_file);
              //         },
              //         icon: Icon(
              //           Icons.done_outline_rounded,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

             // class ItemCaseDemo extends StatefulWidget {
//   const ItemCaseDemo({Key? key}) : super(key: key);

//   @override
//   _ItemCaseDemoState createState() => _ItemCaseDemoState();
// }

// class _ItemCaseDemoState extends State<ItemCaseDemo> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         ItemCase(
//           isCenter: false,
//           child: const Text('Custom case'),
//           onDel: () async {},
//           onOperatStateChanged: (OperatState operatState) => null,
//           onOffsetChanged: (Offset offset) => null,
//           onSizeChanged: (Size size) => null,
//         ),
//       ],
//     );
//   }
// }



// //***********DRAGGABLE WIDGET

//   double randomCoordinates() {
//     double myint = Random().nextDouble() * 50.0;
//     return myint;
//   }

//   Positioned draggableWidget(Color mycolor, double qleft, double qtop) {
//     return Positioned(
//       left: qleft,
//       top: qtop,
//       child: GestureDetector(
//         onPanUpdate: (details) {
//           qleft = max(0, qleft + details.delta.dx);
//           qtop = max(0, qtop + details.delta.dy);
//           setState(() {});
//         },
//         onTap: () {},
//         child: Container(
//           height: 50,
//           width: 50,
//           color: mycolor,
//         ),
//       ),
//     );
//   }
