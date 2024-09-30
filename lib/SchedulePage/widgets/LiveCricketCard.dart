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
class LiveCricketCard extends StatelessWidget {
  // final CricketMatchModel match;
  final LiveNowMatchModel match;
  const LiveCricketCard({super.key, required this.match});



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
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: verticalLogoWithCollegeName(match.team1!, 50, 50),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText('${match.team1_score.toString()}/${match.team1_wickets.toString()}', 18, FontWeight.w600, Colors.grey.shade700, 1),
                              const SizedBox(height: 5),
                              customText('${match.overs.toString()}/20', 12, FontWeight.w600, Colors.grey.shade700, 1),
                            ],
                          ),
                          const SizedBox(width: 15,),
                          customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
                          const SizedBox(width: 15,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              customText('${match.team2_score.toString()}/${match.team2_wickets.toString()}', 18, FontWeight.w600, Colors.grey.shade700, 1),
                              const SizedBox(height: 5),
                              customText('${match.overs.toString()}/20', 12, FontWeight.w600, Colors.grey.shade700, 1),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      InkWell(
                        onTap:(){openLocationUrl("https://maps.app.goo.gl/G9m3EkGGWUKzQfLk9");},
                        child: Row(
                          children: [
                            customText(match.venue!, 13, FontWeight.w600, Colors.grey.shade700, 2),
                            Icon(Icons.location_on_outlined, color: Colors.green.shade700, size: 16,)
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: verticalLogoWithCollegeName(match.team2!, 50, 50),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
              height: 26,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(30),
              ),
              child: customText("Live", 16, FontWeight.w600, Colors.white, 1),
              // Text("Live", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)
          ),
        ],
      ),
    );
  }
}
