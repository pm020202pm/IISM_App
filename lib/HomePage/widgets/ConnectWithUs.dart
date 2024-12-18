
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils.dart';
class ConnectWithUs extends StatelessWidget {
  ConnectWithUs({super.key});
  double iconSize = 25;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        mediaIcon(FontAwesomeIcons.globe, Colors.blue, iconSize, 'https://iism24.iitk.ac.in/'),
        const SizedBox(width: 14,),
        InkWell(
          onTap: () {
            launchUrl(
                Uri.parse(isStaff? 'https://www.instagram.com/iissm_2024/':'https://www.instagram.com/interiit_sports2024/'),
                mode: LaunchMode.externalApplication
            );
          },
          child: GradientIcon(
            icon: FontAwesomeIcons.instagram, // Use FontAwesome icon
            size: iconSize, // Set the size of the icon
            gradient: const LinearGradient(
              colors: [
                Color(0xFF833AB4), // Purple
                Color(0xFFC13584), // Pink
                Color(0xFFF56040), // Orange
                Color(0xFFFCAF45), // Yellow
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        const SizedBox(width: 14,),
        mediaIcon(FontAwesomeIcons.xTwitter, Colors.black, iconSize-1, 'https://x.com/interiit_sports'),
        const SizedBox(width: 14,),
        mediaIcon(FontAwesomeIcons.youtube, Colors.red.shade600, iconSize, 'https://www.youtube.com/@InterIIT_SportsMeet2024'),
        const SizedBox(width: 15,),
        mediaIcon(FontAwesomeIcons.linkedin, Colors.blue.shade800, iconSize, 'https://www.linkedin.com/company/inter-iit-sports-meet-2024/mycompany/'),
      ],
    );
  }
}
Widget mediaIcon(IconData icon, Color color, double iconSize, String url){
  return InkWell(
      onTap: () {
        launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication
        );
      },
      child: Icon(icon, color: color, size: iconSize,)
  );
}

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon({
    required this.icon,
    required this.size,
    required this.gradient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return gradient.createShader(bounds);
      },
      child: FaIcon(
        icon,
        size: size,
        color: Colors.white, // The color is ignored due to ShaderMask
      ),
    );
  }
}