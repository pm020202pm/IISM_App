import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iism/HomePage/widgets/ConnectWithUs.dart';
import 'package:iism/HomePage/widgets/CopyrightFooter.dart';
import 'package:iism/HomePage/widgets/GalleryHighLight.dart';
import '../../widgets/widgets.dart';
import '../widgets/LiveNowHighlight.dart';
import '../../utils.dart';
import '../../widgets/big_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onTap});
  final Function() onTap;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> widgets = [
    BigCard(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Youth-soccer-indiana.jpg/1200px-Youth-soccer-indiana.jpg',
      name: 'ANIME CLUB',
      clubName: 'anime',
      imageHeight: 200,
      imageWidth: 300,
      text: 'hello',
      subName: 'hello',
      radius: 20,
      fit: BoxFit.cover,
    ),
    BigCard(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Youth-soccer-indiana.jpg/1200px-Youth-soccer-indiana.jpg',
      name: 'ANIME CLUB',
      clubName: 'anime',
      imageHeight: 200,
      imageWidth: 300,
      text: 'hello',
      subName: 'hello',
      radius: 20,
      fit: BoxFit.cover,
    ),
    BigCard(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Youth-soccer-indiana.jpg/1200px-Youth-soccer-indiana.jpg',
      name: 'ANIME CLUB',
      clubName: 'anime',
      imageHeight: 200,
      imageWidth: 300,
      text: 'hello',
      subName: 'hello',
      radius: 20,
      fit: BoxFit.cover,
    ),
    BigCard(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Youth-soccer-indiana.jpg/1200px-Youth-soccer-indiana.jpg',
      name: 'ANIME CLUB',
      clubName: 'anime',
      imageHeight: 200,
      imageWidth: 300,
      text: 'hello',
      subName: 'hello',
      radius: 20,
      fit: BoxFit.cover,
    ),
    BigCard(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Youth-soccer-indiana.jpg/1200px-Youth-soccer-indiana.jpg',
      name: 'ANIME CLUB',
      clubName: 'anime',
      imageHeight: 200,
      imageWidth: 300,
      text: 'hello',
      subName: 'hello',
      radius: 20,
      fit: BoxFit.cover,
    ),
    BigCard(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Youth-soccer-indiana.jpg/1200px-Youth-soccer-indiana.jpg',
      name: 'ANIME CLUB',
      clubName: 'anime',
      imageHeight: 200,
      imageWidth: 300,
      text: 'hello',
      subName: 'hello',
      radius: 20,
      fit: BoxFit.cover,
    ),
  ];
  final CarouselSliderController carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark? Colors.black: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black,Colors.grey.shade100, yellowColor.withOpacity(0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 140, bottom: 80, left: 80, right: 80),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                          child: Image.asset('assets/logo/logo.png')),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText("57", 30, FontWeight.bold, whiteColor, 1),
                            customText("th", 18, FontWeight.bold, whiteColor, 1),
                          ],
                        ),
                        const SizedBox(width: 7),
                        customText("INTER IIT", 30, FontWeight.bold, blueColor, 1.2),
                      ],
                    ),
                    customText("SPORTS MEET 2024", 30, FontWeight.bold, whiteColor, 1.2),
                    customText("IIT KANPUR", 30, FontWeight.bold, yellowColor, 1.2),
                    const SizedBox(height: 200),
                  ],
                ),
                CarouselSlider(
                  items: widgets,
                  carouselController: carouselController,
                  options: CarouselOptions(
                    autoPlay: true,
                      height: 200,
                      scrollPhysics: const BouncingScrollPhysics(),
                      enlargeCenterPage: true,
                      viewportFraction: 0.84,
                      onPageChanged: (index, reason) {
                        // setState(() {
                        //   currIndex = index;
                        //   // print(currIndex);
                        // });
                      }),
                ),
                const SizedBox(height: 20,),
                const LiveNowHighLight(),
                const SizedBox(height: 30),
                GalleryHighLight(onTap: widget.onTap),
                // const SizedBox(height: 20),
                // const Sponsors(),
                const SizedBox(height: 40),
                Divider(color: darkYellowColor,),
                ConnectWithUs(),
                Divider(color: darkYellowColor,),
                const SizedBox(height: 20),
                const CopyrightFooter(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


