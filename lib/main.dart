import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myboardapp/pages/audio.dart';
import 'package:myboardapp/pages/boardeditpage.dart';
import 'package:myboardapp/pages/homepage.dart';
import 'package:myboardapp/pages/links.dart';
import 'package:myboardapp/pages/loginpage.dart';
import 'package:myboardapp/pages/memories.dart';
import 'package:myboardapp/pages/quotes.dart';
import 'package:myboardapp/pages/reminder.dart';
import 'package:myboardapp/pages/screenshots.dart';
import 'package:myboardapp/pages/screentime.dart';
import 'package:myboardapp/pages/signuppage.dart';
// import 'package:myboardapp/pages/stack_board.dart';
import 'package:myboardapp/pages/todo.dart';
import 'package:myboardapp/pages/video.dart';
import 'package:myboardapp/pages/voicetotext.dart';
import 'package:myboardapp/pages/welcomescreen.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'services/google_sign_in.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'welcomescreen',
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/homepage': (context) => const HomePage(),
          '/login': (context) => const LogInPage(),
          '/register': (context) => const RegisterPage(),
          '/reminder': (context) => const Reminder(),
          '/voicetotext': (context) => const VoiceToText(),
          '/todo': (context) => const ToDo(),
          '/memories': (context) => const Memories(),
          '/screenshots': (context) => const Screenshots(),
          '/links': (context) => const Links(),
          '/screentime': (context) => const ScreenTime(),
          '/quotes': (context) => const Quotes(),
          '/video': (context) => const Video(),
          '/audio': (context) => const Audio(),
          // '/stack_board': (context) => const StackBoard(),
          '/boardeditpage': (context) => const BoardEditPage(),
        },
      ),
    );
  }
}
