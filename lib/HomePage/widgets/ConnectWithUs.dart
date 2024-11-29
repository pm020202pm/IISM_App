
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
class ConnectWithUs extends StatelessWidget {
  ConnectWithUs({super.key});
  double iconSize = 25;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            launchUrl(
                Uri.parse('https://www.instagram.com/interiit_sports2024/'),
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
        const SizedBox(width: 11,),
        InkWell(
          onTap: (){
            launchUrl(
                Uri.parse('https://x.com/interiit_sports'),
                mode: LaunchMode.externalApplication
            );
          },
            child: Icon(FontAwesomeIcons.xTwitter, color: Colors.black, size: iconSize,)),
        const SizedBox(width: 8,),
        InkWell(
          onTap:(){
            launchUrl(
                Uri.parse('https://www.youtube.com/@InterIIT_SportsMeet2024'),
                mode: LaunchMode.externalApplication
            );
          },
            child: Icon(FontAwesomeIcons.youtube,color: Colors.red.shade600, size: iconSize,)),
        const SizedBox(width: 14,),
        InkWell(
          onTap: () {
            launchUrl(
                Uri.parse('https://www.linkedin.com/company/inter-iit-sports-meet-2024/mycompany/'),
                mode: LaunchMode.externalApplication
            );
          },
            child: Icon(FontAwesomeIcons.linkedin, color: Colors.blue.shade800, size: iconSize,)
        ),


      ],
    );
  }
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