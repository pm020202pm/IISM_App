import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';
import 'package:iism/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/widgets.dart';
import '../models/MatchesModel.dart';
import '../pages/schedule_page.dart';
class UpcomingMatchCard extends StatelessWidget {
  final UpcomingMatchesModel match;
  const UpcomingMatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    String? locationUrl = locationVenueMap[match.sport.toLowerCase()];
    String sport = match.sport.toUpperCase();
    String category = match.category.toUpperCase();
    Size size = MediaQuery.of(context).size;
    double horizontalPadding = size.width>620? 100 :size.width>500? 50 :16;
    return ClipPath(
      clipper: OctagonClipper3(padding: 16+horizontalPadding),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: size.width-horizontalPadding*2,
            decoration: BoxDecoration(
              color: blueColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: horizontalPadding),
            child: ClipPath(
              clipper: OctagonClipper3(padding: 12),
              child: Container(
                margin: const EdgeInsets.all(2),
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalLogoWithCollegeName(match.team1, 45, 45),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(height: (match.delayMinutes>2)? 60:48,),
                              customText(match.matchTime, 14, FontWeight.w900, darkBlueColor, 1),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: customText(match.matchDate.toUpperCase(), 11, FontWeight.w800, Colors.white, 1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12,),
                          InkWell(
                            onTap:(){openLocationUrl(locationUrl!);},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                customText(match.venue, 11, FontWeight.w600, Colors.green.shade700, 2),
                                Icon(Icons.location_on_outlined, color: Colors.green.shade700, size: 15,)
                              ],
                            ),
                          ),
                        ],
                      ),
                      verticalLogoWithCollegeName(match.team2, 45, 45),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
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
                if(match.delayMinutes>2) Container(
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
                      customText("${match.delayMinutes.toStringAsFixed(0)} min", 10, FontWeight.w600, Colors.red, 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> openLocationUrl(String locationUrl) async {
  if (Platform.isAndroid || Platform.isIOS) {
    if (await canLaunchUrl(Uri.parse(locationUrl))) {
      await launchUrl(Uri.parse(locationUrl), mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: 'Could not open location.');
    }
  } else {
    Fluttertoast.showToast(msg: 'Could not open location');
  }
}


class OctagonClipper4 extends CustomClipper<Path> {
  final double padding;
  OctagonClipper4({required this.padding});
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;
    path.moveTo(0, 0);
    path.lineTo(width, 0);
    path.lineTo(width - padding, height);
    path.lineTo(padding, height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}



