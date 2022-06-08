// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myboardapp/main.dart';
import 'package:myboardapp/pages/homepage.dart';
import 'package:myboardapp/pages/todo.dart';
import 'package:provider/provider.dart';
import '../boxes.dart';
import 'package:myboardapp/models/myboard.dart' as m;
import 'package:url_launcher/url_launcher.dart';

import 'boardState.dart';

class Links extends StatefulWidget {
  const Links({Key? key}) : super(key: key);

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {
  //List<Link> mylinks = [];
  // ValueNotifier<Link?> mylinks = ValueNotifier(Link());
  final _linkController = TextEditingController();
  final _descriptionController = TextEditingController();
  var thisLink = '';
  var thisDescription = '';

  // Future addLink(String url, String description) async {
  //   final localaddLink = Link()
  //     ..url = url
  //     ..description = description;
  //   final box = Boxes.getLinks();
  //   ValueNotifier<Link?> mylinks = ValueNotifier(localaddLink);
  //   box.add(localaddLink);
  // }
  double screenHeight() {
    return MediaQuery.of(context).size.height;
  }

  double screenWidth() {
    return MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    _linkController.addListener(() {
      setState(() {});
    });
    _descriptionController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  // @override
  // void dispose() {
  //   Hive.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var linksprovider = Provider.of<LinksController>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 27.0),
          child: Text(
            'Links',
            style: GoogleFonts.italiana(
              color: Colors.black87,
              fontSize: screenHeight() * 0.05,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                child: Text(
                  'enter your links!',
                  style: GoogleFonts.reenieBeanie(
                    fontSize: 36,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(
                      color: Color.fromARGB(255, 10, 75, 107),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _linkController,
                      onSubmitted: (value) => setState(() {
                        thisLink = value;
                      }),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter link here'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(
                      color: Color.fromARGB(255, 10, 75, 107),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      maxLines: 3,
                      onSubmitted: (value) => setState(() {
                        thisDescription = value;
                      }),
                      controller: _descriptionController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter description here'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 10, 75, 107),
                  ),
                ),
                onPressed: () {
                  Provider.of<LinksController>(context, listen: false).addLink(
                    m.Link(
                      url: _linkController.text,
                      description: _descriptionController.text,
                    ),
                  );
                  final box = BoxOfLinks.getLinks();
                  final latestlink = box.getAt(box.length - 1);
                  var index = box.length - 1;
                  // int pinnedWidgetIndex = pinnedWidgets!.length;
                  // print('pinnedwidget length: ${pinnedWidgetIndex}');

                  // pinnedWidgets!.add(
                  //   StaggeredGridTile.count(
                  //       crossAxisCellCount: 2,
                  //       mainAxisCellCount: 1,
                  //       // child: InkWell(
                  //       //   onDoubleTap: () {
                  //       //     if (pinnedWidgetIndex >= 0) {
                  //       //       print(
                  //       //           'pinnedwidget length: ${pinnedWidgetIndex}');
                  //       //       setState(() {
                  //       //         boxoflinks.delete(index);
                  //       //         pinnedWidgets.removeAt(pinnedWidgetIndex);
                  //       //         pinnedWidgets;
                  //       //       });
                  //       //     }
                  //       //   },
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(4.0),
                  //         child: Stack(
                  //           alignment: Alignment.topCenter,
                  //           children: [
                  //             Container(
                  //               decoration: BoxDecoration(
                  //                 // ignore: prefer_const_literals_to_create_immutables
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     blurRadius: 3.0,
                  //                     spreadRadius: 0.5,
                  //                     offset: Offset(1, 1),
                  //                   ),
                  //                 ],
                  //               ),
                  //               child: PinnedLink(
                  //                   latestlink!.url,
                  //                   latestlink.description,
                  //                   index,
                  //                   pinnedWidgetIndex),
                  //             ),
                  //             Image.asset(
                  //               'assets/images/pin.png',
                  //               width: 13,
                  //               height: 13,
                  //             ),
                  //           ],
                  //           // ),
                  //         ),
                  //       )),
                  // );
                  Provider.of<BoardStateController>(context, listen: false)
                      .addBoardData(
                    m.BoardData(
                      position: BoxOfBoardData.getBoardData().length,
                      data: ('${latestlink!.url}:${latestlink.description}'),
                      isDone: false,
                      type: 'link',
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth() * 0.15,
                      vertical: screenHeight() * 0.02),
                  child: Text(
                    'Add Link',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // ValueListenableBuilder<Box<Link>>(
              //     valueListenable: Boxes.getLinks().listenable(),
              //     builder: (context, box, _) {
              //       final mylinks = box.values.toList().cast<Link>();
              //       return BuildContent(mylinks);
              //     })
            ],
          ),
        ),
      ),
    );
  }

  PinnedLink(
          String? url, String? description, int index, int pinnedWidgetIndex) =>
      InkWell(
        // onDoubleTap: () {},
        child: GestureDetector(
          onTap: () {
            launchUrl(url: url!);
          },
          child: Container(
            height: screenHeight() * 0.3,
            width: screenWidth() * 0.3,
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

  Widget BuildContent(List<m.Link> mylinks) {
    if (mylinks.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'No links yet!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
    } else {
      return Expanded(
        child: Column(
          children: [
            Text(
              'links: $mylinks[0][0]',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.amber,
              ),
            ),
            SizedBox(height: 5),
            Consumer<LinksController>(builder: (context, linksData, child) {
              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: boxoflinks.length,
                itemBuilder: (BuildContext context, int index) {
                  final link = boxoflinks.getAt(index);
                  return buildLinksPage(context, link!);
                },
              );
            }),
          ],
        ),
      );
    }
  }

  Widget buildLinksPage(
    BuildContext context,
    m.Link link,
  ) {
    return Card(
      color: Colors.white,
      child: Text(
        link.url!,
        maxLines: 4,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

var boxoflinks = BoxOfLinks.getLinks();

class LinksController with ChangeNotifier {
  late m.Link _link;
  LinksController() {
    _link = m.Link(
      url: 'https://www.linkedin.com/in/sumangla-bafna-7a9b661a9/',
      description: 'LinkedIn',
    );
  }

  m.Link get Link => _link;

  void setLink(m.Link link) {
    _link = link;
    notifyListeners();
  }

  void addLink(m.Link link) {
    boxoflinks.add(link);
    notifyListeners();
  }

  void removeLink(linkKey) {
    boxoflinks.delete(linkKey);
    notifyListeners();
  }

  void emptyLink() async {
    await boxoflinks.clear();
    notifyListeners();
  }
}

Future<void> launchUrl({required String url}) async {
  String checkUrl(String url) {
    if (url.startsWith('http')) {
      return url;
    } else {
      return 'https://$url';
    }
  }

  url = checkUrl(url);
  try {
    final bool shouldContinue = await canLaunch(url);
    if (shouldContinue) {
      await launch(url, forceSafariVC: false);
      return;
    }
    throw Exception('Could not launch $url');
  } catch (e) {
    print('idk');
  }
}
