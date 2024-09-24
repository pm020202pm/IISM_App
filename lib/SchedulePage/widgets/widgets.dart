import 'package:flutter/material.dart';
Widget verticalLogoWithCollegeName(String collegeName, double height, double width) {
  return  Container(
    width: 90,
    alignment: Alignment.center,
    child: Column(
      children: [
        Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(70),
            ),
            child: Image.asset('assets/logo/$collegeName.png', width: width, height: height)
        ),
        customText(collegeName.toUpperCase(), 10, FontWeight.w900, Colors.grey.shade800,1.9),
      ],
    ),
  );
}

Widget horizontalLogoWithCollegeName(String collegeName, double height, double width) {
  return  Container(
    width: 90,
    alignment: Alignment.center,
    child: Row(
      children: [
        Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(70),
            ),
            child: Image.asset('assets/logo/$collegeName.png', width: width, height: height)
        ),
        customText(collegeName.toUpperCase(), 10, FontWeight.w900, Colors.grey.shade800,1.9),
      ],
    ),
  );
}


Widget customText(String text, double fontSize, FontWeight fontWeight, Color color, double? height){
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: 'Aptos',
      height: height??1,),
      overflow: TextOverflow.ellipsis
  );
}

Widget customChips(String sport, IconData icon, bool isActive, Function() onTap){
  return Container(
    decoration: BoxDecoration(
      color: isActive? Colors.blue.shade300: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(30.0),
      border: Border.all(color: isActive? Colors.blue.shade400:Colors.grey.shade300),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.blue,
        borderRadius: BorderRadius.circular(30.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 3.0, bottom: 3.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isActive? Colors.white: Colors.grey, size: 15.0),
              const SizedBox(width: 3.0),
              Text(sport,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: isActive? Colors.white:Colors.grey.shade600,
                    fontFamily: 'Aptos'
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget customChips1(String sport, IconData icon, bool isActive, Function() onTap){
  return Container(
    decoration: BoxDecoration(
      color: isActive? Colors.blue.shade300: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(30.0),
      border: Border.all(color: isActive? Colors.blue.shade400:Colors.grey.shade300),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.blue,
        borderRadius: BorderRadius.circular(30.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 3.0, bottom: 3.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 3.0),
              Icon(icon, color: isActive? Colors.white: Colors.grey, size: 22.0),
              const SizedBox(width: 3.0),
              if(isActive) Text(sport,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: isActive? Colors.white:Colors.grey.shade600,
                    fontFamily: 'Aptos'
                ),
              ),
              if(isActive) const SizedBox(width: 3.0),
            ],
          ),
        ),
      ),
    ),
  );
}