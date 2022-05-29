import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myboardapp/pages/audio.dart';
import 'package:myboardapp/pages/boardeditpage.dart';
import 'package:myboardapp/pages/homepage.dart';
import 'package:myboardapp/pages/links.dart';
import 'package:myboardapp/pages/loginpage.dart';
import 'package:myboardapp/pages/memories.dart';
import 'package:myboardapp/pages/quotes/quotes.dart';
import 'package:myboardapp/pages/remind/reminder.dart';
import 'package:myboardapp/pages/screenshots.dart';
import 'package:myboardapp/pages/screentime.dart';
import 'package:myboardapp/pages/settingspage.dart';
import 'package:myboardapp/pages/signuppage.dart';
// import 'package:myboardapp/pages/stack_board.dart';
import 'package:myboardapp/pages/todo.dart';
import 'package:myboardapp/pages/video.dart';
import 'package:myboardapp/pages/voicetotext.dart';
import 'package:myboardapp/pages/welcomescreen.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'models/myboard.dart' as m;
import 'services/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'boxes.dart';
import 'package:path_provider/path_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory localdocument = await getApplicationDocumentsDirectory();
  print(localdocument);

  Hive.init(localdocument.path);
  // await Hive.initFlutter();

  Hive.registerAdapter(m.ImagesAdapter());
  Hive.registerAdapter(m.LinkAdapter());
  Hive.registerAdapter(m.ToDoAdapter());

  await Hive.openBox<m.Images>('images');
  await Hive.openBox<m.Link>('links');
  await Hive.openBox<m.ToDo>('todo');

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
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskController(),
        ),
        Provider(
          create: (context) => const Reminder(),
        ),
        ChangeNotifierProvider(
          create: (context) => LinksController(),
        ),
      ],
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
          '/todo': (context) => ToDo(),
          '/memories': (context) => const Memories(),
          '/screenshots': (context) => const Screenshots(),
          '/links': (context) => const Links(),
          '/screentime': (context) => const ScreenTime(),
          '/quotes': (context) => const Quotes(),
          '/video': (context) => const Video(),
          '/audio': (context) => const Audio(),
          '/boardeditpage': (context) => const BoardEditPage(),
          '/setting':(context) => Setting(),
        },
      ),
    );
  }
}
