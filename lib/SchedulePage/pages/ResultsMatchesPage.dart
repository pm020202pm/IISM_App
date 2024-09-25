import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iism/api.dart';
import 'package:iism/utils.dart';

import '../models/MatchesModel.dart';
import '../widgets/LiveBasketBallCard.dart';
import '../widgets/LiveCricketCard.dart';
import '../widgets/LiveHockeyCard.dart';
import '../widgets/LiveLawnTennisCard.dart';
import '../widgets/LiveTableTennisCard.dart';
import '../widgets/LiveVolleyBallCard.dart';
import '../widgets/SortBySearch.dart';

class MatchResultsPage extends StatefulWidget {
  final TextEditingController searchController;

  MatchResultsPage({required this.searchController});

  @override
  _MatchResultsPageState createState() => _MatchResultsPageState();
}

class _MatchResultsPageState extends State<MatchResultsPage> {
  int _page = 1;
  final int _limit = 3; // Default limit
  List<dynamic> _matches = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String _sortBy = 'time'; // Default sort field
  String _order = 'ASC'; // Default order
  String _sortCriteria = 'Time'; // Default sort criteria for the dropdown
  String _searchQuery = ''; // Default search query
  String chipSportValue = "Cricket";

  @override
  void initState() {
    super.initState();
    _fetchMatches(sportsTableMap[chipSportValue]!);
  }

  Future<void> onChipTap(String sport) async {
    setState(() {
      chipSportValue = sport;
      _matches.clear();
      _page = 1;
      _hasMore = true;
    });
    await _fetchMatches(sportsTableMap[chipSportValue]!);
  }

  Future<void> _fetchMatches(String sportTableName) async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });
    print("### $sportTableName");
    final String apiUrl = '$apiBaseUrl/getCompletedMatches?page=$_page&limit=$_limit&sortBy=$_sortBy&order=$_order&search=$_searchQuery&sportTableName=$sportTableName';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _matches.addAll(data['matches']);
          print("### ${_matches.length}");
          _page++;
          if (data['matches'].length < _limit) {
            _hasMore = false;
          }
        });
      } else {
        print('Failed to load matches');
      }
    } catch (e) {
      print('Error fetching matches: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Method to handle sorting change
  void _changeSortCriteria(String newValue) {
    setState(() {
      _sortCriteria = newValue;
      _sortBy = _mapSortCriteriaToField(newValue);
      _matches.clear();
      _page = 1;
      _hasMore = true;
      _fetchMatches(sportsTableMap[chipSportValue]!);
    });
  }

  // Mapping dropdown values to database fields
  String _mapSortCriteriaToField(String value) {
    switch (value) {
      case 'Date':
        return 'date';
      case 'Sport':
        return 'sport';
      case 'Time':
        return 'time';
      case 'Venue':
        return 'venue';
      default:
        return 'date';
    }
  }

  // Method to handle search input
  void _filterSchedule(String value) {
    setState(() {
      _searchQuery = value;
      _matches.clear();
      _page = 1;
      _hasMore = true;
      _fetchMatches(sportsTableMap[chipSportValue]!);
    });
  }

  Widget CustonChips(String sport, IconData icon, bool isActive, Function() onTap){
    return Container(
      decoration: BoxDecoration(
        color: isActive? Colors.blue.shade300: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: isActive? Colors.blue.shade400:Colors.grey.shade300),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.blue,
          borderRadius: BorderRadius.circular(30.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 3.0, bottom: 3.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: isActive? Colors.white: Colors.grey, size: 15.0),
                const SizedBox(width: 3.0),
                Text(sport,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: isActive? Colors.white:Colors.grey.shade600,
                      fontFamily: 'Aptos'
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SortBySearch(changeSortCriteria: _changeSortCriteria, searchController: widget.searchController, filterSchedule: _filterSchedule, sortCriteria: _sortCriteria),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CustonChips("Cricket", Icons.sports_cricket,chipSportValue=="Cricket",() async {await onChipTap("Cricket");}),
                const SizedBox(width: 8.0),
                CustonChips("VolleyBall", Icons.sports_volleyball,chipSportValue=="VolleyBall", () async {await onChipTap("VolleyBall");}),
                const SizedBox(width: 8.0),
                CustonChips("BasketBall", Icons.sports_basketball,chipSportValue=="BasketBall",() async {await onChipTap("BasketBall");}),
                const SizedBox(width: 8.0),
                CustonChips("Hockey", Icons.sports_hockey,chipSportValue=="Hockey", () async {await onChipTap("Hockey");}),
                const SizedBox(width: 8.0),
                CustonChips("Lawn Tennis", Icons.sports_tennis,chipSportValue=="Lawn Tennis",() async {await onChipTap("Lawn Tennis");}),
                const SizedBox(width: 8.0),
                CustonChips("Table Tennis", Icons.sports_tennis,chipSportValue=="Table Tennis", () async {await onChipTap("Table Tennis");}),
              ],
            ),
          ),
        ),

        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !_isLoading) {
                _fetchMatches(sportsTableMap[chipSportValue]!);
              }
              return false;
            },
            child: LiveMatchesListWidget(matches: _matches, hasMore: _hasMore),
          ),
        ),
        const SizedBox(height: 100.0)
      ],
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
        if(sport == 'cricket'){
          // CricketMatchModel matchModel = CricketMatchModel.fromJson(match);
          return LiveCricketCard(match: matchModel);
        }
        else if(sport == 'volleyball'){
          // VolleyballMatchModel matchModel = VolleyballMatchModel.fromJson(match);
          return LiveVolleyBallCard(match: matchModel);
        }
        else if(sport == 'basketball'){
          // BasketballMatchModel matchModel = BasketballMatchModel.fromJson(match);
          return LiveBasketBallCard(match: matchModel);
        }
        else if(sport == 'hockey'){
          // HockeyMatchModel matchModel = HockeyMatchModel.fromJson(match);
          return LiveHockeyCard(match: matchModel);
        }
        else if(sport == 'lawn tennis'){
          // LawnTennisMatchModel matchModel = LawnTennisMatchModel.fromJson(match);
          return LiveLawnTennisCard(match: matchModel);
        }
        else if(sport == 'table tennis'){
          // TableTennisMatchModel matchModel = TableTennisMatchModel.fromJson(match);
          return LiveTableTennisCard(match: matchModel);
        }
        else{
          return Container();
        }
      },
    );
  }
}


