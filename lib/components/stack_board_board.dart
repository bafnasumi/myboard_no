import 'package:myboardapp/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:pinningtrialpackage/pinningtrialpackage.dart';

Widget personalBoard(
    BuildContext context, StackBoardController _boardController) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.73,
    width: MediaQuery.of(context).size.width * 0.95,
    decoration: BoxDecoration(
      boxShadow: const [
        BoxShadow(
          blurRadius: 3.0,
          blurStyle: BlurStyle.outer,
          color: Colors.black54,
        )
      ],
      borderRadius: BorderRadius.circular(25.0),
      image: const DecorationImage(
        image: NetworkImage(
            'https://media.istockphoto.com/photos/blue-velvet-picture-id174897941?k=20&m=174897941&s=612x612&w=0&h=earrO_3wBH7HIFScdG5hpUvOUVb35CjrO8McEkHi9x4='),
        fit: BoxFit.fill,
      ),
    ),
    child: StackBoard(
      controller: _boardController,
      caseStyle: const CaseStyle(
        borderColor: Colors.grey,
        iconColor: Colors.white,
      ),
      //background: ColoredBox(color: Colors.grey[100]!),
      customBuilder: (StackBoardItem t) {
        if (t is CustomItem) {
          return ItemCase(
            key: Key('StackBoardItem${t.id}'), // <==== must
            isCenter: false,
            onDel: () async => _boardController.remove(t.id),
            onTap: () => _boardController.moveItemToTop(t.id),
            caseStyle: const CaseStyle(
              borderColor: Colors.grey,
              iconColor: Colors.white,
            ),
            child: Container(
              width: 100,
              height: 100,
              color: t.color,
              alignment: Alignment.center,
              child: const Text(
                'Custom item',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
        return null;
      },
    ),
  );
}