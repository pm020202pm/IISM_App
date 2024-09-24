import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api.dart';
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  TextEditingController emailController = TextEditingController();

  Future<void> sendOTP() async {
    // if (_isLoading || !_hasMore) return;

    // setState(() {
    //   _isLoading = true;
    // });
    final String apiUrl = '$apiBaseUrl/auth/requestotp';

    try {
      final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'contact': emailController.text,
          }
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("OTP sent successfully");
      } else {
        print('Failed to send OTP');
      }
    } catch (e) {
      print('Error sending OTP: $e');
    }

    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your email',
                ),
              ),
              TextButton(
              onPressed: () async {await sendOTP();},
              child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
