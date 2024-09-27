import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iism/HomePage/widgets/ConnectWithUs.dart';
import 'package:iism/HomePage/widgets/CopyrightFooter.dart';
import 'package:iism/HomePage/widgets/GalleryHighLight.dart';
import 'package:iism/HomePage/widgets/Sponsors.dart';
import '../HomePage/widgets/LiveNowHighlight.dart';
import '../SchedulePage/models/MatchesModel.dart';
import '../SchedulePage/pages/live_page.dart';
import '../SchedulePage/widgets/widgets.dart';
import '../api.dart';
import '../utils.dart';
import '../widgets/big_card.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.onTap});
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
  String chipSportValue = "Cricket";
  bool _isLoading = false;
  double livenowHeight = 50;
  List<dynamic> _matches = [];
  List<int> _liveMatchesLength = List.filled(6, 0);
  List<dynamic> liveMatchesLength=[];

  Future<void> onChipTap(String sport) async {
    setState(() {
      chipSportValue = sport;
      _matches.clear();
      // _page = 1;
      // _hasMore = true;
    });
    await _fetchMatches(sportsTableMap[chipSportValue]!);
  }

  final CarouselSliderController carouselController = CarouselSliderController();
  int currIndex = 0;
  @override
  void initState() {
    getLiveMatchesLength();
    onChipTap(chipSportValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                    child: Image.asset('assets/images/iism.png', width: double.infinity)),
                const SizedBox(height: 10),
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

                LiveNowHighLight(),
                const SizedBox(height: 20),
                GalleryHighLight(onTap: widget.onTap),
                const SizedBox(height: 10),
                const Sponsors(),
                const SizedBox(height: 30),
                const Divider(),
                ConnectWithUs(),
                const Divider(),
                const SizedBox(height: 10),
                const CopyrightFooter(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getLiveMatchesLength() async {
    final String apiUrl = '$apiBaseUrl/getTablesLength';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print("###2 ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // liveMatchesLength = data['data'];
          _liveMatchesLength[0] = data['data'][0][1];
          _liveMatchesLength[1] = data['data'][1][1];
          _liveMatchesLength[2] = data['data'][2][1];
          _liveMatchesLength[3] = data['data'][3][1];
          _liveMatchesLength[4] = data['data'][4][1];
          _liveMatchesLength[5] = data['data'][5][1];
          print("###3 ${_liveMatchesLength}");
        });
        // print("###1 ${data['data']}");
      } else {

        print('Failed to load matches');
      }
    } catch (e) {
      print('Error fetching matches: $e');
    }
  }

  Future<void> _fetchMatches(String sportTableName) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    final String apiUrl = '$apiBaseUrl/getLiveMatches?page=1&limit=3&sortBy=time&order=ASC&search=&sportTableName=$sportTableName';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _matches.addAll(data['matches']);
          int len = _matches.length;
          if(len == 0){
            livenowHeight = 0;
          }
          else if(len == 1){
            livenowHeight = 54;
          }
          else if(len == 2){
            livenowHeight = 100;
          }
          else{
            livenowHeight = 166;
          }
        });
        print("### ${_matches.length}");
      } else {

        print('Failed to load matches');
      }
    } catch (e) {
      print('Error fetching matches: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

}

class LiveNowCard extends StatelessWidget {
  const LiveNowCard({super.key, required this.match});
  final LiveNowMatchModel match;

  @override
  Widget build(BuildContext context) {
    print(match.sport);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LivePage(match: match,),
          ),
        );
      },
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(vertical: 3.0),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: Image.asset('assets/logo/${match.team1}.png', width: 20, height: 20)
                        ),
                        const SizedBox(width: 5,),
                        Container(
                          width: 80,
                            child: customText(match.team1!.toUpperCase(), 10, FontWeight.w900, Colors.grey.shade800,1.9)),
                      ],
                    ),
                  )
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if(match.sport == "table tennis" || match.sport == "lawn tennis" || match.sport == "volleyball")
                  setScore("1", match.set1Score1.toString(), match.set1Score2.toString()),
                  if(match.sport == "hockey")
                  score2(match.team1Goals.toString(), match.team2Goals.toString()),
                  if(match.sport == "basketball")
                  score2(match.team1Score.toString(), match.team2Score.toString()),
                  if(match.sport == "cricket")
                  score2(match.team1_score.toString(), match.team2_score.toString()),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                          child: customText(match.team2!.toUpperCase(), 10, FontWeight.w900, Colors.grey.shade800,1.9)),
                      const SizedBox(width: 5),
                      Container(
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: Image.asset('assets/logo/${match.team2}.png', width: 20, height: 20)
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget setScore(String setCount, String score1, String score2){
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            child: customText("Set $setCount", 10, FontWeight.w700, Colors.grey.shade800, 1)),
        Row(
          children: [
            customText(score1, 13, FontWeight.w700, Colors.grey.shade800, 1.4),
            customText(" : ", 13, FontWeight.w700, Colors.grey.shade700, 1.4),
            customText(score2, 13, FontWeight.w700, Colors.grey.shade800, 1),
          ],
        ),

      ],
    ),
  );
}

Widget score2(String score1, String score2){
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


