import 'package:flutter/material.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';

import '../models/MatchesModel.dart';
class LiveBasketBallCard extends StatelessWidget {
  final BasketballMatchModel match;
  const LiveBasketBallCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset("assets/images/cricket.png",)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child:verticalLogoWithCollegeName(match.team1!, 50, 50),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    customText(match.matchTime, 15, FontWeight.w900, Colors.grey.shade900, 1.4),
                    customText(match.matchDate, 13, FontWeight.w700, Colors.grey.shade700, 1),
                    customText(match.venue!, 13, FontWeight.w600, Colors.grey.shade700, 1)
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
    );
  }
}
