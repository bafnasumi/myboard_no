// ignore_for_file: prefer_const_constructors

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myboardapp/pages/loginpage.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Hero(
          tag: 'Splash',
          child: Text(
            'MyBoard',
            style: GoogleFonts.anton(fontSize: 35.0),
          ),
        ),
        nextScreen: LogInPage());
  }
}

// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({Key? key}) : super(key: key);

//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }

// class _WelcomeScreenState extends State<WelcomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SplashScreen(
//         seconds: 4,
//         navigateAfterSeconds: Navigator.pushNamed(context, '/login'),
//         title: Text(
//           'Welcome In SplashScreen',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
//         ),
//         //image: Image.network('https://i.imgur.com/TyCSG9A.png'),
//         backgroundColor: Colors.white,
//         styleTextUnderTheLoader: TextStyle(),
//         photoSize: 100.0,
//         onClick: () {},
//         loaderColor: Colors.red);
//   }
// }
