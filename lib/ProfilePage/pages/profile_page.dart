import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/myhome_page.dart';
import '../models/PlayerModel.dart';

class PlayerProfilePage extends StatelessWidget {
  final ParticipantModel player;
  const PlayerProfilePage({super.key, required this.player});

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('gender');
    await prefs.remove('photo');
    await prefs.remove('sport');
    await prefs.remove('team');
    await prefs.remove('id_generation');
    await prefs.remove('contact');
    await prefs.remove('hall_name');
    await prefs.setBool('isLoggedIn', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text("Player Profile Page"),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(player.id_generation, width: 200, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name : ${player.name}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.grey.shade800, letterSpacing: 1.9)),
                Text("EmailId : ${player.email}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.grey.shade800, letterSpacing: 1.9)),
                Text("Gender : ${player.gender}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.grey.shade800, letterSpacing: 1.9)),
                Text(player.sport, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.grey.shade800, letterSpacing: 1.9)),
                Text(player.team, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.grey.shade800, letterSpacing: 1.9)),
              ],
            ),
            InkWell(
              onTap: () async {
                await logout().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage(index: 5))));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.green.shade300,
                ),
                child: const Text("Logout" ,style: TextStyle(color: Colors.white),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
