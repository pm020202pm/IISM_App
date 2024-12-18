import 'dart:convert';
import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../SchedulePage/models/LiveMatchModel.dart';
import '../../SchedulePage/models/MatchesModel.dart';
import '../../api.dart';
import '../../widgets/widgets.dart';
import '../../utils.dart';
import 'LiveNowHighlightCard.dart';

class LiveNowHighLight extends StatefulWidget {
  const LiveNowHighLight({super.key});

  @override
  State<LiveNowHighLight> createState() => _LiveNowHighLightState();
}

class _LiveNowHighLightState extends State<LiveNowHighLight> {
  String chipSportValue = "Cricket";
  bool _isLoading = false;
  double livenowHeight = 0;
  final List<dynamic> _matches = [];
  final List<int> _liveMatchesLength = List.filled(8, 0);
  List<dynamic> liveMatchesLength=[];

  Future<void> onChipTap(String sport) async {
    chipSportValue = sport;
    _matches.clear();
    await _fetchMatches(sportsTableMap[chipSportValue]!);
    setState(() {});
  }

  void getLiveMatchesLength() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isStaff = prefs.getBool('isStaff') ?? false;
    final String apiUrl = '$apiBaseUrl/${isStaff? "getTablesLengthStaff":"getTablesLength"}';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        for(int i=0; i< data['data'].length; i++){
          _liveMatchesLength[i] = data['data'][i][1];
        }
        if(isStaff){
          for(int i=0; i<_liveMatchesLength.length; i++){
            if(_liveMatchesLength[i]>0) {
              chipSportValue = sportsTableMapStaff.keys.elementAt(i+1);
              break;
            }
          }
        } else{
          for(int i=0; i<_liveMatchesLength.length; i++){
            if(_liveMatchesLength[i]>0) {
              chipSportValue = sportsTableMapStudent.keys.elementAt(i+1);
              break;
            }
          }
        }
        await onChipTap(chipSportValue);
      } else {
        if (kDebugMode) {
          print('Failed to load matches');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching matches: $e');
      }
    }
  }

  Future<void> _fetchMatches(String sportTableName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isStaff = prefs.getBool('isStaff') ?? false;
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    final String apiUrl = '$apiBaseUrl/${isStaff? "getLiveMatchesStaff":"getLiveMatches"}?page=1&limit=3&sortBy=time&order=ASC&search=&sportTableName=$sportTableName';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _matches.addAll(data['matches']);
          int len = _matches.length;
          livenowHeight = len==0?0:(len==1?50:(len==2?100:155));
          print('livenowHeight: $livenowHeight');
        });
      } else {
        if (kDebugMode) {
          print('Failed to load matches');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching matches: $e');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getLiveMatchesLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_liveMatchesLength[0]>0 || _liveMatchesLength[1]>0 || _liveMatchesLength[2]>0 || _liveMatchesLength[3]>0 || _liveMatchesLength[4]>0 || _liveMatchesLength[5]>0) {
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28.0, bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              customText("Live Now", 28, FontWeight.w600, dark? Colors.grey.shade100: Colors.grey.shade900, 1),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              chipSport('Cricket', 0, Icons.sports_cricket),
              chipSport('VolleyBall', 1, Icons.sports_volleyball),
              chipSport('BasketBall', 2, Icons.sports_basketball),
              if(!isStaff) chipSport('Hockey', 3, Icons.sports_hockey),
              chipSport('Lawn Tennis', isStaff? 3:4, Icons.sports_tennis),
              chipSport('Table Tennis', isStaff? 4:5, Icons.sports_tennis),
              if(isStaff) chipSport('Football', 5, BoxIcons.bx_football),
              if(isStaff) chipSport('Badminton', 6, MingCute.badminton_fill),
              if(isStaff) chipSport('Squash', 7, Icons.sports_tennis),
            ],
          ),
        ),
        const SizedBox(height: 6),
        (_matches.isEmpty)
        ? Center(child: Lottie.asset('assets/lottie/loading/loading2.json', width: 100))
        : SizedBox(
          height: livenowHeight,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _matches.length,
            itemBuilder: (context, index) {
              if (index >= _matches.length) {
                return const Center(child: CircularProgressIndicator());
              }
              var match = _matches[index];
              LiveNowMatchModel matchModel = LiveNowMatchModel.fromJson(match);
              return LiveNowCard(match: matchModel);
            },
          ),
        ),
      ],
    );
    } else {
      return const SizedBox.shrink();
    }
  }
  Widget chipSport(String sport, int index, IconData icon){
    if(_liveMatchesLength[index]>0) {
      return Padding(
        padding: const EdgeInsets.only(right: 6.0),
        child: customChips1(sport, icon,chipSportValue==sport, () async {if(chipSportValue!=sport) await onChipTap(sport);}),
      );
    }
    else {
      return const SizedBox.shrink();
    }
  }
}

Widget customChips1(String sport, IconData icon, bool isActive, Function() onTap){
  return Container(
    decoration: BoxDecoration(
      color: isActive? yellowColor: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(30.0),
      border: Border.all(color: isActive? darkYellowColor : Colors.grey.shade400),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: yellowColor,
        borderRadius: BorderRadius.circular(30.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 3.0, bottom: 3.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 3.0),
              Icon(icon, color: isActive? Colors.white: Colors.grey, size: 20.0),
              const SizedBox(width: 3.0),
              if(isActive) customText(sport, 15, FontWeight.w600, isActive? whiteColor:Colors.grey.shade500, 1),
              if(isActive) const SizedBox(width: 3.0),
            ],
          ),
        ),
      ),
    ),
  );

}

Map<String, String> sportsTableMapStaff = {
  'All': 'all',
  'Cricket': 'cricket',
  'VolleyBall': 'volleyball',
  'BasketBall': 'basketball',
  'Lawn Tennis': 'lawntennis',
  'Table Tennis': 'tabletennis',
  'Football': 'football',
  'Badminton': 'badminton',
  'Squash': 'squash',
};

Map<String, String> sportsTableMapStudent = {
  'All': 'all',
  'Cricket': 'cricket',
  'VolleyBall': 'volleyball',
  'BasketBall': 'basketball',
  'Hockey': 'hockey',
  'Lawn Tennis': 'lawntennis',
  'Table Tennis': 'tabletennis',
};
