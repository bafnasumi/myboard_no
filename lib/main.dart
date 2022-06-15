// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myboardapp/boxes.dart';
import 'package:myboardapp/pages/boardState.dart';
import 'package:myboardapp/pages/Documents/documents.dart';
import 'package:myboardapp/pages/imageControlller.dart';
import 'package:myboardapp/pages/recorder/audio/audio.dart';
import 'package:myboardapp/pages/recorder/audiorecorder.dart';
import 'package:myboardapp/pages/background.dart' as bg;
// import 'package:myboardapp/pages/boardeditpage.dart';
import 'package:myboardapp/pages/homepage.dart';
import 'package:myboardapp/pages/links.dart';
import 'package:myboardapp/pages/loginpage.dart';
import 'package:myboardapp/pages/memories.dart';
import 'package:myboardapp/pages/quotes/quotes.dart';
import 'package:myboardapp/pages/remind/controller/task_controller.dart';
import 'package:myboardapp/pages/remind/notificationAPI2.dart';
import 'package:myboardapp/pages/remind/notificationApi.dart';
import 'package:myboardapp/pages/remind/reminder.dart';
import 'package:myboardapp/pages/screenshots.dart';
import 'package:myboardapp/pages/audio.dart';
import 'package:myboardapp/pages/settingspage.dart';
import 'package:myboardapp/pages/signuppage.dart';
import 'package:myboardapp/pages/text.dart';
// import 'package:myboardapp/pages/stack_board.dart';
import 'package:myboardapp/pages/todo.dart';
import 'package:myboardapp/pages/video.dart';
import 'package:myboardapp/pages/voicetotext.dart';
import 'package:myboardapp/pages/welcomescreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'models/myboard.dart' as m;
import 'services/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'dart:math' as math;

Future main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  WidgetsFlutterBinding.ensureInitialized();

  Directory localdocument = await getApplicationDocumentsDirectory();
  print(localdocument);

  Hive.init(localdocument.path);
  // await Hive.initFlutter();

  Hive.registerAdapter(m.ImagesAdapter());
  Hive.registerAdapter(m.LinkAdapter());
  Hive.registerAdapter(m.ToDoAdapter());
  Hive.registerAdapter(m.AudioAdapter());
  Hive.registerAdapter(m.VideoAdapter());
  Hive.registerAdapter(m.ReminderTaskAdapter());
  Hive.registerAdapter(m.VoiceToTextAdapter());
  Hive.registerAdapter(m.TextAdapter());
  Hive.registerAdapter(m.BoardDataAdapter());
  Hive.registerAdapter(m.BackgroundImageAdapter());
  Hive.registerAdapter(m.DocumentsAdapter());

  await Hive.openBox<m.Images>('images');
  await Hive.openBox<m.Link>('links');
  await Hive.openBox<m.ToDo>('todo');
  await Hive.openBox<m.Audio>('audio');
  await Hive.openBox<m.Video>('video');
  await Hive.openBox<m.ReminderTask>('reminder');
  await Hive.openBox<m.VoiceToText>('voicetotext');
  await Hive.openBox<m.Text>('text');
  await Hive.openBox<m.BoardData>('boarddata');
  await Hive.openBox<m.BackgroundImage>('backgroundimage');
  await Hive.openBox<m.Documents>('document');

  await Firebase.initializeApp();
  // await AndroidAlarmManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //final gridviewKey = GlobalKey<_MyAppState>();
  // String myImglink = '';
  // late SharedPreferences preferences;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  // Future init() async {
  //   // preferences = await SharedPreferences.getInstance();
  // }

  @override
  void initState() {
    // AwesomeNotifications().actionStream.listen((event) {
    //   Navigator.pushNamed(context, '/reminder');
    // });
    //var boxofboardData = BoxOfBoardData.getBoardData();
    // var boarddataController = BoardStateController();
    //pinnedWidgets = [];
    // if (boxofboardData.length != 0) {
    //   for (var i = 0; i < boxofboardData.length; i++) {
    //     await boarddataController.addThings(boxofboardData.getAt(i)!, context);
    //     print('from initstate ${boxofboardData.getAt(i)!.data}');
    //   }
    // }
    PinnedToDo(String? todotext, int index, int pinnedWidgetIndex) => InkWell(
          child: Container(
            child: Wrap(
              alignment: WrapAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(todotext!),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white70,
              image: DecorationImage(
                image: AssetImage('assets/images/todo_background.png'),
                fit: BoxFit.contain,
              ),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
          ),
          onDoubleTap: () {
            //isDone = true;
            // boxoftodos.delete(index);
            //pinnedWidgets!.removeAt(pinnedWidgetIndex);
          },
        );
    PinnedReminder(m.ReminderTask? task, int index, int pinnedWidgetIndex) =>
        InkWell(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              //direction: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 0, 2),
                  child: Text(
                    task!.title!,
                    style: GoogleFonts.openSans(fontSize: 13.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
                  child: Text(
                    task.note!,
                    style: TextStyle(fontSize: 7.0),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/reminder_backgroud.png')),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
          ),
          onDoubleTap: () {
            //boxofreminders.delete(index);
            // pinnedWidgets!.removeAt(pinnedWidgetIndex);
          },
        );

    PinnedLink(String? url, String? description, int index,
            int pinnedWidgetIndex, context) =>
        InkWell(
          // onDoubleTap: () {},
          child: GestureDetector(
            onTap: () {
              //TODO: launch url !
              //launchUrl(url: url!);
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.3,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 0, 2),
                    child: Text(
                      description!,
                      style: TextStyle(fontSize: 10.0),
                    ),
                  ),
                  Wrap(
                    //direction: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
                        child: Text(
                          url!,
                          style: TextStyle(fontSize: 5.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                // ignore: prefer_const_literals_to_create_immutables
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3.0,
                    spreadRadius: 0.5,
                    offset: Offset(1, 1),
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage('assets/images/www.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0),
                // border: Border.all(
                //   color: Colors.black,
                //   width: 2.0,
                // ),
              ),
            ),
          ),
        );

    PinnedVoiceToText(String? localtext, int index, int pinnedWidgetIndex) {
      return InkWell(
        child: Container(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            children: [
              Wrap(
                //direction: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 5, 2, 2),
                    child: Text(
                      localtext!,
                      style: TextStyle(fontSize: 10.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onDoubleTap: () {
          //boxofvoicetotext.delete(index);
          //pinnedWidgets!.removeAt(pinnedWidgetIndex);
        },
      );
    }

    PinnedText(String? mytext, int index, int pinnedWidgetIndex) => InkWell(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3.0,
                      spreadRadius: 0.5,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: Wrap(
                  //direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,

                  direction: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 0, 4),
                      child: Center(
                        child: Text(
                          mytext!,
                          style: GoogleFonts.gloriaHallelujah(
                            height: 0,
                            fontSize: 10.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/images/pin.png',
                width: 13,
                height: 13,
              ),
            ],
          ),
          onDoubleTap: () {
            //boxofTextPage.delete(index);
            //pinnedWidgets!.removeAt(pinnedWidgetIndex);
          },
        );
    // SizedBox(
    //   height: 100,
    //   width: 50,
    // child: Consumer<BoardStateController>(
    //   builder: (context, boarddata, child) {
    // return GridView.builder(
    //     key: gridviewKey,
    //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //       maxCrossAxisExtent: 200,
    //       childAspectRatio: 3 / 2,
    //       crossAxisSpacing: 3,
    //       mainAxisSpacing: 2,
    //       // crossAxisCount: 6,
    //     ),
    //     // itemCount: myProducts.length,
    //     itemBuilder: (BuildContext context, index) {
    //       final _boarddata = boxofboarddata.getAt(index);
    //       // return TaskTile(
    //       //   taskTitle: boarddata!.data,
    //       //   isChecked: boarddata.isDone,
    //       //   checkboxCallback: (checkboxState) {
    //       //     taskData.removeToDo(task.key);
    //       //     setState(() {});
    //       //     const snackBar = SnackBar(
    //       //       content: Text('Todo deleted'),
    //       //     );
    //       //});
    //var boarddataController = Provider.of<BoardStateController>(context);

    var boarddata = BoxOfBoardData.getBoardData();

    // for (var index = 0; index < boarddata.length; index++) {
    //   switch (boarddata.getAt(index)!.type) {
    //     case 'image':
    //       {
    //         File finalImage = File(boarddata.getAt(index)!.data!);
    //         // var decodedImage =
    //         //     await decodeImageFromList(finalImage.readAsBytesSync());
    //         // double width = decodedImage.width.toDouble();
    //         // double height = decodedImage.height.toDouble();
    //         StaggeredGridTile.count(
    //           // crossAxisCellCount: width > height ? 3 : 2,
    //           // mainAxisCellCount: width < height ? 3 : 2,
    //           crossAxisCellCount: 2,
    //           mainAxisCellCount: 2,

    //           child: Stack(
    //             alignment: Alignment.topCenter,
    //             children: [
    //               Container(
    //                 child: Image.file(finalImage),
    //                 decoration: BoxDecoration(boxShadow: [
    //                   BoxShadow(
    //                     blurRadius: 3.0,
    //                     spreadRadius: 0.5,
    //                     offset: Offset(1, 1),
    //                   ),
    //                 ]),
    //               ),
    //               Image.asset(
    //                 'assets/images/pin.png',
    //                 width: 13,
    //                 height: 13,
    //               ),
    //             ],
    //           ),
    //         );
    //       }
    //       break;
    //     case 'video':
    //       {
    //         StaggeredGridTile.count(
    //           crossAxisCellCount: 2,
    //           mainAxisCellCount: 2,
    //           child: InkWell(
    //             onTap: (() {
    //               print('tap on video catched');
    //               print(boarddata.getAt(index)!.data);
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: ((context) =>
    //                       Video(localfile_path: boarddata.getAt(index)!.data!)),
    //                 ),
    //               );
    //             }),
    //             child: Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Stack(
    //                 alignment: Alignment.topCenter,
    //                 children: [
    //                   Container(
    //                     child: Text(
    //                       'video link; ${boarddata.getAt(index)!.data!}',
    //                       style: TextStyle(
    //                         color: Colors.white,
    //                       ),
    //                     ),
    //                     // child: Image.file(
    //                     //     File(videopath.toString())),
    //                     decoration: BoxDecoration(boxShadow: [
    //                       BoxShadow(
    //                         blurRadius: 3.0,
    //                         spreadRadius: 0.5,
    //                         offset: Offset(1, 1),
    //                       ),
    //                     ]),
    //                   ),
    //                   Image.asset(
    //                     'assets/images/pin.png',
    //                     width: 13,
    //                     height: 13,
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         );
    //       }
    //       break;
    //     case 'todo':
    //       {
    //         StaggeredGridTile.count(
    //           crossAxisCellCount: 2,
    //           mainAxisCellCount: 1,
    //           child: PinnedToDo(boarddata.getAt(index)!.data!, 0, 0),
    //         );
    //       }
    //       break;
    //     case 'link':
    //       {
    //         StaggeredGridTile.count(
    //             crossAxisCellCount: 2,
    //             mainAxisCellCount: 1,
    //             child: Padding(
    //               padding: const EdgeInsets.all(4.0),
    //               child: Stack(
    //                 alignment: Alignment.topCenter,
    //                 children: [
    //                   Container(
    //                     decoration: BoxDecoration(
    //                       // ignore: prefer_const_literals_to_create_immutables
    //                       boxShadow: [
    //                         BoxShadow(
    //                           blurRadius: 3.0,
    //                           spreadRadius: 0.5,
    //                           offset: Offset(1, 1),
    //                         ),
    //                       ],
    //                     ),
    //                     child: PinnedLink(
    //                         boarddata.getAt(index)!.data!.split(':')[0],
    //                         boarddata.getAt(index)!.data!.split(':')[1],
    //                         0,
    //                         0,
    //                         context),
    //                   ),
    //                   Image.asset(
    //                     'assets/images/pin.png',
    //                     width: 13,
    //                     height: 13,
    //                   ),
    //                 ],
    //                 // ),
    //               ),
    //             ));
    //         break;
    //       }
    //     case 'voicetotext':
    //       {
    //         StaggeredGridTile.count(
    //           crossAxisCellCount: 2,
    //           mainAxisCellCount:
    //               boarddata.getAt(index)!.data!.length > 20 ? 2 : 1,
    //           child: Stack(
    //             alignment: Alignment.topCenter,
    //             children: [
    //               Container(
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: PinnedVoiceToText(
    //                       boarddata.getAt(index)!.data!, 0, 0),
    //                 ),
    //                 // child: Image.file(
    //                 //     File(videopath.toString())),
    //                 decoration: BoxDecoration(
    //                   color: Colors.lightGreen,
    //                   // ignore: prefer_const_literals_to_create_immutables
    //                   boxShadow: [
    //                     BoxShadow(
    //                       blurRadius: 3.0,
    //                       spreadRadius: 0.5,
    //                       offset: Offset(1, 1),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Image.asset(
    //                 'assets/images/pin.png',
    //                 width: 13,
    //                 height: 13,
    //               ),
    //             ],
    //           ),
    //         );
    //       }
    //       break;
    //     case 'text':
    //       {
    //         StaggeredGridTile.count(
    //           crossAxisCellCount: 2,
    //           mainAxisCellCount: (boarddata.getAt(index)!.data!.length > 10
    //               ? (boarddata.getAt(index)!.data!.length > 20 ? 3 : 2)
    //               : 1),
    //           child: PinnedText(boarddata.getAt(index)!.data!, 0, 0),
    //         );
    //       }
    //       break;
    //     case 'audio':
    //       {
    //         StaggeredGridTile.count(
    //           crossAxisCellCount: 2,
    //           mainAxisCellCount: 1,
    //           child: PinnedToDo(boarddata.getAt(index)!.data!, 0, 0),
    //         );
    //       }
    //       break;
    //     case 'quotes':
    //       {
    //         StaggeredGridTile.count(
    //           crossAxisCellCount: 2,
    //           mainAxisCellCount: 2,
    //           // mainAxisCellCount:
    //           //     (quotesList[index1][kAuthor]).toString().length > 30
    //           //         ? 2
    //           //         : 1,
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Stack(
    //               alignment: Alignment.topCenter,
    //               children: [
    //                 Transform.rotate(
    //                   angle: -math.pi / 60,
    //                   child: Container(
    //                     child: Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: Text(
    //                         boarddata.getAt(index)!.data!,
    //                         style: GoogleFonts.caveatBrush(
    //                           color: Colors.black,
    //                           fontSize: 8.5,
    //                         ),
    //                       ),
    //                     ),
    //                     decoration: BoxDecoration(
    //                       color: Colors.greenAccent,
    //                       boxShadow: [
    //                         BoxShadow(
    //                           blurRadius: 3.0,
    //                           spreadRadius: 0.5,
    //                           offset: Offset(1, 1),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //                 Image.asset(
    //                   'assets/images/pin.png',
    //                   width: 13,
    //                   height: 13,
    //                 ),
    //               ],
    //             ),
    //           ),
    //         );
    //       }
    //       break;
    //     case 'reminder':
    //       {
    //         List reminderdata = boarddata.getAt(index)!.data!.split(':');

    //         m.ReminderTask latestreminder = m.ReminderTask(
    //           title: reminderdata[0],
    //           note: reminderdata[1],
    //           date: reminderdata[2],
    //           startTime: reminderdata[3],
    //           reminder: reminderdata[4],
    //           repeat: reminderdata[5],
    //         );
    //         StaggeredGridTile.count(
    //           crossAxisCellCount: 2,
    //           mainAxisCellCount: 1,
    //           child: PinnedReminder(latestreminder!, 0, 0),
    //         );
    //       }
    //       break;

    //     default:
    //       Container();
    //   }
    // }

    //     },
    //   ),
    // );

    // // //notification 1
    NotificationApi.init();
    listenNotifications();
    tz.initializeTimeZones();

    super.initState();
  }

//notification 2
  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickNotification);

  void onClickNotification(String? payload) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Reminder(),
        ),
      );

  Key? gridviewKey;

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
        // ChangeNotifierProvider(
        //   create: (context) => AudioController(),
        // ),
        ChangeNotifierProvider(
          create: (context) => ReminderController(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => VoiceToTextController(),
        // ),
        ChangeNotifierProvider(
          create: (context) => TextPageController(),
        ),
        ChangeNotifierProvider(
          create: (context) => BoardStateController(),
        ),
        ChangeNotifierProvider(
          create: (context) => bg.BackgroundController(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImageController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AudioController(),
        ),
        ChangeNotifierProvider(
          create: (context) => DocumentsController(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        //title: 'welcomescreen',
        initialRoute: '/homepage',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/homepage': (context) => HomePage(
                gridviewKey: gridviewKey,
              ),
          '/login': (context) => const LogInPage(),
          '/register': (context) => const RegisterPage(),
          '/reminder': (context) => const Reminder(),
          // '/voicetotext': (context) => const VoiceToText(),
          '/text': (context) => const TextPage(),
          '/todo': (context) => ToDo(),
          '/memories': (context) => const Memories(),
          '/screenshots': (context) => const Screenshots(),
          '/links': (context) => const Links(),
          // '/screentime': (context) => const ScreenTime(),
          '/quotes': (context) => const Quotes(),
          '/video': (context) => Video(),
          '/audio': (context) => MyAudio(),
          // '/boardeditpage': (context) => const BoardEditPage(),
          '/setting': (context) => const SettingsScreen(),
          '/background': (context) => const bg.Background(),
        },
      ),
    );
  }
}
