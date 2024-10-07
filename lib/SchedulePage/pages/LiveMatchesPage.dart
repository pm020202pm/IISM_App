import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/MatchesModel.dart';
import '../widgets/LiveMatchCard.dart';

class LiveMatchesPage extends StatefulWidget {
  final List<dynamic> matches;
  const LiveMatchesPage({super.key, required this.matches});

  @override
  _LiveMatchesPageState createState() => _LiveMatchesPageState();
}

class _LiveMatchesPageState extends State<LiveMatchesPage> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.matches.length + (true ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= widget.matches.length) {return const Center(child: CircularProgressIndicator());}
          var match = widget.matches[index];
          LiveNowMatchModel matchModel = LiveNowMatchModel.fromJson(match);
          if(index<widget.matches.length-1) return LiveMatchCard(match: matchModel);
          if(index==widget.matches.length-1) {
            return Column(
              children: [
                LiveMatchCard(match: matchModel),
                const SizedBox(height: 70.0),
              ],
            );
          }
        },
      ),
    );
  }
}

