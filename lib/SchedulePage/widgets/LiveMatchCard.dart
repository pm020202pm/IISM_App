import 'package:flutter/material.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
import '../models/LiveMatchModel.dart';
import '../models/MatchesModel.dart';
import '../pages/live_page.dart';
import '../pages/schedule_page.dart';
import 'UpcomingMatchCard.dart';


class LiveMatchCard extends StatelessWidget {
  final LiveNowMatchModel match;
  const LiveMatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // IconData category = (match.category=='Men')? Icons.male: (match.category=='Men')? Icons.female: Icons.group;
    double horizontalPadding = size.width>620? 100 :size.width>500? 50 :16;
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LivePage(match: match)));
      },
      child: ClipPath(
        clipper: OctagonClipper3(padding: 18+horizontalPadding),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: size.width-horizontalPadding*2,
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: horizontalPadding),
              child: ClipPath(
                clipper: OctagonClipper3(padding: 12),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        verticalLogoWithCollegeName(match.team1!, 45, 45),
                        Column(
                          children: [
                            if(match.sport=='cricket')
                              liveCricket(),
                            // Volleyball, basketball, table tennis, lawn tennis
                            if(match.sport=='volleyball' || match.sport == 'basketball' || match.sport == 'table tennis' || match.sport=='lawn tennis')
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: setScore(1.toString(),match.set1Score1.toString() , match.set1Score2.toString()),
                                  ),
                                ],
                              ),
                            if(match.sport=='hockey')
                              liveHockey(),
                            const SizedBox(height: 3,),
                            InkWell(
                              onTap:(){openLocationUrl("https://maps.app.goo.gl/G9m3EkGGWUKzQfLk9");},
                              child: Row(
                                children: [
                                  customText(match.venue!, 11, FontWeight.w600, Colors.grey.shade700, 2),
                                  Icon(Icons.location_on_outlined, color: Colors.green.shade700, size: 15,)
                                ],
                              ),
                            ),
                          ],
                        ),
                        verticalLogoWithCollegeName(match.team2!, 45, 45),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: OctagonClipper3(padding: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                color: Colors.red.shade400,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    customText('Live', 14, FontWeight.w600, whiteColor, 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget liveCricket(){
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText('${match.team1_score.toString()}/${match.team1_wickets.toString()}', 16, FontWeight.w600, Colors.grey.shade700, 1),
            const SizedBox(height: 5),
            customText('${match.team1_overs.toString()}/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
          ],
        ),
        const SizedBox(width: 10,),
        customText("VS", 16, FontWeight.w700, Colors.red.shade400, 1),
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            customText('${match.team2_score.toString()}/${match.team2_wickets.toString()}', 16, FontWeight.w600, Colors.grey.shade700, 1),
            const SizedBox(height: 5),
            customText('${match.team2_overs.toString()}/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
          ],
        ),
      ],
    );
  }

  Widget liveHockey(){
    return Row(
      children: [
        customText(match.team1_score.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
        const SizedBox(width: 15,),
        customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
        const SizedBox(width: 15,),
        customText(match.team2_score.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
      ],
    );
  }
}
// class LiveMatchCard extends StatelessWidget {
//   final LiveNowMatchModel match;
//   const LiveMatchCard({super.key, required this.match});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: (){
//         Navigator.push(context, MaterialPageRoute(builder: (context) => LivePage(match: match)));
//       },
//       child: Stack(
//         alignment: Alignment.topCenter,
//         children: [
//           Card(
//             elevation: 4.0,
//             margin: const EdgeInsets.only(bottom: 8, right: 16.0, left: 16.0, top: 12),
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   verticalLogoWithCollegeName(match.team1!, 45, 45),
//                   Column(
//                     children: [
//                       if(match.sport=='cricket')
//                         liveCricket(),
//                       // Volleyball, basketball, table tennis, lawn tennis
//                       if(match.sport=='volleyball' || match.sport == 'basketball' || match.sport == 'table tennis' || match.sport=='lawn tennis')
//                         Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(3.0),
//                             child: setScore(1.toString(),match.set1Score1.toString() , match.set1Score2.toString()),
//                           ),
//                         ],
//                       ),
//                       if(match.sport=='hockey')
//                         liveHockey(),
//                       const SizedBox(height: 3,),
//                       InkWell(
//                         onTap:(){openLocationUrl("https://maps.app.goo.gl/G9m3EkGGWUKzQfLk9");},
//                         child: Row(
//                           children: [
//                             customText(match.venue!, 11, FontWeight.w600, Colors.grey.shade700, 2),
//                             Icon(Icons.location_on_outlined, color: Colors.green.shade700, size: 15,)
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   verticalLogoWithCollegeName(match.team2!, 45, 45),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             alignment: Alignment.center,
//             height: 21,
//             width: 60,
//             decoration: BoxDecoration(
//               color: Colors.red.shade400,
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: customText("Live", 14, FontWeight.w600, Colors.white, 1),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget liveCricket(){
//     return Row(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             customText('${match.team1_score.toString()}/${match.team1_wickets.toString()}', 16, FontWeight.w600, Colors.grey.shade700, 1),
//             const SizedBox(height: 5),
//             customText('${match.overs.toString()}/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
//           ],
//         ),
//         const SizedBox(width: 12,),
//         customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
//         const SizedBox(width: 12,),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             customText('${match.team2_score.toString()}/${match.team2_wickets.toString()}', 16, FontWeight.w600, Colors.grey.shade700, 1),
//             const SizedBox(height: 5),
//             customText('${match.overs.toString()}/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget liveHockey(){
//     return Row(
//       children: [
//         customText(match.team1_score.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
//         const SizedBox(width: 15,),
//         customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
//         const SizedBox(width: 15,),
//         customText(match.team2_score.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
//       ],
//     );
//   }
// }
