import 'package:flutter/material.dart';

class BoardEditPage extends StatefulWidget {
  const BoardEditPage({Key? key}) : super(key: key);

  @override
  State<BoardEditPage> createState() => _BoardEditPageState();
}

class _BoardEditPageState extends State<BoardEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('MyBoard'),
            const SizedBox(
              height: 10,
            ),
            const Text('Edit'),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://media.istockphoto.com/photos/blue-velvet-picture-id174897941?k=20&m=174897941&s=612x612&w=0&h=earrO_3wBH7HIFScdG5hpUvOUVb35CjrO8McEkHi9x4='),
                    fit: BoxFit.fill,
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: const Text('Book Tatkal Tickets'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: const Text('Book Tatkal Tickets'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
