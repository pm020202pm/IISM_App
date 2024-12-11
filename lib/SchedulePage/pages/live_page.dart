import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../DashBoard/pages/dashboard.dart';
import '../../api.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
import '../models/LiveMatchModel.dart';
import 'package:http/http.dart' as http;
import '../widgets/UpdateButton.dart';
import '../widgets/widgets.dart';
import 'admin_login_page.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key, required this.match});
  final LiveNowMatchModel match;

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  bool isAdminLoggedIn = false;
  late YoutubePlayerController _controller;
  late String videoID = "";
  String url = 'https://youtu.be/7d186s14Jg4';
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

  void checkLogin(){
    SharedPreferences.getInstance().then((prefs) {
      token = prefs.getString('token')??'';
      adminSport = prefs.getString('adminSport')??'';
      if (token!='' && (adminSport=='cricket' || adminSport=='volleyball' || adminSport=='basketball' || adminSport=='hockey' || adminSport=='tabletennis' || adminSport=='lawntennis')) {
        isAdminLoggedIn = true;
        setState(() {});
      }
    });
  }

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
    checkLogin();
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

  Future<void> changeValue(String tableName, String rowId, String columnName, String newValue) async {
    if(adminSport!=tableName){
      errorSnackMsg("You can only update $adminSport scores!");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token')??'';
    if(token == '') {
      errorSnackMsg('Please login to continue');
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminLoginPage()));
      });
      return;
    }
    String apiUrl = '$apiBaseUrl/changeValue';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tableName': tableName,
        'rowId': rowId,
        'columnName': columnName,
        'newValue': newValue,
      }),
    );
    if(response.statusCode == 200) {
      if(columnName == 'status' && newValue == 'completed') {
        successSnackMsg("Match marked as completed");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const DashBoard(index: 1)));
      }
      else if(columnName == 'status' && newValue == 'live'){
        successSnackMsg("Match marked as live");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const DashBoard(index: 1)));
      }
      else{
        setState(() {});
        successSnackMsg("Value changed successfully");
      }
    } else {
      errorSnackMsg("Failed to change value");
    }
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
          if (isAdminLoggedIn)
            Column(
            children: [
              if((widget.match.sport == "table tennis" || widget.match.sport == "volleyball") && widget.match.status=='live') volleyballControlWidget(sport, matchId),
              if(widget.match.sport == "lawn tennis" && widget.match.status=='live') lawnTennisControlWidget(sport, matchId),
              if(widget.match.sport == "hockey" && widget.match.status=='live') hockeyControlWidget(sport, matchId),
              if(widget.match.sport == "basketball" && widget.match.status=='live') basketballControlWidget(sport, matchId),
              if(widget.match.sport == "cricket" && widget.match.status=='live') cricketControlWidget(sport, matchId),
              if(widget.match.status=='live' && sport=='cricket') InkWell(
                  onDoubleTap: () async {
                    HapticFeedback.mediumImpact();
                    String newValue = active=='1'?'2':'1';
                    await changeValue(sport, matchId, 'active', newValue);
                    active=newValue;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 19, right: 19, top: 10, bottom: 15),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          // customText(battingTeam+" is batting!", 14, FontWeight.w800, Colors.white, 1.6),
                          customText("${(active=='1')? widget.match.team1!:widget.match.team2!} is batting", 14, FontWeight.w800, Colors.white, 1.6),
                          customText("(Double Tap to change)", 10, FontWeight.w600, Colors.white, 1),
                        ],
                      ),
                    ),
                  )
              ),
              if((widget.match.sport == "table tennis" || widget.match.sport == "volleyball") && widget.match.status=='live') Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () async {
                          if(double.parse(active)>1) active = (int.parse(active) - 1).toString();
                          await changeValue(sport, matchId, 'active', active);
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_sharp)),
                    const Spacer(),
                    customText("Change Live Set: ",15, FontWeight.w700 , Colors.green, 1),
                    customText(active,14, FontWeight.w700 , Colors.green, 1),
                    const Spacer(),
                    IconButton(
                        onPressed: () async {
                          if(int.parse(active)<=4)active = (int.parse(active) + 1).toString();
                          await changeValue(sport, matchId, 'active', active);
                        },
                        icon: const Icon(Icons.keyboard_arrow_up_sharp)),


                  ],
                ),
              ),
              if(widget.match.sport == "lawn tennis" && widget.match.status=='live') Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () async {
                          if(double.parse(active)>1) active = (int.parse(active) - 1).toString();
                          await changeValue(sport, matchId, 'active', active);
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_sharp)),
                    const Spacer(),
                    customText(active=='1'? "First Singles":active=='2'? "Doubles":"Reverse Singles",15, FontWeight.w700 , Colors.green, 1),
                    const Spacer(),
                    IconButton(
                        onPressed: () async {
                          if(int.parse(active)<=2)active = (int.parse(active) + 1).toString();
                          await changeValue(sport, matchId, 'active', active);
                        },
                        icon: const Icon(Icons.keyboard_arrow_up_sharp)
                    ),


                  ],
                ),
              ),
              if(widget.match.status=='live') Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.red),
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: InkWell(
                    onDoubleTap: () async {
                      HapticFeedback.mediumImpact();
                      await changeValue(sport, matchId, 'status', 'completed');
                    },
                    child: Column(
                      children: [
                        customText("Mark Match as Completed!", 15, FontWeight.w800, Colors.red, 1.5),
                        // customText("as Completed", 13, FontWeight.w800, Colors.red, 1.2),
                        customText("(Double Tap)", 10, FontWeight.w800, Colors.red.shade300, 1),
                      ],
                    )
                ),
              ),
              if(widget.match.status=='completed') Container(
                width: double.infinity,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.red),
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: InkWell(
                    onDoubleTap: () async {
                      HapticFeedback.mediumImpact();
                      await changeValue(sport, matchId, 'status', 'live');
                    },
                    child: Column(
                      children: [
                        customText("Make match live again!", 15, FontWeight.w800, Colors.red, 1.5),
                        // customText("as Completed", 13, FontWeight.w800, Colors.red, 1.2),
                        customText("(Double Tap)", 10, FontWeight.w800, Colors.red.shade300, 1),
                      ],
                    )
                ),
              ),
            ],
          ),
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
  Widget cricketControlWidget(String sport, String matchId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        (active=='1')
            ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UpdateButton(
                  value:team1_overs,
                  label: "OVERS",
                  displayValue: formatOversFromBalls(team1_overs),
                  onPressedUp: () async {
                    if(double.parse(team1_overs)<120) team1_overs = (double.parse(team1_overs) + 1).toString();
                    await changeValue(sport, matchId, 'team1_overs', team1_overs);
                  },
                  onPressedDown: () async {
                    if(double.parse(team1_overs)>0) team1_overs = (double.parse(team1_overs) - 1).toString();
                    await changeValue(sport, matchId, 'team1_overs', team1_overs);
                  }
              ),
              UpdateButton(
                  value:team1_score,
                  label: "RUNS",
                  displayValue: team1_score,
                  onPressedUp: () async {
                    team1_score = (int.parse(team1_score) + 1).toString();
                    await changeValue(sport, matchId, 'team1_score', team1_score);
                  },
                  onPressedDown: (){
                    if(double.parse(team1_score)>0) team1_score = (int.parse(team1_score) - 1).toString();
                    changeValue(sport, matchId, 'team1_score', team1_score);
                  }
              ),
              UpdateButton(
                  value:team1_wickets,
                  label: "WICKETS",
                  displayValue: team1_wickets,
                  onPressedUp: (){
                    if(double.parse(team1_wickets)<10) team1_wickets = (int.parse(team1_wickets) + 1).toString();
                    changeValue(sport, matchId, 'team1_wickets', team1_wickets);
                  },
                  onPressedDown: (){
                    if(double.parse(team1_wickets)>0) team1_wickets = (int.parse(team1_wickets) - 1).toString();
                    changeValue(sport, matchId, 'team1_wickets', team1_wickets);
                  }
              ),
            ],
          ),
        )
            : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UpdateButton(
                  value:team2_overs,
                  label: "OVERS",
                  displayValue: formatOversFromBalls(team2_overs),
                  onPressedUp: () async {
                    if(double.parse(team2_overs)<120) team2_overs = (double.parse(team2_overs) + 1).toString();
                    await changeValue(sport, matchId, 'team2_overs', team2_overs);
                  },
                  onPressedDown: () async {
                    if(double.parse(team2_overs)>0) team2_overs = (double.parse(team2_overs) - 1).toString();
                    await changeValue(sport, matchId, 'team2_overs', team2_overs);
                  }
              ),
              UpdateButton(
                  value:team2_score,
                  label: "RUNS",
                  displayValue: team2_score,
                  onPressedUp: () async {
                    team2_score = (int.parse(team2_score) + 1).toString();
                    await changeValue(sport, matchId, 'team2_score', team2_score);
                  },
                  onPressedDown: (){
                    if(double.parse(team2_score)>0) team2_score = (int.parse(team2_score) - 1).toString();
                    changeValue(sport, matchId, 'team2_score', team2_score);
                  }
              ),
              UpdateButton(
                  value:team2_wickets,
                  label: "WICKETS",
                  displayValue: team2_wickets,
                  onPressedUp: (){
                    if(double.parse(team2_wickets)<10) team2_wickets = (int.parse(team2_wickets) + 1).toString();
                    changeValue(sport, matchId, 'team2_wickets', team2_wickets);
                  },
                  onPressedDown: (){
                    if(double.parse(team2_wickets)>0) team2_wickets = (int.parse(team2_wickets) - 1).toString();
                    changeValue(sport, matchId, 'team2_wickets', team2_wickets);
                  }
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget hockeyControlWidget(String sport, String matchId) {
    double width=160;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UpdateButton(
                width: width,
                value:team1Goals,
                label: "Goals",
                displayValue: team1Goals,
                onPressedUp: () async {
                  team1Goals = (int.parse(team1Goals) + 1).toString();
                  await changeValue(sport, matchId, 'team1_goals', team1Goals);
                },
                onPressedDown: () async {
                  if(double.parse(team1Goals)>0) team1Goals = (int.parse(team1Goals) - 1).toString();
                  await changeValue(sport, matchId, 'team1_goals', team1Goals);
                }
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UpdateButton(
                width: width,
                value:team2Goals,
                label: "Goals",
                displayValue: team2Goals,
                onPressedUp: () async {
                  team2Goals = (int.parse(team2Goals) + 1).toString();
                  await changeValue(sport, matchId, 'team2_goals', team2Goals);
                },
                onPressedDown: () async {
                  if(double.parse(team2Goals)>0) team2Goals = (int.parse(team2Goals) - 1).toString();
                  await changeValue(sport, matchId, 'team2_goals', team2Goals);
                }
            ),
          ],
        ),
      ],
    );
  }
  Widget basketballControlWidget(String sport, String matchId) {
    double width=165;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UpdateButton(
                width: width,
                value:team1_score,
                label: "SCORE",
                displayValue: team1_score,
                onPressedUp: () async {
                  team1_score = (int.parse(team1_score) + 1).toString();
                  await changeValue(sport, matchId, 'team1_score', team1_score);
                },
                onPressedDown: () async {
                  if(double.parse(team1_score)>0) team1_score = (int.parse(team1_score) - 1).toString();
                  await changeValue(sport, matchId, 'team1_score', team1_score);
                }
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UpdateButton(
                width: width,
                value:team2_score,
                label: "SCORE",
                displayValue: team2_score,
                onPressedUp: () async {
                  team2_score = (int.parse(team2_score) + 1).toString();
                  await changeValue(sport, matchId, 'team2_score', team2_score);
                },
                onPressedDown: () async {
                  if(double.parse(team2_score)>0) team2_score = (int.parse(team2_score) - 1).toString();
                  await changeValue(sport, matchId, 'team2_score', team2_score);
                }
            ),
          ],
        ),
      ],
    );
  }
  Widget volleyballControlWidget(String sport, String matchId) {
    double width=150;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (active=='1')
                ? UpdateButton(
                width: width,
                value:set1Score1,
                label: "Set1",
                displayValue: set1Score1,
                onPressedUp: () async {
                  set1Score1 = (int.parse(set1Score1) + 1).toString();
                  await changeValue(sport, matchId, 'set1_score1', set1Score1);
                },
                onPressedDown: () async {
                  if(double.parse(set1Score1)>0) set1Score1 = (int.parse(set1Score1) - 1).toString();
                  await changeValue(sport, matchId, 'set1_score1', set1Score1);
                }
            )
                : (active=='2')
                ? UpdateButton(
                width: width,
                value:set2Score1,
                label: "Set2",
                displayValue: set2Score1,
                onPressedUp: () async {
                  set2Score1 = (int.parse(set2Score1) + 1).toString();
                  await changeValue(sport, matchId, 'set2_score1', set2Score1);
                },
                onPressedDown: () async {
                  if(double.parse(set2Score1)>0) set2Score1 = (int.parse(set2Score1) - 1).toString();
                  await changeValue(sport, matchId, 'set2_score1', set2Score1);
                }
            )
                : (active=='3')
                ? UpdateButton(
                width: width,
                value:set3Score1,
                label: "Set3",
                displayValue: set3Score1,
                onPressedUp: () async {
                  set3Score1 = (int.parse(set3Score1) + 1).toString();
                  await changeValue(sport, matchId, 'set3_score1', set3Score1);
                },
                onPressedDown: () async {
                  if(double.parse(set3Score1)>0) set3Score1 = (int.parse(set3Score1) - 1).toString();
                  await changeValue(sport, matchId, 'set3_score1', set3Score1);
                }
            )
                : (active=='4')
                ? UpdateButton(
                width: width,
                value:set4Score1,
                label: "Set4",
                displayValue: set4Score1,
                onPressedUp: () async {
                  set4Score1 = (int.parse(set4Score1) + 1).toString();
                  await changeValue(sport, matchId, 'set4_score1', set4Score1);
                },
                onPressedDown: () async {
                  if(double.parse(set4Score1)>0) set4Score1 = (int.parse(set4Score1) - 1).toString();
                  await changeValue(sport, matchId, 'set4_score1', set4Score1);
                }
            )
                : (active=='5')
                ? UpdateButton(
                width: width,
                value:set5Score1,
                label: "Set5",
                displayValue: set5Score1,
                onPressedUp: () async {
                  set5Score1 = (int.parse(set5Score1) + 1).toString();
                  await changeValue(sport, matchId, 'set5_score1', set5Score1);
                },
                onPressedDown: () async {
                  if(double.parse(set5Score1)>0) set5Score1 = (int.parse(set5Score1) - 1).toString();
                  await changeValue(sport, matchId, 'set5_score1', set5Score1);
                }
            )
                : Container()
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (active=='1')
                ? UpdateButton(
                width: width,
                value:set1Score2,
                label: "Set1",
                displayValue: set1Score2,
                onPressedUp: () async {
                  set1Score2 = (int.parse(set1Score2) + 1).toString();
                  await changeValue(sport, matchId, 'set1_score2', set1Score2);
                },
                onPressedDown: () async {
                  if(double.parse(set1Score2)>0) set1Score2 = (int.parse(set1Score2) - 1).toString();
                  await changeValue(sport, matchId, 'set1_score2', set1Score2);
                }
            )
                : (active=='2')
                ? UpdateButton(
                width: width,
                value:set2Score2,
                label: "Set2",
                displayValue: set2Score2,
                onPressedUp: () async {
                  set2Score2 = (int.parse(set2Score2) + 1).toString();
                  await changeValue(sport, matchId, 'set2_score2', set2Score2);
                },
                onPressedDown: () async {
                  if(double.parse(set2Score2)>0) set2Score2 = (int.parse(set2Score2) - 1).toString();
                  await changeValue(sport, matchId, 'set2_score2', set2Score2);
                }
            )
                :(active=='3')
                ? UpdateButton(
                width: width,
                value:set3Score2,
                label: "Set3",
                displayValue: set3Score2,
                onPressedUp: () async {
                  set3Score2 = (int.parse(set3Score2) + 1).toString();
                  await changeValue(sport, matchId, 'set3_score2', set3Score2);
                },
                onPressedDown: () async {
                  if(double.parse(set3Score2)>0) set3Score2 = (int.parse(set3Score2) - 1).toString();
                  await changeValue(sport, matchId, 'set3_score2', set3Score2);
                }
            )
                : (active=='4')
                ? UpdateButton(
                width: width,
                value:set4Score2,
                label: "Set4",
                displayValue: set4Score2,
                onPressedUp: () async {
                  set4Score2 = (int.parse(set4Score2) + 1).toString();
                  await changeValue(sport, matchId, 'set4_score2', set4Score2);
                },
                onPressedDown: () async {
                  if(double.parse(set4Score2)>0) set4Score2 = (int.parse(set4Score2) - 1).toString();
                  await changeValue(sport, matchId, 'set4_score2', set4Score2);
                }
            )
                : (active=='5')
                ? UpdateButton(
                width: width,
                value:set5Score2,
                label: "Set5",
                displayValue: set5Score2,
                onPressedUp: () async {
                  set5Score2 = (int.parse(set5Score2) + 1).toString();
                  await changeValue(sport, matchId, 'set5_score2', set5Score2);
                },
                onPressedDown: () async {
                  if(double.parse(set5Score2)>0) set5Score2 = (int.parse(set5Score2) - 1).toString();
                  await changeValue(sport, matchId, 'set5_score2', set5Score2);
                }
            )
                : Container()
          ],
        ),
      ],
    );
  }
  Widget lawnTennisControlWidget(String sport, String matchId) {
    double width=150;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (active=='1')
                ? UpdateButton2(
                width: width,
                value:set1Score1,
                displayValue: set1Score1,
                onPressedUp: () async {
                  set1Score1 = (int.parse(set1Score1) + 1).toString();
                  await changeValue(sport, matchId, 'set1_score1', set1Score1);
                },
                onPressedDown: () async {
                  if(double.parse(set1Score1)>0) set1Score1 = (int.parse(set1Score1) - 1).toString();
                  await changeValue(sport, matchId, 'set1_score1', set1Score1);
                }
            )
                : (active=='2')
                ? UpdateButton2(
                width: width,
                value:set2Score1,
                displayValue: set2Score1,
                onPressedUp: () async {
                  set2Score1 = (int.parse(set2Score1) + 1).toString();
                  await changeValue(sport, matchId, 'set2_score1', set2Score1);
                },
                onPressedDown: () async {
                  if(double.parse(set2Score1)>0) set2Score1 = (int.parse(set2Score1) - 1).toString();
                  await changeValue(sport, matchId, 'set2_score1', set2Score1);
                }
            )
                : (active=='3')
                ? UpdateButton2(
                width: width,
                value:set3Score1,
                displayValue: set3Score1,
                onPressedUp: () async {
                  set3Score1 = (int.parse(set3Score1) + 1).toString();
                  await changeValue(sport, matchId, 'set3_score1', set3Score1);
                },
                onPressedDown: () async {
                  if(double.parse(set3Score1)>0) set3Score1 = (int.parse(set3Score1) - 1).toString();
                  await changeValue(sport, matchId, 'set3_score1', set3Score1);
                }
            )
                : Container()
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (active=='1')
                ? UpdateButton2(
                width: width,
                value:set1Score2,
                displayValue: set1Score2,
                onPressedUp: () async {
                  set1Score2 = (int.parse(set1Score2) + 1).toString();
                  await changeValue(sport, matchId, 'set1_score2', set1Score2);
                },
                onPressedDown: () async {
                  if(double.parse(set1Score2)>0) set1Score2 = (int.parse(set1Score2) - 1).toString();
                  await changeValue(sport, matchId, 'set1_score2', set1Score2);
                }
            )
                : (active=='2')
                ? UpdateButton2(
                width: width,
                value:set2Score2,
                displayValue: set2Score2,
                onPressedUp: () async {
                  set2Score2 = (int.parse(set2Score2) + 1).toString();
                  await changeValue(sport, matchId, 'set2_score2', set2Score2);
                },
                onPressedDown: () async {
                  if(double.parse(set2Score2)>0) set2Score2 = (int.parse(set2Score2) - 1).toString();
                  await changeValue(sport, matchId, 'set2_score2', set2Score2);
                }
            )
                :(active=='3')
                ? UpdateButton2(
                width: width,
                value:set3Score2,
                displayValue: set3Score2,
                onPressedUp: () async {
                  set3Score2 = (int.parse(set3Score2) + 1).toString();
                  await changeValue(sport, matchId, 'set3_score2', set3Score2);
                },
                onPressedDown: () async {
                  if(double.parse(set3Score2)>0) set3Score2 = (int.parse(set3Score2) - 1).toString();
                  await changeValue(sport, matchId, 'set3_score2', set3Score2);
                }
            )
                : Container()
          ],
        ),
      ],
    );
  }

  Widget switchActiveTeamCricket(String active){
    String battingTeam = (active == '1') ? widget.match.team1! : widget.match.team2!;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade400,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          customText("$battingTeam is batting!", 14, FontWeight.w800, Colors.white, 1.6),
          customText("(Double Tap to change)", 12, FontWeight.w600, Colors.white, 1),
        ],
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
            ],
          ),
        ),
      ],
    );
  }
  Widget liveLawnTennis(){
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: [
              setScore2("First Singles", set1Score1 , set1Score2),
              const SizedBox(height: 5),
              setScore2("Doubles",set2Score1 , set2Score2),
              const SizedBox(height: 5),
              setScore2("Reverse Singles",set3Score1 , set3Score2),
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
// import '../widgets/widgets.dart';
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
//   // String url = 'https://youtu.be/7d186s14Jg4';
//   String _selectedQuality = 'hd720';
//   bool allowPop = false;
//   bool isVideoAvailable = false;
//
//   String set1Score1='0';
//   String set1Score2='0';
//   String set2Score1='0';
//   String set2Score2='0';
//   String set3Score1='0';
//   String set3Score2='0';
//   String set4Score1='0';
//   String set4Score2='0';
//   String set5Score1='0';
//   String set5Score2='0';
//
//   // hockey
//   String team1Goals='0';
//   String team2Goals='0';
//
//   // basketball
//   String team1Score='0';
//   String team2Score='0';
//
//   // cricket
//   String team1_score='0';
//   String team1_wickets='0';
//   String team2_score='0';
//   String team2_wickets='0';
//   String team1_overs='0';
//   String team2_overs='0';
//   String active = '1';
//
//   final Map<String, String> _qualityOptions = {
//     '360p': 'small', // YouTube quality option names
//     '480p': 'medium',
//     '720p': 'hd720',
//     '1080p': 'hd1080'
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     String url = widget.match.liveStreamUrl??'';
//     // String url = 'https://youtu.be/3MT8ahOudTk';
//     if(url.length>14 && url.toLowerCase().substring(0,15)=='https://youtu.b'){
//       isVideoAvailable=true;
//       videoID = YoutubePlayer.convertUrlToId(url)!;
//       _controller = YoutubePlayerController(
//         initialVideoId: videoID,
//         flags: const YoutubePlayerFlags(
//           autoPlay: false,
//           mute: false,
//           isLive: true,
//         ),
//       );
//     }
//     else {
//       isVideoAvailable = false;
//     }
//
//     set1Score1 = widget.match.set1Score1;
//     set1Score2 = widget.match.set1Score2;
//     set2Score1 = widget.match.set2Score1;
//     set2Score2 = widget.match.set2Score2;
//     set3Score1 = widget.match.set3Score1;
//     set3Score2 = widget.match.set3Score2;
//     set4Score1 = widget.match.set4Score1;
//     set4Score2 = widget.match.set4Score2;
//     set5Score1 = widget.match.set5Score1;
//     set5Score2 = widget.match.set5Score2;
//     team1Goals = widget.match.team1Goals;
//     team2Goals = widget.match.team2Goals;
//     team1Score = widget.match.team1Score;
//     team2Score = widget.match.team2Score;
//     team1_score = widget.match.team1_score??'0';
//     team1_wickets = widget.match.team1_wickets??'0';
//     team2_score = widget.match.team2_score??'0';
//     team2_wickets = widget.match.team2_wickets??'0';
//     team1_overs = widget.match.team1_overs;
//     team2_overs = widget.match.team2_overs;
//     active = widget.match.active??'1';
//     setState(() {
//
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//
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
//     String sport = widget.match.sport!.replaceAll(' ', '');
//     String matchId = widget.match.matchId.toString();
//     if(isVideoAvailable==false){
//       return Scaffold(
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 50,),
//               Container(
//                 height: 200,
//                 color: Colors.grey.shade200,
//                 child: Center(
//                   child: customText((widget.match.status=='live')? "No Live Stream Available": "No Video Available", 20, FontWeight.w800, Colors.grey, 1.5),
//                 ),
//               ),
//               livePageBody(sport, matchId)
//             ],
//           ),
//         ),
//       );
//     }
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
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 player,
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
//                   child: DropdownButton<String>(
//                     value: _selectedQuality,
//                     items: _qualityOptions.keys.map((String quality) {
//                       return DropdownMenuItem<String>(
//                         value: _qualityOptions[quality]!,
//                         child: Text(quality),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         _changeVideoQuality(value);
//                       }
//                     },
//                     underline: Container(), // Remove underline
//                   ),
//                 ),
//                 livePageBody(sport, matchId)
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget livePageBody(String sport, String matchId){
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           const Divider(),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 verticalLogoWithCollegeName(widget.match.team1!.toUpperCase(), 45, 45),
//                 Column(
//                   children: [
//                     if(widget.match.sport=='cricket') liveCricket(),
//                     if(widget.match.sport=='volleyball' || widget.match.sport == 'table tennis') liveVolleyball(),
//                     if(widget.match.sport=='lawn tennis') liveLawnTennis(),
//                     if(widget.match.sport=='hockey') liveHockey(),
//                     if(widget.match.sport=='basketball') liveBasketball(),
//                   ],
//                 ),
//                 verticalLogoWithCollegeName(widget.match.team2!.toUpperCase(), 45, 45),
//               ],
//             ),
//           ),
//           const Divider(),
//         ],
//       ),
//     );
//   }
//
//   String formatOversFromBalls(String balls) {
//     double ballsInt = double.parse(balls);
//     int oversDone = ballsInt ~/ 6;
//     int ballsDone = ballsInt.toInt() % 6;
//     return "$oversDone.$ballsDone";
//   }
//   Widget liveCricket(){
//     double ball1 = double.parse(team1_overs);
//     double ball2 = double.parse(team2_overs);
//     String team1overs = '${ball1~/6}.${ball1.toInt()%6}';
//     String team2overs = '${ball2~/6}.${ball2.toInt()%6}';
//     return Row(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             customText('$team1_score/${team1_wickets.toString()}', 16, FontWeight.w600, Colors.grey.shade700, 1),
//             const SizedBox(height: 5),
//             customText('$team1overs/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
//           ],
//         ),
//         const SizedBox(width: 10,),
//         customText("VS", 16, FontWeight.w700, Colors.red.shade400, 1),
//         const SizedBox(width: 10,),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             customText('${team2_score.toString()}/${team2_wickets.toString()}', 16, FontWeight.w600, Colors.grey.shade700, 1),
//             const SizedBox(height: 5),
//             customText('$team2overs/20', 11, FontWeight.w600, Colors.grey.shade700, 1.5),
//           ],
//         ),
//       ],
//     );
//   }
//   Widget liveHockey(){
//     return Row(
//       children: [
//         customText(team1Goals.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
//         const SizedBox(width: 15,),
//         customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
//         const SizedBox(width: 15,),
//         customText(team2Goals.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
//       ],
//     );
//   }
//   Widget liveBasketball(){
//     return Row(
//       children: [
//         customText(team1_score.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
//         const SizedBox(width: 15,),
//         customText("VS", 18, FontWeight.w700, Colors.red.shade400, 1),
//         const SizedBox(width: 15,),
//         customText(team2_score.toString(), 18, FontWeight.w600, Colors.grey.shade700, 1),
//       ],
//     );
//   }
//   Widget liveVolleyball(){
//     return Row(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(3.0),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   if(double.parse(set1Score1)>0 || double.parse(set1Score2)>0) setScore("1",set1Score1 , set1Score2),
//                   if(double.parse(set2Score1)>0 || double.parse(set2Score2)>0) const SizedBox(width: 5),
//                   if(double.parse(set2Score1)>0 || double.parse(set2Score2)>0) setScore("2",set2Score1 , set2Score2),
//                 ],
//               ),
//
//               if(double.parse(set3Score1)>0 || double.parse(set3Score2)>0) const SizedBox(height: 5),
//               Row(
//                 children: [
//                   if(double.parse(set3Score1)>0 || double.parse(set3Score2)>0) setScore("3",set3Score1 , set3Score2),
//                   if(double.parse(set4Score1)>0 || double.parse(set4Score2)>0) const SizedBox(width: 5),
//                   if(double.parse(set4Score1)>0 || double.parse(set4Score2)>0) setScore("4",set4Score1 , set4Score2),
//                 ],
//               ),
//               if(double.parse(set5Score1)>0 || double.parse(set5Score2)>0) const SizedBox(height: 5),
//               if(double.parse(set5Score1)>0 || double.parse(set5Score2)>0) setScore("5",set5Score1 , set5Score2),
//               // setScore(active,scoreTeam1 , scoreTeam2),
//               // setScore("3",scoreTeam1 , scoreTeam2),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//   Widget liveLawnTennis(){
//     return Column(
//       children: [
//         setScore2("First Singles", set1Score1 , set1Score2),
//         const SizedBox(height: 5),
//         setScore2("Doubles",set2Score1 , set2Score2),
//         const SizedBox(height: 5),
//         setScore2("Reverse Singles",set3Score1 , set3Score2),
//       ],
//     );
//   }
// }
//
//
//
//
//
//
