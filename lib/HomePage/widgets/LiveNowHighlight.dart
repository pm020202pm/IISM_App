import 'dart:convert';
import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
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
  final List<int> _liveMatchesLength = List.filled(6, 0);
  List<dynamic> liveMatchesLength=[];

  Future<void> onChipTap(String sport) async {
    setState(() {
      chipSportValue = sport;
      _matches.clear();
    });
    await _fetchMatches(sportsTableMap[chipSportValue]!);
  }

  void getLiveMatchesLength() async {
    final String apiUrl = '$apiBaseUrl/getTablesLength';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _liveMatchesLength[0] = data['data'][0][1];
        _liveMatchesLength[1] = data['data'][1][1];
        _liveMatchesLength[2] = data['data'][2][1];
        _liveMatchesLength[3] = data['data'][3][1];
        _liveMatchesLength[4] = data['data'][4][1];
        _liveMatchesLength[5] = data['data'][5][1];
        String _chipSportValue = chipSportValue;
        if(_liveMatchesLength[0]>0){
          _chipSportValue = "Cricket";
        }
        else if(_liveMatchesLength[1]>0){
          _chipSportValue = "VolleyBall";
        }
        else if(_liveMatchesLength[2]>0){
          _chipSportValue = "BasketBall";
        }
        else if(_liveMatchesLength[3]>0){
          _chipSportValue = "Hockey";
        }
        else if(_liveMatchesLength[4]>0){
          _chipSportValue = "Lawn Tennis";
        }
        else if(_liveMatchesLength[5]>0){
          _chipSportValue = "Table Tennis";
        }
        await onChipTap(_chipSportValue);
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
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    final String apiUrl = '$apiBaseUrl/getLiveMatches?page=1&limit=3&sortBy=time&order=ASC&search=&sportTableName=$sportTableName';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _matches.addAll(data['matches']);
          int len = _matches.length;
          if(len == 0){
            livenowHeight = 0;
          }
          else if(len == 1){
            livenowHeight = 45;
          }
          else if(len == 2){
            livenowHeight = 90;
          }
          else{
            livenowHeight = 135;
          }
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
              AnimateIcon(
                key: UniqueKey(),
                onTap: () {},
                iconType: IconType.continueAnimation,
                height: 25,
                width: 40,
                color: Colors.red,
                animateIcon: AnimateIcons.liveVideo,
              )
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(_liveMatchesLength[0]>0) customChips1("Cricket", Icons.sports_cricket,chipSportValue=="Cricket",() async {if(chipSportValue!='Cricket') await onChipTap("Cricket");}),
              if(_liveMatchesLength[1]>0) const SizedBox(width: 6.0),
              if(_liveMatchesLength[1]>0) customChips1("VolleyBall", Icons.sports_volleyball,chipSportValue=="VolleyBall", () async {if(chipSportValue!='VolleyBall') await onChipTap("VolleyBall");}),
              if(_liveMatchesLength[2]>0) const SizedBox(width: 6.0),
              if(_liveMatchesLength[2]>0) customChips1("BasketBall", Icons.sports_basketball,chipSportValue=="BasketBall",() async {if(chipSportValue!='BasketBall') await onChipTap("BasketBall");}),
              if(_liveMatchesLength[3]>0) const SizedBox(width: 6.0),
              if(_liveMatchesLength[3]>0) customChips1("Hockey", Icons.sports_hockey,chipSportValue=="Hockey", () async {if(chipSportValue!='Hockey') await onChipTap("Hockey");}),
              if(_liveMatchesLength[4]>0) const SizedBox(width: 6.0),
              if(_liveMatchesLength[4]>0) customChips1("Lawn Tennis", Icons.sports_tennis,chipSportValue=="Lawn Tennis",() async {if(chipSportValue!='Lawn Tennis') await onChipTap("Lawn Tennis");}),
              if(_liveMatchesLength[5]>0) const SizedBox(width: 6.0),
              if(_liveMatchesLength[5]>0) customChips1("Table Tennis", Icons.sports_tennis,chipSportValue=="Table Tennis", () async {if(chipSportValue!='Table Tennis') await onChipTap("Table Tennis");}),
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
