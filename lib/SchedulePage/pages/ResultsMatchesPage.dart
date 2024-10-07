import 'package:flutter/material.dart';
import '../models/MatchesModel.dart';
import '../widgets/LiveMatchCard.dart';


class MatchResultsPage extends StatefulWidget {
  final List<dynamic> matches;
  MatchResultsPage({super.key, required this.matches});

  @override
  _MatchResultsPageState createState() => _MatchResultsPageState();
}

class _MatchResultsPageState extends State<MatchResultsPage> {

  // Widget CustonChips(String sport, IconData icon, bool isActive, Function() onTap){
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: isActive? Colors.blue.shade300: Colors.grey.shade200,
  //       borderRadius: BorderRadius.circular(30.0),
  //       border: Border.all(color: isActive? Colors.blue.shade400:Colors.grey.shade300),
  //     ),
  //     child: Material(
  //       color: Colors.transparent,
  //       child: InkWell(
  //         onTap: onTap,
  //         splashColor: Colors.blue,
  //         borderRadius: BorderRadius.circular(30.0),
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 3.0, bottom: 3.0),
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Icon(icon, color: isActive? Colors.white: Colors.grey, size: 15.0),
  //               const SizedBox(width: 3.0),
  //               Text(sport,
  //                 style: TextStyle(
  //                     fontSize: 15.0,
  //                     fontWeight: FontWeight.w500,
  //                     color: isActive? Colors.white:Colors.grey.shade600,
  //                     fontFamily: 'Aptos'
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LiveMatchesListWidget(matches: widget.matches, hasMore: true),
    );
  }
}





class LiveMatchesListWidget extends StatelessWidget {
  const LiveMatchesListWidget({super.key, required this.matches, required this.hasMore});
  final List<dynamic> matches;
  final bool hasMore;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: matches.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= matches.length) {
          return const Center(child: CircularProgressIndicator());
        }
        var match = matches[index];
        String sport = match['sport'];
        LiveNowMatchModel matchModel = LiveNowMatchModel.fromJson(match);
        if(index<matches.length-1) return LiveMatchCard(match: matchModel);
        if(index==matches.length-1) {
          return Column(
            children: [
              LiveMatchCard(match: matchModel),
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


