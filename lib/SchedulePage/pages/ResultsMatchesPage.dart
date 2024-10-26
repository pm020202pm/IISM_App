import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iism/SchedulePage/widgets/CompletedMatchCard.dart';
import 'package:iism/widgets/widgets.dart';
import 'package:lottie/lottie.dart';
import '../models/LiveMatchModel.dart';
import '../models/MatchesModel.dart';


class MatchResultsPage extends StatefulWidget {
  final List<dynamic> matches;
  final bool hasMore;
  MatchResultsPage({super.key, required this.matches, required this.hasMore});

  @override
  _MatchResultsPageState createState() => _MatchResultsPageState();
}

class _MatchResultsPageState extends State<MatchResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LiveMatchesListWidget(matches: widget.matches, hasMore: widget.hasMore),
    );
  }
}





class LiveMatchesListWidget extends StatelessWidget {
  const LiveMatchesListWidget({super.key, required this.matches, required this.hasMore});
  final List<dynamic> matches;
  final bool hasMore;
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
    return ListView.builder(
      itemCount: matches.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= matches.length) {
          return const Center(child: CircularProgressIndicator());
        }
        var match = matches[index];
        LiveNowMatchModel matchModel = LiveNowMatchModel.fromJson(match);
        if(index<matches.length-1) return CompletedMatchCard(match: matchModel);
        if(index==matches.length-1) {
          return Column(
            children: [
              CompletedMatchCard(match: matchModel),
              const SizedBox(height: 70.0),
            ],
          );
        }
        else{
          return Container();
        }
      },
    );
  }
}


