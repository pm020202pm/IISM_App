import 'package:flutter/material.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';
import '../models/MatchesModel.dart';
import '../pages/LiveMatchesPage.dart';
import '../pages/live_page.dart';
class LiveHockeyCard extends StatelessWidget {
  // final HockeyMatchModel match;
  final LiveNowMatchModel match;
  const LiveHockeyCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LivePage(match: match)));
      },
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset("assets/images/cricket.png",)),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText('${match.team1_score.toString()}', 18, FontWeight.w600, Colors.grey.shade700, 1),
                            ],
                          ),
                          const SizedBox(width: 15,),
                          customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
                          const SizedBox(width: 15,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              customText('${match.team2_score.toString()}', 18, FontWeight.w600, Colors.grey.shade700, 1),
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
          ],
        ),
      ),
    );
  }
}
