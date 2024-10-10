
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iism/ProfilePage/models/ParticipantModel.dart';
import 'package:iism/GalleryPage/pages/gallery_page.dart';
import 'package:iism/HomePage/pages/home_page.dart';
import 'package:iism/PlayersPage/pages/players_page.dart';
import 'package:iism/SchedulePage/pages/schedule_page.dart';
import 'package:iism/TeamsPage/pages/teams_page.dart';
import 'package:iism/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ProfilePage/pages/login_page.dart';
import '../../ProfilePage/pages/profile_page.dart';
import '../widgets/nav_button.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key, required this.index});
  final int index;

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int index = 0;
  bool isLoggedIn = false;
  double navBarTextSize = 15;
  double iconSize = 22;

  late ParticipantModel savedPlayer;
  void setGalleryPage() {
    setState(() {
      index = 3;
    });
  }

  Future<void> setProfilePage() async {
    ParticipantModel player = await initialisePlayer();
    setState(() {
      index = 5;
      isLoggedIn = true;
      savedPlayer = player;
    });
  }

  Future<ParticipantModel> initialisePlayer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ParticipantModel player = ParticipantModel(
      id: prefs.getString('id') ?? '',
      name: prefs.getString('name') ?? '',
      email: prefs.getString('email') ?? '',
      gender: prefs.getString('gender')??'',
      photo: prefs.getString('photo')??'',
      sport: prefs.getString('sport')??'',
      team: prefs.getString('team')??'',
      id_generation: prefs.getString('id_generation')??'',
      contact: prefs.getString('contact')??'',
      hall_name: prefs.getString('hall_name')??'',
    );
    return player;
  }


  Future<bool> checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (kDebugMode) {
      print("isLoggedIn: $isLoggedIn");
    }
    if(isLoggedIn){
      if (kDebugMode) {
        print(prefs.getString('email'));
      }
      ParticipantModel player = await initialisePlayer();
      setState(() {
        savedPlayer = player;
      });
    }
    return isLoggedIn;
  }

  @override
  void initState() {
    index = widget.index;
    checkLoginState().then((value) => setState(() {
      isLoggedIn = value;
    }));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (index == 0)
          ? HomePage(onTap: setGalleryPage,)
          : (index == 1)
          ? const SchedulePage()
          : (index == 2)
          ? const PlayersPage()
          : (index == 3)
          ? const GalleryPage()
          : (index == 4)
          ? const TeamsPage()
          : (index == 5)
          // ? FeedbackPage()
          ? (isLoggedIn) ? PlayerProfilePage(player: savedPlayer) : LoginPage(onTap: (){setProfilePage();},)
          : Container(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: dark? Colors.grey.shade900:Colors.white,
            boxShadow: [
              BoxShadow(
                color: dark? Colors.grey.shade900: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // const NavBarButton(icon: Icons.home),
              // Button(onPressed: (){}, active: index==0,text: Text("asdkha"), duration: Duration(seconds: 2), icon: Icons.home, curve: Curves.bounceOut, debug: false, gap: 10, color: blueColor,),
              NavButton(onTap: (){
                HapticFeedback.lightImpact();
                setState(() {
                  index = 0;
                });
              }, isActive: index==0, text: "Home",textSize: navBarTextSize, icon: Icons.home, iconSize: iconSize, curve: Curves.easeIn,),
              NavButton(onTap: (){
                HapticFeedback.lightImpact();
                setState(() {
                  index = 1;
                });
              }, isActive: index==1, text: "Matches",textSize: navBarTextSize, icon: Icons.sports_volleyball_rounded,iconSize: iconSize, curve: Curves.easeIn,),
              NavButton(onTap: (){
                HapticFeedback.lightImpact();
                setState(() {
                  index = 2;
                });
              }, isActive: index==2, text: "Players",textSize: navBarTextSize, icon: Icons.sports_handball_outlined, iconSize: iconSize, curve: Curves.easeIn,),
              NavButton(onTap: (){
                HapticFeedback.lightImpact();
                setState(() {
                  index = 3;
                });
              }, isActive: index==3, text: "Gallery",textSize: navBarTextSize, icon: Icons.photo, iconSize: iconSize, curve: Curves.easeIn,),
              NavButton(onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  index = 4;
                });
              }, isActive: index==4, text: "Teams",textSize: navBarTextSize, icon: Icons.people, iconSize: iconSize, curve: Curves.easeIn,),
              NavButton(onTap: () async {
                HapticFeedback.lightImpact();
                bool isLogged = await checkLoginState();
                setState(() {
                  index = 5;
                  isLoggedIn = isLogged;
                });
              }, isActive: index==5, text: "Profile",textSize: navBarTextSize, icon: Icons.person, iconSize: iconSize, curve: Curves.easeIn,),
              // NavButton(onTap: () {
              //   HapticFeedback.lightImpact();
              //   setState(() {
              //     index = 5;
              //   });
              // }, isActive: index==5, text: "",textSize: navBarTextSize, icon: Icons.feedback_rounded, iconSize: iconSize, curve: Curves.easeIn,),
            ],
          ),

        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}



