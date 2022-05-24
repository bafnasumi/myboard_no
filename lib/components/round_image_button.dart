// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildCircleButton(BuildContext context, String buttontext,
        String imagestring, VoidCallback onTap) =>
    Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(28),
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.black,
          onTap: onTap,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 3),
              borderRadius: BorderRadius.circular(28),
              image: DecorationImage(
                image: AssetImage(imagestring),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10.0),
              color: Colors.black45,
              child: Text(
                buttontext,
                style: GoogleFonts.andada(
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 3.0,
                      offset: Offset(
                        2.0,
                        2.0,
                      ),
                    ),
                  ],
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
