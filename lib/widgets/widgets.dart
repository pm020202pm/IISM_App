import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iism/utils.dart';
Widget customText(String text, double fontSize, FontWeight fontWeight, Color color, double? height){
  return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: 'GlacialIndifference',
        height: height??1,),
      overflow: TextOverflow.ellipsis
  );
}


Widget pageTitleText(String text){
  return customText(text, 42, FontWeight.w600, dark? Colors.grey.shade100 :Colors.grey.shade800, 1);
}

class OctagonClipper extends CustomClipper<Path> {
  final double padding;
  OctagonClipper({required this.padding});
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;

    // const double padding = 20; // Adjust this value to modify the octagon cut

    path.moveTo(0, 0); // Top-left cut
    path.lineTo(width - padding, 0); // Top-right cut
    path.lineTo(width, padding); // Right-top cut
    path.lineTo(width, height); // Right-bottom cut
    path.lineTo(padding, height); // Bottom-left cut
    path.lineTo(0, height - padding); // Left-bottom cut
    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget setScore(String setCount, String score1, String score2){
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            child: customText("Set $setCount", 11, FontWeight.w700, Colors.grey.shade800, 1)),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              customText(score1, 14, FontWeight.w700, Colors.grey.shade800, 1.4),
              customText(" : ", 13, FontWeight.w700, Colors.grey.shade700, 1.4),
              customText(score2, 14, FontWeight.w700, Colors.grey.shade800, 1),
            ],
          ),
        ),

      ],
    ),
  );
}

Widget score2(String score1, String score2){
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        customText(score1, 15, FontWeight.w900, Colors.grey.shade900, 1.4),
        customText(" : ", 13, FontWeight.w700, Colors.grey.shade700, 1.4),
        customText(score2, 15, FontWeight.w900, Colors.grey.shade900, 1.4),
      ],
    ),
  );
}

void errorSnackMsg(String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}


void successSnackMsg(String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
  );
}