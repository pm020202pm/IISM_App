import 'package:flutter/material.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
import '../models/LiveMatchModel.dart';
import '../pages/live_page.dart';
import '../pages/schedule_page.dart';


class CompletedMatchCard extends StatelessWidget {
  final LiveNowMatchModel match;
  const CompletedMatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String active = match.active!;
    String? category = match.category?.toUpperCase();
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
                color: Colors.grey.shade400,
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
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 24, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        verticalLogoWithCollegeName(match.team1!.toUpperCase(), 45, 45),
                        Column(
                          children: [
                            if(match.sport=='cricket') liveCricket(),
                            if(match.sport=='volleyball' || match.sport == 'table tennis' || match.sport=='lawn tennis') liveVolleyball(active),
                            if(match.sport=='hockey') liveHockey(),
                            if(match.sport=='basketball') liveBasketball(),
                          ],
                        ),
                        verticalLogoWithCollegeName(match.team2!.toUpperCase(), 45, 45),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                ClipPath(
                  clipper: OctagonClipper3(padding: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    color: Colors.grey.shade400,
                    child: customText(match.matchDate, 12, FontWeight.w600, whiteColor, 1),
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: customText(category!, 10, FontWeight.w600, Colors.white, 1),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget liveCricket(){
    double ball1 = double.parse(match.team1_overs);
    double ball2 = double.parse(match.team2_overs);
    String team1overs = '${ball1~/6}.${ball1.toInt()%6}';
    String team2overs = '${ball2~/6}.${ball2.toInt()%6}';
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText('${match.team1_score}/${match.team1_wickets.toString()}', 16, FontWeight.w600, Colors.grey.shade700, 1),
            const SizedBox(height: 5),
            customText('${team1overs}/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
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
            customText('${team2overs}/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
          ],
        ),
      ],
    );
  }
  Widget liveHockey(){
    return Row(
      children: [
        customText(match.team1Goals.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
        const SizedBox(width: 15,),
        customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
        const SizedBox(width: 15,),
        customText(match.team2Goals.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
      ],
    );
  }
  Widget liveBasketball(){
    return Row(
      children: [
        customText(match.team1Score.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
        const SizedBox(width: 15,),
        customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
        const SizedBox(width: 15,),
        customText(match.team2Score.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
      ],
    );
  }
  Widget liveVolleyball(String active){
    String scoreTeam1 = (active=='1')? match.set1Score1 : (active=='2')? match.set2Score1 : (active=='3')? match.set3Score1 : (active=='4')? match.set4Score1 : match.set5Score1;
    String scoreTeam2 = (active=='1')? match.set1Score2 : (active=='2')? match.set2Score2 : (active=='3')? match.set3Score2 : (active=='4')? match.set4Score2 : match.set5Score2;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: setScore(active,scoreTeam1 , scoreTeam2),
        ),
      ],
    );
  }
}