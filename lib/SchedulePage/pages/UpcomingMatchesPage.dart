import 'package:flutter/material.dart';
import '../models/MatchesModel.dart';
import '../widgets/UpcomingMatchCard.dart';

class UpcomingMatchesPage extends StatefulWidget {
  final List<dynamic> matches;

  const UpcomingMatchesPage({super.key, required this.matches});

  @override
  _UpcomingMatchesPageState createState() => _UpcomingMatchesPageState();
}

class _UpcomingMatchesPageState extends State<UpcomingMatchesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.matches.length + (true ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= widget.matches.length) return const Center(child: CircularProgressIndicator());
              UpcomingMatchesModel model = UpcomingMatchesModel.fromJson(widget.matches[index]);
              if(index<widget.matches.length-1) return UpcomingMatchCard(match: model);
              if(index==widget.matches.length-1) {
                return Column(
                children: [
                  UpcomingMatchCard(match: model),
                  const SizedBox(height: 70.0),
                ],
              );
              }
            },
          ),
        ),
      ],
    );
  }
}
