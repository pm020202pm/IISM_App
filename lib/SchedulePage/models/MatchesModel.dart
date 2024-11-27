import 'package:intl/intl.dart';

class UpcomingMatchesModel {
  final String team1;
  final String team2;
  final String matchDate;
  final String matchTime;
  final String venue;
  final String sport;
  final String category;
  // final String matchType;
  // final String matchStatus;

  UpcomingMatchesModel(
      {required this.team1,
      required this.team2,
      required this.matchDate,
      required this.matchTime,
      required this.venue,
      required this.sport,
      required this.category,
      // this.matchType,
      // this.matchStatus
      });

  factory UpcomingMatchesModel.fromJson(Map<String, dynamic> json) {
    DateTime time = DateFormat('HH:mm:ss').parse(json['time'].toString());
    final date = DateTime.parse(json['date']??'2024-12-05');
    final formattedDate = DateFormat('d MMMM').format(date);
    final formattedTime = DateFormat('h:mm a').format(time);
    return UpcomingMatchesModel(
      team1: json['team1'],
      team2: json['team2'],
      matchDate: formattedDate,
      matchTime: formattedTime,
      venue: json['venue'],
      sport: json['sport'],
      category: json['category'],
      // matchType: json['matchType'],
      // matchStatus: json['matchStatus'],
    );
  }
}

// class CricketMatchModel {
//   final int matchId;
//   final String team1;
//   final String team2;
//   final String venue;
//   final String matchDate;
//   final String matchTime;
//   final String category;
//   final String status;
//   final String sport;
//   final String liveStreamUrl;
//   final int team1_score  ;
//   final int team1_wickets;
//   final int team2_score  ;
//   final int team2_wickets;
//   final double overs;
//
//   CricketMatchModel(
//       {
//         required this.matchId,
//         required this.team1,
//         required this.team2,
//         required this.venue,
//         required this.matchDate,
//         required this.matchTime,
//         required this.category,
//         required this.status,
//         required this.sport,
//         required this.liveStreamUrl,
//         required this.team1_score,
//         required this.team1_wickets,
//         required this.team2_score,
//         required this.team2_wickets,
//         required this.overs
//       });
//
//   factory CricketMatchModel.fromJson(Map<String, dynamic> json) {
//     DateTime time = DateFormat('HH:mm:ss').parse(json['time'].toString());
//     final date = DateTime.parse(json['date']??'2024-12-05');
//     final formattedDate = DateFormat('d MMMM').format(date); // Date format
//     final formattedTime = DateFormat('h:mm a').format(time);   // Time format
//     return CricketMatchModel(
//       matchId: json['matchId'],
//       team1: json['team1'],
//       team2: json['team2'],
//       venue: json['venue'],
//       matchDate: formattedDate,
//       matchTime: formattedTime,
//       category: json['category']??"",
//       status: json['status'],
//       sport: json['sport'],
//       liveStreamUrl: json['liveStreamUrl']??"",
//       team1_score: int.parse(json['team1_score']??"0"),
//       team1_wickets: int.parse(json['team1_wickets']??"0"),
//       team2_score: int.parse(json['team2_score']??"0"),
//       team2_wickets: int.parse(json['team2_wickets']??"0"),
//       overs: double.parse(json['overs']??"0.0")
//     );
//   }
// }
//
// class VolleyballMatchModel {
//   final int matchId;
//   final String? team1;
//   final String? team2;
//   final String? venue;
//   final String matchDate;
//   final String matchTime;
//   final String? category;
//   final String? status;
//   final String? sport;
//   final String? liveStreamUrl;
//   final int? set1Score1;
//   final int? set1Score2;
//   final int? set2Score1;
//   final int? set2Score2;
//   final int? set3Score1;
//   final int? set3Score2;
//   final int? set4Score1;
//   final int? set4Score2;
//   final int? set5Score1;
//   final int? set5Score2;
//
//   VolleyballMatchModel(
//       {
//         required this.matchId,
//         required this.team1,
//         required this.team2,
//         required this.venue,
//         required this.matchDate,
//         required this.matchTime,
//         required this.category,
//         required this.status,
//         required this.sport,
//         required this.liveStreamUrl,
//         required this.set1Score1,
//         required this.set1Score2,
//         required this.set2Score1,
//         required this.set2Score2,
//         required this.set3Score1,
//         required this.set3Score2,
//         required this.set4Score1,
//         required this.set4Score2,
//         required this.set5Score1,
//         required this.set5Score2
//       });
//
//   factory VolleyballMatchModel.fromJson(Map<String, dynamic> json) {
//     DateTime time = DateFormat('HH:mm:ss').parse(json['time'].toString());
//     final date = DateTime.parse(json['date']??'2024-12-05');
//     final formattedDate = DateFormat('d MMMM').format(date); // Date format
//     final formattedTime = DateFormat('h:mm a').format(time);   // Time format
//     return VolleyballMatchModel(
//       matchId: json['matchId'],
//       team1: json['team1'],
//       team2: json['team2'],
//       venue: json['venue'],
//       matchDate: formattedDate,
//       matchTime: formattedTime,
//       category: json['category']??"",
//       status: json['status'],
//       sport: json['sport'],
//       liveStreamUrl: json['liveStreamUrl']??"",
//       set1Score1: int.parse(json['set1_score1']??"0"),
//       set1Score2: int.parse(json['set1_score2']??"0"),
//       set2Score1: int.parse(json['set2_score1']??"0"),
//       set2Score2: int.parse(json['set2_score2']??"0"),
//       set3Score1: int.parse(json['set3_score1']??"0"),
//       set3Score2: int.parse(json['set3_score2']??"0"),
//       set4Score1: int.parse(json['set4_score1']??"0"),
//       set4Score2: int.parse(json['set4_score2']??"0"),
//       set5Score1: int.parse(json['set5_score1']??"0"),
//       set5Score2: int.parse(json['set5_score2']??"0")
//     );
//   }
// }
//
// class BasketballMatchModel {
//   final int? matchId;
//   final String? team1;
//   final String? team2;
//   final String? venue;
//   final String matchDate;
//   final String matchTime;
//   final String? category;
//   final String? status;
//   final String? sport;
//   final String? liveStreamUrl;
//   final int? team1Score;
//   final int? team2Score;
//
//   BasketballMatchModel(
//       {
//         required this.matchId,
//         required this.team1,
//         required this.team2,
//         required this.venue,
//         required this.matchDate,
//         required this.matchTime,
//         required this.category,
//         required this.status,
//         required this.sport,
//         required this.liveStreamUrl,
//         required this.team1Score,
//         required this.team2Score
//       });
//
//   factory BasketballMatchModel.fromJson(Map<String, dynamic> json) {
//     DateTime time = DateFormat('HH:mm:ss').parse(json['time'].toString());
//     final date = DateTime.parse(json['date']??'2024-12-05');
//     final formattedDate = DateFormat('d MMMM').format(date); // Date format
//     final formattedTime = DateFormat('h:mm a').format(time);   // Time format
//     return BasketballMatchModel(
//       matchId: json['matchId'],
//       team1: json['team1'],
//       team2: json['team2'],
//       venue: json['venue'],
//       matchDate: formattedDate,
//       matchTime: formattedTime,
//       category: json['category'],
//       status: json['status'],
//       sport: json['sport'],
//       liveStreamUrl: json['liveStreamUrl'],
//       team1Score: int.parse(json['team1_score']??"0"),
//       team2Score: int.parse(json['team2_score']??"0")
//     );
//   }
// }
//
// class HockeyMatchModel {
//   final int? matchId;
//   final String? team1;
//   final String? team2;
//   final String? venue;
//   final String matchDate;
//   final String matchTime;
//   final String? category;
//   final String? status;
//   final String? sport;
//   final String? liveStreamUrl;
//   final int? team1Goals;
//   final int? team2Goals;
//
//   HockeyMatchModel(
//       {
//         required this.matchId,
//         required this.team1,
//         required this.team2,
//         required this.venue,
//         required this.matchDate,
//         required this.matchTime,
//         required this.category,
//         required this.status,
//         required this.sport,
//         required this.liveStreamUrl,
//         required this.team1Goals,
//         required this.team2Goals
//       });
//
//   factory HockeyMatchModel.fromJson(Map<String, dynamic> json) {
//     DateTime time = DateFormat('HH:mm:ss').parse(json['time'].toString());
//     final date = DateTime.parse(json['date']??'2024-12-05');
//     final formattedDate = DateFormat('d MMMM').format(date); // Date format
//     final formattedTime = DateFormat('h:mm a').format(time);   // Time format
//     return HockeyMatchModel(
//       matchId: json['matchId'],
//       team1: json['team1'],
//       team2: json['team2'],
//       venue: json['venue'],
//       matchDate: formattedDate,
//       matchTime: formattedTime,
//       category: json['category'],
//       status: json['status'],
//       sport: json['sport'],
//       liveStreamUrl: json['liveStreamUrl'],
//       team1Goals: int.parse(json['team1_goals']??"0"),
//       team2Goals: int.parse(json['team2_goals']??"0")
//     );
//   }
// }
//
// class LawnTennisMatchModel {
//   final int? matchId;
//   final String? team1;
//   final String? team2;
//   final String? venue;
//   final String matchDate;
//   final String matchTime;
//   final String? category;
//   final String? status;
//   final String? sport;
//   final String? liveStreamUrl;
//   final int? set1Score1;
//   final int? set1Score2;
//   final int? set2Score1;
//   final int? set2Score2;
//   final int? set3Score1;
//   final int? set3Score2;
//   final int? set4Score1;
//   final int? set4Score2;
//   final int? set5Score1;
//   final int? set5Score2;
//
//   LawnTennisMatchModel(
//       {
//         required this.matchId,
//         required this.team1,
//         required this.team2,
//         required this.venue,
//         required this.matchDate,
//         required this.matchTime,
//         required this.category,
//         required this.status,
//         required this.sport,
//         required this.liveStreamUrl,
//         required this.set1Score1,
//         required this.set1Score2,
//         required this.set2Score1,
//         required this.set2Score2,
//         required this.set3Score1,
//         required this.set3Score2,
//         required this.set4Score1,
//         required this.set4Score2,
//         required this.set5Score1,
//         required this.set5Score2
//       });
//
//   factory LawnTennisMatchModel.fromJson(Map<String, dynamic> json) {
//     DateTime time = DateFormat('HH:mm:ss').parse(json['time'].toString());
//     final date = DateTime.parse(json['date']??'2024-12-05');
//     final formattedDate = DateFormat('d MMMM').format(date); // Date format
//     final formattedTime = DateFormat('h:mm a').format(time);   // Time format
//     return LawnTennisMatchModel(
//       matchId: json['matchId'],
//       team1: json['team1'],
//       team2: json['team2'],
//       venue: json['venue'],
//       matchDate: formattedDate,
//       matchTime: formattedTime,
//       category: json['category'],
//       status: json['status'],
//       sport: json['sport'],
//       liveStreamUrl: json['liveStreamUrl'],
//       set1Score1: json['set1_score1'],
//       set1Score2: json['set1_score2'],
//       set2Score1: json['set2_score1'],
//       set2Score2: json['set2_score2'],
//       set3Score1: json['set3_score1'],
//       set3Score2: json['set3_score2'],
//       set4Score1: json['set4_score1'],
//       set4Score2: json['set4_score2'],
//       set5Score1: json['set5_score1'],
//       set5Score2: json['set5_score2']
//     );
//   }
// }
//
// class TableTennisMatchModel {
//   final int? matchId;
//   final String? team1;
//   final String? team2;
//   final String? venue;
//   final String matchDate;
//   final String matchTime;
//   final String? category;
//   final String? status;
//   final String? sport;
//   final String? liveStreamUrl;
//   final int? set1Score1;
//   final int? set1Score2;
//   final int? set2Score1;
//   final int? set2Score2;
//   final int? set3Score1;
//   final int? set3Score2;
//   final int? set4Score1;
//   final int? set4Score2;
//   final int? set5Score1;
//   final int? set5Score2;
//
//   TableTennisMatchModel(
//       {
//         required this.matchId,
//         required this.team1,
//         required this.team2,
//         required this.venue,
//         required this.matchDate,
//         required this.matchTime,
//         required this.category,
//         required this.status,
//         required this.sport,
//         required this.liveStreamUrl,
//         required this.set1Score1,
//         required this.set1Score2,
//         required this.set2Score1,
//         required this.set2Score2,
//         required this.set3Score1,
//         required this.set3Score2,
//         required this.set4Score1,
//         required this.set4Score2,
//         required this.set5Score1,
//         required this.set5Score2
//       });
//
//   factory TableTennisMatchModel.fromJson(Map<String, dynamic> json) {
//     DateTime time = DateFormat('HH:mm:ss').parse(json['time'].toString());
//     final date = DateTime.parse(json['date']??'2024-12-05');
//     final formattedDate = DateFormat('d MMMM').format(date); // Date format
//     final formattedTime = DateFormat('h:mm a').format(time);   // Time format
//     return TableTennisMatchModel(
//       matchId: json['matchId'],
//       team1: json['team1'],
//       team2: json['team2'],
//       venue: json['venue'],
//       matchDate: formattedDate,
//       matchTime: formattedTime,
//       category: json['category'],
//       status: json['status'],
//       sport: json['sport'],
//       liveStreamUrl: json['liveStreamUrl'],
//       set1Score1: json['set1_score1'],
//       set1Score2: json['set1_score2'],
//       set2Score1: json['set2_score1'],
//       set2Score2: json['set2_score2'],
//       set3Score1: json['set3_score1'],
//       set3Score2: json['set3_score2'],
//       set4Score1: json['set4_score1'],
//       set4Score2: json['set4_score2'],
//       set5Score1: json['set5_score1'],
//       set5Score2: json['set5_score2']
//     );
//   }
// }