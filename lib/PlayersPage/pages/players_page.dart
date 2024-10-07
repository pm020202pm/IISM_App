import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iism/ProfilePage/models/ParticipantModel.dart';
import 'package:iism/api.dart';
import 'package:iism/utils.dart';
import 'package:http/http.dart' as http;
import '../../SchedulePage/widgets/widgets.dart';
import '../../widgets/widgets.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _hasMore = true;
  bool _isLoading = false;
  final List<QueryDocumentSnapshot> _scheduleDocs = [];
  List<dynamic> _players = [];

  int _page = 1;
  final int _limit = 8; // Default limit
  String chipSportValue = "Cricket";

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  void _filterSchedule(String query) {
    setState(() {
      _searchQuery = query;
      _players.clear();
      _scheduleDocs.clear();
      _hasMore = true;
      _page = 1;
      _fetchPlayers();
    });
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
    return Scaffold(
      backgroundColor: dark? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: null,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pageTitleText("Players"),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        // width: 220,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterSchedule,
                          decoration: const InputDecoration(
                            hintText: "Search...",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!_isLoading && _hasMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchPlayers();
            return true;
          }
          return false;
        },
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // 2 items per row
            crossAxisSpacing: 0.0, // Spacing between columns
            mainAxisSpacing: 5.0,  // Spacing between rows
            childAspectRatio: 4,
          ),
          padding: const EdgeInsets.all(8.0),
          itemCount: _players.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _players.length) {
              return const Center(child: CircularProgressIndicator());
            }
            var player = _players[index];
            ParticipantModel playerModel = ParticipantModel.fromJson(player);
            return Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset('assets/images/person.png', fit: BoxFit.cover)),
                    const SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formatName(playerModel.name),
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            height: 1
                          ),

                        ),
                        Text(playerModel.gender,
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              height: 1
                          ),
                        ),
                        Text(playerModel.email,
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              height: 1.1
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      )
      ,
    );
  }
}
