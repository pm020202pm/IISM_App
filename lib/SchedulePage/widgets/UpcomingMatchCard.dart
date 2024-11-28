import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';
import 'package:iism/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/widgets.dart';
import '../models/MatchesModel.dart';
import '../pages/schedule_page.dart';
class UpcomingMatchCard extends StatelessWidget {
  final UpcomingMatchesModel match;
  const UpcomingMatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    IconData category = (match.category=='Men')? Icons.male: (match.category=='Men')? Icons.female: Icons.group;
    double horizontalPadding = size.width>620? 100 :size.width>500? 50 :16;
    return ClipPath(
      clipper: OctagonClipper3(padding: 16+horizontalPadding),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: size.width-horizontalPadding*2,
            decoration: BoxDecoration(
              color: blueColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: horizontalPadding),
            child: ClipPath(
              clipper: OctagonClipper3(padding: 12),
              child: Container(
                margin: const EdgeInsets.all(2),
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalLogoWithCollegeName(match.team1, 45, 45),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 40,),
                              customText(match.matchTime, 14, FontWeight.w900, darkBlueColor, 1),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: customText(match.matchDate.substring(0,5).toUpperCase(), 11, FontWeight.w600, Colors.white, 1),
                              ),
                              // if(size.width>=500)InkWell(
                              //   onTap:(){},
                              //   child: Row(
                              //     children: [
                              //       customText(match.venue, 10, FontWeight.w600, Colors.green.shade700, 2),
                              //       Icon(Icons.location_on_outlined, color: Colors.green.shade700, size: 15,)
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          InkWell(
                            onTap:(){openLocationUrl("https://maps.app.goo.gl/G9m3EkGGWUKzQfLk9");},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                customText(match.venue, 11, FontWeight.w600, Colors.green.shade700, 2),
                                Icon(Icons.location_on_outlined, color: Colors.green.shade700, size: 15,)
                              ],
                            ),
                          ),
                        ],
                      ),
                      verticalLogoWithCollegeName(match.team2, 45, 45),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ClipPath(
              clipper: OctagonClipper4(padding: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                color: blueColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    customText((match.sport.toUpperCase()), 11, FontWeight.w600, darkBlueColor, 1),
                    const SizedBox(width: 3,),
                    Icon(category, size: 16,)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class UpcomingMatchCard extends StatelessWidget {
//   final UpcomingMatchesModel match;
//   const UpcomingMatchCard({super.key, required this.match});
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Card(
//       elevation: 4.0,
//       margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: size.width>620? 100 :size.width>500? 50 :16),
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           ClipRRect(
//               borderRadius: BorderRadius.circular(12.0),
//               child: Image.asset("assets/sportsBg/${match.sport}.png",)),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 verticalLogoWithCollegeName(match.team1, 45, 45),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         customText(match.matchTime, 14, FontWeight.w900, darkBlueColor, 1.4),
//                         Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 5),
//                           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
//                           decoration: BoxDecoration(
//                             color: blueColor,
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: customText(match.matchDate.substring(0,5).toUpperCase(), 11, FontWeight.w600, Colors.white, 1),
//                         ),
//                         if(size.width>=500)InkWell(
//                           onTap:(){},
//                           child: Row(
//                             children: [
//                               customText(match.venue, 10, FontWeight.w600, Colors.green.shade700, 2),
//                               Icon(Icons.location_on_outlined, color: Colors.green.shade700, size: 15,)
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     if(size.width<500)InkWell(
//                       onTap:(){openLocationUrl("https://maps.app.goo.gl/G9m3EkGGWUKzQfLk9");},
//                       child: Row(
//                         children: [
//                           customText(match.venue, 11, FontWeight.w600, Colors.green.shade700, 2),
//                           Icon(Icons.location_on_outlined, color: Colors.green.shade700, size: 15,)
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 verticalLogoWithCollegeName(match.team2, 45, 45),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

Future<void> openLocationUrl(String locationUrl) async {
  if (Platform.isAndroid || Platform.isIOS) {
    if (await canLaunchUrl(Uri.parse(locationUrl))) {
      await launchUrl(Uri.parse(locationUrl), mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: 'Could not open location.');
    }
  } else {
    Fluttertoast.showToast(msg: 'Could not open location');
  }
}


class OctagonClipper4 extends CustomClipper<Path> {
  final double padding;
  OctagonClipper4({required this.padding});
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;

    // const double padding = 20; // Adjust this value to modify the octagon cut

    path.moveTo(0, 0); // Top-left cut
    path.lineTo(width, 0);
    path.lineTo(width - padding, height);
    path.lineTo(padding, height);
    // path.lineTo(width, height-padding);
    // path.lineTo(width-padding, height);
    // path.lineTo(padding, height); // Bottom-left cut
    // path.lineTo(0, height - padding); // Left-bottom cut

    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}



