import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iism/PlayersPage/widgets/PlayerCard.dart';
import 'package:iism/ProfilePage/models/ParticipantModel.dart';
import 'package:iism/api.dart';
import 'package:iism/utils.dart';
import 'package:http/http.dart' as http;
import '../../SchedulePage/pages/schedule_page.dart';
import '../../widgets/widgets.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = "";
  bool _hasMore = true;
  bool _isLoading = false;
  final List<dynamic> _players = [];
  bool isSearching = false;


  int _page = 1;
  final int _limit = 8; // Default limit
  String chipSportValue = "Cricket";

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> searchFun(String value) async {
    setState(() {
      _searchQuery = value;
      _players.clear();
      _page = 1;
      _hasMore = true;
    });
    await _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });
    final String apiUrl = '$apiBaseUrl/players?page=$_page&limit=$_limit&search=$_searchQuery';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _players.addAll(data['players']);
          _page++;
          if (data['players'].length < _limit) {
            _hasMore = false;
          }
        });
      } else {
        errorSnackMsg('Failed to load matches');
      }
    } catch (e) {
      errorSnackMsg('Error fetching players list');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: dark? Colors.black : Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: dark ? Colors.black : Colors.white,
            flexibleSpace: Container(
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
                                pageTitleText('Players'),
                                SizedBox(width: size.width-228.5,),
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
            // setState(() {
              _players.clear();
              _page = 1;
              _hasMore = true;
            // });
            await _fetchPlayers();
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (!_isLoading && _hasMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                _fetchPlayers();
                return true;
              }
              return false;
            },
            child: ListView.builder(
              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 1, // 2 items per row
              //   crossAxisSpacing: 0.0, // Spacing between columns
              //   mainAxisSpacing: 5.0,  // Spacing between rows
              //   childAspectRatio: 4,
              // ),
              padding: const EdgeInsets.all(8.0),
              itemCount: _players.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _players.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                var player = _players[index];
                ParticipantModel playerModel = ParticipantModel.fromJson(player);
                return PlayerCard(playerModel: playerModel);
              },
            ),
          ),
        )
        ,
      ),
    );
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
