

import 'dart:ui';

bool dark= false;
Color whiteColor = const Color.fromRGBO(255, 255, 255,1);
Color yellowColor = const Color.fromRGBO(235, 161, 45, 1);
Color darkYellowColor = const Color.fromRGBO(200, 140, 45, 1);
Color blueColor = const Color.fromRGBO(140, 223, 229,1);
Color darkBlueColor = const Color.fromRGBO(31, 69, 107,1);
String formatName(String name) {
  return name.split(' ').map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return word;
  }).join(' ');
}

Map<String, String> sportsTableMap = {
  'Cricket': 'crickettable',
  'VolleyBall': 'volleyballtable',
  'BasketBall': 'basketballtable',
  'Lawn Tennis': 'lawntennistable',
  'Hockey': 'hockeytable',
  'Table Tennis': 'tabletennistable',
};