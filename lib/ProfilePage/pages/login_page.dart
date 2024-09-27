import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iism/ProfilePage/pages/profile_page.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api.dart';
import '../models/PlayerModel.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.onTap});
  final Function() onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  bool isOTPSent = false;
  bool isRegistering = false;
  String tmpEmail = '';

  Future<void> sendOTP(String emailId) async {
    String apiUrl = '$apiBaseUrl/auth/requestotp';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contact': emailId,
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {

        setState(() {
          tmpEmail = emailId;
          emailController.clear();
          isOTPSent = true;
        });
        print("OTP sent successfully");
      } else {
        print('Failed to send OTP');
      }
    } catch (e) {
      print('Error sending OTP: $e');
    }
  }

  Future<void> saveLoginState(ParticipantModel player) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', player.id);
    await prefs.setString('name', player.name);
    await prefs.setString('email', player.email);
    await prefs.setString('gender', player.gender);
    await prefs.setString('photo', player.photo);
    await prefs.setString('sport', player.sport);
    await prefs.setString('team', player.team);
    await prefs.setString('id_generation', player.id_generation);
    await prefs.setString('contact', player.contact);
    await prefs.setString('hall_name', player.hall_name);
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> loginPlayer(String emailId, String otp) async {
    String apiUrl = '$apiBaseUrl/auth/login';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contact': emailId,
          'otp' : otp
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        dynamic player = data['player'];
        ParticipantModel playerModel = ParticipantModel(
          id: player['id'].toString()??'',
          name: player['name']?? '',
          email: player['email']?? '',
          gender: player['gender']?? '',
          photo: player['photo']?? '',
          sport: player['sport']?? '',
          team: player['team']?? '',
          id_generation: player['id_generation']?? '',
          contact: player['contact']??'',
          hall_name: player['hall_name'].toString()?? '',
        );
        await saveLoginState(playerModel);
        widget.onTap();
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(index: 5,)));
      } else {
        print('Failed to verify OTP');
      }
    } catch (e) {
      print('Error verifying OTP: $e');
    }
  }

  Future<void> registerPlayer(String emailId, String otp) async {
    String apiUrl = '$apiBaseUrl/auth/register';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailId,
          'otp' : otp
        }),
      );
      print(response.statusCode);
      String body = response.body;
      Fluttertoast.showToast(
          msg: body,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print(response.body);
      if (response.statusCode == 200) {
        print("Registered successfully");
        final data = json.decode(response.body);
        dynamic player = data['player'];
        ParticipantModel playerModel = ParticipantModel(
          id: player['id'].toString()??'',
          name: player['name']?? '',
          email: player['email']?? '',
          gender: player['gender']?? '',
          photo: player['photo']?? '',
          sport: player['sport']?? '',
          team: player['team']?? '',
          id_generation: player['id_generation']?? '',
          contact: player['contact']??'',
          hall_name: player['hall_name'].toString()?? '',
        );
        await saveLoginState(playerModel);
        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerProfilePage(player: playerModel,)));

        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlayerProfilePage()));
      } else {
        print('Failed to register');
      }
    } catch (e) {
      print('Error registering OTP: $e');
    }
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       width: 100,
              //       padding: const EdgeInsets.all(4),
              //       decoration: BoxDecoration(
              //           color: isRegistering? Colors.grey.shade100 : Colors.green.shade700,
              //           borderRadius: BorderRadius.circular(30),
              //         border: Border.all(color: isRegistering? Colors.green.shade300 : Colors.grey.shade700, width: 1)
              //       ),
              //       child: TextButton(
              //         onPressed: () {
              //           setState(() {
              //             isRegistering = false;
              //             isOTPSent = false;
              //           });
              //         },
              //         child: customText("Login", 16, FontWeight.w500, isRegistering? Colors.green.shade300 : Colors.grey.shade100, 1),
              //       ),
              //     ),
              //     const SizedBox(width: 12,),
              //     Container(
              //       width: 100,
              //       padding: const EdgeInsets.all(4),
              //       decoration: BoxDecoration(
              //           color: !isRegistering? Colors.grey.shade100 : Colors.green.shade700,
              //           borderRadius: BorderRadius.circular(30),
              //           border: Border.all(color: !isRegistering? Colors.green.shade300 : Colors.grey.shade700, width: 1)
              //
              //       ),
              //       child: TextButton(
              //         onPressed: () {
              //           setState(() {
              //             isRegistering = true;
              //             isOTPSent = false;
              //           });
              //         },
              //         child: customText("Register", 16, FontWeight.w500, isRegistering? Colors.grey.shade100 : Colors.green.shade300, 1),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: isOTPSent? 'OTP' : 'Email',
                        hintText: isOTPSent? 'Enter OTP' : '',
                      ),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if(!isOTPSent){
                          await sendOTP(emailController.text);
                        } else {
                          // await verifyOTP(tmpEmail, emailController.text);
                          // if(isRegistering) {
                            await registerPlayer(tmpEmail, emailController.text);
                          // } else {
                          //   await loginPlayer(tmpEmail, emailController.text);
                          // }
                        }
                      },
                      child: Text(isOTPSent? "Submit" : "Send OTP"),
                    ),
                  ),
                ],
              ),

              if(isOTPSent) Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                        await sendOTP(tmpEmail);
                    },
                    child: const Text("Resend"),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        isOTPSent = false;
                        emailController.text = tmpEmail;
                      });
                    },
                    child: const Text("Change email"),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
