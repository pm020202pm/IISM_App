import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iism/widgets/widgets.dart';

import 'DashBoard/pages/dashboard.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // Controllers for the text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();


  Future<void> submitFeedback() async {
    String email = emailController.text.trim();
    String feedback = feedbackController.text.trim();

    if (feedback.isNotEmpty) {
      await FirebaseFirestore.instance.collection('feedback').add({
        'email': email.isEmpty ? null : email, // Email is optional
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
      });
      emailController.clear();
      feedbackController.clear();

      successSnackMsg('Feedback submitted successfully!');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashBoard(index: 0)));
    } else {
      errorSnackMsg('Error submitting feedback. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customText("Please Provide Feedback", 24, FontWeight.w600, Colors.grey.shade800, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            customText("Your feedback is valuable to us..", 16, FontWeight.w400, Colors.grey, 1),
            const SizedBox(height: 20.0),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email or Name (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            // Feedback input
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(
                labelText: 'Enter your feedback',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20.0),
            // Submit button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green
              ),
              onPressed: submitFeedback,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    emailController.dispose();
    feedbackController.dispose();
    super.dispose();
  }
}
