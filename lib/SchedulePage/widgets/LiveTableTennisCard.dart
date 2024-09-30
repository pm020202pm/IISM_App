import 'package:flutter/material.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';

import '../../HomePage/pages/home_page.dart';
import '../../widgets/widgets.dart';
import '../models/MatchesModel.dart';
import '../pages/LiveMatchesPage.dart';
import '../pages/live_page.dart';
class LiveTableTennisCard extends StatelessWidget {
  // final TableTennisMatchModel match;
  final LiveNowMatchModel match;
  const LiveTableTennisCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LivePage(match: match)));
      },
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: verticalLogoWithCollegeName(match.team1!, 50, 50)
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: setScore(1.toString(),match.set1Score1.toString() , match.set1Score2.toString()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: setScore(2.toString(),match.set1Score1.toString() , match.set1Score2.toString()),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(2.0),
                      //   child: setScore(3.toString(),match.set1Score1.toString() , match.set1Score2.toString()),
                      // ),
                    ],
                  ),
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
    );
  }
}
