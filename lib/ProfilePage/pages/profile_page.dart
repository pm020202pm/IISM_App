import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../DashBoard/pages/dashboard.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
import '../models/ParticipantModel.dart';

class PlayerProfilePage extends StatelessWidget {
  final ParticipantModel player;
  const PlayerProfilePage({super.key, required this.player});

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('gender');
    await prefs.remove('photo');
    await prefs.remove('sport');
    await prefs.remove('team');
    await prefs.remove('id_generation');
    await prefs.remove('contact');
    await prefs.remove('hall_name');
    await prefs.setBool('isLoggedIn', false).then((value) => successSnackMsg("Logged out successfully"));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 16, right: 16),
            child: pageTitleText("My Profile")
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: dark? Colors.black : blueColor,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: dark? Colors.green.shade900 :Colors.green.shade300.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                      child: Image.network(player.id_generation, width: 200, height: 200, fit: BoxFit.cover)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(player.name.toUpperCase(), 20, FontWeight.w600, dark? Colors.grey.shade100: whiteColor, 1.8),
                        customText(player.email, 14, FontWeight.w500, dark? Colors.grey.shade100: whiteColor, 1.4),
                        customText(player.gender, 14, FontWeight.w500, dark? Colors.grey.shade100: whiteColor, 1.4),
                        customText("IIT KANPUR", 14, FontWeight.w500, dark? Colors.grey.shade100: whiteColor, 1.4),
                        customText("Volleyball", 14, FontWeight.w500, dark? Colors.grey.shade100: whiteColor, 1.4),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            octagonalButton(" Edit ",12, 12,Colors.purple.shade400, Colors.purple.shade800,(){}),
                            const SizedBox(width: 10),
                            octagonalButton("Logout",12,12,Colors.red.shade400, Colors.red.shade700, () async {
                              await logout().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashBoard(index: 5))));
                            }),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}


class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;

    final double horizontalPadding = width * 0.15; // Adjust as needed
    final double verticalPadding = height * 0.15; // Adjust as needed

    path.moveTo(width * 0.5, 0); // Top vertex
    path.lineTo(width - horizontalPadding, verticalPadding); // Top-right
    path.lineTo(width - horizontalPadding, height - verticalPadding); // Bottom-right
    path.lineTo(width * 0.5, height); // Bottom
    path.lineTo(horizontalPadding, height - verticalPadding); // Bottom-left
    path.lineTo(horizontalPadding, verticalPadding); // Top-left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


Widget octagonalButton(String text, double textSize,double padding, Color bgColor, Color borderColor, Function() onTap){
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
            child: customText(text, 12, FontWeight.w500, Colors.transparent, 1)
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