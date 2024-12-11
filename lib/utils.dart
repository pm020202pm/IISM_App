

import 'dart:ui';
bool expanded = true;
bool dark= false;
bool isStaff = false;
String adminSport = '';
String token = '';
// bool isFirstLaunch = true;
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
  'All': 'all',
  'Cricket': 'cricket',
  'VolleyBall': 'volleyball',
  'BasketBall': 'basketball',
  'Lawn Tennis': 'lawntennis',
  'Hockey': 'hockey',
  'Table Tennis': 'tabletennis',
};


Map<String, String> locationVenueMap = {
  'cricket': "https://maps.app.goo.gl/qWAPavBtsb7KCsYb9",
  'volleyball': "https://maps.app.goo.gl/N1Wifb1BHsvNWGR8A",
  'basketball': 'https://maps.app.goo.gl/6sn6m9muKxZHhYoN7',
  'lawn tennis': "https://maps.app.goo.gl/YLZz5zWsPFpyZ6wR8",
  'hockey': "https://maps.app.goo.gl/uHzKub8eMjU5ELnKA",
  'table tennis': "https://maps.app.goo.gl/mS963wEW1xnDaKxb8",
};
