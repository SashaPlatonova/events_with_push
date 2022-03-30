import 'package:flutter/material.dart';

class AppTheme {
  static const LinearGradient gradient = LinearGradient(colors: []);

  //свадьба плитка
  static const Color pinkBright = Color.fromARGB(163, 240, 11, 81);
  static const Color pinkPurple =  Color.fromARGB(163, 115, 0, 92);
  static const LinearGradient weddingGradient = LinearGradient(
    colors: [pinkBright, pinkPurple],
  );

  //др плитка
  static const Color purplePink = Color.fromARGB(171, 248, 105, 213);
  static const Color purpleDark =  Color.fromARGB(173, 86, 80, 222);
  static const LinearGradient birthdayGradient = LinearGradient(
    colors: [pinkBright, purpleDark],
  );

  //вечеринка плитка
  static const Color turquoise = Color.fromRGBO(120, 242, 233, 0.97);
  static const Color purpleBlue =  Color.fromRGBO(182, 94, 186, 0.81);
  static const LinearGradient partyGradient = LinearGradient(
    colors: [turquoise, purpleBlue],
  );

  // другие плитка
  static const Color lightOrange = Color.fromRGBO(255, 205, 165, 0.99);
  static const Color mediumOrange = Color.fromRGBO(239, 87, 100, 0.89);
  static const Color redOrange =  Color.fromRGBO(238, 77, 95, 0.63);
  static const LinearGradient otherGradient = LinearGradient(
    colors: [lightOrange, mediumOrange, redOrange],
  );

  static const List<LinearGradient> listGradient = [
    weddingGradient,
    birthdayGradient,
    partyGradient,
    otherGradient,
  ];

  static const Color boldColorFont = Color.fromRGBO(151, 94, 186, 1);
  static const Color pinkColorFont = Color.fromRGBO(248, 105, 148, 1);

  static const Color valueEventColor = Color.fromRGBO(255, 255, 255, 0.65);
  static const Color grey = Color.fromRGBO(203, 198, 206, 1);
  static const Color darkBorderPurple = Color.fromRGBO(162, 83, 210, 1.0);
  static const Color borderPurple = Color.fromRGBO(174, 118, 208, 1.0);
  static const Color panelPink = Color.fromARGB(15, 248, 105, 148);
  static const Color bottomNavigationPurple = Color.fromRGBO(226, 194, 245, 1);
  static const Color bottomAddSheetDate = Color.fromARGB(179, 80, 80, 222);
  static const Color addButton = Color.fromARGB(179, 240, 11, 41);

  static const Color white = Color(0xFFFBFAFF);
  static const Color black = Color(0xFF000000);

  static const TextStyle mainPageHeadline = TextStyle(
    fontSize: 20,
    color: boldColorFont,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle mainPageSmallHeadline = TextStyle(
    fontSize: 15,
    color: pinkColorFont,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle eventHeadline = TextStyle(
    fontSize: 15,
    color: white,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle valueEventText = TextStyle(
    fontSize: 15,
    color: valueEventColor,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle eventPanelHeadline = TextStyle(
    fontSize: 12,
    color: boldColorFont,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle dateEventPanelText = TextStyle(
    fontSize: 10,
    color: grey,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle searchString = TextStyle(
    fontSize: 15,
    color: grey,
    fontWeight: FontWeight.w400,
  );



  static const TextStyle hintsText = TextStyle(
    fontSize: 15,
    color: Color.fromARGB(255, 203, 198, 206)
  );

  static OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppTheme.borderPurple),
  );

  static OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppTheme.darkBorderPurple),
  );

  static OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppTheme.mediumOrange),
  );

  static OutlineInputBorder focusedErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppTheme.redOrange),
  );

  static List<BoxShadow> getShadow(Color color) {
    return [
      BoxShadow(
        color: color.withOpacity(0.3),
        offset: Offset(0, 6),
        blurRadius: 10,
        spreadRadius: 2,
      ),
    ];
  }

  static LinearGradient getGradientByName(String gradient) {
    switch (gradient){
      case 'birthdayGradient':
          return birthdayGradient;
      case 'weddingGradient':
        return weddingGradient;

      case 'partyGradient' :
        return partyGradient;
      default:
        return otherGradient;
    }
  }
}
