// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myboardapp/main.dart';
import 'package:myboardapp/models/myboard.dart';
import 'package:myboardapp/pages/homepage.dart';
import 'package:myboardapp/pages/todo.dart';
import 'package:provider/provider.dart';
import '../boxes.dart';
import 'package:myboardapp/models/myboard.dart' as m;

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
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(height: 50),
              Text(
                'Enter your links!',
                style: GoogleFonts.lato(
                  fontSize: 26,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
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
                        border: InputBorder.none, hintText: 'Enter link here'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
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
                height: 5,
              ),
              TextButton(
                onPressed: () {
                  Provider.of<LinksController>(context, listen: false).addLink(
                    m.Link(
                      url: _linkController.text,
                      description: _descriptionController.text,
                    ),
                  );
                  final box = BoxesOfLinks.getLinks();
                  final latestlink = box.getAt(box.length - 1);
                  var index = box.length - 1;
                  print('pinnedwidget length: ${pinnedWidgets.length}');
                  int pinnedWidgetIndex = pinnedWidgets.length;

                  pinnedWidgets.add(
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 1,
                      child: PinnedLink(latestlink!.url, latestlink.description,
                          index, pinnedWidgetIndex),
                    ),
                  );
                  Navigator.pushNamed(context, '/homepage');
                },
                child: Text(
                  'Add Link',
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
        child: Container(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
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
            image: DecorationImage(image: AssetImage('assets/images/www.png')),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
        ),
        onDoubleTap: () {
          boxoflinks.delete(index);
          pinnedWidgets.removeAt(pinnedWidgetIndex);
        },
      );

  Widget BuildContent(List<Link> mylinks) {
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
    Link link,
  ) {
    return Card(
      color: Colors.white,
      child: Text(
        link.url!,
        maxLines: 2,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

var boxoflinks = BoxesOfLinks.getLinks();

class LinksController with ChangeNotifier {
  late m.Link _link;
  LinksController() {
    _link = m.Link(
        url: 'https://www.linkedin.com/in/sumangla-bafna-7a9b661a9/',
        description: 'LinkedIn');
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
