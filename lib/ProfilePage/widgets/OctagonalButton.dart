import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
class OctagonalButton extends StatelessWidget {
  const OctagonalButton({super.key, required this.text, required this.padding, required this.textSize, required this.bgColor, required this.borderColor, required this.onTap});
  final String text;
  final double padding;
  final double textSize;
  final Color bgColor;
  final Color borderColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [

          ClipPath(
            clipper: OctagonClipper(padding: 10),
            child: Container(
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(40),
                  color: bgColor,
                ),
                child: customText(text, textSize, FontWeight.w500, Colors.transparent, 1)
            ),
          ),
          ClipPath(
            clipper: OctagonClipper(padding: 15),
            child: Container(
                padding: EdgeInsets.all(padding-5),
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: customText(text, textSize, FontWeight.w500, Colors.white, 1)
            ),
          ),
        ],
      ),
    );
  }
}
