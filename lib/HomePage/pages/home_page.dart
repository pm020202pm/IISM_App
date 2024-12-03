import 'package:flutter/material.dart';

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
  // bool expanded = true;
  int animationDuration = 700;
  @override
  void initState() {
    super.initState();

    // Trigger collapse after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        expanded = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double textSize = expanded ? 30 : 22;

    return Scaffold(
      backgroundColor: dark ? Colors.black : Colors.grey.shade300,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(950),
        child: AnimatedContainer(
          height: expanded? 950:160,
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
                  // Animated Logo
                  AnimatedPadding(
                    duration: Duration(milliseconds: animationDuration),
                    padding: EdgeInsets.only(
                      top: expanded ? 0 : 60,
                      right: expanded ? 0 : 240,
                    ),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: animationDuration),
                      width: expanded ? 180 :50,
                      child: Image.asset('assets/logo/logo.png', width: expanded ? 180 : 50),
                    ),
                  ),
                  // Animated Header Text
                  AnimatedPadding(
                    duration: Duration(milliseconds: animationDuration),
                    padding: EdgeInsets.only(
                      top: expanded ? 600 : 64,
                      left: expanded ? 0 : 70,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      expanded ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText("57", textSize, FontWeight.bold, whiteColor, 1),
                                customText("th", textSize - 10, FontWeight.bold, whiteColor, 1),
                              ],
                            ),
                            const SizedBox(width: 7),
                            customText(
                              "INTER IIT",
                              textSize,
                              FontWeight.bold,
                              blueColor,
                              1.2,
                            ),
                          ],
                        ),
                        customText(
                          "SPORTS MEET 2024",
                          textSize+2,
                          FontWeight.bold,
                          whiteColor,
                          1.2,
                        ),
                        customText(
                          "IIT KANPUR",
                          textSize - 5,
                          FontWeight.bold,
                          yellowColor,
                          1.2,
                        ),
                      ],
                    ),
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
                    GalleryHighLight(onTap: widget.onTap),
                    const SizedBox(height: 40),
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


