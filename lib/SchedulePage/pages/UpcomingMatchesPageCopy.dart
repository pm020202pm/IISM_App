// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
//
// import '../../api.dart';
// import '../../utils.dart';
// import '../models/MatchesModel.dart';
// import '../widgets/SortBySearch.dart';
// import '../widgets/UpcomingMatchCard.dart';
// import '../widgets/widgets.dart';
//
// class UpcomingMatchesPage extends StatefulWidget {
//   final TextEditingController searchController;
//   final List<dynamic> matches;
//
//   const UpcomingMatchesPage({super.key, required this.searchController, required this.matches});
//
//   @override
//   _UpcomingMatchesPageState createState() => _UpcomingMatchesPageState();
// }
//
// class _UpcomingMatchesPageState extends State<UpcomingMatchesPage> {
//   int _page = 1;
//   final int _limit = 6; // Default limit
//   List<dynamic> _matches = [];
//   bool _isLoading = false;
//   bool _hasMore = true;
//   String _sortBy = 'time'; // Default sort field
//   String _order = 'ASC'; // Default order
//   String _sortCriteria = 'Time'; // Default sort criteria for the dropdown
//   String _searchQuery = ''; // Default search query
//   String chipSportValue = "All";
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchMatches();
//   }
//
//   Future<void> _fetchMatches() async {
//     if (_isLoading || !_hasMore) return;
//     setState(() {
//       _isLoading = true;
//     });
//     final String apiUrl = '$apiBaseUrl/matches?page=$_page&limit=$_limit&sortBy=$_sortBy&order=$_order&search=$_searchQuery';
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print(data['matches']);
//         setState(() {
//           _matches.addAll(data['matches']);
//           _page++;
//           if (data['matches'].length < _limit) {
//             _hasMore = false;
//           }
//         });
//       } else {
//         print('Failed to load matches');
//       }
//     } catch (e) {
//       print('Error fetching matches: $e');
//     }
//
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   // Method to handle sorting change
//   void _changeSortCriteria(String newValue) {
//     setState(() {
//       _sortCriteria = newValue;
//       _sortBy = _mapSortCriteriaToField(newValue);
//       _matches.clear();
//       _page = 1;
//       _hasMore = true;
//       _fetchMatches();
//     });
//   }
//
//   // Mapping dropdown values to database fields
//   String _mapSortCriteriaToField(String value) {
//     switch (value) {
//       // case 'Date':
//       //   return 'date';
//       case 'Sport':
//         return 'sport';
//       case 'Time':
//         return 'time';
//       case 'Venue':
//         return 'matchVenue';
//       default:
//         return 'matchDate';
//     }
//   }
//
//   // Method to handle search input
//   void _filterSchedule(String value) {
//     setState(() {
//       _searchQuery = value;
//       _matches.clear();
//       _page = 1;
//       _hasMore = true;
//       _fetchMatches();
//     });
//   }
//
//   Future<void> onChipTap(String sport) async {
//     setState(() {
//       chipSportValue = sport;
//       _matches.clear();
//       _page = 1;
//       _hasMore = true;
//     });
//     await _fetchMatches();
//     // await _fetchMatches(sportsTableMap[chipSportValue]!);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // SortBySearch(changeSortCriteria: _changeSortCriteria, searchController: widget.searchController, filterSchedule: _filterSchedule, sortCriteria: _sortCriteria),
//         Expanded(
//           child: NotificationListener<ScrollNotification>(
//             onNotification: (ScrollNotification scrollInfo) {
//               if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !_isLoading) {
//                 _fetchMatches();
//               }
//               return false;
//             },
//             child: ListView.builder(
//               itemCount: widget.matches.length + (_hasMore ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index >= widget.matches.length) return const Center(child: CircularProgressIndicator());
//                 UpcomingMatchesModel model = UpcomingMatchesModel.fromJson(widget.matches[index]);
//                 if(index<widget.matches.length-1) return UpcomingMatchCard(match: model);
//                 if(index==widget.matches.length-1) {
//                   return Column(
//                   children: [
//                     UpcomingMatchCard(match: model),
//                     const SizedBox(height: 70.0),
//                   ],
//                 );
//                 }
//                 // return if(index<=_matches.length) UpcomingMatchCard(match: model);
//
//               },
//             ),
//           ),
//         ),
//         // const SizedBox(height: 100.0)
//       ],
//     );
//   }
// }
