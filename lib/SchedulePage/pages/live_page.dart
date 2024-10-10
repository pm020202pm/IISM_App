import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../models/MatchesModel.dart';
class LivePage extends StatelessWidget {
  const LivePage({super.key, required this.match});
  final LiveNowMatchModel match;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Page"),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.red,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
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
                              width: 110,
                              child: customText(match.team1!.toUpperCase(), 14, FontWeight.w900, Colors.grey.shade800,1.9)),
                        ],
                      ),
                    )
                ),
                Column(
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
                          Container(
                            alignment: Alignment.centerRight,
                              width: 110,
                              child: customText(match.team2!.toUpperCase(), 14, FontWeight.w900, Colors.grey.shade800,1.9)),
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
          )

        ],
      ),
    );
  }
}
