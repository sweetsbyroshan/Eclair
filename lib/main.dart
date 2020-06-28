import 'package:eclair/pages/recipe.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/favourite.dart';
import 'pages/home.dart';
import 'pages/recipe2.dart';
import 'pages/search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xFFFBDFA8),
          backgroundColor: Color(0xFFF9F6EE),
          accentColor: Color(0xFFEA3C53),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
            headline1: GoogleFonts.playfairDisplay()
                .copyWith(color: Color(0xFF160601), fontSize: 21),
            headline2: GoogleFonts.playfairDisplay()
                .copyWith(color: Color(0xFF160601), fontSize: 18),
            subtitle1: GoogleFonts.montserrat()
                .copyWith(color: Color(0xFFEA3C53), fontSize: 18),
            subtitle2: GoogleFonts.montserrat()
                .copyWith(color: Color(0xFF160601), fontSize: 18),
            bodyText1: GoogleFonts.montserrat().copyWith(
                color: Color(0xFF160601),
                fontSize: 16,
                fontWeight: FontWeight.w600),
            bodyText2: GoogleFonts.montserrat().copyWith(
              color: Color(0xFF160601),
              fontSize: 14,
            ),
            caption: GoogleFonts.montserrat()
                .copyWith(color: Color(0xFFEA3C53), fontSize: 14),
          )),
      home: HomePage(),
      routes: {
        HomePage.routeName: (c) => HomePage(),
        SearchPage.routeName: (c) => SearchPage(),
        RecipePage.routeName: (c) => RecipePage(),
        RecipePage2.routeName: (c) => RecipePage2(),
        FavouritePage.routeName: (c) => FavouritePage(),
      },
    );
  }
}
