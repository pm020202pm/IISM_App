import 'package:flutter/material.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
import '../models/LiveMatchModel.dart';
import '../pages/live_page.dart';
import '../pages/schedule_page.dart';
import 'UpcomingMatchCard.dart';


class CompletedMatchCard extends StatelessWidget {
  final LiveNowMatchModel match;
  const CompletedMatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String? category = match.category?.toUpperCase();
    double horizontalPadding = size.width>620? 100 :size.width>500? 50 :16;
    if(match.sport?.toLowerCase()=='chess'){
      return ClipPath(
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            chessCollegePlayer(match.team1!),
                            const SizedBox(width: 5,),
                            SizedBox(
                              width: 70,
                                child: customText(match.winner, 11, FontWeight.w700, Colors.grey.shade800, 1)),
                            const SizedBox(width: 3,),
                            customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
                            const SizedBox(width: 3,),
                            Container(
                              alignment: Alignment.centerRight,
                                width: 70,
                                child: customText(match.loser, 11, FontWeight.w700, Colors.grey.shade800, 1)),
                            const SizedBox(width: 5,),
                            chessCollegePlayer(match.team2!),
                          ],
                        ),
                        customText("${match.winner.toUpperCase()} won!", 11, FontWeight.w700, darkYellowColor, 1),
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
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
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
                  child: customText(category!, 12, FontWeight.w600, Colors.white, 1),
                )
              ],
            ),
          ],
        ),
      );
    }
    if(match.sport?.toLowerCase()=='athletics'){
      return ClipPath(
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText(match.athleteType.toUpperCase(), 16, FontWeight.w800, Colors.grey, 1),
                            const SizedBox(width: 6,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: customText(category!, 12, FontWeight.w600, Colors.white, 1),
                            )                            ],
                        ),
                        const SizedBox(height: 10,),
                        athletePerformer('First', match.first),
                        athletePerformer('Second', match.second),
                        athletePerformer('Third', match.third),
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
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    color: Colors.grey.shade400,
                    child: customText(match.matchDate, 12, FontWeight.w600, whiteColor, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
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
                            if(match.sport=='volleyball' || match.sport == 'table tennis' || match.sport=='lawn tennis' || match.sport=='badminton' || match.sport=='squash') liveVolleyball(),
                            if(match.sport=='hockey') liveHockey(),
                            if(match.sport=='basketball' || match.sport=='football') liveBasketball(),
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
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
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
                  child: customText(category!, 12, FontWeight.w600, Colors.white, 1),
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
            customText('$team1overs/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
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
  Widget liveVolleyball(){
    int score1=0;
    int score2=0;
    if(double.parse(match.set1Score1)>double.parse(match.set1Score2)) {
      score1++;
    } else if(double.parse(match.set1Score1)<double.parse(match.set1Score2)){
      score2++;
    }
    if(double.parse(match.set2Score1)>double.parse(match.set2Score2)) {
      score1++;
    } else if(double.parse(match.set2Score1)<double.parse(match.set2Score2)){
      score2++;
    }
    if(double.parse(match.set3Score1)>double.parse(match.set3Score2)) {
      score1++;
    } else if(double.parse(match.set3Score1)<double.parse(match.set3Score2)){
      score2++;
    }
    if(double.parse(match.set4Score1)>double.parse(match.set4Score2)) {
      score1++;
    } else if(double.parse(match.set4Score1)<double.parse(match.set4Score2)){
      score2++;
    }
    if(double.parse(match.set5Score1)>double.parse(match.set5Score2)) {
      score1++;
    } else if(double.parse(match.set5Score1)<double.parse(match.set5Score2)){
      score2++;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: customText(score1.toString()+" : "+score2.toString(), 18, FontWeight.w800, Colors.grey.shade900, 1),
    );
  }
}

Widget athletePerformer(String position, String college){
  return Padding(
    padding: const EdgeInsets.only(bottom: 5, left: 40),
    child: Row(
      // mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 64,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: darkYellowColor)
          ),
          child: customText(position, 11, FontWeight.w500, darkYellowColor, 1),
        ),
        const SizedBox(width: 10,),
        Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset('assets/logo/$college.png', width: 20)
        ),
        const SizedBox(width: 10,),
        customText(college, 16, FontWeight.w800, Colors.grey.shade700, 1),
      ],
    ),
  );
}

Widget chessCollegePlayer(String college){
  return Container(
    width: 60,
    alignment: Alignment.center,
    child: Column(
      children: [
        Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset('assets/logo/${college.toUpperCase().toUpperCase()}.png', width:35)
        ),
        customText(college.toUpperCase(), 9, FontWeight.w900, Colors.grey.shade800,1.9),
      ],
    ),
  );
}