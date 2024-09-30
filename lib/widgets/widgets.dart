import 'package:flutter/material.dart';
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