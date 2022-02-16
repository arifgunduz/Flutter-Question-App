import 'package:flutter/material.dart';

class ThemeHelper {
  static Color accentColor = Colors.black;
  static Color shadowColor = Color(0xff000000);
  static ThemeData getThemeData() {
    return ThemeData(
        fontFamily: 'MochiyPopOne',
        primarySwatch: Colors.blueGrey,
        colorScheme:
            ColorScheme.light(primary: Colors.red, secondary: Colors.orange),
        textTheme: TextTheme(
          headline3: TextStyle(color: accentColor, fontFamily: 'MochiyPopOne'),
          headline4: TextStyle(color: accentColor, fontFamily: 'MochiyPopOne'),
        ));
  }

  static BoxDecoration fullEkranBgBoxDecoration(
      {String backgroundAssetImage = 'assets/images/255.png'}) {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage(backgroundAssetImage), fit: BoxFit.cover));
  }

  static roundBoxDeco({Color color = Colors.white, double radius = 15}) {
    return BoxDecoration(
        color: color, borderRadius: BorderRadius.all(Radius.circular(radius)));
  }
}
