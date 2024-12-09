import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../widgets/widgets.dart';
import '../models/LiveMatchModel.dart';
import '../widgets/widgets.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key, required this.match});
  final LiveNowMatchModel match;

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  late YoutubePlayerController _controller;
  late String videoID = "";
  String url = 'https://youtu.be/7d186s14Jg4';
  double _playbackSpeed = 1.0;
  String _selectedQuality = 'hd720';
  bool allowPop = false;
  bool isVideoAvailable = false;

  String set1Score1='0';
  String set1Score2='0';
  String set2Score1='0';
  String set2Score2='0';
  String set3Score1='0';
  String set3Score2='0';
  String set4Score1='0';
  String set4Score2='0';
  String set5Score1='0';
  String set5Score2='0';

  // hockey
  String team1Goals='0';
  String team2Goals='0';

  // basketball
  String team1Score='0';
  String team2Score='0';

  // cricket
  String team1_score='0';
  String team1_wickets='0';
  String team2_score='0';
  String team2_wickets='0';
  String team1_overs='0';
  String team2_overs='0';
  String active = '1';

  final Map<String, String> _qualityOptions = {
    '360p': 'small', // YouTube quality option names
    '480p': 'medium',
    '720p': 'hd720',
    '1080p': 'hd1080',
    '1440p': 'hd1440',
    '2160p': 'highres',
  };

  final Map<String, String> _speedOptions = {
    '0.25x': '0.25',
    '0.5x': '0.5',
    'Normal': '1.0',
    '1.5x': '1.5',
    '2.0x': '2.0',
  };

  @override
  void initState() {
    super.initState();
    String url = widget.match.liveStreamUrl??'';
    if(url.length>14 && url.toLowerCase().substring(0,15)=='https://youtu.b'){
      isVideoAvailable=true;
      videoID = YoutubePlayer.convertUrlToId(url)!;
      _controller = YoutubePlayerController(
        initialVideoId: videoID,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          isLive: true,
        ),
      );
    }
    else {
      isVideoAvailable = false;
    }

    set1Score1 = widget.match.set1Score1;
    set1Score2 = widget.match.set1Score2;
    set2Score1 = widget.match.set2Score1;
    set2Score2 = widget.match.set2Score2;
    set3Score1 = widget.match.set3Score1;
    set3Score2 = widget.match.set3Score2;
    set4Score1 = widget.match.set4Score1;
    set4Score2 = widget.match.set4Score2;
    set5Score1 = widget.match.set5Score1;
    set5Score2 = widget.match.set5Score2;
    team1Goals = widget.match.team1Goals;
    team2Goals = widget.match.team2Goals;
    team1Score = widget.match.team1Score;
    team2Score = widget.match.team2Score;
    team1_score = widget.match.team1_score??'0';
    team1_wickets = widget.match.team1_wickets??'0';
    team2_score = widget.match.team2_score??'0';
    team2_wickets = widget.match.team2_wickets??'0';
    team1_overs = widget.match.team1_overs;
    team2_overs = widget.match.team2_overs;
    active = widget.match.active??'1';
    setState(() {

    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });
    _controller.setPlaybackRate(speed);
  }

  void _changeVideoQuality(String quality) {
    setState(() {
      _selectedQuality = quality;
    });
    _controller.load(videoID); // Reload the video using the same ID
  }



  @override
  Widget build(BuildContext context) {
    print("widget.match.liveStreamUrl");
    print(widget.match.liveStreamUrl);
    String url = widget.match.liveStreamUrl??'';
    String sport = widget.match.sport!.replaceAll(' ', '');
    String matchId = widget.match.matchId.toString();
    // if(url.toLowerCase()=='na' || url=='' || widget.match.liveStreamUrl==null){
    //   isVideoAvailable = false;
    // }
    if(isVideoAvailable==false){
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Container(
                height: 200,
                color: Colors.grey.shade200,
                child: Center(
                  child: customText("No Live Stream Available", 20, FontWeight.w800, Colors.grey, 1.5),
                ),
              ),
              const Divider(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    verticalLogoWithCollegeName(widget.match.team1!.toUpperCase(), 45, 45),
                    Column(
                      children: [
                        if(widget.match.sport=='cricket') liveCricket(),
                        if(widget.match.sport=='volleyball' || widget.match.sport == 'table tennis' || widget.match.sport=='lawn tennis') liveVolleyball(active),
                        if(widget.match.sport=='hockey') liveHockey(),
                        if(widget.match.sport=='basketball') liveBasketball(),
                      ],
                    ),
                    verticalLogoWithCollegeName(widget.match.team2!.toUpperCase(), 45, 45),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      );
    }
    // String battingTeam = (active == '1') ? widget.match.team1! : widget.match.team2!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Page"),
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
        builder: (context, player) {
          return SingleChildScrollView(
            child: Column(
              children: [
                player,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: _selectedQuality,
                        items: _qualityOptions.keys.map((String quality) {
                          return DropdownMenuItem<String>(
                            value: _qualityOptions[quality]!,
                            child: Text(quality),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _changeVideoQuality(value);
                          }
                        },
                        underline: Container(), // Remove underline
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      verticalLogoWithCollegeName(widget.match.team1!.toUpperCase(), 45, 45),
                      Column(
                        children: [
                          if(widget.match.sport=='cricket') liveCricket(),
                          if(widget.match.sport=='volleyball' || widget.match.sport == 'table tennis' || widget.match.sport=='lawn tennis') liveVolleyball(active),
                          if(widget.match.sport=='hockey') liveHockey(),
                          if(widget.match.sport=='basketball') liveBasketball(),
                        ],
                      ),
                      verticalLogoWithCollegeName(widget.match.team2!.toUpperCase(), 45, 45),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget liveCricket(){
    double ball1 = double.parse(team1_overs);
    double ball2 = double.parse(team2_overs);
    String team1overs = '${ball1~/6}.${ball1.toInt()%6}';
    String team2overs = '${ball2~/6}.${ball2.toInt()%6}';
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText('${team1_score}/${team1_wickets.toString()}', 16, FontWeight.w600, Colors.grey.shade700, 1),
            const SizedBox(height: 5),
            customText('${team1overs}/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
          ],
        ),
        const SizedBox(width: 10,),
        customText("VS", 16, FontWeight.w700, Colors.red.shade400, 1),
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            customText('${team2_score.toString()}/${team2_wickets.toString()}', 16, FontWeight.w600, Colors.grey.shade700, 1),
            const SizedBox(height: 5),
            customText('${team2overs}/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
          ],
        ),
      ],
    );
  }
  Widget liveHockey(){
    return Row(
      children: [
        customText(team1Goals.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
        const SizedBox(width: 15,),
        customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
        const SizedBox(width: 15,),
        customText(team2Goals.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
      ],
    );
  }
  Widget liveBasketball(){
    return Row(
      children: [
        customText(team1_score.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
        const SizedBox(width: 15,),
        customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
        const SizedBox(width: 15,),
        customText(team2_score.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
      ],
    );
  }
  Widget liveVolleyball(String active){
    // String scoreTeam1 = (active=='1')? set1Score1 : (active=='2')? set2Score1 : (active=='3')? set3Score1 : (active=='4')? set4Score1 : set5Score1;
    // String scoreTeam2 = (active=='1')? set1Score2 : (active=='2')? set2Score2 : (active=='3')? set3Score2 : (active=='4')? set4Score2 : set5Score2;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: [
              Row(
                children: [
                  if(double.parse(set1Score1)>0 || double.parse(set1Score2)>0) setScore("1",set1Score1 , set1Score2),
                  if(double.parse(set2Score1)>0 || double.parse(set2Score2)>0) SizedBox(width: 5),
                  if(double.parse(set2Score1)>0 || double.parse(set2Score2)>0) setScore("2",set2Score1 , set2Score2),
                ],
              ),

              if(double.parse(set3Score1)>0 || double.parse(set3Score2)>0) SizedBox(height: 5),
              Row(
                children: [
                  if(double.parse(set3Score1)>0 || double.parse(set3Score2)>0) setScore("3",set3Score1 , set3Score2),
                  if(double.parse(set4Score1)>0 || double.parse(set4Score2)>0) SizedBox(width: 5),
                  if(double.parse(set4Score1)>0 || double.parse(set4Score2)>0) setScore("4",set4Score1 , set4Score2),
                ],
              ),
              if(double.parse(set5Score1)>0 || double.parse(set5Score2)>0) SizedBox(height: 5),
              if(double.parse(set5Score1)>0 || double.parse(set5Score2)>0) setScore("5",set5Score1 , set5Score2),
              // setScore(active,scoreTeam1 , scoreTeam2),
              // setScore("3",scoreTeam1 , scoreTeam2),
            ],
          ),
        ),
      ],
    );
  }
}























// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import '../../widgets/widgets.dart';
// import '../models/LiveMatchModel.dart';
//
// class LivePage extends StatefulWidget {
//   const LivePage({super.key, required this.match});
//   final LiveNowMatchModel match;
//
//   @override
//   State<LivePage> createState() => _LivePageState();
// }
//
// class _LivePageState extends State<LivePage> {
//   late YoutubePlayerController _controller;
//   late String videoID = "";
//   String url = 'https://youtu.be/7d186s14Jg4';
//   double _playbackSpeed = 1.0;
//   String _selectedQuality = 'hd720';
//   bool allowPop = false;
//
//   final Map<String, String> _qualityOptions = {
//     '360p': 'small', // YouTube quality option names
//     '480p': 'medium',
//     '720p': 'hd720',
//     '1080p': 'hd1080',
//     '1440p': 'hd1440',
//     '2160p': 'highres',
//   };
//
//   final Map<String, String> _speedOptions = {
//     '0.25x': '0.25',
//     '0.5x': '0.5',
//     'Normal': '1.0',
//     '1.5x': '1.5',
//     '2.0x': '2.0',
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     if(widget.match.liveStreamUrl!='' && widget.match.liveStreamUrl!=null) url = widget.match.liveStreamUrl!;
//     videoID = YoutubePlayer.convertUrlToId(url)!;
//     _controller = YoutubePlayerController(
//       initialVideoId: videoID,
//       flags: const YoutubePlayerFlags(
//         autoPlay: false,
//         mute: false,
//         isLive: true,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//
//   }
//
//   void _changePlaybackSpeed(double speed) {
//     setState(() {
//       _playbackSpeed = speed;
//     });
//     _controller.setPlaybackRate(speed);
//   }
//
//   void _changeVideoQuality(String quality) {
//     setState(() {
//       _selectedQuality = quality;
//     });
//     _controller.load(videoID); // Reload the video using the same ID
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Live Page"),
//       ),
//       body: YoutubePlayerBuilder(
//         player: YoutubePlayer(
//           controller: _controller,
//           showVideoProgressIndicator: true,
//         ),
//         builder: (context, player) {
//           return Column(
//             children: [
//               player,
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // DropdownButton<double>(
//                     //   value: _playbackSpeed,
//                     //   items: _speedOptions.map((String speed, String value) {
//                     //     return MapEntry(
//                     //       speed,
//                     //       DropdownMenuItem<double>(
//                     //         value: double.parse(value),
//                     //         child: Text(speed),
//                     //       ),
//                     //     );
//                     //   }).values.toList(), // Convert the map values to a list (DropdownMenuItem<double>
//                     //   onChanged: (value) {
//                     //     if (value != null) {
//                     //       _changePlaybackSpeed(value);
//                     //     }
//                     //   },
//                     //   underline: Container(), // Remove underline
//                     // ),
//                     DropdownButton<String>(
//                       value: _selectedQuality,
//                       items: _qualityOptions.keys.map((String quality) {
//                         return DropdownMenuItem<String>(
//                           value: _qualityOptions[quality]!,
//                           child: Text(quality),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         if (value != null) {
//                           _changeVideoQuality(value);
//                         }
//                       },
//                       underline: Container(), // Remove underline
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 5),
//                       child: Container(
//                         alignment: Alignment.center,
//                         child: Row(
//                           children: [
//                             Container(
//                                 padding: const EdgeInsets.all(2.0),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(70),
//                                 ),
//                                 child: Image.asset(
//                                     'assets/logo/${widget.match.team1?.toUpperCase()}.png',
//                                     width: 20,
//                                     height: 20)),
//                             const SizedBox(width: 5),
//                             SizedBox(
//                                 width: 110,
//                                 child: customText(
//                                     widget.match.team1!.toUpperCase(),
//                                     14,
//                                     FontWeight.w900,
//                                     Colors.grey.shade800,
//                                     1.9)),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         if (widget.match.sport == "table tennis" ||
//                             widget.match.sport == "lawn tennis" ||
//                             widget.match.sport == "volleyball")
//                           liveVolleyball(widget.match.active!),
//                         if (widget.match.sport == "hockey")
//                           score2(widget.match.team1Goals.toString(),
//                               widget.match.team2Goals.toString()),
//                         if (widget.match.sport == "basketball")
//                           score2(widget.match.team1Score.toString(),
//                               widget.match.team2Score.toString()),
//                         if (widget.match.sport == "cricket")
//                           score2(widget.match.team1_score.toString(),
//                               widget.match.team2_score.toString()),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 5),
//                       child: Container(
//                         alignment: Alignment.center,
//                         child: Row(
//                           children: [
//                             Container(
//                                 alignment: Alignment.centerRight,
//                                 width: 110,
//                                 child: customText(
//                                     widget.match.team2!.toUpperCase(),
//                                     14,
//                                     FontWeight.w900,
//                                     Colors.grey.shade800,
//                                     1.9)),
//                             const SizedBox(width: 5),
//                             Container(
//                                 padding: const EdgeInsets.all(2.0),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(70),
//                                 ),
//                                 child: Image.asset(
//                                     'assets/logo/${widget.match.team2?.toUpperCase()}.png',
//                                     width: 20,
//                                     height: 20)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }
//   Widget liveVolleyball(String active){
//     String scoreTeam1 = (active=='1')? widget.match.set1Score1 : (active=='2')? widget.match.set2Score1 : (active=='3')? widget.match.set3Score1 : (active=='4')? widget.match.set4Score1 : widget.match.set5Score1;
//     String scoreTeam2 = (active=='1')? widget.match.set1Score2 : (active=='2')? widget.match.set2Score2 : (active=='3')? widget.match.set3Score2 : (active=='4')? widget.match.set4Score2 : widget.match.set5Score2;
//     return Row(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(3.0),
//           child: setScore(active,scoreTeam1 , scoreTeam2),
//         ),
//       ],
//     );
//   }
// }
