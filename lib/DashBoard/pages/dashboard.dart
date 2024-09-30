
import 'package:flutter/material.dart';
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
import '../widgets/NavButton.dart';


class DashBoard extends StatefulWidget {
  const DashBoard({super.key, required this.index});
  final int index;

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
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
              NavButton(onTap: (){
                setState(() {
                  index = 0;
                });
              }, isActive: index==0, text: "Home", icon: Icons.home,),
              NavButton(onTap: (){
                setState(() {
                  index = 1;
                });
              }, isActive: index==1, text: "Matches", icon: Icons.sports_volleyball_rounded,),
              NavButton(onTap: (){
                setState(() {
                  index = 2;
                });
              }, isActive: index==2, text: "Players", icon: Icons.sports_handball_outlined,),
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



