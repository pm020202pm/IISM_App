import 'package:flutter/material.dart';
import '../../SchedulePage/models/LiveMatchModel.dart';
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
          padding: const EdgeInsets.all(4),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  customText(match.team1!.toUpperCase(), 10, FontWeight.w900, Colors.grey.shade800,1.9),
                  const Spacer(),
                  customText(match.team2!.toUpperCase(), 10, FontWeight.w900, Colors.grey.shade800,1.9),
                ],
              ),
              (match.sport == "table tennis" || match.sport == "volleyball")
                  ? liveVolleyball(match.active!)
                  : (match.sport == "lawn tennis")
                  ? liveLawnTennis(match.active!)
                  : (match.sport == "hockey")
                  ? score2(match.team1Goals.toString(), match.team2Goals.toString())
                  : (match.sport == "basketball")
                  ? score2(match.team1Score.toString(), match.team2Score.toString())
                  : (match.sport == "cricket")
                  ? score2(match.team1_score.toString(), match.team2_score.toString())
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget liveVolleyball(String active){
    String scoreTeam1 = (active=='1')? match.set1Score1 : (active=='2')? match.set2Score1 : (active=='3')? match.set3Score1 : (active=='4')? match.set4Score1 : match.set5Score1;
    String scoreTeam2 = (active=='1')? match.set1Score2 : (active=='2')? match.set2Score2 : (active=='3')? match.set3Score2 : (active=='4')? match.set4Score2 : match.set5Score2;
    return setScore3(active,scoreTeam1 , scoreTeam2);
  }
  Widget liveLawnTennis(String active){
    String scoreTeam1 = (active=='1')? match.set1Score1 : (active=='2')? match.set2Score1 : (active=='3')? match.set3Score1 : (active=='4')? match.set4Score1 : match.set5Score1;
    String scoreTeam2 = (active=='1')? match.set1Score2 : (active=='2')? match.set2Score2 : (active=='3')? match.set3Score2 : (active=='4')? match.set4Score2 : match.set5Score2;
    return Container(
      alignment: Alignment.center,
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customText(scoreTeam1, 15, FontWeight.w800, Colors.grey.shade800, 1),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
              child: customText(active=='1'? ' First\n Singles ': active=='2'? ' Doubles ':' Reverse\n Singles ', 10, FontWeight.w800, Colors.grey.shade800, 1)),
          customText(scoreTeam2, 15, FontWeight.w800, Colors.grey.shade800, 1)
        ],
      ),
    );
  }
}

Widget setScore3(String setCount, String score1, String score2) {
  return Container(
    width: 100,
    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              customText("$score1  ", 14, FontWeight.w700, Colors.grey.shade800, 1.4),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: customText(
                      "SET\n   $setCount", 10, FontWeight.w700, Colors.grey.shade800, 1)
              ),
              customText("  $score2", 14, FontWeight.w700, Colors.grey.shade800, 1),
            ],
          ),
        ),
      ],
    ),
  );
}