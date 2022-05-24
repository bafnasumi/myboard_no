// import 'package:flutter/material.dart';

//   AddPin(String textt, VoidCallback onPressed, ImageProvider givenimage) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: GestureDetector(
//           onTap: onPressed,
//           child: Container(
//             height: MediaQuery.of(context).size.height * .18,
//             width: MediaQuery.of(context).size.width * .2,

//             //padding: EdgeInsets.all(15),
//             decoration: BoxDecoration(
//               image: DecorationImage(image: givenimage, fit: BoxFit.cover),
//               color: Color.fromARGB(255, 117, 117, 117),
//               borderRadius: BorderRadius.circular(32),
//             ),
//             child: Text(
//               '$textt',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18),
//             ),
//           ),
//         ),
//       ),
//     );
//   }