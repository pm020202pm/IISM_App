import 'package:flutter/material.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';
import 'package:iism/utils.dart';

import '../../widgets/widgets.dart';
import '../models/MatchesModel.dart';
import '../pages/LiveMatchesPage.dart';
import '../pages/schedule_page.dart';
class UpcomingMatchCard extends StatelessWidget {
  final UpcomingMatchesModel match;
  const UpcomingMatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("WIDTH : ${size.width} ");
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: size.width>620? 100 :size.width>500? 50 :16),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset("assets/sportsBg/${match.sport}.png",)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalLogoWithCollegeName(match.team1, 45, 45),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        customText(match.matchTime, 14, FontWeight.w900, darkBlueColor, 1.4),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: customText(match.matchDate.substring(0,5).toUpperCase(), 11, FontWeight.w600, Colors.white, 1),
                        ),
                        if(size.width>=500)InkWell(
                          onTap:(){},
                          child: Row(
                            children: [
                              customText(match.venue, 10, FontWeight.w600, Colors.green.shade700, 2),
                              Icon(Icons.location_on_outlined, color: Colors.green.shade700, size: 15,)
                            ],
                          ),
                        ),

                      ],
                    ),
                    if(size.width<500)InkWell(
                      onTap:(){openLocationUrl("https://maps.app.goo.gl/G9m3EkGGWUKzQfLk9");},
                      child: Row(
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
        ],
      ),
    );
  }
}



