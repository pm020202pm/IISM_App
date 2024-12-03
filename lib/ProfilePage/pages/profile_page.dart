import 'package:flutter/material.dart';
import 'package:iism/ProfilePage/widgets/OctagonalButton.dart';
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
    await prefs.remove('sport');
    await prefs.remove('team');
    await prefs.remove('id_generation');
    await prefs.remove('hall_name');
    await prefs.setBool('isLoggedIn', false).then((value) => successSnackMsg("Logged out successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: dark? Colors.black : Colors.white,
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(70),
        //   child: AppBar(
        //     backgroundColor: Colors.transparent,
        //     flexibleSpace: Container(
        //       alignment: Alignment.centerLeft,
        //       height: 80,
        //       child: Padding(
        //         padding: const EdgeInsets.only(left: 16, right: 16),
        //         child: pageTitleText("My Profile")
        //       ),
        //     ),
        //   ),
        // ),
        body: Center(
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: dark? Colors.black : blueColor,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: dark? Colors.green.shade900 :blueColor.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      height: 260,
                      width: 260,
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      placeholder: const AssetImage('assets/files/shimmer.gif'),  // Placeholder image or GIF
                      image: NetworkImage(player.id_generation),     // Actual image to be loaded
                      fit: BoxFit.cover,
                      placeholderFit: BoxFit.cover,                   // Adjust placeholder fit
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(player.name.toUpperCase(), 20, FontWeight.w600, dark? Colors.grey.shade100: whiteColor, 1.8),
                        customText(player.email, 15, FontWeight.w700, dark? Colors.grey.shade100: whiteColor, 1.3),
                        customText(player.gender, 15, FontWeight.w500, dark? Colors.grey.shade100: whiteColor, 1.3),
                        customText(player.team, 15, FontWeight.w500, dark? Colors.grey.shade100: whiteColor, 1.3),
                        customText(player.sport, 15, FontWeight.w500, dark? Colors.grey.shade100: whiteColor, 1.3),
                        const SizedBox(height: 30),
                        OctagonalButton(
                            text: "  LOGOUT  ",
                            padding: 12,
                            textSize: 12,
                            bgColor: Colors.red.shade400,
                            borderColor: Colors.red.shade700,
                            onTap: () async {
                              await logout().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashBoard(index: 5))));
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//
// Widget octagonalButton(String text, double textSize,double padding, Color bgColor, Color borderColor, Function() onTap){
//   return InkWell(
//     onTap: onTap,
//     child: Stack(
//       alignment: Alignment.center,
//       children: [
//
//         ClipPath(
//           clipper: OctagonClipper(padding: 10),
//           child: Container(
//             padding: EdgeInsets.all(padding),
//             decoration: BoxDecoration(
//               // borderRadius: BorderRadius.circular(40),
//               color: bgColor,
//             ),
//             child: customText(text, 12, FontWeight.w500, Colors.transparent, 1)
//           ),
//         ),
//         ClipPath(
//           clipper: OctagonClipper(padding: 15),
//           child: Container(
//             padding: EdgeInsets.all(padding-5),
//             decoration: BoxDecoration(
//               border: Border.all(color: borderColor, width: 1),
//             ),
//             child: customText(text, textSize, FontWeight.w500, Colors.white, 1)
//           ),
//         ),
//       ],
//     ),
//   );
// }