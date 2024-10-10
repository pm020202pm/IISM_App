import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/widgets.dart';
import '../models/MatchesModel.dart';
import '../widgets/UpcomingMatchCard.dart';

class UpcomingMatchesPage extends StatelessWidget {
  final List<dynamic> matches;
  final bool hasMore;
  const UpcomingMatchesPage({super.key, required this.matches, required this.hasMore});

  @override
  Widget build(BuildContext context) {
    if(matches.isEmpty){
      int randomNumber = (1+Random().nextInt(3));
      return Column(
        children: [
          Lottie.asset('assets/lottie/loading/$randomNumber.json', width: 300),
          customText('Nothing to show, check back later!', 14, FontWeight.w500, Colors.grey, 1),
          const SizedBox(height: 20.0),
        ],
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: matches.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= matches.length) return const Center(child: CircularProgressIndicator());
          UpcomingMatchesModel model = UpcomingMatchesModel.fromJson(matches[index]);
          if(index<matches.length-1) return UpcomingMatchCard(match: model);
          if(index==matches.length-1) {
            return Column(
            children: [
              UpcomingMatchCard(match: model),
              const SizedBox(height: 70.0),
            ],
          );
          }
          return Container();
        },
      ),
    );
  }
}
