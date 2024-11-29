import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../widgets/widgets.dart';
class LogoBg extends StatelessWidget {
  const LogoBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 140, bottom: 80, left: 80, right: 80),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset('assets/logo/logo.png')),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText("57", 30, FontWeight.bold, whiteColor, 1),
                customText("th", 18, FontWeight.bold, whiteColor, 1),
              ],
            ),
            const SizedBox(width: 7),
            customText("INTER IIT", 30, FontWeight.bold, blueColor, 1.2),
          ],
        ),
        customText("SPORTS MEET 2024", 30, FontWeight.bold, whiteColor, 1.2),
        customText("IIT KANPUR", 30, FontWeight.bold, yellowColor, 1.2),
        const SizedBox(height: 100),
      ],
    );
  }
}
