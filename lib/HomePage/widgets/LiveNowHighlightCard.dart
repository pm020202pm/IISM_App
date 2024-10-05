import 'package:flutter/material.dart';

import '../../SchedulePage/models/MatchesModel.dart';
import '../../SchedulePage/pages/live_page.dart';
import '../../widgets/widgets.dart';
class LiveNowCard extends StatelessWidget {
  const LiveNowCard({super.key, required this.match});
  final LiveNowMatchModel match;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LivePage(match: match,),
          ),
        );
      },
      child: Card(
        elevation: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(70),
                            ),
                            child: Image.asset('assets/logo/${match.team1}.png', width: 20, height: 20)
                        ),
                        const SizedBox(width: 5,),
                        SizedBox(
                            width: 80,
                            child: customText(match.team1!.toUpperCase(), 10, FontWeight.w900, Colors.grey.shade800,1.9)),
                      ],
                    ),
                  )
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if(match.sport == "table tennis" || match.sport == "lawn tennis" || match.sport == "volleyball")
                    setScore("1", match.set1Score1.toString(), match.set1Score2.toString()),
                  if(match.sport == "hockey")
                    score2(match.team1Goals.toString(), match.team2Goals.toString()),
                  if(match.sport == "basketball")
                    score2(match.team1Score.toString(), match.team2Score.toString()),
                  if(match.sport == "cricket")
                    score2(match.team1_score.toString(), match.team2_score.toString()),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        SizedBox(
                            width: 80,
                            child: customText(match.team2!.toUpperCase(), 10, FontWeight.w900, Colors.grey.shade800,1.9)),
                        const SizedBox(width: 5),
                        Container(
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(70),
                            ),
                            child: Image.asset('assets/logo/${match.team2}.png', width: 20, height: 20)
                        ),
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}