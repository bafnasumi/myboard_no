// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myboardapp/main.dart';
import 'package:myboardapp/models/myboard.dart';

import '../boxes.dart';
import 'package:intl/intl.dart';

class Links extends StatefulWidget {
  const Links({Key? key}) : super(key: key);

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {
  //List<Link> mylinks = [];
  ValueNotifier<Link?> mylinks = ValueNotifier(Link());
  final _linkController = TextEditingController();
  final _descriptionController = TextEditingController();
  var thisLink = '';
  var thisDescription = '';

  Future addLink(String url, String description) async {
    final localaddLink = Link()
      ..url = url
      ..description = description;
    final box = Boxes.getLinks();
    ValueNotifier<Link?> mylinks = ValueNotifier(localaddLink);
    box.add(localaddLink);
  }

  @override
  void initState() {
    _linkController.addListener(() {
      setState(() {});
    });
    _descriptionController.addListener(() {
      setState(() {});
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    // TODO: implement dispose
    super.dispose();
  }

//   Consider setting mainAxisSize to MainAxisSize.min and using FlexFit.loose fits for the flexible
// children (using Flexible rather than Expanded). This will allow the flexible children to size
// themselves to less than the infinite remaining space they would otherwise be forced to take, and
// then will cause the RenderFlex to shrink-wrap the children rather than expanding to fit the maximum
// constraints provided by the parent.

  @override
  Widget build(BuildContext context) {
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
                      thisDescription = value;
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
                        thisLink = value;
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
                  addLink(thisLink, thisDescription);
                },
                child: Text(
                  'Add Link',
                ),
              ),
              ValueListenableBuilder<Box<Link>>(
                  valueListenable: Boxes.getLinks().listenable(),
                  builder: (context, box, _) {
                    final mylinks = box.values.toList().cast<Link>();
                    return BuildContent(mylinks);
                  })
            ],
          ),
        ),
      ),
    );
  }

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
      // final netExpense = links.fold<double>(
      //   0,
      //   (previousValue, transaction) => transaction.isExpense
      //       ? previousValue - transaction.amount
      //       : previousValue + transaction.amount,
      // );
      // final newExpenseString = '\$${netExpense.toStringAsFixed(2)}';
      // final color = netExpense > 0 ? Colors.green : Colors.red;

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
            SizedBox(height: 24),
            ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: mylinks.length,
              itemBuilder: (BuildContext context, int index) {
                final link = mylinks[index];
                return buildTransaction(context, link);
              },
            ),
          ],
        ),
      );
    }
  }

  Widget buildTransaction(
    BuildContext context,
    Link link,
  ) {
    // final color = transaction.isExpense ? Colors.red : Colors.green;
    // final date = DateFormat.yMMMd().format(transaction.createdDate);
    // final amount = '\$' + transaction.amount.toStringAsFixed(2);

    return Card(
      color: Colors.white,
      child: Text(
        link.url,
        maxLines: 2,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      //subtitle: Text(link.description),
    );
  }
}
