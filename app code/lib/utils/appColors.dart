import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

ThemeData myTheme(Brightness brightness) {
  bool isDarkMode = brightness == Brightness.dark;

  return ThemeData(
    brightness: brightness,

    appBarTheme: AppBarTheme(


      titleTextStyle: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    cardTheme: CardTheme(
      elevation: 3,
      color: isDarkMode ? Color(0xFF263238) : Color(0xFFFFF3E0), // Darker card in dark mode
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      bodyMedium: TextStyle(
        color: isDarkMode ? Color(0xFFBBDEFB) : Color(0xFF1E88E5), // Blueish gray for secondary text
      ),
      titleLarge: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFF7043), // Vibrant Orange
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFFFF7043), // Vibrant Orange
      textTheme: ButtonTextTheme.primary,
    ),

    dialogTheme: DialogTheme(
      backgroundColor: isDarkMode ? Color(0xFF263238) : Color(0xFFFFF3E0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
  );
}




//import 'package:flutter/material.dart';
//
// ThemeData myTheme(Brightness brightness) {
//   bool isDarkMode = brightness == Brightness.dark;
//
//   return ThemeData(
//     brightness: brightness,
//     primaryColor: Color(0xFF6D4C41), // Warm brownish-gray for accents
//     scaffoldBackgroundColor: isDarkMode ? Color(0xFF4E4E4E) : Color(0xFFE8E8E8),
//
//     appBarTheme: AppBarTheme(
//       backgroundColor: isDarkMode ? Color(0xFF616161) : Color(0xFFF5F5F5),
//       elevation: 1,
//       iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
//       titleTextStyle: TextStyle(
//         color: isDarkMode ? Colors.white : Colors.black,
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//
//     cardTheme: CardTheme(
//       elevation: 3,
//       color: isDarkMode ? Color(0xFF757575) : Colors.white.withAlpha(230),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//     ),
//
//     textTheme: TextTheme(
//       bodyLarge: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
//       bodyMedium: TextStyle(
//         color: isDarkMode ? Color(0xFFF0F0F0) : Color(0xFF5F6368),
//       ),
//       titleLarge: TextStyle(
//         color: isDarkMode ? Colors.white : Colors.black,
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//       ),
//     ),
//
//     floatingActionButtonTheme: FloatingActionButtonThemeData(
//       backgroundColor: Color(0xFF6D4C41), // Matches primary accent
//     ),
//
//     buttonTheme: ButtonThemeData(
//       buttonColor: Color(0xFF6D4C41), // Unified button color
//       textTheme: ButtonTextTheme.primary,
//     ),
//
//     dialogTheme: DialogTheme(
//       backgroundColor: isDarkMode ? Color(0xFF757575) : Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//     ),
//   );
// }

//class MyColors{
//   static const Color appbarColor = Color(0xffcad3d2);
//   static const Color cardColor = Colors.white54;
//   static const Color gradiant1Color  = Color(0xFF00FFF8);
//   static const Color gradiant2Color  = Color(0xFF0000FF);
//   static const Color disabledButtonColor  = Color(0xff7a7ac4);
//   static const Color startUpColorForPdfBackground  =Colors.white;
//   static const Color startUpDefaultColorForIcon  =Color(0xff022b76);
//   static const Color iconPreviewColor  = Color(0xff022b76);
//   static const Color introScreenBackColor  = Color(0xffb4c6f0);
//   static const Color textColor  =Color(0xff022b76);
//   static const Color startUpDefaultColorForPdfText  =Colors.black;
//   static const Color drawerBackgroundColor  =Color(0xFF0FADEC);
//   static const Color drawerIconColor  =Colors.lightBlueAccent;
//   static const Color splashScreenColor  =Color(0xff041931);
//
//
//
// }