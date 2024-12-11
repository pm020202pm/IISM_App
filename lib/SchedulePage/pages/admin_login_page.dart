import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../DashBoard/pages/dashboard.dart';
import '../../api.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
import 'make_live_page.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});
  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading=false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:  Colors.white,
        appBar: AppBar(
          title: const Text('IISM Admin Login'),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/logo/IIT KANPUR.png', height: 150, fit: BoxFit.fitHeight,),
                const SizedBox(height: 40,),
                customText('Login is only meant for Admins.', 14, FontWeight.w600, Colors.grey.shade600, 1),
                const SizedBox(height: 50,),
                inputField("Enter Email", emailController),
                const SizedBox(height: 15,),
                inputField("Enter Password", passwordController),
                const SizedBox(height: 30,),
                isLoading
                    ? const CircularProgressIndicator()
                    : octagonalButton("        Login        ",12,18, Colors.green.shade300, Colors.green.shade800, () async {
                  if(emailController.text.isEmpty || passwordController.text.isEmpty){
                    errorSnackMsg('Please fill all the fields');
                    return;
                  }
                  else{
                    await loginMessUser(emailController.text, passwordController.text);
                  }
                }),
                const SizedBox(height: 100,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customText('For any technical issue, please contact : ', 12, FontWeight.w800, Colors.grey.shade800, 1.5),
                    InkWell(
                      onTap: (){
                        makePhoneCall('8957866363');
                      },
                      child: customText('8957866363', 14, FontWeight.w800, Colors.blue, 1.5),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      errorSnackMsg('Could not call $phoneNumber');
      throw 'Could not launch $callUri';
    }
  }

  Future<void> loginMessUser(String emailId, String password) async {
    setState(() {isLoading=true;});
    try {
      final response = await http.post(
        Uri.parse("$apiBaseUrl/loginAdmin"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailId,
          'password' : password
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        token  = data['token']??'';
        adminSport= emailId.split('@')[0];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('adminSport', adminSport);
        await prefs.setString('token', token)
            .then((value) => successSnackMsg('Login successful'))
            .then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashBoard(index: 1))));
      }
      else if(response.statusCode==400){
        errorSnackMsg('Invalid credentials');
      }
      else {
        errorSnackMsg('Unable to complete action. Please try again.');
      }
    } catch (e) {
      errorSnackMsg('Error in sending request');
    }
    setState(() {
      isLoading=false;
    });
  }
}


Widget inputField(String hintText, TextEditingController controller){
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
            obscureText: hintText == 'Enter Password',
            style: TextStyle(color: Colors.grey.shade800, fontFamily: 'GlacialIndifference', fontSize: 14),
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(8),
              labelStyle: TextStyle(color: Colors.grey.shade800, fontFamily: 'GlacialIndifference', fontSize: 14),
              hintText: hintText,
            ),
          ),
        ),
      ),
    ),
  );
}




