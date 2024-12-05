import 'package:flutter/material.dart';
import 'package:iism/DashBoard/pages/dashboard.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/files/splash.mp4')
      ..initialize().then((_) {
        setState(() {}); // Ensure the UI updates
        _controller.play();
      });

    // Navigate to home page after the video ends
    _controller.addListener(() {
      if (_controller.value.isInitialized && _controller.value.position >= _controller.value.duration) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashBoard(index: 0)), // Replace with your home page
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? FittedBox(
          fit: BoxFit.fitHeight,  // Ensures video fits the height while maintaining aspect ratio
          child: SizedBox(
            height: MediaQuery.of(context).size.height, // Fit the video to the screen height
            width: _controller.value.size.width * (MediaQuery.of(context).size.height / _controller.value.size.height),
            child: VideoPlayer(_controller),
          ),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
