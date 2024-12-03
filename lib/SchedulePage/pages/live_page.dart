import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../widgets/widgets.dart';
import '../models/LiveMatchModel.dart';

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
    if(widget.match.liveStreamUrl!='' && widget.match.liveStreamUrl!=null) url = widget.match.liveStreamUrl!;
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
          return Column(
            children: [
              player,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // DropdownButton<double>(
                    //   value: _playbackSpeed,
                    //   items: _speedOptions.map((String speed, String value) {
                    //     return MapEntry(
                    //       speed,
                    //       DropdownMenuItem<double>(
                    //         value: double.parse(value),
                    //         child: Text(speed),
                    //       ),
                    //     );
                    //   }).values.toList(), // Convert the map values to a list (DropdownMenuItem<double>
                    //   onChanged: (value) {
                    //     if (value != null) {
                    //       _changePlaybackSpeed(value);
                    //     }
                    //   },
                    //   underline: Container(), // Remove underline
                    // ),
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
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(70),
                                ),
                                child: Image.asset(
                                    'assets/logo/${widget.match.team1?.toUpperCase()}.png',
                                    width: 20,
                                    height: 20)),
                            const SizedBox(width: 5),
                            SizedBox(
                                width: 110,
                                child: customText(
                                    widget.match.team1!.toUpperCase(),
                                    14,
                                    FontWeight.w900,
                                    Colors.grey.shade800,
                                    1.9)),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (widget.match.sport == "table tennis" ||
                            widget.match.sport == "lawn tennis" ||
                            widget.match.sport == "volleyball")
                          liveVolleyball(widget.match.active!),
                        if (widget.match.sport == "hockey")
                          score2(widget.match.team1Goals.toString(),
                              widget.match.team2Goals.toString()),
                        if (widget.match.sport == "basketball")
                          score2(widget.match.team1Score.toString(),
                              widget.match.team2Score.toString()),
                        if (widget.match.sport == "cricket")
                          score2(widget.match.team1_score.toString(),
                              widget.match.team2_score.toString()),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Container(
                                alignment: Alignment.centerRight,
                                width: 110,
                                child: customText(
                                    widget.match.team2!.toUpperCase(),
                                    14,
                                    FontWeight.w900,
                                    Colors.grey.shade800,
                                    1.9)),
                            const SizedBox(width: 5),
                            Container(
                                padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(70),
                                ),
                                child: Image.asset(
                                    'assets/logo/${widget.match.team2?.toUpperCase()}.png',
                                    width: 20,
                                    height: 20)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
  Widget liveVolleyball(String active){
    String scoreTeam1 = (active=='1')? widget.match.set1Score1 : (active=='2')? widget.match.set2Score1 : (active=='3')? widget.match.set3Score1 : (active=='4')? widget.match.set4Score1 : widget.match.set5Score1;
    String scoreTeam2 = (active=='1')? widget.match.set1Score2 : (active=='2')? widget.match.set2Score2 : (active=='3')? widget.match.set3Score2 : (active=='4')? widget.match.set4Score2 : widget.match.set5Score2;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: setScore(active,scoreTeam1 , scoreTeam2),
        ),
      ],
    );
  }
}
