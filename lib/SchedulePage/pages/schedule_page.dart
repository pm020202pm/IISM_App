import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iism/api.dart';
import 'package:iism/utils.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/widgets.dart';
import 'LiveMatchesPage.dart';
import 'ResultsMatchesPage.dart';
import 'UpcomingMatchesPage.dart';
import '../widgets/widgets.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _resultsSearchController = TextEditingController();
  ///
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  int currentIndex = 0;
  List<bool> hasMore = [true, true, true];
  List<List<dynamic>> matches = [[], [], []];
  List<String> apiUrls = [
    'getLiveMatches',
    'matches',
    'getCompletedMatches',
  ];

  List<int> pages = [1, 1, 1];
  List<bool> isLoading = [false, false, false];
  List<String> chipValue= ['Cricket', 'All', 'Cricket'];

  //
  final int _limit = 6;
  bool _hasMore = true;
  String _searchQuery = '';

  Future<void> searchFun(String value) async {
    setState(() {
      _searchQuery = value;
      matches[currentIndex].clear();
      pages[currentIndex] = 1;
      hasMore[currentIndex] = true;
    });
    await _fetchMatches(sportsTableMap[chipValue[currentIndex]]!);
  }


  @override
  void initState() {
    super.initState();
    _fetchMatches(sportsTableMap[chipValue[currentIndex]]!);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget search(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: blueColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              // onChanged: filterSchedule,
              decoration: const InputDecoration(
                hintText: "Search...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: InkWell(
              onTap: (){searchFun(searchController.text);},
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: yellowColor),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Icon(Icons.check, color: yellowColor,),

              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> onChipTap(String sport) async {
    setState(() {
      chipValue[currentIndex] = sport;
      matches[currentIndex].clear();
      pages[currentIndex] = 1;
      hasMore[currentIndex] = true;
    });
    await _fetchMatches(sportsTableMap[chipValue[currentIndex]]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(125.0),
        child: AppBar(
          backgroundColor: dark? Colors.black : Colors.white,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !isSearching
                    ? pageTitleText('Matches')
                    : Expanded(child: search()),
                    // const Spacer(),
                    IconButton(onPressed: (){
                      setState(() {
                        isSearching = !isSearching;
                        searchController.clear();
                      });
                    }, icon: Icon(isSearching? Icons.close_rounded : Icons.search, color: isSearching? Colors.red:yellowColor, size: 30,)),
                  ],
                )
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: yellowColor,
            labelColor: yellowColor,
            enableFeedback: true,
            onTap: (int index) {
              currentIndex = index;
              HapticFeedback.lightImpact();
              if(matches[currentIndex].isEmpty) _fetchMatches(sportsTableMap[chipValue[currentIndex]]!);
              setState(() {});
            },
            tabs: const [
              Tab(text: 'Live'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Results'),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:16, bottom: 10, top: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if(currentIndex==1) customChips("All", Icons.spoke,chipValue[currentIndex]=="All",() async {await onChipTap("All");}),
                  if(currentIndex==1) const SizedBox(width: 8.0),
                  customChips("Cricket", Icons.sports_cricket,chipValue[currentIndex]=="Cricket",() async {await onChipTap("Cricket");}),
                  const SizedBox(width: 8.0),
                  customChips("VolleyBall", Icons.sports_volleyball,chipValue[currentIndex]=="VolleyBall", () async {await onChipTap("VolleyBall");}),
                  const SizedBox(width: 8.0),
                  customChips("BasketBall", Icons.sports_basketball,chipValue[currentIndex]=="BasketBall",() async {await onChipTap("BasketBall");}),
                  const SizedBox(width: 8.0),
                  customChips("Hockey", Icons.sports_hockey,chipValue[currentIndex]=="Hockey", () async {await onChipTap("Hockey");}),
                  const SizedBox(width: 8.0),
                  customChips("Lawn Tennis", Icons.sports_tennis,chipValue[currentIndex]=="Lawn Tennis",() async {await onChipTap("Lawn Tennis");}),
                  const SizedBox(width: 8.0),
                  customChips("Table Tennis", Icons.sports_tennis,chipValue[currentIndex]=="Table Tennis", () async {await onChipTap("Table Tennis");}),
                ],
              ),
            ),
          ),
          Expanded(
            child: NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !isLoading[currentIndex]) {
                  _fetchMatches(sportsTableMap[chipValue[currentIndex]]!);
                }
                return false;
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  // LiveMatchesPage(searchController: _liveSearchController),
                  LiveMatchesPage(matches: matches[currentIndex],),
                  UpcomingMatchesPage(matches: matches[currentIndex],),
                  MatchResultsPage(matches: matches[currentIndex],),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchMatches(String sportTableName) async {
    if (isLoading[currentIndex] || !_hasMore) return;
    setState(() {isLoading[currentIndex] = true;});
    final String apiUrl = '$apiBaseUrl/${apiUrls[currentIndex]}?page=${pages[currentIndex]}&limit=$_limit&sortBy=time&order=ASC&search=$_searchQuery&sportTableName=$sportTableName';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          matches[currentIndex].addAll(data['matches']);
          pages[currentIndex]++;
          if (data['matches'].length < _limit) {
            hasMore[currentIndex] = false;
          }
        });
      } else {
        print('Failed to load matches');
      }
    } catch (e) {
      print('Error fetching matches: $e');
    }
    setState(() {isLoading[currentIndex] = false;});
  }
}

Future<void> openLocationUrl(String locationUrl) async {
  if (Platform.isAndroid || Platform.isIOS) {
    if (await canLaunchUrl(Uri.parse(locationUrl))) {
      await launchUrl(Uri.parse(locationUrl), mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: 'Could not open location.');
    }
  } else {
    Fluttertoast.showToast(msg: 'Could not open location');
  }
}
