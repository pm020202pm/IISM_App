import 'package:flutter/material.dart';
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
  // String url = 'https://youtu.be/7d186s14Jg4';
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
    '1080p': 'hd1080'
  };

  @override
  void initState() {
    super.initState();
    String url = widget.match.liveStreamUrl??'';
    // String url = 'https://youtu.be/3MT8ahOudTk';
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

  void _changeVideoQuality(String quality) {
    setState(() {
      _selectedQuality = quality;
    });
    _controller.load(videoID); // Reload the video using the same ID
  }

  @override
  Widget build(BuildContext context) {
    String sport = widget.match.sport!.replaceAll(' ', '');
    String matchId = widget.match.matchId.toString();
    if(isVideoAvailable==false){
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50,),
              Container(
                height: 200,
                color: Colors.grey.shade200,
                child: Center(
                  child: customText((widget.match.status=='live')? "No Live Stream Available": "No Video Available", 20, FontWeight.w800, Colors.grey, 1.5),
                ),
              ),
              livePageBody(sport, matchId)
            ],
          ),
        ),
      );
    }
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                player,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
                  child: DropdownButton<String>(
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
                ),
                livePageBody(sport, matchId)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget livePageBody(String sport, String matchId){
    return SingleChildScrollView(
      child: Column(
        children: [
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
                    if(widget.match.sport=='volleyball' || widget.match.sport == 'table tennis') liveVolleyball(),
                    if(widget.match.sport=='lawn tennis') liveLawnTennis(),
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
  }

  String formatOversFromBalls(String balls) {
    double ballsInt = double.parse(balls);
    int oversDone = ballsInt ~/ 6;
    int ballsDone = ballsInt.toInt() % 6;
    return "$oversDone.$ballsDone";
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
            customText('$team1_score/${team1_wickets.toString()}', 16, FontWeight.w600, Colors.grey.shade700, 1),
            const SizedBox(height: 5),
            customText('$team1overs/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
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
            customText('$team2overs/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
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
  Widget liveVolleyball(){
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: [
              Row(
                children: [
                  if(double.parse(set1Score1)>0 || double.parse(set1Score2)>0) setScore("1",set1Score1 , set1Score2),
                  if(double.parse(set2Score1)>0 || double.parse(set2Score2)>0) const SizedBox(width: 5),
                  if(double.parse(set2Score1)>0 || double.parse(set2Score2)>0) setScore("2",set2Score1 , set2Score2),
                ],
              ),

              if(double.parse(set3Score1)>0 || double.parse(set3Score2)>0) const SizedBox(height: 5),
              Row(
                children: [
                  if(double.parse(set3Score1)>0 || double.parse(set3Score2)>0) setScore("3",set3Score1 , set3Score2),
                  if(double.parse(set4Score1)>0 || double.parse(set4Score2)>0) const SizedBox(width: 5),
                  if(double.parse(set4Score1)>0 || double.parse(set4Score2)>0) setScore("4",set4Score1 , set4Score2),
                ],
              ),
              if(double.parse(set5Score1)>0 || double.parse(set5Score2)>0) const SizedBox(height: 5),
              if(double.parse(set5Score1)>0 || double.parse(set5Score2)>0) setScore("5",set5Score1 , set5Score2),
              // setScore(active,scoreTeam1 , scoreTeam2),
              // setScore("3",scoreTeam1 , scoreTeam2),
            ],
          ),
        ),
      ],
    );
  }
  Widget liveLawnTennis(){
    return Column(
      children: [
        setScore2("First Singles", set1Score1 , set1Score2),
        const SizedBox(height: 5),
        setScore2("Doubles",set2Score1 , set2Score2),
        const SizedBox(height: 5),
        setScore2("Reverse Singles",set3Score1 , set3Score2),
      ],
    );
  }
}






