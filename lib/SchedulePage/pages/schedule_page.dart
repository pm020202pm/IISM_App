import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iism/api.dart';
import 'package:iism/utils.dart';
import 'package:flutter/services.dart';
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
  // late TabController _tabController;
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  int currentIndex = 1;
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

  final int _limit = 10;
  String _searchQuery = '';
  double tabPadding = 10;

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
    // _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
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
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: dark ? Colors.black : Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: dark ? Colors.black : Colors.white,
            flexibleSpace: SizedBox(
              height: 80,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  AnimatedPositioned(
                    right: isSearching ? 0 : -size.width,
                    top: 0,
                    bottom: 0,
                    left: isSearching ? -size.width : 0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: SizedBox(
                            width: size.width-32,
                            child: Row(
                              children: [
                                pageTitleText('Matches'),
                                const Spacer(),
                                OctagonalIconButton(
                                  onTap: () {
                                    setState(() {
                                      HapticFeedback.lightImpact();
                                      isSearching = !isSearching;
                                      searchController.clear();
                                    });
                                  },
                                  icon: Icons.search,
                                  iconColor: blueColor,
                                  bgColor: blueColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: SizedBox(
                            width: size.width-32,
                            child: Row(
                              children: [
                                Expanded(child: search()),
                                const SizedBox(width: 15,),
                                OctagonalIconButton(
                                  onTap: () async {
                                    if(searchController.text.isNotEmpty) await searchFun('');
                                    setState(() {
                                      HapticFeedback.lightImpact();
                                      isSearching = !isSearching;
                                      searchController.clear();
                                    });

                                  },
                                  icon: Icons.close_rounded,
                                  iconColor: Colors.red,
                                  bgColor: Colors.red.shade500,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              matches[currentIndex].clear();
              pages[currentIndex] = 1;
              hasMore[currentIndex] = true;
            });
            await _fetchMatches(sportsTableMap[chipValue[currentIndex]]!);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ClipPath(
                  clipper: OctagonClipper3(padding: 10),
                  child: SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            HapticFeedback.lightImpact();
                            setState(() {
                              currentIndex = 0;
                            });
                            if(matches[currentIndex].isEmpty) {_fetchMatches(sportsTableMap[chipValue[currentIndex]]!);}
                          },
                          child: AnimatedContainer(
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.all((currentIndex==0) ? tabPadding : 8.0),
                            duration: const Duration(milliseconds: 300),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: (currentIndex==0) ? yellowColor : Colors.grey.shade300,
                            ),
                            child: customText("Live Now", (currentIndex==0) ? 18 : 15, FontWeight.w600, (currentIndex==0) ? Colors.white :Colors.grey.shade600, 1),
                          ),
                        ),
                        const SizedBox(width: 3.0),
                        InkWell(
                          onTap: (){
                            HapticFeedback.lightImpact();
                            setState(() {
                              currentIndex = 1;
                            });
                            if(matches[currentIndex].isEmpty) {
                              _fetchMatches(sportsTableMap[chipValue[currentIndex]]!);
                            }
                          },
                          child: AnimatedContainer(
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.all((currentIndex==1) ? tabPadding : 8.0),
                            duration: const Duration(milliseconds: 300),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: (currentIndex==1) ? yellowColor : Colors.grey.shade300,
                            ),
                            child: customText("Upcoming", (currentIndex==1) ? 18 : 15, FontWeight.w600, (currentIndex==1) ? Colors.white :Colors.grey.shade600, 1),
                          ),
                        ),
                        const SizedBox(width: 3.0),
                        InkWell(
                          onTap: (){
                            HapticFeedback.lightImpact();
                            setState(() {
                              currentIndex = 2;
                            });
                            if(matches[currentIndex].isEmpty) {
                              _fetchMatches(sportsTableMap[chipValue[currentIndex]]!);
                            }
                          },
                          child: AnimatedContainer(
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.all((currentIndex==2) ? tabPadding : 8.0),
                            duration: const Duration(milliseconds: 300),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: (currentIndex==2) ? yellowColor : Colors.grey.shade300,
                              // borderRadius: BorderRadius.circular(50),
                            ),
                            child: customText(" Results ", (currentIndex==2) ? 18 : 15, FontWeight.w600, (currentIndex==2) ? Colors.white :Colors.grey.shade600, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 10, top: 10, right: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (currentIndex == 1)
                        customChip2("All", Icons.spoke, chipValue[currentIndex] == "All", () async {
                          await onChipTap("All");
                        }),
                      if (currentIndex == 1) const SizedBox(width: 8.0),
                      customChip2("Cricket", Icons.sports_cricket, chipValue[currentIndex] == "Cricket", () async {
                        await onChipTap("Cricket");
                      }),
                      const SizedBox(width: 8.0),
                      customChip2("VolleyBall", Icons.sports_volleyball, chipValue[currentIndex] == "VolleyBall", () async {
                        await onChipTap("VolleyBall");
                      }),
                      const SizedBox(width: 8.0),
                      customChip2("BasketBall", Icons.sports_basketball, chipValue[currentIndex] == "BasketBall", () async {
                        await onChipTap("BasketBall");
                      }),
                      const SizedBox(width: 8.0),
                      customChip2("Hockey", Icons.sports_hockey, chipValue[currentIndex] == "Hockey", () async {
                        await onChipTap("Hockey");
                      }),
                      const SizedBox(width: 8.0),
                      customChip2("Lawn Tennis", Icons.sports_tennis, chipValue[currentIndex] == "Lawn Tennis", () async {
                        await onChipTap("Lawn Tennis");
                      }),
                      const SizedBox(width: 8.0),
                      customChip2("Table Tennis", Icons.sports_tennis, chipValue[currentIndex] == "Table Tennis", () async {
                        await onChipTap("Table Tennis");
                      }),
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
                  child: currentIndex == 0
                      ? LiveMatchesPage(matches: matches[currentIndex], hasMore: hasMore[currentIndex])
                      : currentIndex == 1
                      ? UpcomingMatchesPage(matches: matches[currentIndex], hasMore: hasMore[currentIndex])
                      : MatchResultsPage(matches: matches[currentIndex], hasMore: hasMore[currentIndex]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchMatches(String sportTableName) async {
    if (isLoading[currentIndex] || !hasMore[currentIndex]) return;
    setState(() {
      isLoading[currentIndex] = true;
    });
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
    setState(() {
      isLoading[currentIndex] = false;
    });
  }

  Widget search() {
    return ClipPath(
      clipper: OctagonClipper(padding: 10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: blueColor),
          color: blueColor,
        ),
        child: ClipPath(
          clipper: OctagonClipper(padding: 10),
          child: Container(
            width: 100,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (val) async {
                      await searchFun(searchController.text);
                    },
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(6.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: OctagonalIconButton(
                      onTap: () async {await searchFun(searchController.text);},
                      icon: Icons.check_rounded,
                      iconColor: yellowColor,
                      bgColor: yellowColor
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OctagonalIconButton extends StatelessWidget {
  const OctagonalIconButton({super.key, required this.onTap, required this.icon, required this.iconColor, required this.bgColor});
  final Function() onTap;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: OctagonClipper(padding: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: bgColor),
            color: bgColor,
          ),
          child: ClipPath(
              clipper: OctagonClipper(padding: 10),
              child: Container(
                // color: Colors.white,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(10)
                    color: Colors.white.withOpacity(0.8),
                  ),
                  child: Icon(icon, color: iconColor,))),

        ),
      ),
    );
  }
}

class OctagonClipper3 extends CustomClipper<Path> {
  final double padding;
  OctagonClipper3({required this.padding});
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;

    // const double padding = 20; // Adjust this value to modify the octagon cut

    path.moveTo(0, padding); // Top-left cut
    path.lineTo(padding, 0);
    path.lineTo(width - padding, 0);
    path.lineTo(width, padding);
    path.lineTo(width, height-padding);
    path.lineTo(width-padding, height);
    path.lineTo(padding, height); // Bottom-left cut
    path.lineTo(0, height - padding); // Left-bottom cut

    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}