import 'package:flutter/material.dart';
import 'package:iism/DashBoard/pages/dashboard.dart';
import 'package:iism/HomePage/pages/standings.dart';
import 'package:lottie/lottie.dart';
import 'package:popover/popover.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
import '../widgets/ConnectWithUs.dart';
import '../widgets/ContactUs.dart';
import '../widgets/CopyrightFooter.dart';
import '../widgets/GalleryHighLight.dart';
import '../widgets/LiveNowHighlight.dart';
import '../widgets/MapWidget.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onTap});
  final Function() onTap;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int animationDuration = 700;
  bool isStaffMeet = false;
  final GlobalKey _moreButtonKey = GlobalKey();
  void checkForMeetType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool meetType = prefs.getBool('isStaff') ?? false;
    setState(() {
      isStaff = meetType;
      isStaffMeet = meetType;
    });
  }

  @override
  void initState() {
    super.initState();
    checkForMeetType();
    // Trigger collapse after a short delay
    Future.delayed(const Duration(milliseconds: 1600), () {
      setState(() {
        expanded = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double textSize = expanded ? 30 : 22;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: dark ? Colors.black : Colors.grey.shade200,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(950),
          child: AnimatedContainer(
            height: expanded? size.height:180,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(expanded? 0: 20),
                bottomRight: Radius.circular(expanded? 0: 20),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            duration: Duration(milliseconds: animationDuration),
            child: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Stack(
                  alignment:expanded? Alignment.center: Alignment.topCenter,
                  children: [
                    if(expanded==false)
                    Padding(
                      padding: EdgeInsets.only(left: size.width - 70, top: 50),
                      child: MoreButton()
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedPadding(
                          duration: Duration(milliseconds: animationDuration),
                          padding: EdgeInsets.only(
                            top: expanded ? 0 : 48,
                            right: expanded ? 0 : 180,
                          ),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: animationDuration),
                            width: expanded ? 180 :80,
                            child: Image.asset('assets/logo/logo.png', width: expanded ? 150 : 80),
                          ),
                        ),
                      ],
                    ),
                    // Animated Header Text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedPadding(
                          duration: Duration(milliseconds: animationDuration),
                          padding: EdgeInsets.only(
                            bottom: expanded ? 100 : 0,
                            top: expanded ? 0 : 85,
                            left: expanded ? 0 : 95,
                          ),
                          child: Column(
                            crossAxisAlignment:
                            expanded ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                            children: [
                              customText(
                                "INTER IIT",
                                textSize+9,
                                FontWeight.bold,
                                yellowColor,
                                1.1,
                              ),
                              customText(
                                "${isStaffMeet? "STAFF": "SPORTS"} MEET",
                                textSize+2,
                                FontWeight.bold,
                                whiteColor,
                                1.1,
                              ),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  customText(
                                    "2024",
                                    textSize,
                                    FontWeight.bold,
                                    blueColor,
                                    1.1,
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    color: yellowColor,
                                    child: customText(
                                      " KANPUR ",
                                      textSize - 6,
                                      FontWeight.bold,
                                      whiteColor,
                                      1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Main Content
                AnimatedOpacity(
                  duration: Duration(milliseconds: animationDuration),
                  opacity: expanded ? 0 : 1,
                  child: Column(
                    children: [
                      const LiveNowHighLight(),
                      const SizedBox(height: 30),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => StandingsPage()));
                      //   },
                      //   child: Container(
                      //     margin: const EdgeInsets.symmetric(horizontal: 4),
                      //     height: 100,
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       border: Border.all(color: Colors.yellow),
                      //       color: Colors.yellow[50],
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.yellow.shade100,
                      //           blurRadius: 5,
                      //           spreadRadius: 3,
                      //         ),
                      //       ],
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //       children: [
                      //         const SizedBox(width: 20),
                      //         customText("Standings", 30, FontWeight.w800, darkBlueColor, 1),
                      //         const SizedBox(width: 20),
                      //         Lottie.asset('assets/files/standings.json', height: 80),
                      //         const SizedBox(width: 20),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 30),
                      GalleryHighLight(onTap: widget.onTap),
                      const SizedBox(height: 30),
                      const MapWidget(),
                      const SizedBox(height: 30),
                      const ContactUs(),
                      const SizedBox(height: 30),
                      Divider(color: darkYellowColor),
                      ConnectWithUs(),
                      Divider(color: darkYellowColor),
                      const SizedBox(height: 20),
                      const CopyrightFooter(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

class MoreButton extends StatelessWidget {
  MoreButton({super.key});
  final GlobalKey _moreButtonKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Icon(Icons.more_vert, color: Colors.white, size: 25),
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => const ListItems(),
          direction: PopoverDirection.bottom,
          width: 200,
          height: 70,
          arrowHeight: 10,
          arrowWidth: 15,
        );
      },
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          InkWell(
            onTap: () async {
              isStaff = !isStaff;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('isStaff', isStaff);
              Navigator.of(context).pop();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashBoard(index: 0)));
              successSnackMsg("Switched to ${isStaff? 'Staff': 'Student'} Meet");
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.amber[50],
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                  child: customText( isStaff? 'Switch to Student Meet': 'Switch to Staff Meet', 15, FontWeight.w600, darkYellowColor, 1.2)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
