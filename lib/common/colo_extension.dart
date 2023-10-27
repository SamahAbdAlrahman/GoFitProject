
import 'package:flutter/material.dart';

class TColor {
  static Color get primaryColor1 => const Color.fromRGBO(248, 96, 2, 1.0);
  static Color get primaryColor2 => const Color.fromRGBO(190, 57, 33, 1.0);
  // Color.fromRGBO(248, 96, 2, 1.0),
  // Color.fromRGBO(190, 57, 33, 1.0)
  static Color get secondaryColor1 => const Color(0xffd38e5c);
  static Color get secondaryColor2 => const Color(0xff8f5c4a);


  static List<Color> get primaryG => [ primaryColor2, primaryColor1 , secondaryColor1 ];
  static List<Color> get secondaryG => [secondaryColor2, secondaryColor1];

  static Color get black => const Color(0xd2000000);
  static Color get white => Colors.white;
  static Color get lightGray => const  Color.fromRGBO(200, 200, 200, 0.7);

 static  Color get primary => const Color.fromRGBO(248, 96, 2, 1.0);

  static Color get primaryText => const Color(0xff221E3A);
  static Color get secondaryText => const Color(0xff4d4a4a);
  static Color get green=> const Color(0xff77E517);

  static Color get gray => const Color(0xff777474);
  static Color get divider => const Color(0xffE1E1E1);

}