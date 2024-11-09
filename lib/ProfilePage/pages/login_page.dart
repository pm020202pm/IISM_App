import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iism/DashBoard/pages/dashboard.dart';
import 'package:iism/ProfilePage/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
import '../models/ParticipantModel.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.onTap});
  final Function() onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController textController = TextEditingController();
  bool isOTPSent = false;
  bool isRegistering = false;
  String tmpEmail = '';
  bool isLoading=false;
  FocusNode focusNode = FocusNode();

  Future<void> sendOTP(String emailId) async {
    setState(() {
      isLoading=true;
    });
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
      if (response.statusCode == 200) {
        setState(() {
          tmpEmail = emailId;
          textController.clear();
          isOTPSent = true;
          focusNode.unfocus();
          Future.delayed(const Duration(milliseconds: 100), () {
            focusNode.requestFocus();
          });
        });
        successSnackMsg('OTP sent successfully');
      } else if(response.statusCode == 404) {
        errorSnackMsg('You are not an authentic user');
      }
      else {
        errorSnackMsg('Unable to complete action. Please try again.');
      }
    } catch (e) {
      errorSnackMsg('Error in sending OTP');
    }
    setState(() {
      isLoading=false;
    });
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

  Future<void> registerPlayer(String emailId, String otp) async {
    setState(() {
      isLoading=true;
    });
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
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        dynamic player = data['player'];
        ParticipantModel playerModel = ParticipantModel.fromJson(player);
        await saveLoginState(playerModel);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashBoard(index: 5))).then((value) => successSnackMsg('Login successful'));
      } else {
        errorSnackMsg('Unable to complete action. Please try again.');
      }
    } catch (e) {
      errorSnackMsg('Error in sending request');
    }
    setState(() {
      isLoading=false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget inputField(){
    return ClipPath(
      clipper: OctagonClipper(padding: 10),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: blueColor),
            color: blueColor
        ),
        child: ClipPath(
          clipper: OctagonClipper(padding: 10),
          child: Container(
            color: Colors.white,
            child: TextField(
              focusNode: focusNode,
              style: TextStyle(color: dark? Colors.white:Colors.grey.shade800, fontFamily: 'GlacialIndifference', fontSize: 14),
              controller: textController,
              keyboardType: isOTPSent? TextInputType.number: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(8),
                labelStyle: TextStyle(color: dark? Colors.grey.shade100 : Colors.grey.shade800, fontFamily: 'GlacialIndifference', fontSize: 14),
                // labelText: isOTPSent? 'OTP' : 'Email',
                hintText: isOTPSent? 'Enter OTP' : 'Enter Email',
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:  dark? Colors.black : Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90.0),
          child: AppBar(
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              alignment: Alignment.centerLeft,
              height: 80,
              child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: pageTitleText("Login")
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // const SizedBox(height: 50,),
                Image.asset('assets/logo/IIT Kanpur.png', height: 150, fit: BoxFit.fitHeight,),
                const SizedBox(height: 40,),
                Text('Login is only meant for Inter IIT Sports Meet\'24 Participants.\nOthers may kindly ignore.', style: TextStyle(color: dark? Colors.white:Colors.grey.shade600, fontFamily: 'GlacialIndifference', fontSize: 12, fontWeight: FontWeight.w500,), textAlign: TextAlign.center,),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: inputField()),
                      const SizedBox(width: 10,),
                      isLoading
                          ? const CircularProgressIndicator()
                          : octagonalButton(isOTPSent? "Submit" : "Send OTP",12,18, Colors.green.shade300, Colors.green.shade800, () async {
                            if(textController.text.isEmpty) {
                              errorSnackMsg('Please enter email');
                              return;
                            }
                            if(!isOTPSent) {
                              await sendOTP(textController.text);
                            } else {
                              await registerPlayer(tmpEmail, textController.text);
                            }
                          }),
                    ],
                  ),
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
                          textController.text = tmpEmail;
                        });
                      },
                      child: const Text("Change email"),
                    ),
                  ],
                ),
                SizedBox(height: 100,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
