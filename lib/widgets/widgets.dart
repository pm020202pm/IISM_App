import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iism/TeamsPage/pages/teams_page.dart';
import 'package:iism/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../HomePage/widgets/ConnectWithUs.dart';

Widget customText(String text, double fontSize, FontWeight fontWeight, Color color, double? height) {
  return Text(text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: 'GlacialIndifference',
        height: height ?? 1,
      ),
      overflow: TextOverflow.ellipsis);
}

Widget pageTitleText(String text) {
  return customText(text, 42, FontWeight.w600,
      dark ? Colors.grey.shade100 : Colors.grey.shade800, 1);
}

class OctagonClipper extends CustomClipper<Path> {
  final double padding;
  OctagonClipper({required this.padding});
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;

    // const double padding = 20; // Adjust this value to modify the octagon cut

    path.moveTo(0, 0); // Top-left cut
    path.lineTo(width - padding, 0); // Top-right cut
    path.lineTo(width, padding); // Right-top cut
    path.lineTo(width, height); // Right-bottom cut
    path.lineTo(padding, height); // Bottom-left cut
    path.lineTo(0, height - padding); // Left-bottom cut
    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget setScore(String setCount, String score1, String score2) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            child: customText(
                "Set $setCount", 11, FontWeight.w700, Colors.grey.shade800, 1)),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              customText(
                  score1, 14, FontWeight.w700, Colors.grey.shade800, 1.4),
              customText(" : ", 13, FontWeight.w700, Colors.grey.shade700, 1.4),
              customText(score2, 14, FontWeight.w700, Colors.grey.shade800, 1),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget score2(String score1, String score2) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        customText(score1, 15, FontWeight.w900, Colors.grey.shade900, 1.4),
        customText(" : ", 13, FontWeight.w700, Colors.grey.shade700, 1.4),
        customText(score2, 15, FontWeight.w900, Colors.grey.shade900, 1.4),
      ],
    ),
  );
}

void errorSnackMsg(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void successSnackMsg(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

void enlargeImg(
    BuildContext context, double width,double height, String imgUrl, Widget widget) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: ClipPath(
                      clipper: OctagonClipper(padding: 20),
                      child: Container(
                        color: darkYellowColor,
                        width: width,
                        child: ClipPath(
                          clipper: OctagonClipper(padding: 24),
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            color: Colors.grey.shade200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipPath(
                                      clipper: OctagonClipper(padding: 16),
                                      child: Hero(
                                          tag: imgUrl,
                                          child: Image.network(
                                            imgUrl,
                                            width: width,
                                          ))),
                                  const SizedBox(
                                    height: 17,
                                  ),
                                  widget,
                                  const SizedBox(height: 15)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      });
}

void enlargeCoreTeamCard(BuildContext context, dynamic data) {
  String instagramUrl = data['Instagram'];
  String facebookUrl = data['Facebook'];
  String linkedinUrl = data['Linkedin'];
  List<String> names = splitName(data['Name']);
  print(instagramUrl);
  print(facebookUrl);
  print(linkedinUrl);
  double iconSize = 25;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(60),
                child: Material(
                  color: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Column(
                        children: [
                          ClipPath(
                            clipper: OctagonClipper(padding: 30),
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: darkBlueColor, width: 1),
                                ),
                                child: Container(
                                  color: yellowColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ClipPath(
                                            clipper: OctagonClipper(padding: 15),
                                            child: Image.asset(
                                              'assets/headPhotos/${names[0]}.jpg',
                                              fit: BoxFit.cover,
                                            )),
                                        const SizedBox(height: 20),
                                        customText(names[0].toUpperCase(), 18, FontWeight.w700, darkBlueColor, 1.2),
                                        if (names.length > 1)customText(names[1].toUpperCase(), 15, FontWeight.w700, darkBlueColor, 1.6),
                                        // if(names.length>2)customText(names[2].toUpperCase(), 12, FontWeight.w700 , darkBlueColor, 1),
                                        customText(
                                            formatName(data['Position']),
                                            15,
                                            FontWeight.w600,
                                            darkBlueColor.withOpacity(0.8),
                                            1.9),
                                        customText(
                                            data['Email'].toLowerCase(),
                                            13,
                                            FontWeight.w600,
                                            darkBlueColor.withOpacity(0.8),
                                            1.4),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                          const SizedBox(height: 12,),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: InkWell(
                              onTap: () {
                                launchUrl(
                                    Uri.parse(instagramUrl),
                                    mode: LaunchMode.externalApplication);
                              },
                              child: GradientIcon(
                                icon: FontAwesomeIcons.instagram, // Use FontAwesome icon
                                size: iconSize, // Set the size of the icon
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF833AB4), // Purple
                                    Color(0xFFC13584), // Pink
                                    Color(0xFFF56040), // Orange
                                    Color(0xFFFCAF45), // Yellow
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 11,
                          ),
                          if(names[0]=='priyanshu') mediaIcons(FontAwesomeIcons.github, Colors.black, 25, facebookUrl),
                          if(facebookUrl!='na' && names[0]!='priyanshu') mediaIcons(FontAwesomeIcons.facebook, Colors.blue, 25, facebookUrl),
                          const SizedBox(
                            width: 11,
                          ),
                          if(linkedinUrl!='na') mediaIcons(FontAwesomeIcons.linkedin, Colors.blue.shade800, 25, linkedinUrl),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
      });
}

Widget mediaIcons(IconData icon, Color iconColor, double iconSize, String url) {
  return Container(
    alignment: Alignment.center,
    width: 40,
    height: 40,
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
    ),
    child: InkWell(
        onTap: () {
          launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication);
        },
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        )),
  );
}
