
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iism/ProfilePage/models/ParticipantModel.dart';
import 'package:iism/GalleryPage/pages/gallery_page.dart';
import 'package:iism/HomePage/pages/home_page.dart';
import 'package:iism/PlayersPage/pages/players_page.dart';
import 'package:iism/SchedulePage/pages/schedule_page.dart';
import 'package:iism/TeamsPage/pages/teams_page.dart';
import 'package:iism/TeamsPage/pages/teams_page2.dart';
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
      sport: prefs.getString('sport')??'',
      team: prefs.getString('team')??'',
      id_generation: prefs.getString('id_generation')??'',
      hall_name: prefs.getString('hall_name')??'',
    );
    return player;
  }


  Future<bool> checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    isStaff = prefs.getBool('isStaff') ?? false;
    if(isLoggedIn){
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

  Widget customStyledNavButton(int ind, String text, IconData icon){
    return NavButton(
      onTap: (){
        HapticFeedback.lightImpact();
        setState(() {
          index = ind;
        });
        },
      isActive: index==ind, text: text,textSize: navBarTextSize, icon: icon, iconSize: iconSize, curve: Curves.easeIn,);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: (index == 0)
            ? HomePage(onTap: setGalleryPage,)
            : (index == 1)
            ? const SchedulePage()
            : (index == 2)
            ? const PlayersPage()
            : (index == 3)
            ? const GalleryPage()
            : (index == 4)
            ? (isStaff) ? TeamsPageStaff(): TeamsPage()
            : (index == 5)
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
                customStyledNavButton(0, "Home", Icons.home),
                customStyledNavButton(1, "Matches", Icons.sports_volleyball_rounded),
                customStyledNavButton(2, "Players", Icons.sports_handball_outlined),
                customStyledNavButton(3, "Gallery", Icons.photo),
                customStyledNavButton(4, "Teams", Icons.people),
                customStyledNavButton(5, "Profile", Icons.person),
              ],
            ),

          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}



