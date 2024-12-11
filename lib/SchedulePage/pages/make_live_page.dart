import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../DashBoard/pages/dashboard.dart';
import '../../api.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
import '../models/MatchesModel.dart';
import '../widgets/UpcomingMatchCard.dart';
import '../widgets/widgets.dart';
import 'admin_login_page.dart';

class MakeMatchLive extends StatefulWidget {
  const MakeMatchLive({super.key, required this.match});
  final UpcomingMatchesModel match;

  @override
  State<MakeMatchLive> createState() => _MakeMatchLiveState();
}

class _MakeMatchLiveState extends State<MakeMatchLive> {
  final TextEditingController liveStreamUrl = TextEditingController();

  // final TextEditingController locationUrl = TextEditingController();

  Future<void> makeMatchLive(int matchId, String liveStreamUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token')??'';
    if(token == '') {
      errorSnackMsg('Please login to continue');
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminLoginPage()));
      });
      return;
    }
    String makeMatchLiveUrl = '$apiBaseUrl/makeMatchLive';
    final response = await http.post(
      Uri.parse(makeMatchLiveUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "matchId":matchId,
        "liveStreamUrl":liveStreamUrl,
        "locationUrl" : ""
      }),
    );
    if (response.statusCode == 200) {
      successSnackMsg('Match is now live');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const DashBoard(index: 1)));
    }
    else if(response.statusCode==404){
      errorSnackMsg('Match not found');
    }
    else {
      errorSnackMsg('Unable to complete action. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? locationUrl = locationVenueMap[widget.match.sport.toLowerCase()];
    String sport = widget.match.sport.toUpperCase();
    String category = widget.match.category.toUpperCase();
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Make Match Live'),
            backgroundColor: blueColor,
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height-100,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        color: Colors.grey.shade200,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              verticalLogoWithCollegeName(widget.match.team1, 45, 45),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(height: (widget.match.delayMinutes>2)? 60:48,),
                                      customText(widget.match.matchTime, 14, FontWeight.w900, darkBlueColor, 1),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: blueColor,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: customText(widget.match.matchDate.toUpperCase(), 11, FontWeight.w800, Colors.white, 1),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12,),
                                  InkWell(
                                    onTap:(){openLocationUrl(locationUrl!);},
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        customText(widget.match.venue, 11, FontWeight.w600, Colors.green.shade700, 2),
                                        Icon(Icons.location_on_outlined, color: Colors.green.shade700, size: 15,)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              verticalLogoWithCollegeName(widget.match.team2, 45, 45),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Column(
                          children: [
                            ClipPath(
                              clipper: OctagonClipper4(padding: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                                color: blueColor,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    customText(sport, 11, FontWeight.w600, darkBlueColor, 1),
                                    const SizedBox(width: 3,),
                                    Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: customText(category, 11, FontWeight.w600, darkBlueColor, 1)),
                                    // Icon(category, size: 16,)
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            if(widget.match.delayMinutes>2) Container(
                              alignment: Alignment.center,
                              width: 120,
                              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red.shade200, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  customText("Delayed by ", 10, FontWeight.w600, Colors.grey.shade700, 1),
                                  customText("${widget.match.delayMinutes.toStringAsFixed(0)} min", 10, FontWeight.w600, Colors.red, 1),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  customText('Note 1: No youtube URL link, then please write NA.', 11, FontWeight.w800, Colors.grey, 1.4),
                  const SizedBox(height: 10,),
                  customText('Note 2: Correct URL format: https://youtu.be/3MT8ahOudTk', 11, FontWeight.w800, Colors.grey, 1),
                  customText('         not https://www.youtube.com/live/3MT8ahOudTk', 11, FontWeight.w800, Colors.grey, 1),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: inputField(liveStreamUrl, 'Paste live YouTube URL link'),
                  ),
                  const SizedBox(height: 20,),
                  octagonalButton("Make Match Live",12,18, Colors.green.shade400, Colors.green.shade800, () async {
                    if(liveStreamUrl.text.isEmpty) {
                      errorSnackMsg('Please paste live stream URL');
                      return;
                    }
                    else{
                      await makeMatchLive(widget.match.matchId, liveStreamUrl.text);
                    }
                  }),
                  const Spacer(),
                  octagonalButton("Logout ($adminSport)",12,18, Colors.red.shade400, Colors.red.shade800, () async {
                     SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.remove('token');
                      await prefs.remove('adminSport');
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const DashBoard(index: 1)));
                  }),
                  const SizedBox(height: 20,),
                ]
              ),
            ),
          )
        )
    );
  }
}

Widget inputField(TextEditingController textController, String hintText){
  return ClipPath(
    clipper: OctagonClipper(padding: 10),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: blueColor),
          color: blueColor
      ),
      child: ClipPath(
        clipper: OctagonClipper(padding: 10),
        child: Container(
          color: Colors.white,
          child: TextField(
            // focusNode: focusNode,
            style: TextStyle(color: Colors.grey.shade800, fontFamily: 'GlacialIndifference', fontSize: 14),
            controller: textController,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(8),
              labelStyle: TextStyle(color: dark? Colors.grey.shade100 : Colors.grey.shade800, fontFamily: 'GlacialIndifference', fontSize: 14),
              // labelText: isOTPSent? 'OTP' : 'Email',
              hintText: hintText,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget octagonalButton(String text, double textSize,double padding, Color bgColor, Color borderColor, Function() onTap){
  return InkWell(
    onTap: onTap,
    child: Stack(
      alignment: Alignment.center,
      children: [

        ClipPath(
          clipper: OctagonClipper(padding: 10),
          child: Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(40),
                color: bgColor,
              ),
              child: customText(text, 12, FontWeight.w500, Colors.transparent, 1)
          ),
        ),
        ClipPath(
          clipper: OctagonClipper(padding: 15),
          child: Container(
              padding: EdgeInsets.all(padding-5),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1),
              ),
              child: customText(text, textSize, FontWeight.w500, Colors.white, 1)
          ),
        ),
      ],
    ),
  );
}