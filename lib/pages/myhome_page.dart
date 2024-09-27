
import 'package:flutter/material.dart';
import 'package:iism/ProfilePage/models/PlayerModel.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';
import 'package:iism/pages/gallery_page.dart';
import 'package:iism/pages/home_page.dart';
import 'package:iism/pages/players_page.dart';
import 'package:iism/pages/schedule_page.dart';
import 'package:iism/pages/teams_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ProfilePage/pages/login_page.dart';
import '../ProfilePage/pages/profile_page.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.index});
  final int index;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  bool isLoggedIn = false;

  late ParticipantModel savedPlayer;
  void setGalleryPage() {
    setState(() {
      index = 3;
    });
  }

  Future<void> setProfilePage() async {
    ParticipantModel _player = await initialisePlayer();
    setState(() {
      index = 5;
      isLoggedIn = true;
      savedPlayer = _player;
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
    print("isLoggedIn: $isLoggedIn");
    if(isLoggedIn){
      print(prefs.getString('email'));
      ParticipantModel _player = await initialisePlayer();
      setState(() {
        savedPlayer = _player;
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
      body: (index == 0) ?
      HomePage(onTap: setGalleryPage,) :
      (index == 1)
          ? SchedulePage()
          : (index == 2)
          ? const PlayersPage()
          : (index == 3)
          ? const GalleryPage()
          : (index == 4)
          ? const TeamsPage()
          : (index == 5)
          ? (isLoggedIn) ? PlayerProfilePage(player: savedPlayer) : LoginPage(onTap: (){setProfilePage();},)
          : Container(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(6),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavButton(onTap: (){
                setState(() {
                  index = 0;
                });
              }, isActive: index==0, text: "Home", icon: Icons.home,),
              NavButton(onTap: (){
                setState(() {
                  index = 1;
                });
              }, isActive: index==1, text: "Schedule", icon: Icons.schedule,),
              NavButton(onTap: (){
                setState(() {
                  index = 2;
                });
              }, isActive: index==2, text: "Players", icon: Icons.sports_basketball,),
              NavButton(onTap: (){
                setState(() {
                  index = 3;
                });
              }, isActive: index==3, text: "Gallery", icon: Icons.photo),
              NavButton(onTap: () {
                setState(() {
                  index = 4;
                });
              }, isActive: index==4, text: "Teams", icon: Icons.people,),
              NavButton(onTap: () async {
                bool _isLoggedIn = await checkLoginState();
                setState(() {
                  index = 5;
                  isLoggedIn = _isLoggedIn;

                });
              }, isActive: index==5, text: "Profile", icon: Icons.person,),

            ],
          ),

        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class NavButton extends StatefulWidget {
  const NavButton({super.key, required this.onTap, required this.isActive, required this.text, required this.icon});
  final Function() onTap;
  final bool isActive;
  final String text;
  final IconData icon;

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Adjust the duration as needed
        padding: const EdgeInsets.symmetric(vertical:10 , horizontal: 10),
        decoration: BoxDecoration(
          color: widget.isActive ? Colors.green.shade200 : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: widget.isActive
                  ? Colors.green.shade300.withOpacity(0.4)
                  : Colors.grey.withOpacity(0),
              spreadRadius: 2,
              blurRadius: 9,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: widget.isActive ? Colors.green.shade800 : Colors.deepPurple,
              size: 25,
            ),
            if (widget.isActive) const SizedBox(width: 3),
            if (widget.isActive)
              customText(
                widget.text,
                15,
                FontWeight.w600,
                widget.isActive ? Colors.green.shade800 : Colors.deepPurple,
                1,
              )
          ],
        ),
      ),
    );
  }
}

