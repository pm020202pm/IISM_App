
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