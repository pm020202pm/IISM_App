import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';
import 'package:iism/HomePage/pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/widgets.dart';
import '../models/MatchesModel.dart';
import '../pages/LiveMatchesPage.dart';
import '../pages/live_page.dart';
class LiveMatchCard extends StatelessWidget {
  // final CricketMatchModel match;
  final LiveNowMatchModel match;
  const LiveMatchCard({super.key, required this.match});



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LivePage(match: match)));

      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Card(
            elevation: 4.0,
            margin: const EdgeInsets.only(bottom: 8, right: 16.0, left: 16.0, top: 14),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  verticalLogoWithCollegeName(match.team1!, 50, 50),
                  Column(
                    children: [
                      // cricket
                      if(match.sport=='cricket')Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText('${match.team1_score.toString()}/${match.team1_wickets.toString()}', 16, FontWeight.w600, Colors.grey.shade700, 1),
                              const SizedBox(height: 5),
                              customText('${match.overs.toString()}/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
                            ],
                          ),
                          const SizedBox(width: 15,),
                          customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
                          const SizedBox(width: 15,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              customText('${match.team2_score.toString()}/${match.team2_wickets.toString()}', 16, FontWeight.w600, Colors.grey.shade700, 1),
                              const SizedBox(height: 5),
                              customText('${match.overs.toString()}/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
                            ],
                          ),
                        ],
                      ),

                      // Volleyball, basketball, table tennis, lawn tennis
                      if(match.sport=='volleyball' || match.sport == 'basketball' || match.sport == 'table tennis' || match.sport=='lawn tennis') Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: setScore(1.toString(),match.set1Score1.toString() , match.set1Score2.toString()),
                          ),
                        ],
                      ),

                      // hockey
                      if(match.sport=='hockey') Row(
                        children: [
                          customText(match.team1_score.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
                          const SizedBox(width: 15,),
                          customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
                          const SizedBox(width: 15,),
                          customText(match.team2_score.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
                        ],
                      ),
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
                  verticalLogoWithCollegeName(match.team2!, 50, 50),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 23,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(30),
            ),
            child: customText("Live", 16, FontWeight.w600, Colors.white, 1),
          ),
        ],
      ),
    );
  }
}
